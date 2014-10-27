Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:55595 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaJ0PWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 11:22:52 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NE4006G5021X360@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Oct 2014 11:22:49 -0400 (EDT)
Date: Mon, 27 Oct 2014 13:22:45 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/7] v4l-utils/dvb: add COUNTRY property
Message-id: <20141027132245.6242b7a5.m.chehab@samsung.com>
In-reply-to: <1414323983-15996-5-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-5-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Oct 2014 20:46:20 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> to distinguish country variants of delivery systems like ISDB-T.

SOB is missing here.

> ---
>  configure.ac                      |   4 +
>  lib/include/libdvbv5/countries.h  | 308 +++++++++++++++++++++++++++++
>  lib/include/libdvbv5/dvb-fe.h     |   4 +
>  lib/include/libdvbv5/dvb-v5-std.h |   7 +-
>  lib/libdvbv5/Makefile.am          |   2 +
>  lib/libdvbv5/countries.c          | 403 ++++++++++++++++++++++++++++++++++++++
>  lib/libdvbv5/dvb-fe.c             |  42 +++-
>  lib/libdvbv5/dvb-file.c           |  19 ++
>  lib/libdvbv5/dvb-v5-std.c         |   2 +
>  utils/dvb/dvbv5-scan.c            |  11 ++
>  utils/dvb/dvbv5-zap.c             |  11 ++
>  11 files changed, 810 insertions(+), 3 deletions(-)
>  create mode 100644 lib/include/libdvbv5/countries.h
>  create mode 100644 lib/libdvbv5/countries.c
> 
> diff --git a/configure.ac b/configure.ac
> index 94a857e..b1c5e54 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -48,6 +48,8 @@ AC_CONFIG_FILES([Makefile
>  	utils/media-ctl/libv4l2subdev.pc
>  ])
>  
> +AC_GNU_SOURCE
> +
>  AM_INIT_AUTOMAKE([1.9 subdir-objects no-dist-gzip dist-bzip2 -Wno-portability]) # 1.10 is needed for target_LIBTOOLFLAGS
>  
>  AM_MAINTAINER_MODE
> @@ -73,6 +75,8 @@ gl_VISIBILITY
>  AC_CHECK_HEADERS([sys/klog.h])
>  AC_CHECK_FUNCS([klogctl])
>  
> +AC_CHECK_FUNCS([__secure_getenv secure_getenv])
> +
>  # Check host os
>  case "$host_os" in
>    linux*)
> diff --git a/lib/include/libdvbv5/countries.h b/lib/include/libdvbv5/countries.h
> new file mode 100644
> index 0000000..945094f
> --- /dev/null
> +++ b/lib/include/libdvbv5/countries.h
> @@ -0,0 +1,308 @@
> +/*
> + * Copyright (C) 2006, 2007, 2008, 2009 Winfried Koehler
> + * Copyright (C) 2014 Akihiro Tsukada
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *


> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
> + * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html

We're removing GNU address from Kernel, as this might change. Also, it is
now a way easier to get the copy of the license via Internet.

I don't have a too strong opinion on v4l-utils, but, at least from the
code I'm adding there, I prefer to remove the 4 above lines.

> + *
> + */
> +
> +/**
> + * @file countries.h
> + * @ingroup ancillary
> + * @brief Provides ancillary code to convert ISO 3166-1 country codes
> + * @copyright GNU General Public License version 2 (GPLv2)
> + * @author Winfried Koehler
> + * @author Akihiro Tsukada
> + *
> + * @par Bug Report
> + * Please submit bug reports and patches to linux-media@vger.kernel.org
> + */
> +
> +#ifndef _COUNTRIES_H_
> +#define _COUNTRIES_H_
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +/* Every country has its own number here. if adding new one
> + * simply append to enum.
> + */
> +enum country_t {

To avoid API conflicts, I would prefix it with dvb.

> +    COUNTRY_UNKNOWN,
> +
> +    AF,
> +    AX,
> +    AL,
> +    DZ,
> +    AS,
> +    AD,
> +    AO,
> +    AI,
> +    AQ,
> +    AG,
> +    AR,
> +    AM,
> +    AW,
> +    AU,
> +    AT,
> +    AZ,
> +    BS,
> +    BH,
> +    BD,
> +    BB,
> +    BY,
> +    BE,
> +    BZ,
> +    BJ,
> +    BM,
> +    BT,
> +    BO,
> +    BQ,
> +    BA,
> +    BW,
> +    BV,
> +    BR,
> +    IO,
> +    BN,
> +    BG,
> +    BF,
> +    BI,
> +    KH,
> +    CM,
> +    CA,
> +    CV,
> +    KY,
> +    CF,
> +    TD,
> +    CL,
> +    CN,
> +    CX,
> +    CC,
> +    CO,
> +    KM,
> +    CG,
> +    CD,
> +    CK,
> +    CR,
> +    CI,
> +    HR,
> +    CU,
> +    CW,
> +    CY,
> +    CZ,
> +    DK,
> +    DJ,
> +    DM,
> +    DO,
> +    EC,
> +    EG,
> +    SV,
> +    GQ,
> +    ER,
> +    EE,
> +    ET,
> +    FK,
> +    FO,
> +    FJ,
> +    FI,
> +    FR,
> +    GF,
> +    PF,
> +    TF,
> +    GA,
> +    GM,
> +    GE,
> +    DE,
> +    GH,
> +    GI,
> +    GR,
> +    GL,
> +    GD,
> +    GP,
> +    GU,
> +    GT,
> +    GG,
> +    GN,
> +    GW,
> +    GY,
> +    HT,
> +    HM,
> +    VA,
> +    HN,
> +    HK,
> +    HU,
> +    IS,
> +    IN,
> +    ID,
> +    IR,
> +    IQ,
> +    IE,
> +    IM,
> +    IL,
> +    IT,
> +    JM,
> +    JP,
> +    JE,
> +    JO,
> +    KZ,
> +    KE,
> +    KI,
> +    KP,
> +    KR,
> +    KW,
> +    KG,
> +    LA,
> +    LV,
> +    LB,
> +    LS,
> +    LR,
> +    LY,
> +    LI,
> +    LT,
> +    LU,
> +    MO,
> +    MK,
> +    MG,
> +    MW,
> +    MY,
> +    MV,
> +    ML,
> +    MT,
> +    MH,
> +    MQ,
> +    MR,
> +    MU,
> +    YT,
> +    MX,
> +    FM,
> +    MD,
> +    MC,
> +    MN,
> +    ME,
> +    MS,
> +    MA,
> +    MZ,
> +    MM,
> +    NA,
> +    NR,
> +    NP,
> +    NL,
> +    NC,
> +    NZ,
> +    NI,
> +    NE,
> +    NG,
> +    NU,
> +    NF,
> +    MP,
> +    NO,
> +    OM,
> +    PK,
> +    PW,
> +    PS,
> +    PA,
> +    PG,
> +    PY,
> +    PE,
> +    PH,
> +    PN,
> +    PL,
> +    PT,
> +    PR,
> +    QA,
> +    RE,
> +    RO,
> +    RU,
> +    RW,
> +    BL,
> +    SH,
> +    KN,
> +    LC,
> +    MF,
> +    PM,
> +    VC,
> +    WS,
> +    SM,
> +    ST,
> +    SA,
> +    SN,
> +    RS,
> +    SC,
> +    SL,
> +    SX,
> +    SG,
> +    SK,
> +    SI,
> +    SB,
> +    SO,
> +    ZA,
> +    GS,
> +    ES,
> +    LK,
> +    SD,
> +    SR,
> +    SJ,
> +    SZ,
> +    SE,
> +    CH,
> +    SY,
> +    TW,
> +    TJ,
> +    TZ,
> +    TH,
> +    TL,
> +    TG,
> +    TK,
> +    TO,
> +    TT,
> +    TN,
> +    TR,
> +    TM,
> +    TC,
> +    TV,
> +    UG,
> +    UA,
> +    AE,
> +    GB,
> +    US,
> +    UM,
> +    UY,
> +    UZ,
> +    VU,
> +    VE,
> +    VN,
> +    VG,
> +    VI,
> +    WF,
> +    EH,
> +    YE,
> +    ZM,
> +    ZW
> +};
> +
> +extern int dvb_country_to_id (const char * name);
> +
> +extern const char * dvb_country_to_short_name(int id);
> +extern const char * dvb_country_to_full_name(int id);

