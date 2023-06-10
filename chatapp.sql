--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

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
    created bigint,
    temp boolean DEFAULT false NOT NULL,
    filesize bigint,
    msg_id bigint,
    entity_type character varying(12) NOT NULL,
    guild_id bigint,
    user_id bigint,
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

COPY public.files (id, filename, created, temp, filesize, msg_id, entity_type, guild_id, user_id) FROM stdin;
1667079317911244800	BowedHomelyAmmonite-size_restricted.gif	1686297656	f	836276	\N	guild	1666972515739635712	\N
1667147941841735680	icon1.jpg	1686314018	f	48475	\N	user	\N	1666965682685743104
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
1666976770080903168	aaaaaa	t	f
1666965710766608384	asdasdasddd	f	f
1666990758374150144	aaaasdasa	t	f
1666972515739635712	asda55	t	f
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invites (invite, guild_id) FROM stdin;
XI82kfSWsZ	1666965710766608384
UwWQmvOaT5	1666976770080903168
FbvnaetZIt	1666990758374150144
oJJfgXJmaC	1666990758374150144
ntQ6hhOZsl	1666972515739635712
\.


--
-- Data for Name: msgmentions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msgmentions (msg_id, user_id) FROM stdin;
1667066735997489152	1666965682685743104
1667066777051336704	1666965682685743104
1667066786719207424	1666965682685743104
1667066792096305152	1666965682685743104
1667066796567433216	1666965682685743104
1667066799776075776	1666965682685743104
1667066802779197440	1666965682685743104
1667066805660684288	1666965682685743104
1667147714976026624	1666965682685743104
1667326480364867584	1666965682685743104
1667328795566149632	1666965682685743104
1667343795772985344	1666965682685743104
1667344620033413120	1666965682685743104
1667344948598411264	1666965682685743104
1667344425237352448	1666965682685743104
1667345264530165760	1666965682685743104
1667345675202859008	1666965682685743104
\.


