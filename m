Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44901 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0KFVdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 17:33:41 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michal Marek <mmarek@suse.cz>,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 2/5] kconfig: regen parser
Date: Sat,  6 Nov 2010 17:30:24 -0400
Message-Id: <1289079027-3037-3-git-send-email-lacombar@gmail.com>
In-Reply-To: <4CD300AC.3010708@redhat.com>
References: <4CD300AC.3010708@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/zconf.hash.c_shipped |  122 ++++----
 scripts/kconfig/zconf.tab.c_shipped  |  570 +++++++++++++++++----------------
 2 files changed, 358 insertions(+), 334 deletions(-)

diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
index c1748fa..4055d5d 100644
--- a/scripts/kconfig/zconf.hash.c_shipped
+++ b/scripts/kconfig/zconf.hash.c_shipped
@@ -32,7 +32,7 @@
 struct kconf_id;
 
 static struct kconf_id *kconf_id_lookup(register const char *str, register unsigned int len);
-/* maximum key range = 47, duplicates = 0 */
+/* maximum key range = 50, duplicates = 0 */
 
 #ifdef __GNUC__
 __inline
@@ -46,32 +46,32 @@ kconf_id_hash (register const char *str, register unsigned int len)
 {
   static unsigned char asso_values[] =
     {
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 11,  5,
-       0,  0,  5, 49,  5, 20, 49, 49,  5, 20,
-       5,  0, 30, 49,  0, 15,  0, 10,  0, 49,
-      25, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 40,  5,
+       0,  0,  5, 52,  0, 20, 52, 52, 10, 20,
+       5,  0, 35, 52,  0, 30,  0, 15,  0, 52,
+      15, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
+      52, 52, 52, 52, 52, 52
     };
   register int hval = len;
 
@@ -102,25 +102,26 @@ struct kconf_id_strings_t
     char kconf_id_strings_str12[sizeof("default")];
     char kconf_id_strings_str13[sizeof("def_bool")];
     char kconf_id_strings_str14[sizeof("help")];
-    char kconf_id_strings_str15[sizeof("bool")];
     char kconf_id_strings_str16[sizeof("config")];
     char kconf_id_strings_str17[sizeof("def_tristate")];
-    char kconf_id_strings_str18[sizeof("boolean")];
+    char kconf_id_strings_str18[sizeof("hex")];
     char kconf_id_strings_str19[sizeof("defconfig_list")];
-    char kconf_id_strings_str21[sizeof("string")];
     char kconf_id_strings_str22[sizeof("if")];
     char kconf_id_strings_str23[sizeof("int")];
-    char kconf_id_strings_str26[sizeof("select")];
     char kconf_id_strings_str27[sizeof("modules")];
     char kconf_id_strings_str28[sizeof("tristate")];
     char kconf_id_strings_str29[sizeof("menu")];
-    char kconf_id_strings_str31[sizeof("source")];
     char kconf_id_strings_str32[sizeof("comment")];
-    char kconf_id_strings_str33[sizeof("hex")];
     char kconf_id_strings_str35[sizeof("menuconfig")];
-    char kconf_id_strings_str36[sizeof("prompt")];
-    char kconf_id_strings_str37[sizeof("depends")];
+    char kconf_id_strings_str36[sizeof("string")];
+    char kconf_id_strings_str37[sizeof("visible")];
+    char kconf_id_strings_str41[sizeof("prompt")];
+    char kconf_id_strings_str42[sizeof("depends")];
+    char kconf_id_strings_str44[sizeof("bool")];
+    char kconf_id_strings_str46[sizeof("select")];
+    char kconf_id_strings_str47[sizeof("boolean")];
     char kconf_id_strings_str48[sizeof("mainmenu")];
+    char kconf_id_strings_str51[sizeof("source")];
   };
 static struct kconf_id_strings_t kconf_id_strings_contents =
   {
@@ -136,25 +137,26 @@ static struct kconf_id_strings_t kconf_id_strings_contents =
     "default",
     "def_bool",
     "help",
-    "bool",
     "config",
     "def_tristate",
-    "boolean",
+    "hex",
     "defconfig_list",
-    "string",
     "if",
     "int",
-    "select",
     "modules",
     "tristate",
     "menu",
-    "source",
     "comment",
-    "hex",
     "menuconfig",
+    "string",
+    "visible",
     "prompt",
     "depends",
-    "mainmenu"
+    "bool",
+    "select",
+    "boolean",
+    "mainmenu",
+    "source"
   };
 #define kconf_id_strings ((const char *) &kconf_id_strings_contents)
 #ifdef __GNUC__
@@ -168,11 +170,11 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 {
   enum
     {
-      TOTAL_KEYWORDS = 31,
+      TOTAL_KEYWORDS = 32,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
-      MAX_HASH_VALUE = 48
+      MAX_HASH_VALUE = 51
     };
 
   static struct kconf_id wordlist[] =
@@ -191,31 +193,35 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_UNKNOWN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,		T_HELP,		TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str15,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str16,		T_CONFIG,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,		T_TYPE,		TF_COMMAND, S_HEX},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
-      {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_TYPE,		TF_COMMAND, S_STRING},
+      {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,		T_IF,		TF_COMMAND|TF_PARAM},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str23,		T_TYPE,		TF_COMMAND, S_INT},
-      {-1}, {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str26,		T_SELECT,	TF_COMMAND},
+      {-1}, {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_TYPE,		TF_COMMAND, S_TRISTATE},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str29,		T_MENU,		TF_COMMAND},
-      {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_SOURCE,	TF_COMMAND},
+      {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_COMMENT,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,		T_TYPE,		TF_COMMAND, S_HEX},
-      {-1},
+      {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,	T_MENUCONFIG,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_PROMPT,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str37,	T_DEPENDS,	TF_COMMAND},
-      {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_TYPE,		TF_COMMAND, S_STRING},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str37,	T_VISIBLE,	TF_COMMAND},
+      {-1}, {-1}, {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str41,		T_PROMPT,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_DEPENDS,	TF_COMMAND},
       {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str48,	T_MAINMENU,	TF_COMMAND}
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str44,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str46,		T_SELECT,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str47,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str48,	T_MAINMENU,	TF_COMMAND},
+      {-1}, {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str51,		T_SOURCE,	TF_COMMAND}
     };
 
   if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 699d4b2..4c5495e 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -160,18 +160,19 @@ static struct menu *current_menu, *current_entry;
      T_DEFAULT = 275,
      T_SELECT = 276,
      T_RANGE = 277,
