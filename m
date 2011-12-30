Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1L3PJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:35 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9YXS015952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 91/94] [media] dvb-core: be sure that drivers won't use DVBv3 internally
Date: Fri, 30 Dec 2011 13:08:28 -0200
Message-Id: <1325257711-12274-92-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all frontends are implementing DVBv5, don't export the
DVBv3 specific stuff to the drivers. Only the core should be
aware of that, as it will keep providing DVBv3 backward compatibility.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    3 +++
 drivers/media/dvb/dvb-core/dvb_frontend.h |    2 ++
 include/linux/dvb/frontend.h              |    6 ++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 68d284b..9131f1a 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -25,6 +25,9 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
+/* Enables DVBv3 compatibility bits at the headers */
+#define __DVB_CORE__
+
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 52efcbd..382d97f 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -315,6 +315,7 @@ struct dvb_frontend_ops {
 	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
+#ifdef __DVB_CORE__
 #define MAX_EVENT 8
 
 struct dvb_fe_events {
@@ -325,6 +326,7 @@ struct dvb_fe_events {
 	wait_queue_head_t	  wait_queue;
 	struct mutex		  mtx;
 };
+#endif
 
 struct dtv_frontend_properties {
 
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index a3c7623..7e7cb64 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -181,6 +181,7 @@ typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_32K,
 } fe_transmit_mode_t;
 
+#if defined(__DVB_CORE__) || !defined (__KERNEL__)
 typedef enum fe_bandwidth {
 	BANDWIDTH_8_MHZ,
 	BANDWIDTH_7_MHZ,
@@ -190,7 +191,7 @@ typedef enum fe_bandwidth {
 	BANDWIDTH_10_MHZ,
 	BANDWIDTH_1_712_MHZ,
 } fe_bandwidth_t;
-
+#endif
 
 typedef enum fe_guard_interval {
 	GUARD_INTERVAL_1_32,
@@ -213,6 +214,7 @@ typedef enum fe_hierarchy {
 } fe_hierarchy_t;
 
 
+#if defined(__DVB_CORE__) || !defined (__KERNEL__)
 struct dvb_qpsk_parameters {
 	__u32		symbol_rate;  /* symbol rate in Symbols per second */
 	fe_code_rate_t	fec_inner;    /* forward error correction (see above) */
@@ -251,11 +253,11 @@ struct dvb_frontend_parameters {
 	} u;
 };
 
-
 struct dvb_frontend_event {
 	fe_status_t status;
 	struct dvb_frontend_parameters parameters;
 };
+#endif
 
 /* S2API Commands */
 #define DTV_UNDEFINED		0
-- 
1.7.8.352.g876a6

