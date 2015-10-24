Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35106 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbbJXEUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2015 00:20:49 -0400
Received: by wicll6 with SMTP id ll6so53445374wic.0
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2015 21:20:48 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 Oct 2015 05:20:47 +0100
Message-ID: <CAOQWjw3bfX8XWsXRhCJWy84MTKzpR2X-ivBQmVio-O3v+wdVJA@mail.gmail.com>
Subject: [PATCH]: Correct references to ISO 3166-1 in help/translations
From: Nick Morrott <knowledgejunkie@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several incorrect references to the ISO 3166-1 standard
(country codes) in the output of some DVBv5 utilities and in the
v4l-utils translations file.

This patch corrects these errors.

Signed-off-by: Nick Morrott <knowledgejunkie@gmail.com>
---

diff --git a/lib/include/libdvbv5/dvb-fe.h b/lib/include/libdvbv5/dvb-fe.h
index 5a842ed..43fc282 100644
--- a/lib/include/libdvbv5/dvb-fe.h
+++ b/lib/include/libdvbv5/dvb-fe.h
@@ -724,7 +724,7 @@ int dvb_fe_is_satellite(uint32_t delivery_system);
  * @ingroup frontend
  *
  * @param parms        struct dvb_v5_fe_parms pointer to the opened device
- * @param country    default country, in ISO 3316-1 two letter code. If
+ * @param country    default country, in ISO 3166-1 two letter code. If
  *            NULL, default charset is guessed from locale environment
  *            variables.
  *
diff --git a/utils/dvb/dvbv5-scan.1.in b/utils/dvb/dvbv5-scan.1.in
index e6161a1..8958ceb 100644
--- a/utils/dvb/dvbv5-scan.1.in
+++ b/utils/dvb/dvbv5-scan.1.in
@@ -36,7 +36,7 @@ Force dvbv5\-scan to use DVBv3 only.
 Use the given adapter. Default value: 0.
 .TP
 \fB\-C\fR, \fB\-\-cc\fR=\fIcountry_code\fR
-Set the default country to be used by the MPEG-TS parsers, in ISO 3316-1 two
+Set the default country to be used by the MPEG-TS parsers, in ISO 3166-1 two
 letter code. If not specified, the default charset is guessed from the
 locale environment variables.
 .TP
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index be1586d..c25cca5 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -89,7 +89,7 @@ static const struct argp_option options[] = {
     {"input-format", 'I',    N_("format"),        0, N_("Input
format: CHANNEL, DVBV5 (default: DVBV5)"), 0},
     {"output-format", 'O',    N_("format"),        0, N_("Output
format: VDR, CHANNEL, ZAP, DVBV5 (default: DVBV5)"), 0},
     {"dvbv3",    '3',    0,            0, N_("Use DVBv3 only"), 0},
-    {"cc",        'C',    N_("country_code"),    0, N_("Set the
default country to be used (in ISO 3316-1 two letter code)"), 0},
+    {"cc",        'C',    N_("country_code"),    0, N_("Set the
default country to be used (in ISO 3166-1 two letter code)"), 0},
     {"help",        '?',    0,        0,    N_("Give this help list"), -1},
     {"usage",    -3,    0,        0,    N_("Give a short usage message")},
     {"version",    'V',    0,        0,    N_("Print program version"), -1},
diff --git a/utils/dvb/dvbv5-zap.1.in b/utils/dvb/dvbv5-zap.1.in
index 80d9701..9bf2687 100644
--- a/utils/dvb/dvbv5-zap.1.in
+++ b/utils/dvb/dvbv5-zap.1.in
@@ -41,7 +41,7 @@ Select a different audio Packet ID (PID).
 The default is to use the first audio PID found at the \fBchannel-name-file\fR.
 .TP
 \fB\-C\fR, \fB\-\-cc\fR=\fIcountry_code\fR
-Set the default country to be used by the MPEG-TS parsers, in ISO 3316-1 two
+Set the default country to be used by the MPEG-TS parsers, in ISO 3166-1 two
 letter code. If not specified, the default charset is guessed from the
 locale environment variables.
 .TP
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 2812166..b684919 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -103,7 +103,7 @@ static const struct argp_option options[] = {
     {"wait",    'W', N_("time"),        0, N_("adds additional wait
time for DISEqC command completion"), 0},
     {"exit",    'x', NULL,            0, N_("exit after tuning"), 0},
     {"low_traffic",    'X', NULL,            0, N_("also shows DVB
traffic with less then 1 packet per second"), 0},
-    {"cc",        'C', N_("country_code"),    0, N_("Set the default
country to be used (in ISO 3316-1 two letter code)"), 0},
+    {"cc",        'C', N_("country_code"),    0, N_("Set the default
country to be used (in ISO 3166-1 two letter code)"), 0},
     {"help",        '?',    0,        0,    N_("Give this help list"), -1},
     {"usage",    -3,    0,        0,    N_("Give a short usage message")},
     {"version",    -4,    0,        0,    N_("Print program version"), -1},
diff --git a/v4l-utils-po/pt_BR.po b/v4l-utils-po/pt_BR.po
index 888e9c8..76abc0a 100644
--- a/v4l-utils-po/pt_BR.po
+++ b/v4l-utils-po/pt_BR.po
@@ -865,9 +865,9 @@ msgid "country_code"
 msgstr "código_país"

 #: utils/dvb/dvbv5-scan.c:92 utils/dvb/dvbv5-zap.c:106
-msgid "Set the default country to be used (in ISO 3316-1 two letter code)"
+msgid "Set the default country to be used (in ISO 3166-1 two letter code)"
 msgstr ""
-"Configura o país padrão a ser utilizado (em código de 2 letras ISO 3316-1)"
+"Configura o país padrão a ser utilizado (em código de 2 letras ISO 3166-1)"

 #: utils/dvb/dvbv5-scan.c:254
 msgid "openening pat demux failed"
diff --git a/v4l-utils-po/v4l-utils.pot b/v4l-utils-po/v4l-utils.pot
index f07380b..c34d4e1 100644
--- a/v4l-utils-po/v4l-utils.pot
+++ b/v4l-utils-po/v4l-utils.pot
@@ -810,7 +810,7 @@ msgid "country_code"
 msgstr ""

 #: utils/dvb/dvbv5-scan.c:92 utils/dvb/dvbv5-zap.c:106
-msgid "Set the default country to be used (in ISO 3316-1 two letter code)"
+msgid "Set the default country to be used (in ISO 3166-1 two letter code)"
 msgstr ""

 #: utils/dvb/dvbv5-scan.c:254