-     T_OPTION = 278,
-     T_ON = 279,
-     T_WORD = 280,
-     T_WORD_QUOTE = 281,
-     T_UNEQUAL = 282,
-     T_CLOSE_PAREN = 283,
-     T_OPEN_PAREN = 284,
-     T_EOL = 285,
-     T_OR = 286,
-     T_AND = 287,
-     T_EQUAL = 288,
-     T_NOT = 289
+     T_VISIBLE = 278,
+     T_OPTION = 279,
+     T_ON = 280,
+     T_WORD = 281,
+     T_WORD_QUOTE = 282,
+     T_UNEQUAL = 283,
+     T_CLOSE_PAREN = 284,
+     T_OPEN_PAREN = 285,
+     T_EOL = 286,
+     T_OR = 287,
+     T_AND = 288,
+     T_EQUAL = 289,
+     T_NOT = 290
    };
 #endif
 
@@ -419,20 +420,20 @@ union yyalloc
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  11
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   277
+#define YYLAST   290
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  35
+#define YYNTOKENS  36
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  48
+#define YYNNTS  50
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  113
+#define YYNRULES  118
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  185
+#define YYNSTATES  191
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
-#define YYMAXUTOK   289
+#define YYMAXUTOK   290
 
 #define YYTRANSLATE(YYX)						\
   ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
@@ -468,7 +469,8 @@ static const yytype_uint8 yytranslate[] =
        2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
        5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
       15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
-      25,    26,    27,    28,    29,    30,    31,    32,    33,    34
+      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
+      35
 };
 
 #if YYDEBUG
