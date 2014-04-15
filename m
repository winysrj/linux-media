Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59302 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaDOSl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 14:41:27 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so8082905eei.14
        for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 11:41:25 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/4] libdvbv5: move table parsers to separate directory
Date: Tue, 15 Apr 2014 20:39:30 +0200
Message-Id: <1397587173-1120-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move the dvb table parsers from the descriptors/ directory
to tables/ to have a nice and clear separation.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/Makefile.am                        | 42 ++++++++++++-------------
 lib/libdvbv5/{descriptors => tables}/atsc_eit.c |  0
 lib/libdvbv5/{descriptors => tables}/cat.c      |  0
 lib/libdvbv5/{descriptors => tables}/eit.c      |  0
 lib/libdvbv5/{descriptors => tables}/header.c   |  0
 lib/libdvbv5/{descriptors => tables}/mgt.c      |  0
 lib/libdvbv5/{descriptors => tables}/mpeg_es.c  |  0
 lib/libdvbv5/{descriptors => tables}/mpeg_pes.c |  0
 lib/libdvbv5/{descriptors => tables}/mpeg_ts.c  |  0
 lib/libdvbv5/{descriptors => tables}/nit.c      |  0
 lib/libdvbv5/{descriptors => tables}/pat.c      |  0
 lib/libdvbv5/{descriptors => tables}/pmt.c      |  0
 lib/libdvbv5/{descriptors => tables}/sdt.c      |  0
 lib/libdvbv5/{descriptors => tables}/vct.c      |  0
 14 files changed, 21 insertions(+), 21 deletions(-)
 rename lib/libdvbv5/{descriptors => tables}/atsc_eit.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/cat.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/eit.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/header.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/mgt.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/mpeg_es.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/mpeg_pes.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/mpeg_ts.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/nit.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/pat.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/pmt.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/sdt.c (100%)
 rename lib/libdvbv5/{descriptors => tables}/vct.c (100%)

diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index ce3f806..515adc3 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -63,27 +63,30 @@ libdvbv5_la_SOURCES = \
 	parse_string.c	 \
 	dvb-demux.c	 \
 	dvb-fe.c	 \
-	dvb-log.c	\
-	dvb-file.c	\
-	dvb-v5-std.c	\
-	dvb-sat.c	\
-	dvb-scan.c	\
-	descriptors.c	\
-	descriptors/header.c		\
-	descriptors/pat.c		\
-	descriptors/pmt.c		\
-	descriptors/nit.c		\
-	descriptors/sdt.c		\
-	descriptors/vct.c		\
-	descriptors/mgt.c		\
-	descriptors/eit.c		\
-	descriptors/cat.c		\
-	descriptors/atsc_eit.c		\
+	dvb-log.c	 \
+	dvb-file.c	 \
+	dvb-v5-std.c	 \
+	dvb-sat.c	 \
+	dvb-scan.c	 \
+	descriptors.c	 \
+	tables/header.c		\
+	tables/pat.c		\
+	tables/pmt.c		\
+	tables/nit.c		\
+	tables/sdt.c		\
+	tables/vct.c		\
+	tables/mgt.c		\
+	tables/eit.c		\
+	tables/cat.c		\
+	tables/atsc_eit.c	\
+	tables/mpeg_ts.c	\
+	tables/mpeg_pes.c	\
+	tables/mpeg_es.c	\
 	descriptors/desc_language.c		\
 	descriptors/desc_network_name.c		\
 	descriptors/desc_cable_delivery.c	\
 	descriptors/desc_sat.c			\
-	descriptors/desc_terrestrial_delivery.c  \
+	descriptors/desc_terrestrial_delivery.c \
 	descriptors/desc_t2_delivery.c		\
 	descriptors/desc_service.c		\
 	descriptors/desc_frequency_list.c	\
@@ -99,10 +102,7 @@ libdvbv5_la_SOURCES = \
 	descriptors/desc_partial_reception.c	\
 	descriptors/desc_service_location.c	\
 	descriptors/desc_ca.c			\
-	descriptors/desc_ca_identifier.c	\
-	descriptors/mpeg_ts.c			\
-	descriptors/mpeg_pes.c			\
-	descriptors/mpeg_es.c
+	descriptors/desc_ca_identifier.c
 
 libdvbv5_la_CPPFLAGS = -I../.. $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/tables/atsc_eit.c
similarity index 100%
rename from lib/libdvbv5/descriptors/atsc_eit.c
rename to lib/libdvbv5/tables/atsc_eit.c
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/tables/cat.c
similarity index 100%
rename from lib/libdvbv5/descriptors/cat.c
rename to lib/libdvbv5/tables/cat.c
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/tables/eit.c
similarity index 100%
rename from lib/libdvbv5/descriptors/eit.c
rename to lib/libdvbv5/tables/eit.c
diff --git a/lib/libdvbv5/descriptors/header.c b/lib/libdvbv5/tables/header.c
similarity index 100%
rename from lib/libdvbv5/descriptors/header.c
rename to lib/libdvbv5/tables/header.c
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/tables/mgt.c
similarity index 100%
rename from lib/libdvbv5/descriptors/mgt.c
rename to lib/libdvbv5/tables/mgt.c
diff --git a/lib/libdvbv5/descriptors/mpeg_es.c b/lib/libdvbv5/tables/mpeg_es.c
similarity index 100%
rename from lib/libdvbv5/descriptors/mpeg_es.c
rename to lib/libdvbv5/tables/mpeg_es.c
diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/tables/mpeg_pes.c
similarity index 100%
rename from lib/libdvbv5/descriptors/mpeg_pes.c
rename to lib/libdvbv5/tables/mpeg_pes.c
diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/tables/mpeg_ts.c
similarity index 100%
rename from lib/libdvbv5/descriptors/mpeg_ts.c
rename to lib/libdvbv5/tables/mpeg_ts.c
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/tables/nit.c
similarity index 100%
rename from lib/libdvbv5/descriptors/nit.c
rename to lib/libdvbv5/tables/nit.c
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/tables/pat.c
similarity index 100%
rename from lib/libdvbv5/descriptors/pat.c
rename to lib/libdvbv5/tables/pat.c
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/tables/pmt.c
similarity index 100%
rename from lib/libdvbv5/descriptors/pmt.c
rename to lib/libdvbv5/tables/pmt.c
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/tables/sdt.c
similarity index 100%
rename from lib/libdvbv5/descriptors/sdt.c
rename to lib/libdvbv5/tables/sdt.c
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/tables/vct.c
similarity index 100%
rename from lib/libdvbv5/descriptors/vct.c
rename to lib/libdvbv5/tables/vct.c
-- 
1.9.1

