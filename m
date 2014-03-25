Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48391 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaCYSUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 14:20:41 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so760758eek.21
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 11:20:40 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 06/11] libdvbv5: remove header files from SOURCES in Makefile.am
Date: Tue, 25 Mar 2014 19:19:56 +0100
Message-Id: <1395771601-3509-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
References: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The header files are not needed in the Makefile.am since
automake finds the dependencies automatically. This is not
needed for installing header files either.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/Makefile.am | 87 ++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index ddf9ea1..8f89531 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -52,52 +52,51 @@ noinst_LTLIBRARIES = libdvbv5.la
 endif
 
 libdvbv5_la_SOURCES = \
-	crc32.c crc32.h \
-	../include/dvb-frontend.h \
+	crc32.c \
 	dvb-legacy-channel-format.c \
 	dvb-zap-format.c \
-	dvb-v5.c	dvb-v5.h \
-	parse_string.c	parse_string.h \
-	dvb-demux.c	../include/dvb-demux.h \
-	dvb-fe.c	../include/dvb-fe.h \
-	dvb-log.c	../include/dvb-log.h \
-	dvb-file.c	../include/dvb-file.h \
-	dvb-v5-std.c	../include/dvb-v5-std.h \
-	dvb-sat.c	../include/dvb-sat.h \
-	dvb-scan.c	../include/dvb-scan.h \
-	descriptors.c	../include/descriptors.h \
-	descriptors/header.c		../include/libdvbv5/header.h \
-	descriptors/atsc_header.c	../include/libdvbv5/atsc_header.h \
-	descriptors/pat.c		../include/libdvbv5/pat.h \
-	descriptors/pmt.c		../include/libdvbv5/pmt.h \
-	descriptors/nit.c		../include/libdvbv5/nit.h \
-	descriptors/sdt.c		../include/libdvbv5/sdt.h \
-	descriptors/vct.c		../include/libdvbv5/vct.h \
-	descriptors/mgt.c		../include/libdvbv5/mgt.h \
-	descriptors/eit.c		../include/libdvbv5/eit.h \
-	descriptors/atsc_eit.c		../include/libdvbv5/atsc_eit.h \
-	descriptors/desc_language.c		../include/libdvbv5/desc_language.h \
-	descriptors/desc_network_name.c		../include/libdvbv5/desc_network_name.h \
-	descriptors/desc_cable_delivery.c	../include/libdvbv5/desc_cable_delivery.h \
-	descriptors/desc_sat.c			../include/libdvbv5/desc_sat.h \
-	descriptors/desc_terrestrial_delivery.c  ../include/libdvbv5/desc_terrestrial_delivery.h \
-	descriptors/desc_t2_delivery.c		../include/libdvbv5/desc_t2_delivery.h \
-	descriptors/desc_service.c		../include/libdvbv5/desc_service.h \
-	descriptors/desc_frequency_list.c	../include/libdvbv5/desc_frequency_list.h \
-	descriptors/desc_service_list.c		../include/libdvbv5/desc_service_list.h \
-	descriptors/desc_event_short.c		../include/libdvbv5/desc_event_short.h \
-	descriptors/desc_event_extended.c	../include/libdvbv5/desc_event_extended.h \
-	descriptors/desc_atsc_service_location.c ../include/libdvbv5/desc_atsc_service_location.h \
-	descriptors/desc_hierarchy.c		../include/libdvbv5/desc_hierarchy.h \
-	descriptors/desc_extension.c		../include/libdvbv5/desc_extension.h \
-	descriptors/desc_isdbt_delivery.c	../include/libdvbv5/desc_isdbt_delivery.h \
-	descriptors/desc_logical_channel.c	../include/libdvbv5/desc_logical_channel.h \
-	descriptors/desc_ts_info.c		../include/libdvbv5/desc_ts_info.h \
-	descriptors/desc_partial_reception.c	../include/libdvbv5/desc_partial_reception.h \
-	descriptors/desc_service_location.c	../include/libdvbv5/desc_service_location.h \
-	descriptors/mpeg_ts.c		../include/libdvbv5/mpeg_ts.h \
-	descriptors/mpeg_pes.c		../include/libdvbv5/mpeg_pes.h \
-	descriptors/mpeg_es.c		../include/libdvbv5/mpeg_es.h
+	dvb-v5.c	 \
+	parse_string.c	 \
+	dvb-demux.c	 \
+	dvb-fe.c	 \
+	dvb-log.c	\
+	dvb-file.c	\
+	dvb-v5-std.c	\
+	dvb-sat.c	\
+	dvb-scan.c	\
+	descriptors.c	\
+	descriptors/header.c		\
+	descriptors/atsc_header.c	\
+	descriptors/pat.c		\
+	descriptors/pmt.c		\
+	descriptors/nit.c		\
+	descriptors/sdt.c		\
+	descriptors/vct.c		\
+	descriptors/mgt.c		\
+	descriptors/eit.c		\
+	descriptors/atsc_eit.c		\
+	descriptors/desc_language.c		\
+	descriptors/desc_network_name.c		\
+	descriptors/desc_cable_delivery.c	\
+	descriptors/desc_sat.c			\
+	descriptors/desc_terrestrial_delivery.c  \
+	descriptors/desc_t2_delivery.c		\
+	descriptors/desc_service.c		\
+	descriptors/desc_frequency_list.c	\
+	descriptors/desc_service_list.c		\
+	descriptors/desc_event_short.c		\
+	descriptors/desc_event_extended.c	\
+	descriptors/desc_atsc_service_location.c \
+	descriptors/desc_hierarchy.c		\
+	descriptors/desc_extension.c		\
+	descriptors/desc_isdbt_delivery.c	\
+	descriptors/desc_logical_channel.c	\
+	descriptors/desc_ts_info.c		\
+	descriptors/desc_partial_reception.c	\
+	descriptors/desc_service_location.c	\
+	descriptors/mpeg_ts.c		\
+	descriptors/mpeg_pes.c		\
+	descriptors/mpeg_es.c
 
 libdvbv5_la_CPPFLAGS = -I../.. $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
-- 
1.8.3.2