We're following Kernel coding style. So, no spaces after *.

> +
> +extern enum country_t dvb_guess_user_country(void);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/lib/include/libdvbv5/dvb-fe.h b/lib/include/libdvbv5/dvb-fe.h
> index ba4c2dc..929b830 100644
> --- a/lib/include/libdvbv5/dvb-fe.h
> +++ b/lib/include/libdvbv5/dvb-fe.h
> @@ -101,6 +101,7 @@
>   *				DVBv3 only mode was forced by the client (RO)
>   * @param abort			Client should set it to abort a pending
>   *				operation like DTV scan (RW)
> + * @param country		Country variant of the delivery system (RW)
>   * @param lna:			Sets the LNA mode 0 disables; 1 enables, -1 uses
>   *				auto mode (RW)
>   * @param lnb			LNBf description (RW)
> @@ -130,6 +131,9 @@ struct dvb_v5_fe_parms {
>  	/* Flags from the client to the library */
>  	int				abort;
>  
> +	/* Country variant of the international delsys standard. */
> +	int				country;
> +

Please, don't add it here, but, instead, at the private header
(lib/libdvbv5/dvb-fe-priv.h). Adding/removing anything here would
break binary compatibility, with is something that we don't want to do
inside a library.

Instead, add some function here to setup the default country code.
Of course, apps can always override the default usind dvb_fe_set_parms().

>  	/* Linear Amplifier settings */
>  	int				lna;
>  
> diff --git a/lib/include/libdvbv5/dvb-v5-std.h b/lib/include/libdvbv5/dvb-v5-std.h
> index c03b0d3..6ca8c90 100644
> --- a/lib/include/libdvbv5/dvb-v5-std.h
> +++ b/lib/include/libdvbv5/dvb-v5-std.h
> @@ -93,6 +93,10 @@
>   *	@brief DVB-T2 PLS mode. Not used internally. It is needed
>   *			only for file conversion.
>   *	@ingroup frontend
> + * @def DTV_COUNTRY_CODE
> + *	@brief Country variant of international delivery system standard.
> +		in ISO 3166-1 two letter code.
> + *	@ingroup frontend
>   * @def DTV_MAX_USER_COMMAND
>   *	 @brief Last user command
>   *	@ingroup frontend
> @@ -115,8 +119,9 @@
>  #define DTV_FREQ_BPF            (DTV_USER_COMMAND_START + 9)
>  #define DTV_PLS_CODE		(DTV_USER_COMMAND_START + 10)
>  #define DTV_PLS_MODE		(DTV_USER_COMMAND_START + 11)
> +#define DTV_COUNTRY_CODE	(DTV_USER_COMMAND_START + 12)
>  
> -#define DTV_MAX_USER_COMMAND    DTV_PLS_MODE
> +#define DTV_MAX_USER_COMMAND    DTV_COUNTRY_CODE
>  
>  #define DTV_USER_NAME_SIZE	(1 + DTV_MAX_USER_COMMAND - DTV_USER_COMMAND_START)
>  
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index fd21236..c95da04 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -6,6 +6,7 @@ otherinclude_HEADERS = \
>  	../include/libdvbv5/dvb-demux.h \
>  	../include/libdvbv5/dvb-v5-std.h \
>  	../include/libdvbv5/dvb-file.h \
> +	../include/libdvbv5/countries.h \
>  	../include/libdvbv5/crc32.h \
>  	../include/libdvbv5/dvb-frontend.h \
>  	../include/libdvbv5/dvb-fe.h \
> @@ -57,6 +58,7 @@ endif
>  
>  libdvbv5_la_SOURCES = \
>  	crc32.c \
> +	countries.c \
>  	dvb-legacy-channel-format.c \
>  	dvb-zap-format.c \
>  	dvb-vdr-format.c \
> diff --git a/lib/libdvbv5/countries.c b/lib/libdvbv5/countries.c
> new file mode 100644
> index 0000000..04d1195
> --- /dev/null
> +++ b/lib/libdvbv5/countries.c
> @@ -0,0 +1,403 @@
> +/*
> + * Copyright (C) 2006, 2007, 2008, 2009 Winfried Koehler 
> + * Copyright (C) 2014 Akihiro Tsukada 
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
> + * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + *
> + */
> +
> +#include <config.h>
> +#include "libdvbv5/countries.h"
> +
> +#include <ctype.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <strings.h>
> +
> +typedef struct cCountry {
> +        const char *    short_name;
> +        enum country_t  id;
> +        const char*     full_name;
> +} _country;
> +
> +/* 
> + * two letters constants from ISO 3166-1.
> + * sorted alphabetically by long country name
> + */
> +
> +struct cCountry country_list[] = {
> +/*- ISO 3166-1 - unique id - long country name                 alpha-3 numeric */
> +       {"AF", AF, "AFGHANISTAN"},                                  /*AFG, 4  },*/
> +       {"AX", AX, "ﾅLAND ISLANDS"},                                /*ALA, 248},*/
> +       {"AL", AL, "ALBANIA"},                                      /*ALB, 8  },*/
> +       {"DZ", DZ, "ALGERIA"},                                      /*DZA, 12 },*/
> +       {"AS", AS, "AMERICAN SAMOA"},                               /*ASM, 16 },*/
> +       {"AD", AD, "ANDORRA"},                                      /*AND, 20 },*/
> +       {"AO", AO, "ANGOLA"},                                       /*AGO, 24 },*/
> +       {"AI", AI, "ANGUILLA"},                                     /*AIA, 660},*/
> +       {"AQ", AQ, "ANTARCTICA"},                                   /*ATA, 10 },*/
> +       {"AG", AG, "ANTIGUA AND BARBUDA"},                          /*ATG, 28 },*/
> +       {"AR", AR, "ARGENTINA"},                                    /*ARG, 32 },*/
> +       {"AM", AM, "ARMENIA"},                                      /*ARM, 51 },*/
> +       {"AW", AW, "ARUBA"},                                        /*ABW, 533},*/
> +       {"AU", AU, "AUSTRALIA"},                                    /*AUS, 36 },*/
> +       {"AT", AT, "AUSTRIA"},                                      /*AUT, 40 },*/
> +       {"AZ", AZ, "AZERBAIJAN"},                                   /*AZE, 31 },*/
> +       {"BS", BS, "BAHAMAS"},                                      /*BHS, 44 },*/
> +       {"BH", BH, "BAHRAIN"},                                      /*BHR, 48 },*/
> +       {"BD", BD, "BANGLADESH"},                                   /*BGD, 50 },*/
> +       {"BB", BB, "BARBADOS"},                                     /*BRB, 52 },*/
> +       {"BY", BY, "BELARUS"},                                      /*BLR, 112},*/
> +       {"BE", BE, "BELGIUM"},                                      /*BEL, 56 },*/
> +       {"BZ", BZ, "BELIZE"},                                       /*BLZ, 84 },*/
> +       {"BJ", BJ, "BENIN"},                                        /*BEN, 204},*/
> +       {"BM", BM, "BERMUDA"},                                      /*BMU, 60 },*/
> +       {"BT", BT, "BHUTAN"},                                       /*BTN, 64 },*/
> +       {"BO", BO, "BOLIVIA"},                                      /*BOL, 68 },*/
> +       {"BQ", BQ, "BONAIRE"},                                      /*BES, 535},*/
> +       {"BA", BA, "BOSNIA AND HERZEGOVINA"},                       /*BIH, 70 },*/
> +       {"BW", BW, "BOTSWANA"},                                     /*BWA, 72 },*/
> +       {"BV", BV, "BOUVET ISLAND"},                                /*BVT, 74 },*/
> +       {"BR", BR, "BRAZIL"},                                       /*BRA, 76 },*/
> +       {"IO", IO, "BRITISH INDIAN OCEAN TERRITORY"},               /*IOT, 86 },*/
> +       {"BN", BN, "BRUNEI DARUSSALAM"},                            /*BRN, 96 },*/
> +       {"BG", BG, "BULGARIA"},                                     /*BGR, 100},*/
> +       {"BF", BF, "BURKINA FASO"},                                 /*BFA, 854},*/
> +       {"BI", BI, "BURUNDI"},                                      /*BDI, 108},*/
> +       {"KH", KH, "CAMBODIA"},                                     /*KHM, 116},*/
> +       {"CM", CM, "CAMEROON"},                                     /*CMR, 120},*/
> +       {"CA", CA, "CANADA"},                                       /*CAN, 124},*/
> +       {"CV", CV, "CAPE VERDE"},                                   /*CPV, 132},*/
> +       {"KY", KY, "CAYMAN ISLANDS"},                               /*CYM, 136},*/
> +       {"CF", CF, "CENTRAL AFRICAN REPUBLIC"},                     /*CAF, 140},*/
> +       {"TD", TD, "CHAD"},                                         /*TCD, 148},*/
> +       {"CL", CL, "CHILE"},                                        /*CHL, 152},*/
> +       {"CN", CN, "CHINA"},                                        /*CHN, 156},*/
> +       {"CX", CX, "CHRISTMAS ISLAND"},                             /*CXR, 162},*/
> +       {"CC", CC, "COCOS (KEELING) ISLANDS"},                      /*CCK, 166},*/
> +       {"CO", CO, "COLOMBIA"},                                     /*COL, 170},*/
> +       {"KM", KM, "COMOROS"},                                      /*COM, 174},*/
> +       {"CG", CG, "CONGO"},                                        /*COG, 178},*/
> +       {"CD", CD, "CONGO, THE DEMOCRATIC REPUBLIC OF THE"},        /*COD, 180},*/
> +       {"CK", CK, "COOK ISLANDS"},                                 /*COK, 184},*/
> +       {"CR", CR, "COSTA RICA"},                                   /*CRI, 188},*/
> +       {"CI", CI, "CﾔTE D'IVOIRE"},                                /*CIV, 384},*/
> +       {"HR", HR, "CROATIA"},                                      /*HRV, 191},*/
> +       {"CU", CU, "CUBA"},                                         /*CUB, 192},*/
> +       {"CW", CW, "CURAﾇAO"},                                      /*CUW, 531},*/
> +       {"CY", CY, "CYPRUS"},                                       /*CYP, 196},*/
> +       {"CZ", CZ, "CZECH REPUBLIC"},                               /*CZE, 203},*/
> +       {"DK", DK, "DENMARK"},                                      /*DNK, 208},*/
> +       {"DJ", DJ, "DJIBOUTI"},                                     /*DJI, 262},*/
> +       {"DM", DM, "DOMINICA"},                                     /*DMA, 212},*/
> +       {"DO", DO, "DOMINICAN REPUBLIC"},                           /*DOM, 214},*/
> +       {"EC", EC, "ECUADOR"},                                      /*ECU, 218},*/
> +       {"EG", EG, "EGYPT"},                                        /*EGY, 818},*/
> +       {"SV", SV, "EL SALVADOR"},                                  /*SLV, 222},*/
> +       {"GQ", GQ, "EQUATORIAL GUINEA"},                            /*GNQ, 226},*/
> +       {"ER", ER, "ERITREA"},                                      /*ERI, 232},*/
> +       {"EE", EE, "ESTONIA"},                                      /*EST, 233},*/
> +       {"ET", ET, "ETHIOPIA"},                                     /*ETH, 231},*/
> +       {"FK", FK, "FALKLAND ISLANDS (MALVINAS)"},                  /*FLK, 238},*/
> +       {"FO", FO, "FAROE ISLANDS"},                                /*FRO, 234},*/
> +       {"FJ", FJ, "FIJI"},                                         /*FJI, 242},*/
> +       {"FI", FI, "FINLAND"},                                      /*FIN, 246},*/
> +       {"FR", FR, "FRANCE"},                                       /*FRA, 250},*/
> +       {"GF", GF, "FRENCH GUIANA"},                                /*GUF, 254},*/
> +       {"PF", PF, "FRENCH POLYNESIA"},                             /*PYF, 258},*/
> +       {"TF", TF, "FRENCH SOUTHERN TERRITORIES"},                  /*ATF, 260},*/
> +       {"GA", GA, "GABON"},                                        /*GAB, 266},*/
> +       {"GM", GM, "GAMBIA"},                                       /*GMB, 270},*/
> +       {"GE", GE, "GEORGIA"},                                      /*GEO, 268},*/
> +       {"DE", DE, "GERMANY"},                                      /*DEU, 276},*/
> +       {"GH", GH, "GHANA"},                                        /*GHA, 288},*/
> +       {"GI", GI, "GIBRALTAR"},                                    /*GIB, 292},*/
> +       {"GR", GR, "GREECE"},                                       /*GRC, 300},*/
> +       {"GL", GL, "GREENLAND"},                                    /*GRL, 304},*/
> +       {"GD", GD, "GRENADA"},                                      /*GRD, 308},*/
> +       {"GP", GP, "GUADELOUPE"},                                   /*GLP, 312},*/
> +       {"GU", GU, "GUAM"},                                         /*GUM, 316},*/
> +       {"GT", GT, "GUATEMALA"},                                    /*GTM, 320},*/
> +       {"GG", GG, "GUERNSEY"},                                     /*GGY, 831},*/
> +       {"GN", GN, "GUINEA"},                                       /*GIN, 324},*/
> +       {"GW", GW, "GUINEA-BISSAU"},                                /*GNB, 624},*/
> +       {"GY", GY, "GUYANA"},                                       /*GUY, 328},*/
> +       {"HT", HT, "HAITI"},                                        /*HTI, 332},*/
> +       {"HM", HM, "HEARD ISLAND AND MCDONALD ISLANDS"},            /*HMD, 334},*/
> +       {"VA", VA, "HOLY SEE (VATICAN CITY STATE)"},                /*VAT, 336},*/
> +       {"HN", HN, "HONDURAS"},                                     /*HND, 340},*/
> +       {"HK", HK, "HONG KONG"},                                    /*HKG, 344},*/
> +       {"HU", HU, "HUNGARY"},                                      /*HUN, 348},*/
> +       {"IS", IS, "ICELAND"},                                      /*ISL, 352},*/
> +       {"IN", IN, "INDIA"},                                        /*IND, 356},*/
> +       {"ID", ID, "INDONESIA"},                                    /*IDN, 360},*/
> +       {"IR", IR, "IRAN, ISLAMIC REPUBLIC OF"},                    /*IRN, 364},*/
> +       {"IQ", IQ, "IRAQ"},                                         /*IRQ, 368},*/
> +       {"IE", IE, "IRELAND"},                                      /*IRL, 372},*/
> +       {"IM", IM, "ISLE OF MAN"},                                  /*IMN, 833},*/
> +       {"IL", IL, "ISRAEL"},                                       /*ISR, 376},*/
> +       {"IT", IT, "ITALY"},                                        /*ITA, 380},*/
> +       {"JM", JM, "JAMAICA"},                                      /*JAM, 388},*/
> +       {"JP", JP, "JAPAN"},                                        /*JPN, 392},*/
> +       {"JE", JE, "JERSEY"},                                       /*JEY, 832},*/
> +       {"JO", JO, "JORDAN"},                                       /*JOR, 400},*/
> +       {"KZ", KZ, "KAZAKHSTAN"},                                   /*KAZ, 398},*/
> +       {"KE", KE, "KENYA"},                                        /*KEN, 404},*/
> +       {"KI", KI, "KIRIBATI"},                                     /*KIR, 296},*/
> +       {"KP", KP, "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF"},       /*PRK, 408},*/
> +       {"KR", KR, "KOREA, REPUBLIC OF"},                           /*KOR, 410},*/
> +       {"KW", KW, "KUWAIT"},                                       /*KWT, 414},*/
> +       {"KG", KG, "KYRGYZSTAN"},                                   /*KGZ, 417},*/
> +       {"LA", LA, "LAO PEOPLE'S DEMOCRATIC REPUBLIC"},             /*LAO, 418},*/
> +       {"LV", LV, "LATVIA"},                                       /*LVA, 428},*/
> +       {"LB", LB, "LEBANON"},                                      /*LBN, 422},*/
> +       {"LS", LS, "LESOTHO"},                                      /*LSO, 426},*/
> +       {"LR", LR, "LIBERIA"},                                      /*LBR, 430},*/
> +       {"LY", LY, "LIBYAN ARAB JAMAHIRIYA"},                       /*LBY, 434},*/
> +       {"LI", LI, "LIECHTENSTEIN"},                                /*LIE, 438},*/
> +       {"LT", LT, "LITHUANIA"},                                    /*LTU, 440},*/
> +       {"LU", LU, "LUXEMBOURG"},                                   /*LUX, 442},*/
> +       {"MO", MO, "MACAO"},                                        /*MAC, 446},*/
> +       {"MK", MK, "MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF"},   /*MKD, 807},*/
> +       {"MG", MG, "MADAGASCAR"},                                   /*MDG, 450},*/
> +       {"MW", MW, "MALAWI"},                                       /*MWI, 454},*/
> +       {"MY", MY, "MALAYSIA"},                                     /*MYS, 458},*/
> +       {"MV", MV, "MALDIVES"},                                     /*MDV, 462},*/
> +       {"ML", ML, "MALI"},                                         /*MLI, 466},*/
> +       {"MT", MT, "MALTA"},                                        /*MLT, 470},*/
> +       {"MH", MH, "MARSHALL ISLANDS"},                             /*MHL, 584},*/
> +       {"MQ", MQ, "MARTINIQUE"},                                   /*MTQ, 474},*/
> +       {"MR", MR, "MAURITANIA"},                                   /*MRT, 478},*/
> +       {"MU", MU, "MAURITIUS"},                                    /*MUS, 480},*/
> +       {"YT", YT, "MAYOTTE"},                                      /*MYT, 175},*/
> +       {"MX", MX, "MEXICO"},                                       /*MEX, 484},*/
> +       {"FM", FM, "MICRONESIA, FEDERATED STATES OF"},              /*FSM, 583},*/
> +       {"MD", MD, "MOLDOVA"},                                      /*MDA, 498},*/
> +       {"MC", MC, "MONACO"},                                       /*MCO, 492},*/
> +       {"MN", MN, "MONGOLIA"},                                     /*MNG, 496},*/
> +       {"ME", ME, "MONTENEGRO"},                                   /*MNE, 499},*/
> +       {"MS", MS, "MONTSERRAT"},                                   /*MSR, 500},*/
> +       {"MA", MA, "MOROCCO"},                                      /*MAR, 504},*/
> +       {"MZ", MZ, "MOZAMBIQUE"},                                   /*MOZ, 508},*/
> +       {"MM", MM, "MYANMAR"},                                      /*MMR, 104},*/
> +       {"NA", NA, "NAMIBIA"},                                      /*NAM, 516},*/
> +       {"NR", NR, "NAURU"},                                        /*NRU, 520},*/
> +       {"NP", NP, "NEPAL"},                                        /*NPL, 524},*/
> +       {"NL", NL, "NETHERLANDS"},                                  /*NLD, 528},*/
> +       {"NC", NC, "NEW CALEDONIA"},                                /*NCL, 540},*/
> +       {"NZ", NZ, "NEW ZEALAND"},                                  /*NZL, 554},*/
> +       {"NI", NI, "NICARAGUA"},                                    /*NIC, 558},*/
> +       {"NE", NE, "NIGER"},                                        /*NER, 562},*/
> +       {"NG", NG, "NIGERIA"},                                      /*NGA, 566},*/
> +       {"NU", NU, "NIUE"},                                         /*NIU, 570},*/
> +       {"NF", NF, "NORFOLK ISLAND"},                               /*NFK, 574},*/
> +       {"MP", MP, "NORTHERN MARIANA ISLANDS"},                     /*MNP, 580},*/
> +       {"NO", NO, "NORWAY"},                                       /*NOR, 578},*/
> +       {"OM", OM, "OMAN"},                                         /*OMN, 512},*/
> +       {"PK", PK, "PAKISTAN"},                                     /*PAK, 586},*/
> +       {"PW", PW, "PALAU"},                                        /*PLW, 585},*/
> +       {"PS", PS, "PALESTINIAN TERRITORY, OCCUPIED"},              /*PSE, 275},*/
> +       {"PA", PA, "PANAMA"},                                       /*PAN, 591},*/
> +       {"PG", PG, "PAPUA NEW GUINEA"},                             /*PNG, 598},*/
> +       {"PY", PY, "PARAGUAY"},                                     /*PRY, 600},*/
> +       {"PE", PE, "PERU"},                                         /*PER, 604},*/
> +       {"PH", PH, "PHILIPPINES"},                                  /*PHL, 608},*/
> +       {"PN", PN, "PITCAIRN"},                                     /*PCN, 612},*/
> +       {"PL", PL, "POLAND"},                                       /*POL, 616},*/
> +       {"PT", PT, "PORTUGAL"},                                     /*PRT, 620},*/
> +       {"PR", PR, "PUERTO RICO"},                                  /*PRI, 630},*/
> +       {"QA", QA, "QATA"},                                         /*QAT, 634},*/
> +       {"RE", RE, "RﾉUNION"},                                      /*REU, 638},*/
> +       {"RO", RO, "ROMANIA"},                                      /*ROU, 642},*/
> +       {"RU", RU, "RUSSIAN FEDERATION"},                           /*RUS, 643},*/
> +       {"RW", RW, "RWANDA"},                                       /*RWA, 646},*/
> +       {"BL", BL, "SAINT BARTHﾉLEMY"},                             /*BLM, 652},*/
> +       {"SH", SH, "SAINT HELENA"},                                 /*SHN, 654},*/
> +       {"KN", KN, "SAINT KITTS AND NEVIS"},                        /*KNA, 659},*/
> +       {"LC", LC, "SAINT LUCIA"},                                  /*LCA, 662},*/
> +       {"MF", MF, "SAINT MARTIN"},                                 /*MAF, 663},*/
> +       {"PM", PM, "SAINT PIERRE AND MIQUELON"},                    /*SPM, 666},*/
> +       {"VC", VC, "SAINT VINCENT AND THE GRENADINES"},             /*VCT, 670},*/
> +       {"WS", WS, "SAMOA"},                                        /*WSM, 882},*/
> +       {"SM", SM, "SAN MARINO"},                                   /*SMR, 674},*/
> +       {"ST", ST, "SAO TOME AND PRINCIPE"},                        /*STP, 678},*/
> +       {"SA", SA, "SAUDI ARABIA"},                                 /*SAU, 682},*/
> +       {"SN", SN, "SENEGAL"},                                      /*SEN, 686},*/
> +       {"RS", RS, "SERBIA"},                                       /*SRB, 688},*/
> +       {"SC", SC, "SEYCHELLES"},                                   /*SYC, 690},*/
> +       {"SL", SL, "SIERRA LEONE"},                                 /*SLE, 694},*/
> +       {"SX", SX, "SINT MAARTEN"},                                 /*SXM, 534},*/
> +       {"SG", SG, "SINGAPORE"},                                    /*SGP, 702},*/
> +       {"SK", SK, "SLOVAKIA"},                                     /*SVK, 703},*/
> +       {"SI", SI, "SLOVENIA"},                                     /*SVN, 705},*/
> +       {"SB", SB, "SOLOMON ISLANDS"},                              /*SLB, 90 },*/
> +       {"SO", SO, "SOMALIA"},                                      /*SOM, 706},*/
> +       {"ZA", ZA, "SOUTH AFRICA"},                                 /*ZAF, 710},*/
> +       {"GS", GS, "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS"}, /*SGS, 239},*/
> +       {"ES", ES, "SPAIN"},                                        /*ESP, 724},*/
> +       {"LK", LK, "SRI LANKA"},                                    /*LKA, 144},*/
> +       {"SD", SD, "SUDAN"},                                        /*SDN, 736},*/
> +       {"SR", SR, "SURINAME"},                                     /*SUR, 740},*/
> +       {"SJ", SJ, "SVALBARD AND JAN MAYEN"},                       /*SJM, 744},*/
> +       {"SZ", SZ, "SWAZILAND"},                                    /*SWZ, 748},*/
> +       {"SE", SE, "SWEDEN"},                                       /*SWE, 752},*/
> +       {"CH", CH, "SWITZERLAND"},                                  /*CHE, 756},*/
> +       {"SY", SY, "SYRIAN ARAB REPUBLIC"},                         /*SYR, 760},*/
> +       {"TW", TW, "TAIWAN"},                                       /*TWN, 158},*/
> +       {"TJ", TJ, "TAJIKISTAN"},                                   /*TJK, 762},*/
> +       {"TZ", TZ, "TANZANIA, UNITED REPUBLIC OF"},                 /*TZA, 834},*/
> +       {"TH", TH, "THAILAND"},                                     /*THA, 764},*/
> +       {"TL", TL, "TIMOR-LESTE"},                                  /*TLS, 626},*/
> +       {"TG", TG, "TOGO"},                                         /*TGO, 768},*/
> +       {"TK", TK, "TOKELAU"},                                      /*TKL, 772},*/
> +       {"TO", TO, "TONGA"},                                        /*TON, 776},*/
> +       {"TT", TT, "TRINIDAD AND TOBAGO"},                          /*TTO, 780},*/
> +       {"TN", TN, "TUNISIA"},                                      /*TUN, 788},*/
> +       {"TR", TR, "TURKEY"},                                       /*TUR, 792},*/
> +       {"TM", TM, "TURKMENISTAN"},                                 /*TKM, 795},*/
> +       {"TC", TC, "TURKS AND CAICOS ISLANDS"},                     /*TCA, 796},*/
> +       {"TV", TV, "TUVALU"},                                       /*TUV, 798},*/
> +       {"UG", UG, "UGANDA"},                                       /*UGA, 800},*/
> +       {"UA", UA, "UKRAINE"},                                      /*UKR, 804},*/
> +       {"AE", AE, "UNITED ARAB EMIRATES"},                         /*ARE, 784},*/
> +       {"GB", GB, "UNITED KINGDOM"},                               /*GBR, 826},*/
> +       {"US", US, "UNITED STATES"},                                /*USA, 840},*/
> +       {"UM", UM, "UNITED STATES MINOR OUTLYING ISLANDS"},         /*UMI, 581},*/
> +       {"UY", UY, "URUGUAY"},                                      /*URY, 858},*/
> +       {"UZ", UZ, "UZBEKISTAN"},                                   /*UZB, 860},*/
> +       {"VU", VU, "VANUATU"},                                      /*VUT, 548},*/
> +       {"VE", VE, "VENEZUELA"},                                    /*VEN, 862},*/
> +       {"VN", VN, "VIET NAM"},                                     /*VNM, 704},*/
> +       {"VG", VG, "VIRGIN ISLANDS, BRITISH"},                      /*VGB, 92 },*/
> +       {"VI", VI, "VIRGIN ISLANDS, U.S."},                         /*VIR, 850},*/
> +       {"WF", WF, "WALLIS AND FUTUNA"},                            /*WLF, 876},*/
> +       {"EH", EH, "WESTERN SAHARA"},                               /*ESH, 732},*/
> +       {"YE", YE, "YEMEN"},                                        /*YEM, 887},*/
> +       {"ZM", ZM, "ZAMBIA"},                                       /*ZMB, 894},*/
> +       {"ZW", ZW, "ZIMBABWE"}                                      /*ZWE, 716},*/
> +};

Hmm... especially since we're putting this on an exported header, IMO
we should also add the 3 letter code here, as this table could be useful 
when handling the DVB Program Elementary Stream Country Codes too.

> +
> +#define COUNTRY_COUNT(x) (sizeof(x)/sizeof(struct cCountry))
> +
> +
> +
> +/* convert ISO 3166-1 two-letter constant
> + * to index number
> + * return -1 if not found.
> + */
> +int dvb_country_to_id(const char * name)
> +{
> +        unsigned int i;
> +
> +        for (i = 0; i < COUNTRY_COUNT(country_list); i++) {
> +                if (! strcasecmp(name, country_list[i].short_name))
> +                        return country_list[i].id;
> +        }
> +        return COUNTRY_UNKNOWN;
> +}
> +
> +
> +/* convert index number
> + * to ISO 3166-1 two-letter constant
> + */
> +const char * dvb_country_to_short_name(int idx)
> +{
> +        unsigned int i;
> +
> +        for (i = 0; i < COUNTRY_COUNT(country_list); i++)
> +                if (idx == country_list[i].id)
> +                        return country_list[i].short_name;
> +        return NULL;
> +}
> +
> +/* convert index number
> + * to country name
> + */
> +const char * dvb_country_to_full_name(int idx)
> +{
> +        unsigned int i;
> +
> +        for (i = 0; i < COUNTRY_COUNT(country_list); i++)
> +                if (idx == country_list[i].id)
> +                        return country_list[i].full_name;
> +        return NULL;
> +}
> +
> +#ifndef HAVE_SECURE_GETENV
> +#  ifdef HAVE___SECURE_GETENV
> +#    define secure_getenv __secure_getenv
> +#  else
> +#    define secure_getenv getenv
> +#  endif
> +#endif
> +
> +#define MIN(X,Y) (X < Y ? X : Y)
> +
> +static const char * cats[] = {
> + "LC_ALL", "LC_CTYPE", "LC_COLLATE", "LC_MESSAGES", "LANG"
> +};
> +
> +enum country_t dvb_guess_user_country(void)
> +{
> +        char * buf, * pch, * pbuf;
> +        unsigned cat;
> +        enum country_t id = COUNTRY_UNKNOWN;
> +
> +        for (cat = 0; cat < sizeof(cats)/sizeof(cats[0]); cat++) {
> +
> +                // the returned char * should be "C", "POSIX" or something valid.
> +                // If valid, we can only *guess* which format is returned.
> +                // Assume here something like "de_DE.iso8859-1@euro" or "de_DE.utf-8"
> +                buf = secure_getenv(cats[cat]);
> +                if (! buf || strlen(buf) < 2)
> +                        continue;
> +
> +                buf = strdup(buf);
> +                pbuf= buf;
> +       
> +                if (! strncmp(buf, "POSIX", MIN(strlen(buf), 5)) ||
> +                    ! (strncmp(buf, "en", MIN(strlen(buf), 2)) && !isalpha(buf[2])) )
> +                        continue;
> +
> +                // assuming 'language_country.encoding@variant'
> +
> +                // country after '_', if given
> +                if ((pch = strchr(buf, '_')))
> +                        pbuf = pch + 1;
> +
> +                // remove all after '@', including '@'
> +                if ((pch = strchr(pbuf, '@')))
> +                        *pch = 0;
> +
> +                // remove all after '.', including '.'
> +                if ((pch = strchr(pbuf, '.')))
> +                        *pch = 0;
> +
> +                if (strlen(pbuf) == 2) {
> +                        unsigned int i;
> +                        for (i = 0; i < COUNTRY_COUNT(country_list); i++)
> +                                if (! strcasecmp(pbuf, country_list[i].short_name)) {
> +                                        id = country_list[i].id;
> +                                        break;
> +                                }
> +                }
> +                free(buf);
> +                if (id != COUNTRY_UNKNOWN)
> +                        return id;
> +        }
> +
> +        return COUNTRY_UNKNOWN;
> +}
> diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
> index 93c0b9b..05f7d03 100644
> --- a/lib/libdvbv5/dvb-fe.c
> +++ b/lib/libdvbv5/dvb-fe.c
> @@ -20,6 +20,7 @@
>  
>  #include "dvb-fe-priv.h"
>  #include "dvb-v5.h"
> +#include <libdvbv5/countries.h>
>  #include <libdvbv5/dvb-v5-std.h>
>  
>  #include <inttypes.h>
> @@ -113,6 +114,7 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
>  	parms->p.lna = LNA_AUTO;
>  	parms->p.sat_number = -1;
>  	parms->p.abort = 0;
> +	parms->p.country = COUNTRY_UNKNOWN;
>  
>  	if (ioctl(fd, FE_GET_INFO, &parms->p.info) == -1) {
>  		dvb_perror("FE_GET_INFO");
> @@ -372,8 +374,6 @@ int dvb_set_sys(struct dvb_v5_fe_parms *p, fe_delivery_system_t sys)
>  	parms->p.current_sys = sys;
>  	parms->n_props = rc;
>  
> -	if (sys == SYS_ISDBS /* || sys == SYS_ISDBT */)
> -		parms->p.default_charset = "arib-std-b24";
>  	return 0;
>  }
>  
> @@ -658,6 +658,42 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
>  	return 0;
>  }
>  
> +/* set the delsys default/fixed parameters and replace DVBv5 default values */
> +static void dvb_setup_delsys_default(struct dvb_v5_fe_parms *p)
> +{
> +	uint32_t cc;
> +
> +	switch (p->current_sys) {
> +	case SYS_ISDBT:
> +		/* Set country code. */
> +		/* if the default country is not known, fallback to JP */
> +		cc = COUNTRY_UNKNOWN;
> +		dvb_fe_retrieve_parm(p, DTV_COUNTRY_CODE, &cc);
> +		if (cc == COUNTRY_UNKNOWN) {
> +			cc = (p->country == COUNTRY_UNKNOWN)
> +				? JP : p->country;

I think that we should default to "BR" here. Two rationales for it:

1) It would be backward compatible;
2) If those Wikipedia parges are right:
	http://en.wikipedia.org/wiki/ISDB-T_International
	http://en.wikipedia.org/wiki/ISDB
   most Countries are using the "ISDB-T International" variant, as shown
at http://en.wikipedia.org/wiki/ISDB-T_International#Countries_have_adopted_ISDB-T_International.2FSBTVD_.28ISDB-Tb.29

> +			dvb_fe_store_parm(p, DTV_COUNTRY_CODE, cc);
> +		}