--
-- Data for Name: msgs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msgs (id, content, user_id, guild_id, created, modified, mentions_everyone) FROM stdin;
1666984235249963008	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:07.409229+10	\N	f
1666984236831215616	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:07.785745+10	\N	f
1666984238026592256	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:08.071651+10	\N	f
1666984239230357504	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:08.358115+10	\N	f
1666984240459288576	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:08.651214+10	\N	f
1666984241721774080	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:08.952803+10	\N	f
1666984243017814016	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:09.260941+10	\N	f
1666984244343214080	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:09.577127+10	\N	f
1666984245681197056	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:09.896114+10	\N	f
1666984247027568640	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:10.217414+10	\N	f
1666984257437831168	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:12.698937+10	\N	f
1666984259933442048	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:13.294057+10	\N	f
1666984261854433280	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:13.752548+10	\N	f
1666984263523766272	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:14.150223+10	\N	f
1666984265272791040	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:14.567686+10	\N	f
1666990466383482880	a	1666965682685743104	1666976770080903168	2023-06-09 12:07:53.026529+10	\N	f
1666990845624061952	asd	1666965682685743104	1666990758374150144	2023-06-09 12:09:23.44467+10	\N	f
1666990848069341184	as	1666965682685743104	1666990758374150144	2023-06-09 12:09:24.027928+10	\N	f
1666984266854043648	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:14.943844+10	\N	f
1666984268200415232	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:15.265373+10	\N	f
1666984269630672896	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:15.606253+10	\N	f
1666984271023181824	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:15.938448+10	\N	f
1666984272457633792	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:16.280666+10	\N	f
1666984278715535360	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:17.773081+10	\N	f
1666984281102094336	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:18.341745+10	\N	f
1666984283035668480	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:18.801963+10	\N	f
1666984284969242624	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:19.263166+10	\N	f
1666984286932176896	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:19.731077+10	\N	f
1666984288844779520	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:20.187497+10	\N	f
1666984290740604928	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:20.638998+10	\N	f
1666984293315907584	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:21.253207+10	\N	f
1666984295492751360	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:21.772301+10	\N	f
1666984297279524864	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:22.19834+10	\N	f
1666990499602370560	a	1666965682685743104	1666976770080903168	2023-06-09 12:08:00.947352+10	\N	f
1666990767836499968	asdasd	1666965682685743104	1666990758374150144	2023-06-09 12:09:04.899828+10	\N	f
1667066802779197440	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:11:13.043323+10	\N	f
1666984299141795840	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:22.641941+10	\N	f
1666984300949540864	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:23.072871+10	\N	f
1666984307098390528	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:24.540346+10	\N	f
1666984308964855808	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:24.984722+10	\N	f
1666984310625800192	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:25.380556+10	\N	f
1666984312441933824	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:25.813031+10	\N	f
1666984314199347200	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:26.232374+10	\N	f
1666984315960954880	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:26.651996+10	\N	f
1666984317613510656	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:27.045983+10	\N	f
1666984319287037952	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:27.444913+10	\N	f
1666984321015091200	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:27.857374+10	\N	f
1666984322575372288	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:28.229156+10	\N	f
1666984324005629952	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:28.57056+10	\N	f
1666984327600148480	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:29.427332+10	\N	f
1667066735997489152	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:10:57.121599+10	\N	f
1667066750962765824	<@everyone>	1666965682685743104	1666972515739635712	2023-06-09 17:11:00.689516+10	\N	t
1666984331995779072	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:30.475451+10	\N	f
1666984333371510784	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:30.802942+10	\N	f
1666984335103758336	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:31.216199+10	\N	f
1666984336580153344	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:31.568103+10	\N	f
1666984338220126208	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:31.959121+10	\N	f
1666984341537820672	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:32.750273+10	\N	f
1666984343018409984	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:33.103167+10	\N	f
1666984344385753088	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:33.428801+10	\N	f
1666984345681793024	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:33.738321+10	\N	f
1666984347086884864	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:34.073743+10	\N	f
1666984127938695168	a	1666965682685743104	1666972515739635712	2023-06-09 11:42:41.824936+10	\N	f
1666984132242051072	t	1666965682685743104	1666972515739635712	2023-06-09 11:42:42.849918+10	\N	f
1666984136729956352	a	1666965682685743104	1666972515739635712	2023-06-09 11:42:43.920566+10	\N	f
1666984348508753920	v	1666965682685743104	1666972515739635712	2023-06-09 11:43:34.412371+10	\N	f
1666984349846736896	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:34.731698+10	\N	f
1666984351268605952	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:35.070784+10	\N	f
1666984352531091456	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:35.371167+10	\N	f
1666984353722273792	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	1666965682685743104	1666972515739635712	2023-06-09 11:43:35.654959+10	\N	f
1667066777051336704	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:11:06.909738+10	\N	f
1667066786719207424	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:11:09.214205+10	\N	f
1667066792096305152	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:11:10.496057+10	\N	f
1667066796567433216	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:11:11.562895+10	\N	f
1667066799776075776	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:11:12.327461+10	\N	f
1667066805660684288	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-09 17:11:13.73032+10	\N	f
1667066908374994944	test	1666965682685743104	1666972515739635712	2023-06-09 17:11:38.218992+10	\N	f
1667066989731909632	test	1666965682685743104	1666972515739635712	2023-06-09 17:11:57.616731+10	\N	f
1667076956723613696	asdasd	1666965682685743104	1666972515739635712	2023-06-09 17:51:33.92988+10	\N	f
1667076981755219968	a	1666965682685743104	1666972515739635712	2023-06-09 17:51:39.897685+10	\N	f
1667076984359882752	a	1666965682685743104	1666972515739635712	2023-06-09 17:51:40.518542+10	\N	f
1667076985920163840	a	1666965682685743104	1666972515739635712	2023-06-09 17:51:40.890873+10	\N	f
1667077001594277888	a	1666965682685743104	1666972515739635712	2023-06-09 17:51:44.628005+10	\N	f
1667077034121105408	test	1666965682685743104	1666972515739635712	2023-06-09 17:51:52.382971+10	\N	f
1667081133872910336	@a	1666965682685743104	1666972515739635712	2023-06-09 18:08:09.838628+10	\N	f
1667147706465783808	<@everyone>	1666965682685743104	1666972515739635712	2023-06-09 22:32:41.985828+10	\N	t
1667147714976026624	<@1666965682685743104> \\	1666965682685743104	1666972515739635712	2023-06-09 22:32:44.014718+10	\N	f
1667147971063451648	test	1666965682685743104	1666976770080903168	2023-06-09 22:33:45.070489+10	\N	f
1667148105679638528	choice = input.nextLine();      choice = input.nextLine();	1666965682685743104	1666976770080903168	2023-06-09 22:34:17.165976+10	\N	f
1667148107013427200	choice = input.nextLine();	1666965682685743104	1666976770080903168	2023-06-09 22:34:17.483395+10	\N	f
1667148107676127232	choice = input.nextLine();	1666965682685743104	1666976770080903168	2023-06-09 22:34:17.641664+10	\N	f
1667148109056053248	choice = input.nextLine();	1666965682685743104	1666976770080903168	2023-06-09 22:34:17.970716+10	\N	f
1667148109894914048	choice = input.nextLine();	1666965682685743104	1666976770080903168	2023-06-09 22:34:18.171001+10	\N	f
1667148111249674240	choice = input.nextLine();	1666965682685743104	1666976770080903168	2023-06-09 22:34:18.494197+10	\N	f
1667148111950123008	choice = input.nextLine();	1666965682685743104	1666976770080903168	2023-06-09 22:34:18.660408+10	\N	f
1667328795566149632	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-10 10:32:16.985576+10	\N	f
1667328807234703360	<@everyone>	1666965682685743104	1666972515739635712	2023-06-10 10:32:19.767552+10	\N	t
1667326480364867584	<@1666965682685743104>sa	1666965682685743104	1666972515739635712	2023-06-10 10:23:04.998755+10	2023-06-10 10:49:53.171028+10	f
1667352733297938432	asdas	1666965682685743104	1666972515739635712	2023-06-10 12:07:24.189071+10	\N	f
1667334306109853696	2	1666965682685743104	1666972515739635712	2023-06-10 10:54:10.79981+10	\N	f
1667334370244956160	123123	1666965682685743104	1666972515739635712	2023-06-10 10:54:26.089897+10	\N	f
1667334372212084736	23	1666965682685743104	1666972515739635712	2023-06-10 10:54:26.559158+10	\N	f
1667356182831960064	asdasdasdasdasd	1666965682685743104	1666972515739635712	2023-06-10 12:21:06.621843+10	\N	f
1667356203707011072	asdasdasd	1666965682685743104	1666972515739635712	2023-06-10 12:21:11.598364+10	\N	f
1667356207683211264	asdasd	1666965682685743104	1666972515739635712	2023-06-10 12:21:12.546662+10	\N	f
1667356230475059200	sdfgsdfsdf	1666965682685743104	1666972515739635712	2023-06-10 12:21:17.98107+10	\N	f
1667334373340352512	232dasda\\asds	1666965682685743104	1666972515739635712	2023-06-10 10:54:26.828252+10	2023-06-10 10:57:30.859531+10	f
1667336530449928192	asda	1666965682685743104	1666976770080903168	2023-06-10 11:03:01.123975+10	\N	f
1667336531603361792	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:01.397624+10	\N	f
1667336532664520704	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:01.650698+10	\N	f
1667336533939589120	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:01.954824+10	\N	f
1667336535827025920	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:02.40442+10	\N	f
1667336555158573056	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:07.013702+10	\N	f
1667336557939396608	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:07.676433+10	\N	f
1667336559180910592	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:07.973123+10	\N	f
1667336560435007488	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:08.271819+10	\N	f
1667336561613606912	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:08.552729+10	\N	f
1667336562985144320	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:08.879097+10	\N	f
1667336564264407040	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:09.185211+10	\N	f
1667336565501726720	s	1666965682685743104	1666976770080903168	2023-06-10 11:03:09.479339+10	\N	f
1667336799577444352	as	1666965682685743104	1666976770080903168	2023-06-10 11:04:05.287895+10	\N	f
1667337096672579584	asd	1666965682685743104	1666972515739635712	2023-06-10 11:05:16.121686+10	\N	f
1667337104658534400	asdasdas	1666965682685743104	1666972515739635712	2023-06-10 11:05:18.023885+10	\N	f
1667337105715499008	a	1666965682685743104	1666972515739635712	2023-06-10 11:05:18.27606+10	\N	f
1667339369494614016	asdasd	1666965682685743104	1666972515739635712	2023-06-10 11:14:18.002583+10	2023-06-10 11:14:40.353734+10	f
1667333469644001280	<@1666965682685743104> 	1666965682685743104	1666972515739635712	2023-06-10 10:50:51.370489+10	2023-06-10 11:21:34.480802+10	f
1667343795772985344	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-10 11:31:53.319353+10	\N	f
1667344596272680960	<@everyone>	1666965682685743104	1666972515739635712	2023-06-10 11:35:04.173313+10	\N	t
1667344620033413120	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-10 11:35:09.838814+10	\N	f
1667359624480690176	asdasd	1666965682685743104	1666976770080903168	2023-06-10 12:34:47.173415+10	\N	f
1667344919221506048	<@everyone><@everyone> 	1666965682685743104	1666972515739635712	2023-06-10 11:36:21.170371+10	2023-06-10 11:36:24.075248+10	t
1667344948598411264	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-10 11:36:28.174894+10	\N	f
1667344425237352448	a <@1666965682685743104> 	1666965682685743104	1666972515739635712	2023-06-10 11:34:23.395629+10	2023-06-10 11:36:48.521758+10	f
1667338729854865408	sda <@everyone> 	1666965682685743104	1666972515739635712	2023-06-10 11:11:45.501132+10	2023-06-10 11:37:39.206309+10	f
1667345264530165760	<@1666965682685743104>	1666965682685743104	1666972515739635712	2023-06-10 11:37:43.498362+10	\N	f
1667388428318150656	test	1666965682685743104	1666976770080903168	2023-06-10 14:29:14.547078+10	\N	f
1667345675202859008	<@1666965682685743104> <@everyone> 	1666965682685743104	1666972515739635712	2023-06-10 11:39:21.411089+10	2023-06-10 11:39:25.133511+10	f
1667389539737407488	<@everyone>	1666965682685743104	1666972515739635712	2023-06-10 14:33:39.52946+10	\N	t
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
e1c4f02e734fd58755bf29b9b208bc42148d5946e7b4e060e631a75fafa47958	1691454564	1666965682685743104
\.


