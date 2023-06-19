--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bannedips; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bannedips (
    ip character varying(128)
);


ALTER TABLE public.bannedips OWNER TO postgres;

--
-- Name: blocked; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blocked (
    user_id bigint,
    blocked_id bigint
);


ALTER TABLE public.blocked OWNER TO postgres;

--
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.files (
    id bigint NOT NULL,
    filename character varying(4096),
    created timestamp with time zone,
    temp boolean DEFAULT false NOT NULL,
    filesize bigint,
    msg_id bigint,
    entity_type character varying(12) NOT NULL,
    guild_id bigint,
    user_id bigint,
    filetype character varying(128) NOT NULL,
    CONSTRAINT files_entity_type_check CHECK ((((entity_type)::text = 'guild'::text) OR ((entity_type)::text = 'user'::text) OR ((entity_type)::text = 'msg'::text)))
);


ALTER TABLE public.files OWNER TO postgres;

--
-- Name: friends; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friends (
    user_id bigint,
    friend_id bigint,
    friended boolean DEFAULT false NOT NULL,
    CONSTRAINT not_same CHECK ((user_id <> friend_id))
);


ALTER TABLE public.friends OWNER TO postgres;

--
-- Name: guilds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guilds (
    id bigint NOT NULL,
    name character varying(16) DEFAULT ''::character varying NOT NULL,
    save_chat boolean DEFAULT true NOT NULL,
    dm boolean DEFAULT false NOT NULL
);


ALTER TABLE public.guilds OWNER TO postgres;

--
-- Name: invites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invites (
    invite character varying(10) NOT NULL,
    guild_id bigint NOT NULL
);


ALTER TABLE public.invites OWNER TO postgres;

--
-- Name: msgmentions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msgmentions (
    msg_id bigint,
    user_id bigint
);


ALTER TABLE public.msgmentions OWNER TO postgres;

--
-- Name: msgs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msgs (
    id bigint NOT NULL,
    content character varying(4096) NOT NULL,
    user_id bigint NOT NULL,
    guild_id bigint NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    modified timestamp with time zone,
    mentions_everyone boolean DEFAULT false NOT NULL
);


ALTER TABLE public.msgs OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying(64)
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: rolepermissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rolepermissions (
    role_id integer,
    permission_id integer
);


