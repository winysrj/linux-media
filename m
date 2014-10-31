Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60973 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742AbaJaNOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:46 -0400
Received: by mail-pd0-f172.google.com with SMTP id r10so7266650pdi.31
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:14:33 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 6/7] v4l-utils/dvb: add COUNTRY property
Date: Fri, 31 Oct 2014 22:13:43 +0900
Message-Id: <1414761224-32761-7-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

to distinguish country variants of delivery systems like ISDB-T.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 configure.ac                      |   4 +
 lib/include/libdvbv5/countries.h  | 307 +++++++++++++++++++++++++++
 lib/include/libdvbv5/dvb-fe.h     |  14 ++
 lib/include/libdvbv5/dvb-v5-std.h |   7 +-
 lib/libdvbv5/Makefile.am          |   2 +
 lib/libdvbv5/countries.c          | 427 ++++++++++++++++++++++++++++++++++++++
 lib/libdvbv5/dvb-fe-priv.h        |   6 +-
 lib/libdvbv5/dvb-fe.c             |  76 ++++++-
 lib/libdvbv5/dvb-file.c           |  19 ++
 lib/libdvbv5/dvb-v5-std.c         |   2 +
 utils/dvb/dvbv5-scan.c            |   9 +
 utils/dvb/dvbv5-zap.c             |  10 +
 12 files changed, 879 insertions(+), 4 deletions(-)
 create mode 100644 lib/include/libdvbv5/countries.h
 create mode 100644 lib/libdvbv5/countries.c

diff --git a/configure.ac b/configure.ac
index 9646fe9..d44214f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -55,6 +55,8 @@ AC_CONFIG_FILES([Makefile
 	utils/dvb/dvbv5-zap.1
 ])
 
+AC_GNU_SOURCE
+
 AM_INIT_AUTOMAKE([1.9 subdir-objects no-dist-gzip dist-bzip2 -Wno-portability]) # 1.10 is needed for target_LIBTOOLFLAGS
 
 AM_MAINTAINER_MODE
@@ -80,6 +82,8 @@ gl_VISIBILITY
 AC_CHECK_HEADERS([sys/klog.h])
 AC_CHECK_FUNCS([klogctl])
 
+AC_CHECK_FUNCS([__secure_getenv secure_getenv])
+
 # Check host os
 case "$host_os" in
   linux*)
diff --git a/lib/include/libdvbv5/countries.h b/lib/include/libdvbv5/countries.h
new file mode 100644
index 0000000..0766717
--- /dev/null
+++ b/lib/include/libdvbv5/countries.h
@@ -0,0 +1,307 @@
+/*
+ * Copyright (C) 2006, 2007, 2008, 2009 Winfried Koehler
+ * Copyright (C) 2014 Akihiro Tsukada
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. if not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+/**
+ * @file countries.h
+ * @ingroup ancillary
+ * @brief Provides ancillary code to convert ISO 3166-1 country codes
+ * @copyright GNU General Public License version 2 (GPLv2)
+ * @author Winfried Koehler
+ * @author Akihiro Tsukada
+ *
+ * @par Bug Report
+ * Please submit bug reports and patches to linux-media@vger.kernel.org
+ */
+
+#ifndef _COUNTRIES_H_
+#define _COUNTRIES_H_
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* ISO-3166-1 alpha-2 country code */
+enum dvb_country_t {
+    COUNTRY_UNKNOWN,
+
+    AD,
+    AE,
+    AF,
+    AG,
+    AI,
+    AL,
+    AM,
+    AO,
+    AQ,
+    AR,
+    AS,
+    AT,
+    AU,
+    AW,
+    AX,
+    AZ,
+    BA,
+    BB,
+    BD,
+    BE,
+    BF,
+    BG,
+    BH,
+    BI,
+    BJ,
+    BL,
+    BM,
+    BN,
+    BO,
+    BQ,
+    BR,
+    BS,
+    BT,
+    BV,
+    BW,
+    BY,
+    BZ,
+    CA,
+    CC,
+    CD,
+    CF,
+    CG,
+    CH,
+    CI,
+    CK,
+    CL,
+    CM,
+    CN,
+    CO,
+    CR,
+    CU,
+    CV,
+    CW,
+    CX,
+    CY,
+    CZ,
+    DE,
+    DJ,
+    DK,
+    DM,
+    DO,
+    DZ,
+    EC,
+    EE,
+    EG,
+    EH,
+    ER,
+    ES,
+    ET,
+    FI,
+    FJ,
+    FK,
+    FM,
+    FO,
+    FR,
+    GA,
+    GB,
+    GD,
+    GE,
+    GF,
+    GG,
+    GH,
+    GI,
+    GL,
+    GM,
+    GN,
+    GP,
+    GQ,
+    GR,
+    GS,
+    GT,
+    GU,
+    GW,
+    GY,
+    HK,
+    HM,
+    HN,
+    HR,
+    HT,
+    HU,
+    ID,
+    IE,
+    IL,
+    IM,
+    IN,
+    IO,
+    IQ,
+    IR,
+    IS,
+    IT,
+    JE,
+    JM,
+    JO,
+    JP,
+    KE,
+    KG,
+    KH,
+    KI,
+    KM,
+    KN,
+    KP,
+    KR,
+    KW,
+    KY,
+    KZ,
+    LA,
+    LB,
+    LC,
+    LI,
+    LK,
+    LR,
+    LS,
+    LT,
+    LU,
+    LV,
+    LY,
+    MA,
+    MC,
+    MD,
+    ME,
+    MF,
+    MG,
+    MH,
+    MK,
+    ML,
+    MM,
+    MN,
+    MO,
+    MP,
+    MQ,
+    MR,
+    MS,
+    MT,
+    MU,
+    MV,
+    MW,
+    MX,
+    MY,
+    MZ,
+    NA,
+    NC,
+    NE,
+    NF,
+    NG,
+    NI,
+    NL,
+    NO,
+    NP,
+    NR,
+    NU,
+    NZ,
+    OM,
+    PA,
+    PE,
+    PF,
+    PG,
+    PH,
+    PK,
+    PL,
+    PM,
+    PN,
+    PR,
+    PS,
+    PT,
+    PW,
+    PY,
+    QA,
+    RE,
+    RO,
+    RS,
+    RU,
+    RW,
+    SA,
+    SB,
+    SC,
+    SD,
+    SE,
+    SG,
+    SH,
+    SI,
+    SJ,
+    SK,
+    SL,
+    SM,
+    SN,
+    SO,
+    SR,
+    SS,
+    ST,
+    SV,
+    SX,
+    SY,
+    SZ,
+    TC,
+    TD,
+    TF,
+    TG,
+    TH,
+    TJ,
+    TK,
+    TL,
+    TM,
+    TN,
+    TO,
+    TR,
+    TT,
+    TV,
+    TW,
+    TZ,
+    UA,
+    UG,
+    UM,
+    US,
+    UY,
+    UZ,
+    VA,
+    VC,
+    VE,
+    VG,
+    VI,
+    VN,
+    VU,
+    WF,
+    WS,
+    YE,
+    YT,
+    ZA,
+    ZM,
+    ZW,
+};
+
+extern enum dvb_country_t dvb_country_a2_to_id (const char * name);
+extern enum dvb_country_t dvb_country_a3_to_id (const char * name);
+
+extern const char *dvb_country_to_2letters(int id);
+extern const char *dvb_country_to_3letters(int id);
+extern const char *dvb_country_to_name(int id);
+
+extern enum dvb_country_t dvb_guess_user_country(void);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/libdvbv5/dvb-fe.h b/lib/include/libdvbv5/dvb-fe.h
index ba4c2dc..b7f56ca 100644
--- a/lib/include/libdvbv5/dvb-fe.h
+++ b/lib/include/libdvbv5/dvb-fe.h
@@ -719,6 +719,20 @@ int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
  */
 int dvb_fe_is_satellite(uint32_t delivery_system);
 
