Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:47382 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaI3PRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 11:17:32 -0400
Received: by mail-we0-f175.google.com with SMTP id q59so4068842wes.34
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 08:17:31 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Andre Roth <neolynx@gmail.com>
Subject: [PATCH 3/3] libdvbv5: remove service_list descriptor
Date: Tue, 30 Sep 2014 17:17:08 +0200
Message-Id: <1412090228-19996-4-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
References: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC: Andre Roth <neolynx@gmail.com>
Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 doxygen_libdvbv5.cfg                         |   1 -
 lib/include/libdvbv5/desc_service_list.h     | 119 ---------------------------
 lib/libdvbv5/Makefile.am                     |   2 -
 lib/libdvbv5/compat-soname.c                 |   8 ++
 lib/libdvbv5/descriptors.c                   |   8 --
 lib/libdvbv5/descriptors/desc_service_list.c |  56 -------------
 6 files changed, 8 insertions(+), 186 deletions(-)
 delete mode 100644 lib/include/libdvbv5/desc_service_list.h
 delete mode 100644 lib/libdvbv5/descriptors/desc_service_list.c

diff --git a/doxygen_libdvbv5.cfg b/doxygen_libdvbv5.cfg
index 0c3c24e..21c3626 100644
--- a/doxygen_libdvbv5.cfg
+++ b/doxygen_libdvbv5.cfg
@@ -783,7 +783,6 @@ INPUT                  = $(SRCDIR)/doc/libdvbv5-index.doc \
 			 $(SRCDIR)/lib/include/libdvbv5/desc_partial_reception.h \
 			 $(SRCDIR)/lib/include/libdvbv5/desc_sat.h \
 			 $(SRCDIR)/lib/include/libdvbv5/desc_service.h \
-			 $(SRCDIR)/lib/include/libdvbv5/desc_service_list.h \
 			 $(SRCDIR)/lib/include/libdvbv5/desc_t2_delivery.h \
 			 $(SRCDIR)/lib/include/libdvbv5/desc_terrestrial_delivery.h \
 			 $(SRCDIR)/lib/include/libdvbv5/desc_ts_info.h \
diff --git a/lib/include/libdvbv5/desc_service_list.h b/lib/include/libdvbv5/desc_service_list.h
deleted file mode 100644
index dfcb596..0000000
--- a/lib/include/libdvbv5/desc_service_list.h
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation version 2
- * of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
- * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
- *
- */
-
-/**
- * @file desc_service_list.h
- * @ingroup descriptors
- * @brief Provides the descriptors for the service list descriptor
- * @copyright GNU General Public License version 2 (GPLv2)
- * @author Andre Roth
- *
- * @par Relevant specs
- * The descriptor described herein is defined at:
- * - ETSI EN 300 468 V1.11.1
- *
- * @par Bug Report
- * Please submit bug reports and patches to linux-media@vger.kernel.org
- *
- * @todo Properly implement a parser for this descriptor. However, this
- *	 will break the API.
- */
-
-#ifndef _DESC_SERVICE_LIST_H
-#define _DESC_SERVICE_LIST_H
-
-#include <libdvbv5/descriptors.h>
-
-/**
- * @struct dvb_desc_service_list_table
- * @ingroup descriptors
- * @brief Structure containing the service list table
- *
- * @param service_id	service id
- * @param service_type	service type
- */
-struct dvb_desc_service_list_table {
-	uint16_t service_id;
-	uint8_t service_type;
-} __attribute__((packed));
-
-/**
- * @struct dvb_desc_service_list
- * @ingroup descriptors
- * @brief Structure containing the service list descriptor
- *
- * @param type			descriptor tag
- * @param length		descriptor length
- * @param next			pointer to struct dvb_desc
- *
- * @bug Currently, the service list is not properly parsed, as the
- * struct dvb_desc_service_list_table pointer is commented.
- */
-struct dvb_desc_service_list {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
-
-	/* FIXME */
-	/* struct dvb_desc_service_list_table services[]; */
-} __attribute__((packed));
-
-struct dvb_v5_fe_parms;
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-/**
- * @brief Initializes and parses the service list descriptor
- * @ingroup descriptors
- *
- * @param parms	struct dvb_v5_fe_parms pointer to the opened device
- * @param buf	buffer containing the descriptor's raw data
- * @param desc	pointer to struct dvb_desc to be allocated and filled
- *
- * This function initializes and makes sure that all fields will follow the CPU
- * endianness. Due to that, the content of the buffer may change.
- *
- * Currently, no memory is allocated internally.
- *
- * @return On success, it returns the size of the allocated struct.
- *	   A negative value indicates an error.
- */
-int dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms,
-			       const uint8_t *buf, struct dvb_desc *desc);
-
-/**
- * @brief Prints the content of the service list descriptor
- * @ingroup descriptors
- *
- * @param parms	struct dvb_v5_fe_parms pointer to the opened device
- * @param desc	pointer to struct dvb_desc
- *
- * @bug Currently, it does nothing.
- */
-void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms,
-				 const struct dvb_desc *desc);
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 037c153..f126dc5 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -24,7 +24,6 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/desc_t2_delivery.h \
 	../include/libdvbv5/desc_service.h \
 	../include/libdvbv5/desc_frequency_list.h \
