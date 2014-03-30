Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45130 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaC3QV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:21:58 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so5754512eek.8
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:21:57 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 6/8] libdvbv5: remove unneeded includes
Date: Sun, 30 Mar 2014 18:21:16 +0200
Message-Id: <1396196478-996-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1396196478-996-1-git-send-email-neolynx@gmail.com>
References: <1396196478-996-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors/desc_atsc_service_location.c | 1 -
 lib/libdvbv5/descriptors/desc_ca.c                    | 1 -
 lib/libdvbv5/descriptors/desc_ca_identifier.c         | 1 -
 lib/libdvbv5/descriptors/desc_cable_delivery.c        | 1 -
 lib/libdvbv5/descriptors/desc_event_extended.c        | 1 -
 lib/libdvbv5/descriptors/desc_event_short.c           | 1 -
 lib/libdvbv5/descriptors/desc_extension.c             | 1 -
 lib/libdvbv5/descriptors/desc_frequency_list.c        | 1 -
 lib/libdvbv5/descriptors/desc_hierarchy.c             | 1 -
 lib/libdvbv5/descriptors/desc_isdbt_delivery.c        | 1 -
 lib/libdvbv5/descriptors/desc_language.c              | 1 -
 lib/libdvbv5/descriptors/desc_logical_channel.c       | 1 -
 lib/libdvbv5/descriptors/desc_network_name.c          | 1 -
 lib/libdvbv5/descriptors/desc_partial_reception.c     | 1 -
 lib/libdvbv5/descriptors/desc_sat.c                   | 1 -
 lib/libdvbv5/descriptors/desc_service.c               | 1 -
 lib/libdvbv5/descriptors/desc_service_list.c          | 1 -
 lib/libdvbv5/descriptors/desc_t2_delivery.c           | 1 -
 lib/libdvbv5/descriptors/desc_terrestrial_delivery.c  | 1 -
 lib/libdvbv5/descriptors/desc_ts_info.c               | 1 -
 20 files changed, 20 deletions(-)

diff --git a/lib/libdvbv5/descriptors/desc_atsc_service_location.c b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
index d47eee0..a654adc 100644
--- a/lib/libdvbv5/descriptors/desc_atsc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
@@ -18,7 +18,6 @@
  *
  */
 
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/desc_atsc_service_location.h>
 #include <libdvbv5/dvb-fe.h>
 
diff --git a/lib/libdvbv5/descriptors/desc_ca.c b/lib/libdvbv5/descriptors/desc_ca.c
index 01d3b8c..791bda2 100644
--- a/lib/libdvbv5/descriptors/desc_ca.c
+++ b/lib/libdvbv5/descriptors/desc_ca.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_ca.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_ca_identifier.c b/lib/libdvbv5/descriptors/desc_ca_identifier.c
index c986ac7..3102d01 100644
--- a/lib/libdvbv5/descriptors/desc_ca_identifier.c
+++ b/lib/libdvbv5/descriptors/desc_ca_identifier.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_ca_identifier.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_ca_identifier_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
index 63583eb..2ba0ce6 100644
--- a/lib/libdvbv5/descriptors/desc_cable_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -21,7 +21,6 @@
  */
 
 #include <libdvbv5/desc_cable_delivery.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index 9d7c6e3..346a71c 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_event_extended.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index d28e5f0..e9d7bd7 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_event_short.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
diff --git a/lib/libdvbv5/descriptors/desc_extension.c b/lib/libdvbv5/descriptors/desc_extension.c
index 91748bb..0aaeba8 100644
--- a/lib/libdvbv5/descriptors/desc_extension.c
+++ b/lib/libdvbv5/descriptors/desc_extension.c
@@ -18,7 +18,6 @@
  *
  */
 
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/desc_extension.h>
 #include <libdvbv5/desc_t2_delivery.h>
 #include <libdvbv5/dvb-fe.h>
diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
index 9643015..a9a3b9e 100644
--- a/lib/libdvbv5/descriptors/desc_frequency_list.c
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_frequency_list.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_hierarchy.c b/lib/libdvbv5/descriptors/desc_hierarchy.c
index 0d8ac66..17b3699 100644
--- a/lib/libdvbv5/descriptors/desc_hierarchy.c
+++ b/lib/libdvbv5/descriptors/desc_hierarchy.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_hierarchy.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_hierarchy_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
index 9ef5df4..336ca85 100644
--- a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
@@ -18,7 +18,6 @@
  *
  */
 
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/desc_isdbt_delivery.h>
 #include <libdvbv5/dvb-fe.h>
 
diff --git a/lib/libdvbv5/descriptors/desc_language.c b/lib/libdvbv5/descriptors/desc_language.c
index 91646c7..7504dd5 100644
--- a/lib/libdvbv5/descriptors/desc_language.c
+++ b/lib/libdvbv5/descriptors/desc_language.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_language.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_logical_channel.c b/lib/libdvbv5/descriptors/desc_logical_channel.c
index 6ebea03..7137c57 100644
--- a/lib/libdvbv5/descriptors/desc_logical_channel.c
+++ b/lib/libdvbv5/descriptors/desc_logical_channel.c
@@ -22,7 +22,6 @@
  *	http://tdt.telecom.pt/recursos/apresentacoes/Signalling Specifications for DTT deployment in Portugal.pdf
  */
 
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/desc_logical_channel.h>
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
index 6a6cb09..0fa456f 100644
--- a/lib/libdvbv5/descriptors/desc_network_name.c
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_network_name.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 #include "parse_string.h"
 
diff --git a/lib/libdvbv5/descriptors/desc_partial_reception.c b/lib/libdvbv5/descriptors/desc_partial_reception.c
index 4d19f14..0e4d25c 100644
--- a/lib/libdvbv5/descriptors/desc_partial_reception.c
+++ b/lib/libdvbv5/descriptors/desc_partial_reception.c
@@ -19,7 +19,6 @@
  * Described on ARIB STD-B10 as Partial reception descriptor
  */
 
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/desc_partial_reception.h>
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
index 3084435..5494799 100644
--- a/lib/libdvbv5/descriptors/desc_sat.c
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_sat.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index c356b7f..7289219 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_service.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
index 58d4f2d..3e7e603 100644
--- a/lib/libdvbv5/descriptors/desc_service_list.c
+++ b/lib/libdvbv5/descriptors/desc_service_list.c
@@ -20,7 +20,6 @@
  */
 
 #include <libdvbv5/desc_service_list.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 /* FIXME: implement */
diff --git a/lib/libdvbv5/descriptors/desc_t2_delivery.c b/lib/libdvbv5/descriptors/desc_t2_delivery.c
index b7f2d0b..0d5cab6 100644
--- a/lib/libdvbv5/descriptors/desc_t2_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_t2_delivery.c
@@ -19,7 +19,6 @@
  * Based on ETSI EN 300 468 V1.11.1 (2010-04)
  */
 
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/desc_extension.h>
 #include <libdvbv5/desc_t2_delivery.h>
 #include <libdvbv5/dvb-fe.h>
diff --git a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
index 3bf478c..8b6a92d 100644
--- a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
@@ -22,7 +22,6 @@
  */
 
 #include <libdvbv5/desc_terrestrial_delivery.h>
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 int dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_ts_info.c b/lib/libdvbv5/descriptors/desc_ts_info.c
index f2867e5..7a6e520 100644
--- a/lib/libdvbv5/descriptors/desc_ts_info.c
+++ b/lib/libdvbv5/descriptors/desc_ts_info.c
@@ -19,7 +19,6 @@
  * Described on ARIB STD-B10 as TS information descriptor
  */
 
-#include <libdvbv5/descriptors.h>
 #include <libdvbv5/desc_ts_info.h>
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
-- 
1.8.3.2