+/**
+ * @brief Set default country variant of delivery systems like ISDB-T
+ * @ingroup frontend
+ *
+ * @param parms		struct dvb_v5_fe_parms pointer to the opened device
+ * @param country	default country, in ISO 3316-1 two letter code
+ * @return 0 if success or an errorno otherwise.
+ *
+ * If this function is called with @ref country NULL,
+ * the default country is guessed from the locale environment variables.
+ * "COUNTRY" property in dvb_fe_set_parm() overrides the setting.
+ */
+int dvb_fe_set_default_country(struct dvb_v5_fe_parms *parms, const char *cc);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/lib/include/libdvbv5/dvb-v5-std.h b/lib/include/libdvbv5/dvb-v5-std.h
index c03b0d3..6ca8c90 100644
--- a/lib/include/libdvbv5/dvb-v5-std.h
+++ b/lib/include/libdvbv5/dvb-v5-std.h
@@ -93,6 +93,10 @@
  *	@brief DVB-T2 PLS mode. Not used internally. It is needed
  *			only for file conversion.
  *	@ingroup frontend
+ * @def DTV_COUNTRY_CODE
+ *	@brief Country variant of international delivery system standard.
+		in ISO 3166-1 two letter code.
+ *	@ingroup frontend
  * @def DTV_MAX_USER_COMMAND
  *	 @brief Last user command
  *	@ingroup frontend
@@ -115,8 +119,9 @@
 #define DTV_FREQ_BPF            (DTV_USER_COMMAND_START + 9)
 #define DTV_PLS_CODE		(DTV_USER_COMMAND_START + 10)
 #define DTV_PLS_MODE		(DTV_USER_COMMAND_START + 11)
+#define DTV_COUNTRY_CODE	(DTV_USER_COMMAND_START + 12)
 
-#define DTV_MAX_USER_COMMAND    DTV_PLS_MODE
+#define DTV_MAX_USER_COMMAND    DTV_COUNTRY_CODE
 
 #define DTV_USER_NAME_SIZE	(1 + DTV_MAX_USER_COMMAND - DTV_USER_COMMAND_START)
 
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index f126dc5..f0c0b3a 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -6,6 +6,7 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/dvb-demux.h \
 	../include/libdvbv5/dvb-v5-std.h \
 	../include/libdvbv5/dvb-file.h \
+	../include/libdvbv5/countries.h \
 	../include/libdvbv5/crc32.h \
 	../include/libdvbv5/dvb-frontend.h \
 	../include/libdvbv5/dvb-fe.h \
@@ -56,6 +57,7 @@ endif
 libdvbv5_la_SOURCES = \
         compat-soname.c \
 	crc32.c \
+	countries.c \
 	dvb-legacy-channel-format.c \
 	dvb-zap-format.c \
 	dvb-vdr-format.c \