-	../include/libdvbv5/desc_service_list.h \
 	../include/libdvbv5/desc_event_short.h \
 	../include/libdvbv5/desc_event_extended.h \
 	../include/libdvbv5/desc_atsc_service_location.h \
@@ -94,7 +93,6 @@ libdvbv5_la_SOURCES = \
 	descriptors/desc_t2_delivery.c		\
 	descriptors/desc_service.c		\
 	descriptors/desc_frequency_list.c	\
-	descriptors/desc_service_list.c		\
 	descriptors/desc_event_short.c		\
 	descriptors/desc_event_extended.c	\
 	descriptors/desc_atsc_service_location.c \
diff --git a/lib/libdvbv5/compat-soname.c b/lib/libdvbv5/compat-soname.c
index e9f534a..f021c9b 100644
--- a/lib/libdvbv5/compat-soname.c
+++ b/lib/libdvbv5/compat-soname.c
@@ -34,3 +34,11 @@ void dvb_desc_service_location_free(struct dvb_desc *desc)
 {
 }
 
+int dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	return -1;
+}
+
+void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+}
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 63ce939..0a42fe9 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -45,7 +45,6 @@
 #include <libdvbv5/desc_terrestrial_delivery.h>
 #include <libdvbv5/desc_isdbt_delivery.h>
 #include <libdvbv5/desc_service.h>
-#include <libdvbv5/desc_service_list.h>
 #include <libdvbv5/desc_frequency_list.h>
 #include <libdvbv5/desc_event_short.h>
 #include <libdvbv5/desc_event_extended.h>
@@ -458,13 +457,6 @@ const struct dvb_descriptor dvb_descriptors[] = {
 		.free  = dvb_desc_network_name_free,
 		.size  = sizeof(struct dvb_desc_network_name),
 	},
-	[service_list_descriptor] = {
-		.name  = "service_list_descriptor",
-		.init  = dvb_desc_service_list_init,
-		.print = dvb_desc_service_list_print,
-		.free  = NULL,
-		.size  = sizeof(struct dvb_desc_service_list),
-	},
 	[stuffing_descriptor] = {
 		.name  = "stuffing_descriptor",
 		.init  = NULL,
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
deleted file mode 100644
index 4cd4018..0000000
--- a/lib/libdvbv5/descriptors/desc_service_list.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation version 2
- * of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
- * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
- *
- */
-
-#include <libdvbv5/desc_service_list.h>
-#include <libdvbv5/dvb-fe.h>
-
-/* FIXME: implement */
-
-int dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
-{
-	/*struct dvb_desc_service_list *slist = (struct dvb_desc_service_list *) desc;*/
-
-	/*memcpy( slist->services, buf, slist->length);*/
-	/*[> close the list <]*/
-	/*slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_id = 0;*/
-	/*slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_type = 0;*/
-	/*[> swap the ids <]*/
-	/*int i;*/
-	/*for( i = 0; slist->services[i].service_id != 0; ++i) {*/
-		/*bswap16(slist->services[i].service_id);*/
-	/*}*/
-
-	/*return sizeof(struct dvb_desc_service_list) + slist->length + sizeof(struct dvb_desc_service_list_table);*/
-	/* FIXME: make linked list */
-	return 0;
-}
-
-void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
-{
-	/*const struct dvb_desc_service_list *slist = (const struct dvb_desc_service_list *) desc;*/
-	/*int i = 0;*/
-	/*while(slist->services[i].service_id != 0) {*/
-		/*dvb_loginfo("|           service id   : '%d'", slist->services[i].service_id);*/
-		/*dvb_loginfo("|           service type : '%d'", slist->services[i].service_type);*/
-		/*++i;*/
-	/*}*/
-}
-
-- 
2.1.0