I would add this to the switch below.

> +		switch (cc) {
> +		case BR:
> +			p->default_charset = "iso8859-15";
> +			break;

I would explicitly add at the switch below the Country codes for all
South America Countries that adopted ISDB-T, as it is very doubtful
that they would be using ARIB STD B24 charset. Also, AFAIKT, they're
using the Brazilian ABNT NBR specs, and the Wiki page also says about
the sam.

> +		case JP:
> +			p->default_charset = "arib-std-b24";
> +			dvb_fe_store_parm(p, DTV_BANDWIDTH_HZ, 6000000);
> +			break;

The ISDB-T International Wiki page makes us to believe that some Asian 
Countries (Maldives, Philippines and Sri Lanka), plus one African one
(Botswana) are also using ABNT NBR specs instead of ARIB ones.

Yet, I don't think it is safe to assume that. So, I would just don't
add any case for those Countries, letting them fall into the default one.

> +		}
> +		break;
> +	case SYS_ISDBS:
> +		p->default_charset = "arib-std-b24";
> +		if (!p->lnb);
> +			p->lnb = dvb_sat_get_lnb(dvb_sat_search_lnb("110BS"));
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  int dvb_fe_set_parms(struct dvb_v5_fe_parms *p)
>  {
>  	struct dvb_v5_fe_parms_priv *parms = (void *)p;
> @@ -690,6 +726,8 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *p)
>  		parms->freq_offset = tmp_parms.freq_offset;
>  	}
>  
> +	dvb_setup_delsys_default(p);
> +
>  	/* Filter out any user DTV_foo property such as DTV_POLARIZATION */
>  	tmp_parms.n_props = dvb_copy_fe_props(tmp_parms.dvb_prop,
>  					      tmp_parms.n_props,
> diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
> index fa4d370..41e20bb 100644
> --- a/lib/libdvbv5/dvb-file.c
> +++ b/lib/libdvbv5/dvb-file.c
> @@ -49,6 +49,7 @@
>  #include <libdvbv5/desc_event_extended.h>
>  #include <libdvbv5/desc_atsc_service_location.h>
>  #include <libdvbv5/desc_hierarchy.h>
> +#include <libdvbv5/countries.h>
>  
>  int dvb_store_entry_prop(struct dvb_entry *entry,
>  			 uint32_t cmd, uint32_t value)
> @@ -150,6 +151,9 @@ static uint32_t dvbv5_default_value(int cmd)
>  		case DTV_ROLLOFF:
>  			return ROLLOFF_AUTO;
>  
> +		case DTV_COUNTRY_CODE:
> +			return COUNTRY_UNKNOWN;
> +
>  		default:
>  			return (uint32_t)-1;
>  	}
> @@ -616,6 +620,14 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
>  		return 0;
>  	}
>  
> +	if (!strcasecmp(key, "COUNTRY")) {
> +		int id = dvb_country_to_id(value);
> +		if (id < 0)
> +			return -2;
> +		dvb_store_entry_prop(entry, DTV_COUNTRY_CODE, id);
> +		return 0;
> +	}
> +
>  	if (!strcasecmp(key, "VIDEO_PID"))
>  		is_video = 1;
>  	else if (!strcasecmp(key, "AUDIO_PID"))
> @@ -879,6 +891,8 @@ int dvb_write_file(const char *fname, struct dvb_file *dvb_file)
>  
>  		for (i = 0; i < entry->n_props; i++) {
>  			const char * const *attr_name = dvb_attr_names(entry->props[i].cmd);
> +			const char *buf;
> +
>  			if (attr_name) {
>  				int j;
>  
> @@ -889,6 +903,11 @@ int dvb_write_file(const char *fname, struct dvb_file *dvb_file)
>  				}
>  			}
>  
> +			if (entry->props[i].cmd == DTV_COUNTRY_CODE) {
> +				buf = dvb_country_to_short_name(entry->props[i].u.data);
> +				attr_name = &buf;
> +			}
> +
>  			/* Handle parameters with optional values */
>  			switch (entry->props[i].cmd) {
>  			case DTV_PLS_CODE:
> diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
> index 50365cb..5de6b46 100644
> --- a/lib/libdvbv5/dvb-v5-std.c
> +++ b/lib/libdvbv5/dvb-v5-std.c
> @@ -75,6 +75,7 @@ const unsigned int sys_isdbt_props[] = {
>  	DTV_ISDBT_LAYERC_MODULATION,
>  	DTV_ISDBT_LAYERC_SEGMENT_COUNT,
>  	DTV_ISDBT_LAYERC_TIME_INTERLEAVING,
> +	DTV_COUNTRY_CODE,
>  	0
>  };
>  
> @@ -226,6 +227,7 @@ const char *dvb_user_name[DTV_USER_NAME_SIZE + 1] = {
>  	[DTV_FREQ_BPF - DTV_USER_COMMAND_START] =	"FREQ BPF",
>  	[DTV_PLS_CODE - DTV_USER_COMMAND_START] =	"PLS CODE",
>  	[DTV_PLS_MODE - DTV_USER_COMMAND_START] =	"PLS MODE",
> +	[DTV_COUNTRY_CODE - DTV_USER_COMMAND_START] =	"COUNTRY",
>  	[DTV_USER_NAME_SIZE] = NULL,
>  };
>  
> diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
> index 45c8516..e87c983 100644
> --- a/utils/dvb/dvbv5-scan.c
> +++ b/utils/dvb/dvbv5-scan.c
> @@ -37,6 +37,7 @@
>  #include "libdvbv5/dvb-demux.h"
>  #include "libdvbv5/dvb-v5-std.h"
>  #include "libdvbv5/dvb-scan.h"
> +#include "libdvbv5/countries.h"
>  
>  #define PROGRAM_NAME	"dvbv5-scan"
>  #define DEFAULT_OUTPUT  "dvb_channel.conf"
> @@ -51,6 +52,7 @@ struct arguments {
>  	unsigned diseqc_wait, dont_add_new_freqs, timeout_multiply;
>  	unsigned other_nit;
>  	enum dvb_file_formats input_format, output_format;
> +	const char *cc;
>  
>  	/* Used by status print */
>  	unsigned n_status_lines;
> @@ -75,6 +77,7 @@ static const struct argp_option options[] = {
>  	{"input-format", 'I',	"format",		0, "Input format: CHANNEL, DVBV5 (default: DVBV5)", 0},
>  	{"output-format", 'O',	"format",		0, "Output format: CHANNEL, ZAP, DVBV5 (default: DVBV5)", 0},
>  	{"dvbv3",	'3',	0,			0, "Use DVBv3 only", 0},
> +	{"cc",		'C',	"country_code",		0, "use default parameters for given country", 0},
>  	{ 0, 0, 0, 0, 0, 0 }
>  };
>  
> @@ -400,6 +403,9 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
>  	case '3':
>  		args->force_dvbv3 = 1;
>  		break;
> +	case 'C':
> +		args->cc = strndup(optarg, 2);
> +		break;
>  	default:
>  		return ARGP_ERR_UNKNOWN;
>  	};
> @@ -503,6 +509,11 @@ int main(int argc, char **argv)
>  	parms->diseqc_wait = args.diseqc_wait;
>  	parms->freq_bpf = args.freq_bpf;
>  	parms->lna = args.lna;
> +	parms->country = args.cc ? dvb_country_to_id(args.cc)
> +						 : dvb_guess_user_country();
> +	if (verbose && !args.cc)
> +		fprintf(stderr, "Assumign you're in '%s'\n",
> +			dvb_country_to_short_name(parms->country));
>  
>  	timeout_flag = &parms->abort;
>  	signal(SIGTERM, do_timeout);
> diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
> index 498d3dd..c961b89 100644
> --- a/utils/dvb/dvbv5-zap.c
> +++ b/utils/dvb/dvbv5-zap.c
> @@ -41,6 +41,7 @@
>  #include "libdvbv5/dvb-demux.h"
>  #include "libdvbv5/dvb-scan.h"
>  #include "libdvbv5/header.h"
> +#include "libdvbv5/countries.h"
>  
>  #define CHANNEL_FILE	"channels.conf"
>  #define PROGRAM_NAME	"dvbv5-zap"
> @@ -59,6 +60,7 @@ struct arguments {
>  	enum dvb_file_formats input_format, output_format;
>  	unsigned traffic_monitor, low_traffic;
>  	char *search;
> +	const char *cc;
>  
>  	/* Used by status print */
>  	unsigned n_status_lines;
> @@ -89,6 +91,7 @@ static const struct argp_option options[] = {
>  	{"wait",	'W', "time",			0, "adds additional wait time for DISEqC command completion", 0},
>  	{"exit",	'x', NULL,			0, "exit after tuning", 0},
>  	{"low_traffic",	'X', NULL,			0, "also shows DVB traffic with less then 1 packet per second", 0},
> +	{"cc",		'C', "country_code",		0, "use default parameters for given country", 0},
>  	{ 0, 0, 0, 0, 0, 0 }
>  };
>  
> @@ -549,6 +552,9 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
>  	case 'L':
>  		args->search = strdup(optarg);
>  		break;
> +	case 'C':
> +		args->cc = strndup(optarg, 2);
> +		break;
>  	default:
>  		return ARGP_ERR_UNKNOWN;
>  	};
> @@ -803,6 +809,11 @@ int main(int argc, char **argv)
>  	parms->diseqc_wait = args.diseqc_wait;
>  	parms->freq_bpf = args.freq_bpf;
>  	parms->lna = args.lna;
> +	parms->country = args.cc ? dvb_country_to_id(args.cc)
> +						 : dvb_guess_user_country();
> +	if (args.verbose > 0 && !args.cc)
> +		fprintf(stderr, "Assumign you're in '%s'\n",
> +			dvb_country_to_short_name(parms->country));
>  
>  	if (parse(&args, parms, channel, &vpid, &apid, &sid))
>  		goto err;