@@ -478,72 +480,73 @@ static const yytype_uint16 yyprhs[] =
 {
        0,     0,     3,     6,     8,    11,    13,    14,    17,    20,
       23,    26,    31,    36,    40,    42,    44,    46,    48,    50,
-      52,    54,    56,    58,    60,    62,    64,    66,    70,    73,
-      77,    80,    84,    87,    88,    91,    94,    97,   100,   103,
-     106,   110,   115,   120,   125,   131,   135,   136,   140,   141,
-     144,   148,   151,   153,   157,   158,   161,   164,   167,   170,
-     173,   178,   182,   185,   190,   191,   194,   198,   200,   204,
-     205,   208,   211,   214,   218,   222,   225,   227,   231,   232,
-     235,   238,   241,   245,   249,   252,   255,   258,   259,   262,
-     265,   268,   273,   274,   277,   279,   281,   284,   287,   290,
-     292,   295,   296,   299,   301,   305,   309,   313,   316,   320,
-     324,   326,   328,   329
+      52,    54,    56,    58,    60,    62,    64,    66,    68,    72,
+      75,    79,    82,    86,    89,    90,    93,    96,    99,   102,
+     105,   108,   112,   117,   122,   127,   133,   137,   138,   142,
+     143,   146,   150,   153,   155,   159,   160,   163,   166,   169,
+     172,   175,   180,   184,   187,   192,   193,   196,   200,   202,
+     206,   207,   210,   213,   216,   220,   224,   228,   230,   234,
+     235,   238,   241,   244,   248,   252,   255,   258,   261,   262,
+     265,   268,   271,   276,   277,   280,   283,   286,   287,   290,
+     292,   294,   297,   300,   303,   305,   308,   309,   312,   314,
+     318,   322,   326,   329,   333,   337,   339,   341,   342
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
-      36,     0,    -1,    78,    37,    -1,    37,    -1,    62,    38,
-      -1,    38,    -1,    -1,    38,    40,    -1,    38,    54,    -1,
-      38,    66,    -1,    38,    77,    -1,    38,    25,     1,    30,
-      -1,    38,    39,     1,    30,    -1,    38,     1,    30,    -1,
+      37,     0,    -1,    81,    38,    -1,    38,    -1,    63,    39,
+      -1,    39,    -1,    -1,    39,    41,    -1,    39,    55,    -1,
+      39,    67,    -1,    39,    80,    -1,    39,    26,     1,    31,
+      -1,    39,    40,     1,    31,    -1,    39,     1,    31,    -1,
       16,    -1,    18,    -1,    19,    -1,    21,    -1,    17,    -1,
-      22,    -1,    20,    -1,    30,    -1,    60,    -1,    70,    -1,
-      43,    -1,    45,    -1,    68,    -1,    25,     1,    30,    -1,
-       1,    30,    -1,    10,    25,    30,    -1,    42,    46,    -1,
-      11,    25,    30,    -1,    44,    46,    -1,    -1,    46,    47,
-      -1,    46,    48,    -1,    46,    74,    -1,    46,    72,    -1,
-      46,    41,    -1,    46,    30,    -1,    19,    75,    30,    -1,
-      18,    76,    79,    30,    -1,    20,    80,    79,    30,    -1,
-      21,    25,    79,    30,    -1,    22,    81,    81,    79,    30,
-      -1,    23,    49,    30,    -1,    -1,    49,    25,    50,    -1,
-      -1,    33,    76,    -1,     7,    82,    30,    -1,    51,    55,
-      -1,    77,    -1,    52,    57,    53,    -1,    -1,    55,    56,
-      -1,    55,    74,    -1,    55,    72,    -1,    55,    30,    -1,
-      55,    41,    -1,    18,    76,    79,    30,    -1,    19,    75,
-      30,    -1,    17,    30,    -1,    20,    25,    79,    30,    -1,
-      -1,    57,    40,    -1,    14,    80,    78,    -1,    77,    -1,
-      58,    61,    59,    -1,    -1,    61,    40,    -1,    61,    66,
-      -1,    61,    54,    -1,     3,    76,    78,    -1,     4,    76,
-      30,    -1,    63,    73,    -1,    77,    -1,    64,    67,    65,
-      -1,    -1,    67,    40,    -1,    67,    66,    -1,    67,    54,
-      -1,     6,    76,    30,    -1,     9,    76,    30,    -1,    69,
-      73,    -1,    12,    30,    -1,    71,    13,    -1,    -1,    73,
-      74,    -1,    73,    30,    -1,    73,    41,    -1,    16,    24,
-      80,    30,    -1,    -1,    76,    79,    -1,    25,    -1,    26,
-      -1,     5,    30,    -1,     8,    30,    -1,    15,    30,    -1,
-      30,    -1,    78,    30,    -1,    -1,    14,    80,    -1,    81,
-      -1,    81,    33,    81,    -1,    81,    27,    81,    -1,    29,
-      80,    28,    -1,    34,    80,    -1,    80,    31,    80,    -1,
-      80,    32,    80,    -1,    25,    -1,    26,    -1,    -1,    25,
-      -1
+      22,    -1,    20,    -1,    23,    -1,    31,    -1,    61,    -1,
+      71,    -1,    44,    -1,    46,    -1,    69,    -1,    26,     1,
+      31,    -1,     1,    31,    -1,    10,    26,    31,    -1,    43,
+      47,    -1,    11,    26,    31,    -1,    45,    47,    -1,    -1,
+      47,    48,    -1,    47,    49,    -1,    47,    75,    -1,    47,
+      73,    -1,    47,    42,    -1,    47,    31,    -1,    19,    78,
+      31,    -1,    18,    79,    82,    31,    -1,    20,    83,    82,
+      31,    -1,    21,    26,    82,    31,    -1,    22,    84,    84,
+      82,    31,    -1,    24,    50,    31,    -1,    -1,    50,    26,
+      51,    -1,    -1,    34,    79,    -1,     7,    85,    31,    -1,
+      52,    56,    -1,    80,    -1,    53,    58,    54,    -1,    -1,
+      56,    57,    -1,    56,    75,    -1,    56,    73,    -1,    56,
+      31,    -1,    56,    42,    -1,    18,    79,    82,    31,    -1,
+      19,    78,    31,    -1,    17,    31,    -1,    20,    26,    82,
+      31,    -1,    -1,    58,    41,    -1,    14,    83,    81,    -1,
+      80,    -1,    59,    62,    60,    -1,    -1,    62,    41,    -1,
+      62,    67,    -1,    62,    55,    -1,     3,    79,    81,    -1,
+       4,    79,    31,    -1,    64,    76,    74,    -1,    80,    -1,
+      65,    68,    66,    -1,    -1,    68,    41,    -1,    68,    67,
+      -1,    68,    55,    -1,     6,    79,    31,    -1,     9,    79,
+      31,    -1,    70,    74,    -1,    12,    31,    -1,    72,    13,
+      -1,    -1,    74,    75,    -1,    74,    31,    -1,    74,    42,
+      -1,    16,    25,    83,    31,    -1,    -1,    76,    77,    -1,
+      76,    31,    -1,    23,    82,    -1,    -1,    79,    82,    -1,
+      26,    -1,    27,    -1,     5,    31,    -1,     8,    31,    -1,
+      15,    31,    -1,    31,    -1,    81,    31,    -1,    -1,    14,
+      83,    -1,    84,    -1,    84,    34,    84,    -1,    84,    28,
+      84,    -1,    30,    83,    29,    -1,    35,    83,    -1,    83,
+      32,    83,    -1,    83,    33,    83,    -1,    26,    -1,    27,
+      -1,    -1,    26,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
-       0,   107,   107,   107,   109,   109,   111,   113,   114,   115,
-     116,   117,   118,   122,   126,   126,   126,   126,   126,   126,
-     126,   130,   131,   132,   133,   134,   135,   139,   140,   146,
-     154,   160,   168,   178,   180,   181,   182,   183,   184,   185,
-     188,   196,   202,   212,   218,   224,   227,   229,   240,   241,
-     246,   255,   260,   268,   271,   273,   274,   275,   276,   277,
-     280,   286,   297,   303,   313,   315,   320,   328,   336,   339,
-     341,   342,   343,   348,   355,   362,   367,   375,   378,   380,
-     381,   382,   385,   393,   400,   407,   413,   420,   422,   423,
-     424,   427,   435,   437,   442,   443,   446,   447,   448,   452,
-     453,   456,   457,   460,   461,   462,   463,   464,   465,   466,
-     469,   470,   473,   474
+       0,   108,   108,   108,   110,   110,   112,   114,   115,   116,
+     117,   118,   119,   123,   127,   127,   127,   127,   127,   127,
+     127,   127,   131,   132,   133,   134,   135,   136,   140,   141,
+     147,   155,   161,   169,   179,   181,   182,   183,   184,   185,
+     186,   189,   197,   203,   213,   219,   225,   228,   230,   241,
+     242,   247,   256,   261,   269,   272,   274,   275,   276,   277,
+     278,   281,   287,   298,   304,   314,   316,   321,   329,   337,
+     340,   342,   343,   344,   349,   356,   363,   368,   376,   379,
+     381,   382,   383,   386,   394,   401,   408,   414,   421,   423,
+     424,   425,   428,   436,   438,   439,   442,   449,   451,   456,
+     457,   460,   461,   462,   466,   467,   470,   471,   474,   475,
+     476,   477,   478,   479,   480,   483,   484,   487,   488
 };
 #endif
 
@@ -556,7 +559,7 @@ static const char *const yytname[] =
   "T_SOURCE", "T_CHOICE", "T_ENDCHOICE", "T_COMMENT", "T_CONFIG",
   "T_MENUCONFIG", "T_HELP", "T_HELPTEXT", "T_IF", "T_ENDIF", "T_DEPENDS",
   "T_OPTIONAL", "T_PROMPT", "T_TYPE", "T_DEFAULT", "T_SELECT", "T_RANGE",
-  "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE", "T_UNEQUAL",
+  "T_VISIBLE", "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE", "T_UNEQUAL",
   "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND", "T_EQUAL",
   "T_NOT", "$accept", "input", "start", "stmt_list", "option_name",
   "common_stmt", "option_error", "config_entry_start", "config_stmt",
@@ -567,8 +570,8 @@ static const char *const yytname[] =
   "if_entry", "if_end", "if_stmt", "if_block", "mainmenu_stmt", "menu",
   "menu_entry", "menu_end", "menu_stmt", "menu_block", "source_stmt",
   "comment", "comment_stmt", "help_start", "help", "depends_list",