diff --git a/lib/libdvbv5/countries.c b/lib/libdvbv5/countries.c
new file mode 100644
index 0000000..7acdcc7
--- /dev/null
+++ b/lib/libdvbv5/countries.c
@@ -0,0 +1,427 @@
+/*
+ * Copyright (C) 2014 Akihiro Tsukada 
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <config.h>
+#include "libdvbv5/countries.h"
+
+#include <ctype.h>
+#include <stdlib.h>
+#include <string.h>
+#include <strings.h>
+
+struct cCountry {
+	enum dvb_country_t id;
+	const char *alpha2_name;
+	const char *alpha3_name;
+	const char *short_name;
+};
+
+/* 
+ * constants from ISO 3166-1.
+ * sorted alphabetically by two-letter(alpha-2) country name and
+ * in the same order with enum dvb_country_t.
+ */
+static const struct cCountry country_list[] = {
+	/* id, alpha-2, alpha-3, short name */
+
+	{ COUNTRY_UNKNOWN, "", "", "(Unknown Country)" },
+
+	{ AD, "AD", "AND", "Andorra" },
+	{ AE, "AE", "ARE", "United Arab Emirates" },
+	{ AF, "AF", "AFG", "Afghanistan" },
+	{ AG, "AG", "ATG", "Antigua and Barbuda" },
+	{ AI, "AI", "AIA", "Anguilla" },
+	{ AL, "AL", "ALB", "Albania" },
+	{ AM, "AM", "ARM", "Armenia" },
+	{ AO, "AO", "AGO", "Angola" },
+	{ AQ, "AQ", "ATA", "Antarctica" },
+	{ AR, "AR", "ARG", "Argentina" },
+	{ AS, "AS", "ASM", "American Samoa" },
+	{ AT, "AT", "AUT", "Austria" },
+	{ AU, "AU", "AUS", "Australia" },
+	{ AW, "AW", "ABW", "Aruba" },
+	{ AX, "AX", "ALA", "Aland Islands" },
+	{ AZ, "AZ", "AZE", "Azerbaijan" },
+	{ BA, "BA", "BIH", "Bosnia and Herzegovina" },
+	{ BB, "BB", "BRB", "Barbados" },
+	{ BD, "BD", "BGD", "Bangladesh" },
+	{ BE, "BE", "BEL", "Belgium" },
+	{ BF, "BF", "BFA", "Burkina Faso" },
+	{ BG, "BG", "BGR", "Bulgaria" },
+	{ BH, "BH", "BHR", "Bahrain" },
+	{ BI, "BI", "BDI", "Burundi" },
+	{ BJ, "BJ", "BEN", "Benin" },
+	{ BL, "BL", "534", "Saint Barthelemy" },
+	{ BM, "BM", "BMU", "Bermuda" },
+	{ BN, "BN", "BRN", "Brunei Darussalam" },
+	{ BO, "BO", "BOL", "Plurinational State of Bolivia" },
+	{ BQ, "BQ", "BES", "Bonaire, Saint Eustatius and Saba" },
+	{ BR, "BR", "BRA", "Brazil" },
+	{ BS, "BS", "BHS", "Bahamas" },
+	{ BT, "BT", "BTN", "Bhutan" },
+	{ BV, "BV", "BVT", "Bouvet Island" },
+	{ BW, "BW", "BWA", "Botswana" },
+	{ BY, "BY", "BLR", "Belarus" },
+	{ BZ, "BZ", "BLZ", "Belize" },
+	{ CA, "CA", "CAN", "Canada" },
+	{ CC, "CC", "CCK", "Cocos (Keeling) Islands" },
+	{ CD, "CD", "COD", "The Democratic Republic of the Congo" },
+	{ CF, "CF", "CAF", "Central African Republic" },
+	{ CG, "CG", "COG", "Congo" },
+	{ CH, "CH", "CHE", "Switzerland" },
+	{ CI, "CI", "CIV", "Cote d'Ivoire" },
+	{ CK, "CK", "COK", "Cook Islands" },
+	{ CL, "CL", "CHL", "Chile" },
+	{ CM, "CM", "CMR", "Cameroon" },
+	{ CN, "CN", "CHN", "China" },
+	{ CO, "CO", "COL", "Colombia" },
+	{ CR, "CR", "CRI", "Costa Rica" },
+	{ CU, "CU", "CUB", "Cuba" },
+	{ CV, "CV", "CPV", "Cape Verde" },
+	{ CW, "CW", "CUW", "Curacao" },
+	{ CX, "CX", "CXR", "Christmas Island" },
+	{ CY, "CY", "CYP", "Cyprus" },
+	{ CZ, "CZ", "CZE", "Czech Republic" },
+	{ DE, "DE", "DEU", "Germany" },
+	{ DJ, "DJ", "DJI", "Djibouti" },
+	{ DK, "DK", "DNK", "Denmark" },
+	{ DM, "DM", "DMA", "Dominica" },
+	{ DO, "DO", "DOM", "Dominican Republic" },
+	{ DZ, "DZ", "DZA", "Algeria" },
+	{ EC, "EC", "ECU", "Ecuador" },
+	{ EE, "EE", "EST", "Estonia" },
+	{ EG, "EG", "EGY", "Egypt" },
+	{ EH, "EH", "ESH", "Western Sahara" },
+	{ ER, "ER", "ERI", "Eritrea" },
+	{ ES, "ES", "ESP", "Spain" },
+	{ ET, "ET", "ETH", "Ethiopia" },
+	{ FI, "FI", "FIN", "Finland" },
+	{ FJ, "FJ", "FJI", "Fiji" },
+	{ FK, "FK", "FLK", "Falkland Islands (Malvinas)" },
+	{ FM, "FM", "FSM", "Federated States of Micronesia" },
+	{ FO, "FO", "534", "Faroe Islands" },
+	{ FR, "FR", "FRA", "France" },
+	{ GA, "GA", "GAB", "Gabon" },
+	{ GB, "GB", "GBR", "United Kingdom" },
+	{ GD, "GD", "GRD", "Grenada" },
+	{ GE, "GE", "GEO", "Georgia" },
+	{ GF, "GF", "GUF", "French Guiana" },
+	{ GG, "GG", "GGY", "Guernsey" },
+	{ GH, "GH", "GHA", "Ghana" },
+	{ GI, "GI", "GIB", "Gibraltar" },
+	{ GL, "GL", "GRL", "Greenland" },
+	{ GM, "GM", "GMB", "Gambia" },
+	{ GN, "GN", "GIN", "Guinea" },
+	{ GP, "GP", "GLP", "Guadeloupe" },
+	{ GQ, "GQ", "GNQ", "Equatorial Guinea" },
+	{ GR, "GR", "GRC", "Greece" },
+	{ GS, "GS", "SGS", "South Georgia and the South Sandwich Islands" },
+	{ GT, "GT", "GTM", "Guatemala" },
+	{ GU, "GU", "GUM", "Guam" },
+	{ GW, "GW", "GNB", "Guinea-Bissau" },
+	{ GY, "GY", "GUY", "Guyana" },
+	{ HK, "HK", "HKG", "Hong Kong" },
+	{ HM, "HM", "HMD", "Heard Island and McDonald Islands" },
+	{ HN, "HN", "HND", "Honduras" },
+	{ HR, "HR", "HRV", "Croatia" },
+	{ HT, "HT", "HTI", "Haiti" },
+	{ HU, "HU", "HUN", "Hungary" },
+	{ ID, "ID", "IDN", "Indonesia" },
+	{ IE, "IE", "IRL", "Ireland" },
+	{ IL, "IL", "ISR", "Israel" },
+	{ IM, "IM", "IMN", "Isle of Man" },
+	{ IN, "IN", "IND", "India" },
+	{ IO, "IO", "IOT", "British Indian Ocean Territory" },
+	{ IQ, "IQ", "IRQ", "Iraq" },
+	{ IR, "IR", "IRN", "Islamic Republic of Iran" },
+	{ IS, "IS", "ISL", "Iceland" },
+	{ IT, "IT", "ITA", "Italy" },
+	{ JE, "JE", "JEY", "Jersey" },
+	{ JM, "JM", "JAM", "Jamaica" },
+	{ JO, "JO", "JOR", "Jordan" },
+	{ JP, "JP", "JPN", "Japan" },
+	{ KE, "KE", "KEN", "Kenya" },
+	{ KG, "KG", "KGZ", "Kyrgyzstan" },
+	{ KH, "KH", "KHM", "Cambodia" },
+	{ KI, "KI", "KIR", "Kiribati" },
+	{ KM, "KM", "COM", "Comoros" },
+	{ KN, "KN", "KNA", "Saint Kitts and Nevis" },
+	{ KP, "KP", "PRK", "Democratic People's Republic of Korea" },
+	{ KR, "KR", "KOR", "Republic of Korea" },
+	{ KW, "KW", "KWT", "Kuwait" },
+	{ KY, "KY", "CYM", "Cayman Islands" },
+	{ KZ, "KZ", "KAZ", "Kazakhstan" },
+	{ LA, "LA", "LAO", "Lao People's Democratic Republic" },
+	{ LB, "LB", "LBN", "Lebanon" },
+	{ LC, "LC", "LCA", "Saint Lucia" },
+	{ LI, "LI", "LIE", "Liechtenstein" },
+	{ LK, "LK", "LKA", "Sri Lanka" },
+	{ LR, "LR", "LBR", "Liberia" },
+	{ LS, "LS", "LSO", "Lesotho" },
+	{ LT, "LT", "LTU", "Lithuania" },
+	{ LU, "LU", "LUX", "Luxembourg" },
+	{ LV, "LV", "LVA", "Latvia" },
+	{ LY, "LY", "LBY", "Libyan Arab Jamahiriya" },
+	{ MA, "MA", "MAR", "Morocco" },
+	{ MC, "MC", "MCO", "Monaco" },
+	{ MD, "MD", "MDA", "Republic of Moldova" },
+	{ ME, "ME", "MNE", "Montenegro" },
+	{ MF, "MF", "MAF", "Saint Martin (French part)" },
+	{ MG, "MG", "MDG", "Madagascar" },
+	{ MH, "MH", "MHL", "Marshall Islands" },
+	{ MK, "MK", "MKD", "The Former Yugoslav Republic of Macedonia" },
+	{ ML, "ML", "MLI", "Mali" },
+	{ MM, "MM", "MMR", "Myanmar" },
+	{ MN, "MN", "MNG", "Mongolia" },
+	{ MO, "MO", "MAC", "Macao" },
+	{ MP, "MP", "MNP", "Northern Mariana Islands" },
+	{ MQ, "MQ", "MTQ", "Martinique" },
+	{ MR, "MR", "MRT", "Mauritania" },
+	{ MS, "MS", "MSR", "Montserrat" },
+	{ MT, "MT", "MLT", "Malta" },
+	{ MU, "MU", "MUS", "Mauritius" },
+	{ MV, "MV", "MDV", "Maldives" },
+	{ MW, "MW", "MWI", "Malawi" },
+	{ MX, "MX", "MEX", "Mexico" },
+	{ MY, "MY", "MYS", "Malaysia" },
+	{ MZ, "MZ", "MOZ", "Mozambique" },
+	{ NA, "NA", "NAM", "Namibia" },
+	{ NC, "NC", "NCL", "New Caledonia" },
+	{ NE, "NE", "NER", "Niger" },
+	{ NF, "NF", "NFK", "Norfolk Island" },
+	{ NG, "NG", "NGA", "Nigeria" },
+	{ NI, "NI", "NIC", "Nicaragua" },
+	{ NL, "NL", "NLD", "Netherlands" },
+	{ NO, "NO", "NOR", "Norway" },
+	{ NP, "NP", "NPL", "Nepal" },
+	{ NR, "NR", "NRU", "Nauru" },
+	{ NU, "NU", "NIU", "Niue" },
+	{ NZ, "NZ", "NZL", "New Zealand" },
+	{ OM, "OM", "OMN", "Oman" },
+	{ PA, "PA", "PAN", "Panama" },
+	{ PE, "PE", "PER", "Peru" },
+	{ PF, "PF", "PYF", "French Polynesia" },
+	{ PG, "PG", "PNG", "Papua New Guinea" },
+	{ PH, "PH", "PHL", "Philippines" },
+	{ PK, "PK", "PAK", "Pakistan" },
+	{ PL, "PL", "POL", "Poland" },
+	{ PM, "PM", "SPM", "Saint Pierre and Miquelon" },
+	{ PN, "PN", "PCN", "Pitcairn" },
+	{ PR, "PR", "PRI", "Puerto Rico" },
+	{ PS, "PS", "PSE", "Occupied Palestinian Territory" },
+	{ PT, "PT", "PRT", "Portugal" },
+	{ PW, "PW", "PLW", "Palau" },
+	{ PY, "PY", "PRY", "Paraguay" },
+	{ QA, "QA", "QAT", "Qatar" },
+	{ RE, "RE", "REU", "Reunion" },
+	{ RO, "RO", "ROU", "Romania" },
+	{ RS, "RS", "SRB", "Serbia" },
+	{ RU, "RU", "RUS", "Russian Federation" },
+	{ RW, "RW", "RWA", "Rwanda" },
+	{ SA, "SA", "SAU", "Saudi Arabia" },
+	{ SB, "SB", "SLB", "Solomon Islands" },
+	{ SC, "SC", "SYC", "Seychelles" },
+	{ SD, "SD", "SDN", "Sudan" },
+	{ SE, "SE", "SWE", "Sweden" },
+	{ SG, "SG", "SGP", "Singapore" },
+	{ SH, "SH", "SHN", "Saint Helena, Ascension and Tristan da Cunha" },
+	{ SI, "SI", "SVN", "Slovenia" },
+	{ SJ, "SJ", "534", "Svalbard and Jan Mayen" },
+	{ SK, "SK", "SVK", "Slovakia" },
+	{ SL, "SL", "SLE", "Sierra Leone" },
+	{ SM, "SM", "SMR", "San Marino" },
+	{ SN, "SN", "SEN", "Senegal" },
+	{ SO, "SO", "SOM", "Somalia" },
+	{ SR, "SR", "SUR", "Suriname" },
+	{ SS, "SS", "SSD", "South Sudan" },
+	{ ST, "ST", "STP", "Sao Tome and Principe" },
+	{ SV, "SV", "SLV", "El Salvador" },
+	{ SX, "SX", "SXM", "Sint Maarten (Dutch part)" },
+	{ SY, "SY", "SYR", "Syrian Arab Republic" },
+	{ SZ, "SZ", "SWZ", "Swaziland" },
+	{ TC, "TC", "TCA", "Turks and Caicos Islands" },
+	{ TD, "TD", "TCD", "Chad" },
+	{ TF, "TF", "ATF", "French Southern Territories" },
+	{ TG, "TG", "TGO", "Togo" },
+	{ TH, "TH", "THA", "Thailand" },
+	{ TJ, "TJ", "TJK", "Tajikistan" },
+	{ TK, "TK", "TKL", "Tokelau" },
+	{ TL, "TL", "TLS", "Timor-Leste" },
+	{ TM, "TM", "TKM", "Turkmenistan" },
+	{ TN, "TN", "TUN", "Tunisia" },
+	{ TO, "TO", "TON", "Tonga" },
+	{ TR, "TR", "TUR", "Turkey" },
+	{ TT, "TT", "TTO", "Trinidad and Tobago" },
+	{ TV, "TV", "TUV", "Tuvalu" },
+	{ TW, "TW", "TWN", "Taiwan, Province of China" },
+	{ TZ, "TZ", "TZA", "United Republic of Tanzania" },
+	{ UA, "UA", "UKR", "Ukraine" },
+	{ UG, "UG", "UGA", "Uganda" },
+	{ UM, "UM", "UMI", "United States Minor Outlying Islands" },
+	{ US, "US", "USA", "United States" },
+	{ UY, "UY", "URY", "Uruguay" },
+	{ UZ, "UZ", "UZB", "Uzbekistan" },
+	{ VA, "VA", "VAT", "Holy See (Vatican City State)" },
+	{ VC, "VC", "VCT", "Saint Vincent and The Grenadines" },
+	{ VE, "VE", "VEN", "Bolivarian Republic of Venezuela" },
+	{ VG, "VG", "VGB", "British Virgin Islands" },
+	{ VI, "VI", "VIR", "U.S. Virgin Islands" },
+	{ VN, "VN", "VNM", "Viet Nam" },
+	{ VU, "VU", "VUT", "Vanuatu" },
+	{ WF, "WF", "WLF", "Wallis and Futuna" },
+	{ WS, "WS", "WSM", "Samoa" },
+	{ YE, "YE", "YEM", "Yemen" },
+	{ YT, "YT", "MYT", "Mayotte" },
+	{ ZA, "ZA", "ZAF", "South Africa" },
+	{ ZM, "ZM", "ZMB", "Zambia" },
+	{ ZW, "ZW", "ZWE", "Zimbabwe" },
+};
+
+#define COUNTRY_COUNT (sizeof(country_list)/sizeof(struct cCountry))
+
+static int cmp_alpha2(const void *key, const void *b)
+{
+	const struct cCountry *elem = b;
+
+	return strcasecmp(key, elem->alpha2_name);
+}
+
+static int cmp_alpha3(const void *key, const void *b)
+{
+	const struct cCountry *elem = b;
+
+	return strcasecmp(key, elem->alpha3_name);
+}
+
+
+/* convert ISO 3166-1 two-letter constant (alpha-2)
+ * to index number
+ * return 0(COUNTRY_UNKNOWN) if not found.
+ */
+enum dvb_country_t dvb_country_a2_to_id(const char *name)
+{
+	const struct cCountry *p;
+
+	p = bsearch(name, country_list,
+			COUNTRY_COUNT, sizeof(country_list[0]), cmp_alpha2);
+	return p ? p->id : COUNTRY_UNKNOWN;
+}
+
+/* convert ISO 3166-1 three-letter constant (alpha-3)
+ * to index number
+ * return 0(COUNTRY_UNKNOWN) if not found.
+ */
+enum dvb_country_t dvb_country_a3_to_id(const char *name)
+{
+	const struct cCountry *p;
+
+	p = bsearch(name, country_list,
+			COUNTRY_COUNT, sizeof(country_list[0]), cmp_alpha3);
+	return p ? p->id : COUNTRY_UNKNOWN;
+}
+
+
+/* convert index number
+ * to ISO 3166-1 two-letter constant
+ * return NULL if not found.
+ */
+const char *dvb_country_to_2letters(int idx)
+{
+	return (idx >= 1 && idx < COUNTRY_COUNT)
+			 ? country_list[idx].alpha2_name : NULL;
+}
+
+/* convert index number
+ * to ISO 3166-1 three-letter constant
+ * return NULL if not found.
+ */
+const char *dvb_country_to_3letters(int idx)
+{
+	return (idx >= 1 && idx < COUNTRY_COUNT)
+			 ? country_list[idx].alpha3_name : NULL;
+}
+
+/* convert index number
+ * to country name
+ * return NULL if not found.
+ */
+const char *dvb_country_to_name(int idx)
+{
+	return (idx >= 1 && idx < COUNTRY_COUNT)
+			 ? country_list[idx].short_name : NULL;
+}
+
+#ifndef HAVE_SECURE_GETENV
+#  ifdef HAVE___SECURE_GETENV
+#    define secure_getenv __secure_getenv
+#  else
+#    define secure_getenv getenv
+#  endif
+#endif
+
+#define MIN(X,Y) (X < Y ? X : Y)
+
+static const char * cats[] = {
+ "LC_ALL", "LC_CTYPE", "LC_COLLATE", "LC_MESSAGES", "LANG"
+};
+
+enum dvb_country_t dvb_guess_user_country(void)
+{
+	char * buf, * pch, * pbuf;
+	unsigned cat;
+	enum dvb_country_t id = COUNTRY_UNKNOWN;
+
+	for (cat = 0; cat < sizeof(cats)/sizeof(cats[0]); cat++) {
+
+		// the returned char * should be "C", "POSIX" or something valid.
+		// If valid, we can only *guess* which format is returned.
+		// Assume here something like "de_DE.iso8859-1@euro" or "de_DE.utf-8"
+		buf = secure_getenv(cats[cat]);
+		if (! buf || strlen(buf) < 2)
+			continue;
+
+		buf = strdup(buf);
+		pbuf= buf;
+
+		if (! strncmp(buf, "POSIX", MIN(strlen(buf), 5)) ||
+		    ! (strncmp(buf, "en", MIN(strlen(buf), 2)) && !isalpha(buf[2])) )
+			continue;
+
+		// assuming 'language_country.encoding@variant'
+
+		// country after '_', if given
+		if ((pch = strchr(buf, '_')))
+			pbuf = pch + 1;
+
+		// remove all after '@', including '@'
+		if ((pch = strchr(pbuf, '@')))
+			*pch = 0;
+
+		// remove all after '.', including '.'
+		if ((pch = strchr(pbuf, '.')))
+			*pch = 0;
+
+		if (strlen(pbuf) == 2)
+			id = dvb_country_a2_to_id(pbuf);
+		free(buf);
+		if (id != COUNTRY_UNKNOWN)
+			return id;
+	}
+
+	return COUNTRY_UNKNOWN;
+}
diff --git a/lib/libdvbv5/dvb-fe-priv.h b/lib/libdvbv5/dvb-fe-priv.h
index f3e99dd..b44fe1c 100644
--- a/lib/libdvbv5/dvb-fe-priv.h
+++ b/lib/libdvbv5/dvb-fe-priv.h
@@ -22,6 +22,7 @@
 #define __DVB_FE_PRIV_H
 
 #include <libdvbv5/dvb-fe.h>