--
-- Data for Name: unreadmsgs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unreadmsgs (guild_id, user_id, msg_id, "time") FROM stdin;
1666965710766608384	1666965682685743104	0	2023-06-09 20:29:30.829932+10
1666990758374150144	1666965682685743104	1666990848069341184	2023-06-09 12:09:24.027928+10
1666972515739635712	1666965682685743104	1667389539737407488	2023-06-10 14:33:39.52946+10
1666976770080903168	1666965682685743104	1667388428318150656	2023-06-10 14:29:14.547078+10
\.


--
-- Data for Name: userguilds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userguilds (guild_id, user_id, banned, owner, receiver_id, left_dm, admin) FROM stdin;
1666965710766608384	1666965682685743104	f	t	\N	\N	f
1666972515739635712	1666965682685743104	f	t	\N	\N	f
1666976770080903168	1666965682685743104	f	t	\N	\N	f
1666990758374150144	1666965682685743104	f	t	\N	\N	f
\.


--
-- Data for Name: userroles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userroles (user_id, role_id) FROM stdin;
1666965682685743104	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, username, flags, options) FROM stdin;
1666965682685743104		$2a$10$p0mQLWzTtnv1MG0wYkfI9OUfz0k7dytOlGtnT.rDtbqDmr0eYxalG	OWNER	0	15
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