ALTER TABLE public.rolepermissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(64)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens (
    token character varying(64) NOT NULL,
    token_expires bigint NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE public.tokens OWNER TO postgres;

--
-- Name: unreadmsgs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unreadmsgs (
    guild_id bigint,
    user_id bigint,
    msg_id bigint DEFAULT 0,
    "time" timestamp with time zone DEFAULT now()
);


ALTER TABLE public.unreadmsgs OWNER TO postgres;

--
-- Name: userguilds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userguilds (
    guild_id bigint NOT NULL,
    user_id bigint NOT NULL,
    banned boolean DEFAULT false NOT NULL,
    owner boolean DEFAULT false NOT NULL,
    receiver_id bigint,
    left_dm boolean,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.userguilds OWNER TO postgres;

--
-- Name: userroles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userroles (
    user_id bigint,
    role_id integer
);


ALTER TABLE public.userroles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(64) NOT NULL,
    username character varying(32),
    flags integer DEFAULT 0,
    options integer DEFAULT 15
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Data for Name: bannedips; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bannedips (ip) FROM stdin;
\.


--
-- Data for Name: blocked; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blocked (user_id, blocked_id) FROM stdin;
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.files (id, filename, created, temp, filesize, msg_id, entity_type, guild_id, user_id, filetype) FROM stdin;
1670701200346976256	Untitled.jpg	2023-06-19 17:53:00.93661+10	f	7702	1670701200300838912	msg	\N	\N	image/jpeg
1670702429068333056	Untitled.jpg	2023-06-19 17:57:53.881968+10	f	7702	1670702429005418496	msg	\N	\N	image/jpeg
1670704441344397312	Untitled.jpg	2023-06-19 18:05:53.636398+10	f	7702	1670704441239539712	msg	\N	\N	image/jpeg
1670704441411506176	Untitled.jpg	2023-06-19 18:05:53.636398+10	f	7702	1670704441239539712	msg	\N	\N	image/jpeg
1670706463581933568	SpotifySetup.exe	2023-06-19 18:13:55.792084+10	f	931808	1670706463544184832	msg	\N	\N	application/octet-stream
1670708698843975680	Untitled.jpg	2023-06-19 18:22:48.712387+10	f	7702	1670708698776866816	msg	\N	\N	image/jpeg
1670708698957221888	800px-MPSS_Mario.webp	2023-06-19 18:22:48.712387+10	f	365482	1670708698776866816	msg	\N	\N	image/webp
1670708699024330752	SpotifySetup.exe	2023-06-19 18:22:48.712387+10	f	931808	1670708698776866816	msg	\N	\N	application/octet-stream
1670711225270407168	Adventure Time Theme Song Cartoon Network.mp4	2023-06-19 18:32:51.069605+10	f	5925283	1670711225245241344	msg	\N	\N	video/mp4
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friends (user_id, friend_id, friended) FROM stdin;
\.


--
-- Data for Name: guilds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.guilds (id, name, save_chat, dm) FROM stdin;
1670649566514384896	testaa	t	f
1670649780239339520	bingchilling	t	f
1670651126984216576	test232	t	f
1670651601137700864	aaaaaa	t	f
1670652270963855360	aaaaaa	t	f
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invites (invite, guild_id) FROM stdin;
HdR3x5vpea	1670649566514384896
DGEXYZhTWP	1670649780239339520
3N5oj5x3aV	1670651126984216576
Ts94x05ZUT	1670651601137700864
4MNtJQvF6m	1670652270963855360
\.


--
-- Data for Name: msgmentions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msgmentions (msg_id, user_id) FROM stdin;
1670711142369988608	1670409315980152832
\.


--
-- Data for Name: msgs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msgs (id, content, user_id, guild_id, created, modified, mentions_everyone) FROM stdin;
1670701200300838912		1670409315980152832	1670651126984216576	2023-06-19 17:53:00.93661+10	\N	f
1670702429005418496		1670409315980152832	1670651126984216576	2023-06-19 17:57:53.881968+10	\N	f
1670704441239539712	testing the thing	1670409315980152832	1670651126984216576	2023-06-19 18:05:53.636398+10	\N	f
1670706463544184832		1670409315980152832	1670651126984216576	2023-06-19 18:13:55.792084+10	\N	f
1670708698776866816		1670409315980152832	1670651126984216576	2023-06-19 18:22:48.712387+10	\N	f
1670710920420003840	hello	1670409315980152832	1670651126984216576	2023-06-19 18:31:38.39384+10	\N	f
1670711142369988608	<@1670409315980152832>	1670409315980152832	1670651126984216576	2023-06-19 18:32:31.310713+10	\N	f
1670711225245241344		1670409315980152832	1670651126984216576	2023-06-19 18:32:51.069605+10	\N	f
1670713295062962176	<@everyone>	1670409315980152832	1670651126984216576	2023-06-19 18:41:04.552454+10	\N	t
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name) FROM stdin;
1	admin
2	banip
3	users_get
4	users_edit
5	users_delete
6	guilds_get
7	guilds_edit
8	guilds_delete
\.


--
-- Data for Name: rolepermissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rolepermissions (role_id, permission_id) FROM stdin;
2	1
3	3
3	4
3	5
3	6
3	7
3	8
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
1	user
2	admin
3	moderator
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokens (token, token_expires, user_id) FROM stdin;
edba9398727bae3ba93268112c446976bfaab464844d4ea8655fa57dcee97ce1	1692275590	1670409315980152832
\.


--
-- Data for Name: unreadmsgs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unreadmsgs (guild_id, user_id, msg_id, "time") FROM stdin;
1670649780239339520	1670409315980152832	0	2023-06-19 14:28:41.437913+10
1670649566514384896	1670409315980152832	1670649878704820224	2023-06-19 14:29:04.914616+10
1670651601137700864	1670409315980152832	0	2023-06-19 14:35:55.572617+10
1670652270963855360	1670409315980152832	0	2023-06-19 14:38:35.273482+10
1670651126984216576	1670409315980152832	1670711142369988608	2023-06-19 18:32:31.310713+10
\.


--
-- Data for Name: userguilds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userguilds (guild_id, user_id, banned, owner, receiver_id, left_dm, admin) FROM stdin;
1670649566514384896	1670409315980152832	f	t	\N	\N	f
1670649780239339520	1670409315980152832	f	t	\N	\N	f
1670651126984216576	1670409315980152832	f	t	\N	\N	f
1670651601137700864	1670409315980152832	f	t	\N	\N	f
1670652270963855360	1670409315980152832	f	t	\N	\N	f
\.


--
-- Data for Name: userroles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userroles (user_id, role_id) FROM stdin;
1670409315980152832	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, username, flags, options) FROM stdin;
1670409315980152832		$2a$10$Myk10T94HW0wp0IuQ6eUAO0gXPjPVSI/PD.l0xOy3y1CrVn5fFuKq	testing420	0	15
\.


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 8, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- Name: files files_guild_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_guild_id_key UNIQUE (guild_id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: files files_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_user_id_key UNIQUE (user_id);


--
-- Name: guilds guilds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guilds
    ADD CONSTRAINT guilds_pkey PRIMARY KEY (id);


--
-- Name: bannedips ip_unq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bannedips
    ADD CONSTRAINT ip_unq UNIQUE (ip);


--
-- Name: msgmentions mention_is_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msgmentions
    ADD CONSTRAINT mention_is_unique UNIQUE (msg_id, user_id);


--
-- Name: msgs msgs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msgs
    ADD CONSTRAINT msgs_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (token);


--
-- Name: tokens tokens_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_user_id_key UNIQUE (user_id);


--
-- Name: userroles unique_user_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userroles
    ADD CONSTRAINT unique_user_role UNIQUE (user_id, role_id);


--
-- Name: userguilds userguilds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userguilds
    ADD CONSTRAINT userguilds_pkey PRIMARY KEY (guild_id, user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: files files_guild_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_guild_id_fkey FOREIGN KEY (guild_id) REFERENCES public.guilds(id) ON DELETE CASCADE;


--
-- Name: files files_msg_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_msg_id_fkey FOREIGN KEY (msg_id) REFERENCES public.msgs(id) ON DELETE CASCADE;


--
-- Name: files files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: blocked fk_blocked_blocked_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocked
    ADD CONSTRAINT fk_blocked_blocked_id FOREIGN KEY (blocked_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: blocked fk_blocked_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocked
    ADD CONSTRAINT fk_blocked_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: invites fk_invite_guild; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT fk_invite_guild FOREIGN KEY (guild_id) REFERENCES public.guilds(id) ON DELETE CASCADE;


--
-- Name: msgs fk_msg_guild; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msgs
    ADD CONSTRAINT fk_msg_guild FOREIGN KEY (guild_id) REFERENCES public.guilds(id) ON DELETE CASCADE;


--
-- Name: msgs fk_msg_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msgs
    ADD CONSTRAINT fk_msg_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: tokens fk_token_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT fk_token_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: unreadmsgs fk_unreadmsg_guild; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unreadmsgs
    ADD CONSTRAINT fk_unreadmsg_guild FOREIGN KEY (guild_id) REFERENCES public.guilds(id) ON DELETE CASCADE;


--
-- Name: unreadmsgs fk_unreadmsg_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unreadmsgs
    ADD CONSTRAINT fk_unreadmsg_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: userguilds fk_userguild_guild; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userguilds
    ADD CONSTRAINT fk_userguild_guild FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: userguilds fk_userguild_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userguilds
    ADD CONSTRAINT fk_userguild_user FOREIGN KEY (guild_id) REFERENCES public.guilds(id) ON DELETE CASCADE;


--
-- Name: userroles fk_userrole_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userroles
    ADD CONSTRAINT fk_userrole_role_id FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: userroles fk_userrole_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userroles
    ADD CONSTRAINT fk_userrole_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: friends friend_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friend_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: friends friend_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friend_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: msgmentions msgmentions_msg_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msgmentions
    ADD CONSTRAINT msgmentions_msg_id_fkey FOREIGN KEY (msg_id) REFERENCES public.msgs(id) ON DELETE CASCADE;


--
-- Name: msgmentions msgmentions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msgmentions
    ADD CONSTRAINT msgmentions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rolepermissions rolepermission_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolepermissions
    ADD CONSTRAINT rolepermission_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: rolepermissions rolepermission_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolepermissions
    ADD CONSTRAINT rolepermission_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: userguilds userguilds_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userguilds
    ADD CONSTRAINT userguilds_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