+#include <libdvbv5/countries.h>
 
 enum dvbv3_emulation_type {
 	DVBV3_UNKNOWN = -1,
@@ -65,9 +66,12 @@ struct dvb_v5_fe_parms_priv {
 	struct dtv_property		dvb_prop[DTV_MAX_COMMAND];
 	struct dvb_v5_stats		stats;
 
+	/* country variant of the delivery system */
+	enum dvb_country_t		country;
+
 	/* Satellite specific stuff */
 	int				high_band;
 	unsigned			freq_offset;
 };
 
-#endif
\ No newline at end of file
+#endif
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 09eb37e..d942880 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -20,6 +20,7 @@
 
 #include "dvb-fe-priv.h"
 #include "dvb-v5.h"
+#include <libdvbv5/countries.h>
 #include <libdvbv5/dvb-v5-std.h>
 
 #include <inttypes.h>
@@ -113,6 +114,7 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 	parms->p.lna = LNA_AUTO;
 	parms->p.sat_number = -1;
 	parms->p.abort = 0;
+	parms->country = COUNTRY_UNKNOWN;
 
 	if (ioctl(fd, FE_GET_INFO, &parms->p.info) == -1) {
 		dvb_perror("FE_GET_INFO");
@@ -372,8 +374,6 @@ int dvb_set_sys(struct dvb_v5_fe_parms *p, fe_delivery_system_t sys)
 	parms->p.current_sys = sys;
 	parms->n_props = rc;
 
-	if (sys == SYS_ISDBS /* || sys == SYS_ISDBT */)
-		parms->p.default_charset = "arib-std-b24";
 	return 0;
 }
 
@@ -662,6 +662,56 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
 	return 0;
 }
 