-  "depends", "prompt_stmt_opt", "prompt", "end", "nl", "if_expr", "expr",
-  "symbol", "word_opt", 0
+  "depends", "visibility_list", "visible", "prompt_stmt_opt", "prompt",
+  "end", "nl", "if_expr", "expr", "symbol", "word_opt", 0
 };
 #endif
 
@@ -580,25 +583,25 @@ static const yytype_uint16 yytoknum[] =
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
      265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
      275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
-     285,   286,   287,   288,   289
+     285,   286,   287,   288,   289,   290
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    35,    36,    36,    37,    37,    38,    38,    38,    38,
-      38,    38,    38,    38,    39,    39,    39,    39,    39,    39,
-      39,    40,    40,    40,    40,    40,    40,    41,    41,    42,
-      43,    44,    45,    46,    46,    46,    46,    46,    46,    46,
-      47,    47,    47,    47,    47,    48,    49,    49,    50,    50,
-      51,    52,    53,    54,    55,    55,    55,    55,    55,    55,
-      56,    56,    56,    56,    57,    57,    58,    59,    60,    61,
-      61,    61,    61,    62,    63,    64,    65,    66,    67,    67,
-      67,    67,    68,    69,    70,    71,    72,    73,    73,    73,
-      73,    74,    75,    75,    76,    76,    77,    77,    77,    78,
-      78,    79,    79,    80,    80,    80,    80,    80,    80,    80,
-      81,    81,    82,    82
+       0,    36,    37,    37,    38,    38,    39,    39,    39,    39,
+      39,    39,    39,    39,    40,    40,    40,    40,    40,    40,
+      40,    40,    41,    41,    41,    41,    41,    41,    42,    42,
+      43,    44,    45,    46,    47,    47,    47,    47,    47,    47,
+      47,    48,    48,    48,    48,    48,    49,    50,    50,    51,
+      51,    52,    53,    54,    55,    56,    56,    56,    56,    56,
+      56,    57,    57,    57,    57,    58,    58,    59,    60,    61,
+      62,    62,    62,    62,    63,    64,    65,    66,    67,    68,
+      68,    68,    68,    69,    70,    71,    72,    73,    74,    74,
+      74,    74,    75,    76,    76,    76,    77,    78,    78,    79,
+      79,    80,    80,    80,    81,    81,    82,    82,    83,    83,
+      83,    83,    83,    83,    83,    84,    84,    85,    85
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
@@ -606,16 +609,16 @@ static const yytype_uint8 yyr2[] =
 {
        0,     2,     2,     1,     2,     1,     0,     2,     2,     2,
        2,     4,     4,     3,     1,     1,     1,     1,     1,     1,
-       1,     1,     1,     1,     1,     1,     1,     3,     2,     3,
-       2,     3,     2,     0,     2,     2,     2,     2,     2,     2,
-       3,     4,     4,     4,     5,     3,     0,     3,     0,     2,
-       3,     2,     1,     3,     0,     2,     2,     2,     2,     2,
-       4,     3,     2,     4,     0,     2,     3,     1,     3,     0,
-       2,     2,     2,     3,     3,     2,     1,     3,     0,     2,
-       2,     2,     3,     3,     2,     2,     2,     0,     2,     2,
-       2,     4,     0,     2,     1,     1,     2,     2,     2,     1,
-       2,     0,     2,     1,     3,     3,     3,     2,     3,     3,
-       1,     1,     0,     1
+       1,     1,     1,     1,     1,     1,     1,     1,     3,     2,
+       3,     2,     3,     2,     0,     2,     2,     2,     2,     2,
+       2,     3,     4,     4,     4,     5,     3,     0,     3,     0,
+       2,     3,     2,     1,     3,     0,     2,     2,     2,     2,
+       2,     4,     3,     2,     4,     0,     2,     3,     1,     3,
+       0,     2,     2,     2,     3,     3,     3,     1,     3,     0,
+       2,     2,     2,     3,     3,     2,     2,     2,     0,     2,
+       2,     2,     4,     0,     2,     2,     2,     0,     2,     1,
+       1,     2,     2,     2,     1,     2,     0,     2,     1,     3,
+       3,     3,     2,     3,     3,     1,     1,     0,     1
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -623,165 +626,172 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       6,     0,    99,     0,     3,     0,     6,     6,    94,    95,
-       0,     1,     0,     0,     0,     0,   112,     0,     0,     0,
+       6,     0,   104,     0,     3,     0,     6,     6,    99,   100,
+       0,     1,     0,     0,     0,     0,   117,     0,     0,     0,
        0,     0,     0,    14,    18,    15,    16,    20,    17,    19,
-       0,    21,     0,     7,    33,    24,    33,    25,    54,    64,
-       8,    69,    22,    87,    78,     9,    26,    87,    23,    10,
-       0,   100,     2,    73,    13,     0,    96,     0,   113,     0,
-      97,     0,     0,     0,   110,   111,     0,     0,     0,   103,
-      98,     0,     0,     0,     0,     0,     0,     0,     0,     0,
-       0,    74,    82,    50,    83,    29,    31,     0,   107,     0,
-       0,    66,     0,     0,    11,    12,     0,     0,     0,     0,
-      92,     0,     0,     0,    46,     0,    39,    38,    34,    35,
-       0,    37,    36,     0,     0,    92,     0,    58,    59,    55,
-      57,    56,    65,    53,    52,    70,    72,    68,    71,    67,
-      89,    90,    88,    79,    81,    77,    80,    76,   106,   108,
-     109,   105,   104,    28,    85,     0,   101,     0,   101,   101,
-     101,     0,     0,     0,    86,    62,   101,     0,   101,     0,
-       0,     0,    40,    93,     0,     0,   101,    48,    45,    27,
-       0,    61,     0,    91,   102,    41,    42,    43,     0,     0,
-      47,    60,    63,    44,    49
+      21,     0,    22,     0,     7,    34,    25,    34,    26,    55,
+      65,     8,    70,    23,    93,    79,     9,    27,    88,    24,
+      10,     0,   105,     2,    74,    13,     0,   101,     0,   118,
+       0,   102,     0,     0,     0,   115,   116,     0,     0,     0,
+     108,   103,     0,     0,     0,     0,     0,     0,     0,    88,
+       0,     0,    75,    83,    51,    84,    30,    32,     0,   112,
+       0,     0,    67,     0,     0,    11,    12,     0,     0,     0,
+       0,    97,     0,     0,     0,    47,     0,    40,    39,    35,
+      36,     0,    38,    37,     0,     0,    97,     0,    59,    60,
+      56,    58,    57,    66,    54,    53,    71,    73,    69,    72,
+      68,   106,    95,     0,    94,    80,    82,    78,    81,    77,
+      90,    91,    89,   111,   113,   114,   110,   109,    29,    86,
+       0,   106,     0,   106,   106,   106,     0,     0,     0,    87,
+      63,   106,     0,   106,     0,    96,     0,     0,    41,    98,
+       0,     0,   106,    49,    46,    28,     0,    62,     0,   107,
+      92,    42,    43,    44,     0,     0,    48,    61,    64,    45,
+      50
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int16 yydefgoto[] =
 {
-      -1,     3,     4,     5,    32,    33,   107,    34,    35,    36,
-      37,    73,   108,   109,   152,   180,    38,    39,   123,    40,
-      75,   119,    76,    41,   127,    42,    77,     6,    43,    44,
-     135,    45,    79,    46,    47,    48,   110,   111,    78,   112,
-     147,   148,    49,     7,   161,    68,    69,    59
+      -1,     3,     4,     5,    33,    34,   108,    35,    36,    37,
+      38,    74,   109,   110,   157,   186,    39,    40,   124,    41,
+      76,   120,    77,    42,   128,    43,    78,     6,    44,    45,
+     137,    46,    80,    47,    48,    49,   111,   112,    81,   113,
+      79,   134,   152,   153,    50,     7,   165,    69,    70,    60
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -89
+#define YYPACT_NINF -90
 static const yytype_int16 yypact[] =
 {
-       3,     4,   -89,    20,   -89,   100,   -89,     7,   -89,   -89,
-      -8,   -89,    17,     4,    28,     4,    37,    36,     4,    68,
-      87,   -18,    69,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
-     128,   -89,   138,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
-     -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
-     127,   -89,   -89,   110,   -89,   126,   -89,   136,   -89,   137,
-     -89,   147,   150,   152,   -89,   -89,   -18,   -18,   171,   -14,
-     -89,   153,   157,    34,    67,   180,   233,   220,   207,   220,
-     154,   -89,   -89,   -89,   -89,   -89,   -89,     0,   -89,   -18,
-     -18,   110,    44,    44,   -89,   -89,   163,   174,   182,     4,
-       4,   -18,   194,    44,   -89,   219,   -89,   -89,   -89,   -89,
-     223,   -89,   -89,   203,     4,     4,   215,   -89,   -89,   -89,
-     -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
-     -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   213,
-     -89,   -89,   -89,   -89,   -89,   -18,   232,   227,   232,    -5,
-     232,    44,    35,   234,   -89,   -89,   232,   235,   232,   224,
-     -18,   236,   -89,   -89,   237,   238,   232,   216,   -89,   -89,
-     240,   -89,   241,   -89,    71,   -89,   -89,   -89,   242,     4,
-     -89,   -89,   -89,   -89,   -89
+       4,    42,   -90,    96,   -90,   111,   -90,    15,   -90,   -90,
+      75,   -90,    82,    42,   104,    42,   110,   107,    42,   115,
+     125,    -4,   121,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
+     -90,   162,   -90,   163,   -90,   -90,   -90,   -90,   -90,   -90,
+     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
+     -90,   139,   -90,   -90,   138,   -90,   142,   -90,   143,   -90,
+     152,   -90,   164,   167,   168,   -90,   -90,    -4,    -4,    77,
+     -18,   -90,   177,   185,    33,    71,   195,   247,   236,    -2,
+     236,   171,   -90,   -90,   -90,   -90,   -90,   -90,    41,   -90,
+      -4,    -4,   138,    97,    97,   -90,   -90,   186,   187,   194,
+      42,    42,    -4,   196,    97,   -90,   219,   -90,   -90,   -90,
+     -90,   210,   -90,   -90,   204,    42,    42,   199,   -90,   -90,
+     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
+     -90,   222,   -90,   223,   -90,   -90,   -90,   -90,   -90,   -90,
+     -90,   -90,   -90,   -90,   215,   -90,   -90,   -90,   -90,   -90,
+      -4,   222,   228,   222,    -5,   222,    97,    35,   229,   -90,
+     -90,   222,   232,   222,    -4,   -90,   135,   233,   -90,   -90,
+     234,   235,   222,   240,   -90,   -90,   237,   -90,   239,   -13,
+     -90,   -90,   -90,   -90,   244,    42,   -90,   -90,   -90,   -90,
+     -90
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
-     -89,   -89,   255,   267,   -89,    47,   -57,   -89,   -89,   -89,
-     -89,   239,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   130,
-     -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
-     -89,   181,   -89,   -89,   -89,   -89,   -89,   199,   229,    16,
-     162,    -1,    74,    -7,   103,   -65,   -88,   -89
+     -90,   -90,   269,   271,   -90,    23,   -70,   -90,   -90,   -90,
+     -90,   243,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -48,
+     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
+     -90,   -20,   -90,   -90,   -90,   -90,   -90,   206,   205,   -68,
+     -90,   -90,   169,    -1,    27,    -7,   118,   -66,   -89,   -90
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
    number is the opposite.  If zero, do what YYDEFACT says.
    If YYTABLE_NINF, syntax error.  */
-#define YYTABLE_NINF -85
+#define YYTABLE_NINF -86
 static const yytype_int16 yytable[] =
 {
-      10,    87,    88,    53,   141,   142,     1,    64,    65,   160,
-       1,    66,    55,    92,    57,   151,    67,    61,   118,    93,
-      11,   131,     2,   131,   139,   140,    89,    90,   138,     8,
-       9,    89,    90,     2,   -30,    96,   149,    51,   -30,   -30,
-     -30,   -30,   -30,   -30,   -30,   -30,    97,    54,   -30,   -30,
-      98,   -30,    99,   100,   101,   102,   103,   104,    56,   105,
-     167,    91,    58,   166,   106,   168,    60,   -32,    96,    64,
-      65,   -32,   -32,   -32,   -32,   -32,   -32,   -32,   -32,    97,
-     159,   -32,   -32,    98,   -32,    99,   100,   101,   102,   103,
-     104,   121,   105,    62,   132,   174,   132,   106,   146,    70,
-      -5,    12,    89,    90,    13,    14,    15,    16,    17,    18,
-      19,    20,    63,   156,    21,    22,    23,    24,    25,    26,
-      27,    28,    29,   122,   125,    30,   133,    -4,    12,    71,
-      31,    13,    14,    15,    16,    17,    18,    19,    20,    72,
-      51,    21,    22,    23,    24,    25,    26,    27,    28,    29,
-     124,   129,    30,   137,   -84,    96,    81,    31,   -84,   -84,
-     -84,   -84,   -84,   -84,   -84,   -84,    82,    83,   -84,   -84,
-      98,   -84,   -84,   -84,   -84,   -84,   -84,    84,   184,   105,
-      85,    96,    86,    94,   130,   -51,   -51,    95,   -51,   -51,
-     -51,   -51,    97,   143,   -51,   -51,    98,   113,   114,   115,
-     116,     2,    89,    90,   144,   105,   145,   126,    96,   134,
-     117,   -75,   -75,   -75,   -75,   -75,   -75,   -75,   -75,   150,
-     153,   -75,   -75,    98,    13,    14,    15,    16,    17,    18,
-      19,    20,   105,   155,    21,    22,   154,   130,    14,    15,
-     158,    17,    18,    19,    20,    90,   160,    21,    22,   179,
-      31,   163,   164,   165,   173,    89,    90,   162,   128,   170,
-     136,   172,    52,    31,   169,   171,   175,   176,   177,   178,
-     181,   182,   183,    50,   120,    74,    80,   157
+      10,    88,    89,    54,   146,   147,   119,     1,   122,   164,
+      93,   141,    56,   142,    58,   156,    94,    62,     1,    90,
+      91,   131,    65,    66,   144,   145,    67,    90,    91,   132,
+     127,    68,   136,   -31,    97,     2,   154,   -31,   -31,   -31,
+     -31,   -31,   -31,   -31,   -31,    98,    52,   -31,   -31,    99,
+     -31,   100,   101,   102,   103,   104,   -31,   105,   129,   106,
+     138,   173,    92,   141,   107,   142,   174,   172,     8,     9,
+     143,   -33,    97,    90,    91,   -33,   -33,   -33,   -33,   -33,
+     -33,   -33,   -33,    98,   166,   -33,   -33,    99,   -33,   100,
+     101,   102,   103,   104,   -33,   105,    11,   106,   179,   151,
+     123,   126,   107,   135,   125,   130,     2,   139,     2,    90,
+      91,    -5,    12,    55,   161,    13,    14,    15,    16,    17,
+      18,    19,    20,    65,    66,    21,    22,    23,    24,    25,
+      26,    27,    28,    29,    30,    57,    59,    31,    61,    -4,
+      12,    63,    32,    13,    14,    15,    16,    17,    18,    19,
+      20,    64,    71,    21,    22,    23,    24,    25,    26,    27,
+      28,    29,    30,    72,    73,    31,   180,    90,    91,    52,
+      32,   -85,    97,    82,    83,   -85,   -85,   -85,   -85,   -85,
+     -85,   -85,   -85,    84,   190,   -85,   -85,    99,   -85,   -85,
+     -85,   -85,   -85,   -85,   -85,    85,    97,   106,    86,    87,
+     -52,   -52,   140,   -52,   -52,   -52,   -52,    98,    95,   -52,
+     -52,    99,   114,   115,   116,   117,    96,   148,   149,   150,
+     158,   106,   155,   159,    97,   163,   118,   -76,   -76,   -76,
+     -76,   -76,   -76,   -76,   -76,   160,   164,   -76,   -76,    99,
+      13,    14,    15,    16,    17,    18,    19,    20,    91,   106,
+      21,    22,    14,    15,   140,    17,    18,    19,    20,   168,
+     175,    21,    22,   177,   181,   182,   183,    32,   187,   167,
+     188,   169,   170,   171,   185,   189,    53,    51,    32,   176,
+      75,   178,   121,     0,   133,   162,     0,     0,     0,     0,
+     184
 };
 
-static const yytype_uint8 yycheck[] =
+static const yytype_int16 yycheck[] =
 {
-       1,    66,    67,    10,    92,    93,     3,    25,    26,    14,
-       3,    29,    13,    27,    15,   103,    34,    18,    75,    33,
-       0,    78,    30,    80,    89,    90,    31,    32,    28,    25,
-      26,    31,    32,    30,     0,     1,   101,    30,     4,     5,
-       6,     7,     8,     9,    10,    11,    12,    30,    14,    15,
-      16,    17,    18,    19,    20,    21,    22,    23,    30,    25,
-      25,    68,    25,   151,    30,    30,    30,     0,     1,    25,
-      26,     4,     5,     6,     7,     8,     9,    10,    11,    12,
-     145,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      23,    75,    25,    25,    78,   160,    80,    30,    99,    30,
-       0,     1,    31,    32,     4,     5,     6,     7,     8,     9,
-      10,    11,    25,   114,    14,    15,    16,    17,    18,    19,
-      20,    21,    22,    76,    77,    25,    79,     0,     1,     1,
-      30,     4,     5,     6,     7,     8,     9,    10,    11,     1,
-      30,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      76,    77,    25,    79,     0,     1,    30,    30,     4,     5,
-       6,     7,     8,     9,    10,    11,    30,    30,    14,    15,
-      16,    17,    18,    19,    20,    21,    22,    30,   179,    25,
-      30,     1,    30,    30,    30,     5,     6,    30,     8,     9,
-      10,    11,    12,    30,    14,    15,    16,    17,    18,    19,
-      20,    30,    31,    32,    30,    25,    24,    77,     1,    79,
-      30,     4,     5,     6,     7,     8,     9,    10,    11,    25,
-       1,    14,    15,    16,     4,     5,     6,     7,     8,     9,
-      10,    11,    25,    30,    14,    15,    13,    30,     5,     6,
-      25,     8,     9,    10,    11,    32,    14,    14,    15,    33,
-      30,   148,   149,   150,    30,    31,    32,    30,    77,   156,
-      79,   158,     7,    30,    30,    30,    30,    30,    30,   166,
-      30,    30,    30,     6,    75,    36,    47,   115
+       1,    67,    68,    10,    93,    94,    76,     3,    76,    14,
+      28,    81,    13,    81,    15,   104,    34,    18,     3,    32,
+      33,    23,    26,    27,    90,    91,    30,    32,    33,    31,
+      78,    35,    80,     0,     1,    31,   102,     4,     5,     6,
+       7,     8,     9,    10,    11,    12,    31,    14,    15,    16,
+      17,    18,    19,    20,    21,    22,    23,    24,    78,    26,
+      80,    26,    69,   133,    31,   133,    31,   156,    26,    27,
+      29,     0,     1,    32,    33,     4,     5,     6,     7,     8,
+       9,    10,    11,    12,   150,    14,    15,    16,    17,    18,
+      19,    20,    21,    22,    23,    24,     0,    26,   164,   100,
+      77,    78,    31,    80,    77,    78,    31,    80,    31,    32,
+      33,     0,     1,    31,   115,     4,     5,     6,     7,     8,
+       9,    10,    11,    26,    27,    14,    15,    16,    17,    18,
+      19,    20,    21,    22,    23,    31,    26,    26,    31,     0,
+       1,    26,    31,     4,     5,     6,     7,     8,     9,    10,
+      11,    26,    31,    14,    15,    16,    17,    18,    19,    20,
+      21,    22,    23,     1,     1,    26,    31,    32,    33,    31,
+      31,     0,     1,    31,    31,     4,     5,     6,     7,     8,
+       9,    10,    11,    31,   185,    14,    15,    16,    17,    18,
+      19,    20,    21,    22,    23,    31,     1,    26,    31,    31,
+       5,     6,    31,     8,     9,    10,    11,    12,    31,    14,
+      15,    16,    17,    18,    19,    20,    31,    31,    31,    25,
+       1,    26,    26,    13,     1,    26,    31,     4,     5,     6,
+       7,     8,     9,    10,    11,    31,    14,    14,    15,    16,
+       4,     5,     6,     7,     8,     9,    10,    11,    33,    26,
+      14,    15,     5,     6,    31,     8,     9,    10,    11,    31,
+      31,    14,    15,    31,    31,    31,    31,    31,    31,   151,
+      31,   153,   154,   155,    34,    31,     7,     6,    31,   161,
+      37,   163,    76,    -1,    79,   116,    -1,    -1,    -1,    -1,
+     172
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,     3,    30,    36,    37,    38,    62,    78,    25,    26,
-      76,     0,     1,     4,     5,     6,     7,     8,     9,    10,
+       0,     3,    31,    37,    38,    39,    63,    81,    26,    27,
+      79,     0,     1,     4,     5,     6,     7,     8,     9,    10,
       11,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      25,    30,    39,    40,    42,    43,    44,    45,    51,    52,
-      54,    58,    60,    63,    64,    66,    68,    69,    70,    77,
-      38,    30,    37,    78,    30,    76,    30,    76,    25,    82,
-      30,    76,    25,    25,    25,    26,    29,    34,    80,    81,
-      30,     1,     1,    46,    46,    55,    57,    61,    73,    67,
-      73,    30,    30,    30,    30,    30,    30,    80,    80,    31,
-      32,    78,    27,    33,    30,    30,     1,    12,    16,    18,
-      19,    20,    21,    22,    23,    25,    30,    41,    47,    48,
-      71,    72,    74,    17,    18,    19,    20,    30,    41,    56,
-      72,    74,    40,    53,    77,    40,    54,    59,    66,    77,
-      30,    41,    74,    40,    54,    65,    66,    77,    28,    80,
-      80,    81,    81,    30,    30,    24,    76,    75,    76,    80,
-      25,    81,    49,     1,    13,    30,    76,    75,    25,    80,
-      14,    79,    30,    79,    79,    79,    81,    25,    30,    30,
-      79,    30,    79,    30,    80,    30,    30,    30,    79,    33,
-      50,    30,    30,    30,    76
+      23,    26,    31,    40,    41,    43,    44,    45,    46,    52,
+      53,    55,    59,    61,    64,    65,    67,    69,    70,    71,
+      80,    39,    31,    38,    81,    31,    79,    31,    79,    26,
+      85,    31,    79,    26,    26,    26,    27,    30,    35,    83,
+      84,    31,     1,     1,    47,    47,    56,    58,    62,    76,
+      68,    74,    31,    31,    31,    31,    31,    31,    83,    83,
+      32,    33,    81,    28,    34,    31,    31,     1,    12,    16,
+      18,    19,    20,    21,    22,    24,    26,    31,    42,    48,
+      49,    72,    73,    75,    17,    18,    19,    20,    31,    42,
+      57,    73,    75,    41,    54,    80,    41,    55,    60,    67,
+      80,    23,    31,    74,    77,    41,    55,    66,    67,    80,
+      31,    42,    75,    29,    83,    83,    84,    84,    31,    31,
+      25,    79,    78,    79,    83,    26,    84,    50,     1,    13,
+      31,    79,    78,    26,    14,    82,    83,    82,    31,    82,
+      82,    82,    84,    26,    31,    31,    82,    31,    82,    83,
+      31,    31,    31,    31,    82,    34,    51,    31,    31,    31,
+      79
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -1292,7 +1302,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 
   switch (yytype)
     {
-      case 52: /* "choice_entry" */
+      case 53: /* "choice_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1302,7 +1312,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 };
 
 	break;
-      case 58: /* "if_entry" */
+      case 59: /* "if_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1312,7 +1322,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 };
 
 	break;
-      case 64: /* "menu_entry" */
+      case 65: /* "menu_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1644,17 +1654,17 @@ yyreduce:
     { zconf_error("invalid statement"); ;}
     break;
 
-  case 27:
+  case 28:
 
     { zconf_error("unknown option \"%s\"", (yyvsp[(1) - (3)].string)); ;}
     break;
 
-  case 28:
+  case 29:
 
     { zconf_error("invalid option"); ;}
     break;
 
-  case 29:
+  case 30:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
@@ -1664,7 +1674,7 @@ yyreduce:
 ;}
     break;
 
-  case 30:
+  case 31:
 
     {
 	menu_end_entry();
@@ -1672,7 +1682,7 @@ yyreduce:
 ;}
     break;
 
-  case 31:
+  case 32:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
@@ -1682,7 +1692,7 @@ yyreduce:
 ;}
     break;
 
-  case 32:
+  case 33:
 
     {
 	if (current_entry->prompt)
@@ -1694,7 +1704,7 @@ yyreduce:
 ;}
     break;
 
-  case 40:
+  case 41:
 
     {
 	menu_set_type((yyvsp[(1) - (3)].id)->stype);
@@ -1704,7 +1714,7 @@ yyreduce:
 ;}
     break;
 
-  case 41:
+  case 42:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
@@ -1712,7 +1722,7 @@ yyreduce:
 ;}
     break;
 
-  case 42:
+  case 43:
 
     {
 	menu_add_expr(P_DEFAULT, (yyvsp[(2) - (4)].expr), (yyvsp[(3) - (4)].expr));
@@ -1724,7 +1734,7 @@ yyreduce:
 ;}
     break;
 
-  case 43:
+  case 44:
 
     {
 	menu_add_symbol(P_SELECT, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
@@ -1732,7 +1742,7 @@ yyreduce:
 ;}
     break;
 
-  case 44:
+  case 45:
 
     {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[(2) - (5)].symbol), (yyvsp[(3) - (5)].symbol)), (yyvsp[(4) - (5)].expr));
@@ -1740,7 +1750,7 @@ yyreduce:
 ;}
     break;
 
-  case 47:
+  case 48:
 
     {
 	struct kconf_id *id = kconf_id_lookup((yyvsp[(2) - (3)].string), strlen((yyvsp[(2) - (3)].string)));
@@ -1752,17 +1762,17 @@ yyreduce:
 ;}
     break;
 
-  case 48:
+  case 49:
 
     { (yyval.string) = NULL; ;}
     break;
 
-  case 49:
+  case 50:
 
     { (yyval.string) = (yyvsp[(2) - (2)].string); ;}
     break;
 
-  case 50:
+  case 51:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), SYMBOL_CHOICE);
@@ -1773,14 +1783,14 @@ yyreduce:
 ;}
     break;
 
-  case 51:
+  case 52:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 52:
+  case 53:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_CHOICE, T_ENDCHOICE)) {
@@ -1790,7 +1800,7 @@ yyreduce:
 ;}
     break;
 
-  case 60:
+  case 61:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
@@ -1798,7 +1808,7 @@ yyreduce:
 ;}
     break;
 
-  case 61:
+  case 62:
 
     {
 	if ((yyvsp[(1) - (3)].id)->stype == S_BOOLEAN || (yyvsp[(1) - (3)].id)->stype == S_TRISTATE) {
@@ -1811,7 +1821,7 @@ yyreduce:
 ;}
     break;
 
-  case 62:
+  case 63:
 
     {
 	current_entry->sym->flags |= SYMBOL_OPTIONAL;
@@ -1819,7 +1829,7 @@ yyreduce:
 ;}
     break;
 
-  case 63:
+  case 64:
 
     {
 	if ((yyvsp[(1) - (4)].id)->stype == S_UNKNOWN) {
@@ -1831,7 +1841,7 @@ yyreduce:
 ;}
     break;
 
-  case 66:
+  case 67:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
@@ -1841,7 +1851,7 @@ yyreduce:
 ;}
     break;
 
-  case 67:
+  case 68:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_IF, T_ENDIF)) {
@@ -1851,14 +1861,14 @@ yyreduce:
 ;}
     break;
 
-  case 73:
+  case 74:
 
     {
 	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
 ;}
     break;
 
-  case 74:
+  case 75:
 
     {
 	menu_add_entry(NULL);
@@ -1867,14 +1877,14 @@ yyreduce:
 ;}
     break;
 
-  case 75:
+  case 76:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 76:
+  case 77:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_MENU, T_ENDMENU)) {
@@ -1884,7 +1894,7 @@ yyreduce:
 ;}
     break;
 
-  case 82:
+  case 83:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
@@ -1892,7 +1902,7 @@ yyreduce:
 ;}
     break;
 
-  case 83:
+  case 84:
 
     {
 	menu_add_entry(NULL);
@@ -1901,14 +1911,14 @@ yyreduce:
 ;}
     break;
 
-  case 84:
+  case 85:
 
     {
 	menu_end_entry();
 ;}
     break;
 
-  case 85:
+  case 86:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
@@ -1916,14 +1926,14 @@ yyreduce:
 ;}
     break;
 
-  case 86:
+  case 87:
 
     {
 	current_entry->help = (yyvsp[(2) - (2)].string);
 ;}
     break;
 
-  case 91:
+  case 92:
 
     {
 	menu_add_dep((yyvsp[(3) - (4)].expr));
@@ -1931,84 +1941,91 @@ yyreduce:
 ;}
     break;
 
-  case 93:
+  case 96:
+
+    {
+	menu_add_visibility((yyvsp[(2) - (2)].expr));
+;}
+    break;
+
+  case 98:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].expr));
 ;}
     break;
 
-  case 96:
+  case 101:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 97:
+  case 102:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 98:
+  case 103:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 101:
+  case 106:
 
     { (yyval.expr) = NULL; ;}
     break;
 
-  case 102:
+  case 107:
 
     { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
     break;
 
-  case 103:
+  case 108:
 
     { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); ;}
     break;
 
-  case 104:
+  case 109:
 
     { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 105:
+  case 110:
 
     { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 106:
+  case 111:
 
     { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
     break;
 
-  case 107:
+  case 112:
 
     { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); ;}
     break;
 
-  case 108:
+  case 113:
 
     { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 109:
+  case 114:
 
     { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 110:
+  case 115:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 111:
+  case 116:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 112:
+  case 117:
 
     { (yyval.string) = NULL; ;}
     break;
@@ -2278,6 +2295,7 @@ static const char *zconf_tokenname(int token)
 	case T_IF:		return "if";
 	case T_ENDIF:		return "endif";
 	case T_DEPENDS:		return "depends";
+	case T_VISIBLE:		return "visible";
 	}
 	return "<token>";
 }
-- 
1.7.2.30.gc37d7.dirty