+/* set the delsys default/fixed parameters and replace DVBv5 default values */
+static void dvb_setup_delsys_default(struct dvb_v5_fe_parms *p)
+{
+	struct dvb_v5_fe_parms_priv *parms = (void *)p;
+	uint32_t cc;
+
+	switch (p->current_sys) {
+	case SYS_ISDBT:
+		/* Set country code. */
+		/* if the default country is not known, fallback to BR */
+		cc = COUNTRY_UNKNOWN;
+		dvb_fe_retrieve_parm(p, DTV_COUNTRY_CODE, &cc);
+		if (cc == COUNTRY_UNKNOWN) {
+			cc = (parms->country == COUNTRY_UNKNOWN)
+				? BR : parms->country;
+			dvb_fe_store_parm(p, DTV_COUNTRY_CODE, cc);
+		}
+		switch (cc) {
+		case JP:
+			p->default_charset = "arib-std-b24";
+			dvb_fe_store_parm(p, DTV_BANDWIDTH_HZ, 6000000);
+			break;
+		/* Americas (SBTVD) */
+		case AR:
+		case BO:
+		case BR:
+		case CL:
+		case CR:
+		case EC:
+		case GT:
+		case HN:
+		case NI:
+		case PE:
+		case PY:
+		case UY:
+		case VE:
+			p->default_charset = "iso8859-15";
+			break;
+		}
+		break;
+	case SYS_ISDBS:
+		p->default_charset = "arib-std-b24";
+		if (!p->lnb);
+			p->lnb = dvb_sat_get_lnb(dvb_sat_search_lnb("110BS"));
+		break;
+	default:
+		break;
+	}
+}
+
 int dvb_fe_set_parms(struct dvb_v5_fe_parms *p)
 {
 	struct dvb_v5_fe_parms_priv *parms = (void *)p;
@@ -703,6 +753,8 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *p)
 		parms->freq_offset = tmp_parms.freq_offset;
 	}
 
+	dvb_setup_delsys_default(p);
+
 	/* Filter out any user DTV_foo property such as DTV_POLARIZATION */
 	tmp_parms.n_props = dvb_copy_fe_props(tmp_parms.dvb_prop,
 					      tmp_parms.n_props,
@@ -1714,3 +1766,23 @@ int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *p, unsigned *len, char *buf,
 
 	return 0;
 }
+
+int dvb_fe_set_default_country(struct dvb_v5_fe_parms *p, const char *cc)
+{
+	struct dvb_v5_fe_parms_priv *parms = (void *)p;
+
+	if (!cc) {
+		parms->country = dvb_guess_user_country();
+		if (parms->p.verbose) {
+			if (parms->country != COUNTRY_UNKNOWN)
+				dvb_log("Assuming you're in %s.\n",
+					dvb_country_to_2letters(parms->country));
+			else
+				dvb_log("Failed to guess country from the current locale setting.\n");
+		}
+		return 0;
+	}
+
+	parms->country = dvb_country_a2_to_id(cc);
+	return (parms->country == COUNTRY_UNKNOWN) ? -EINVAL : 0;
+}
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 89b09ff..a4d20b8 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -48,6 +48,7 @@
 #include <libdvbv5/desc_event_extended.h>
 #include <libdvbv5/desc_atsc_service_location.h>
 #include <libdvbv5/desc_hierarchy.h>
+#include <libdvbv5/countries.h>
 
 int dvb_store_entry_prop(struct dvb_entry *entry,
 			 uint32_t cmd, uint32_t value)
@@ -149,6 +150,9 @@ static uint32_t dvbv5_default_value(int cmd)
 		case DTV_ROLLOFF:
 			return ROLLOFF_AUTO;
 
+		case DTV_COUNTRY_CODE:
+			return COUNTRY_UNKNOWN;
+
 		default:
 			return (uint32_t)-1;
 	}
@@ -617,6 +621,14 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 		return 0;
 	}
 
+	if (!strcasecmp(key, "COUNTRY")) {
+		enum dvb_country_t id = dvb_country_a2_to_id(value);
+		if (id == COUNTRY_UNKNOWN)
+			return -2;
+		dvb_store_entry_prop(entry, DTV_COUNTRY_CODE, id);
+		return 0;
+	}
+
 	if (!strcasecmp(key, "VIDEO_PID"))
 		is_video = 1;
 	else if (!strcasecmp(key, "AUDIO_PID"))
@@ -884,6 +896,8 @@ int dvb_write_file(const char *fname, struct dvb_file *dvb_file)
 
 		for (i = 0; i < entry->n_props; i++) {
 			const char * const *attr_name = dvb_attr_names(entry->props[i].cmd);
+			const char *buf;
+
 			if (attr_name) {
 				int j;
 
@@ -894,6 +908,11 @@ int dvb_write_file(const char *fname, struct dvb_file *dvb_file)
 				}
 			}
 
+			if (entry->props[i].cmd == DTV_COUNTRY_CODE) {
+				buf = dvb_country_to_2letters(entry->props[i].u.data);
+				attr_name = &buf;
+			}
+
 			/* Handle parameters with optional values */
 			switch (entry->props[i].cmd) {
 			case DTV_PLS_CODE:
diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
index 50365cb..5de6b46 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -75,6 +75,7 @@ const unsigned int sys_isdbt_props[] = {
 	DTV_ISDBT_LAYERC_MODULATION,
 	DTV_ISDBT_LAYERC_SEGMENT_COUNT,
 	DTV_ISDBT_LAYERC_TIME_INTERLEAVING,
+	DTV_COUNTRY_CODE,
 	0
 };
 
@@ -226,6 +227,7 @@ const char *dvb_user_name[DTV_USER_NAME_SIZE + 1] = {
 	[DTV_FREQ_BPF - DTV_USER_COMMAND_START] =	"FREQ BPF",
 	[DTV_PLS_CODE - DTV_USER_COMMAND_START] =	"PLS CODE",
 	[DTV_PLS_MODE - DTV_USER_COMMAND_START] =	"PLS MODE",
+	[DTV_COUNTRY_CODE - DTV_USER_COMMAND_START] =	"COUNTRY",
 	[DTV_USER_NAME_SIZE] = NULL,
 };
 
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 53a54f7..ad9c9bd 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -37,6 +37,7 @@
 #include "libdvbv5/dvb-demux.h"
 #include "libdvbv5/dvb-v5-std.h"
 #include "libdvbv5/dvb-scan.h"
+#include "libdvbv5/countries.h"
 
 #define PROGRAM_NAME	"dvbv5-scan"
 #define DEFAULT_OUTPUT  "dvb_channel.conf"
@@ -51,6 +52,7 @@ struct arguments {
 	unsigned diseqc_wait, dont_add_new_freqs, timeout_multiply;
 	unsigned other_nit;
 	enum dvb_file_formats input_format, output_format;
+	const char *cc;
 
 	/* Used by status print */
 	unsigned n_status_lines;
@@ -75,6 +77,7 @@ static const struct argp_option options[] = {
 	{"input-format", 'I',	"format",		0, "Input format: CHANNEL, DVBV5 (default: DVBV5)", 0},
 	{"output-format", 'O',	"format",		0, "Output format: VDR, CHANNEL, ZAP, DVBV5 (default: DVBV5)", 0},
 	{"dvbv3",	'3',	0,			0, "Use DVBv3 only", 0},
+	{"cc",		'C',	"country_code",		0, "use default parameters for given country", 0},
 	{ 0, 0, 0, 0, 0, 0 }
 };
 
@@ -394,6 +397,9 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 	case '3':
 		args->force_dvbv3 = 1;
 		break;
+	case 'C':
+		args->cc = strndup(optarg, 2);
+		break;
 	default:
 		return ARGP_ERR_UNKNOWN;
 	};
@@ -497,6 +503,9 @@ int main(int argc, char **argv)
 	parms->diseqc_wait = args.diseqc_wait;
 	parms->freq_bpf = args.freq_bpf;
 	parms->lna = args.lna;
+	r = dvb_fe_set_default_country(parms, args.cc);
+	if (r < 0)
+		fprintf(stderr, "Failed to set the country code:%s\n", args.cc);
 
 	timeout_flag = &parms->abort;
 	signal(SIGTERM, do_timeout);
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 498d3dd..6060450 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -41,6 +41,7 @@
 #include "libdvbv5/dvb-demux.h"
 #include "libdvbv5/dvb-scan.h"
 #include "libdvbv5/header.h"
+#include "libdvbv5/countries.h"
 
 #define CHANNEL_FILE	"channels.conf"
 #define PROGRAM_NAME	"dvbv5-zap"
@@ -59,6 +60,7 @@ struct arguments {
 	enum dvb_file_formats input_format, output_format;
 	unsigned traffic_monitor, low_traffic;
 	char *search;
+	const char *cc;
 
 	/* Used by status print */
 	unsigned n_status_lines;
@@ -89,6 +91,7 @@ static const struct argp_option options[] = {
 	{"wait",	'W', "time",			0, "adds additional wait time for DISEqC command completion", 0},
 	{"exit",	'x', NULL,			0, "exit after tuning", 0},
 	{"low_traffic",	'X', NULL,			0, "also shows DVB traffic with less then 1 packet per second", 0},
+	{"cc",		'C', "country_code",		0, "use default parameters for given country", 0},
 	{ 0, 0, 0, 0, 0, 0 }
 };
 
@@ -549,6 +552,9 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 	case 'L':
 		args->search = strdup(optarg);
 		break;
+	case 'C':
+		args->cc = strndup(optarg, 2);
+		break;
 	default:
 		return ARGP_ERR_UNKNOWN;
 	};
@@ -804,6 +810,10 @@ int main(int argc, char **argv)
 	parms->freq_bpf = args.freq_bpf;
 	parms->lna = args.lna;
 
+	r = dvb_fe_set_default_country(parms, args.cc);
+	if (r < 0)
+		fprintf(stderr, "Failed to set the country code:%s\n", args.cc);
+
 	if (parse(&args, parms, channel, &vpid, &apid, &sid))
 		goto err;
 
-- 
2.1.3

