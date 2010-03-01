Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53250 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0CAL4x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 06:56:53 -0500
Date: Mon, 1 Mar 2010 12:56:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firedtv: add parameter to fake ca_system_ids in
 CA_INFO
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, Henrik Kurelid <henrik@kurelid.se>
In-Reply-To: <tkrat.a8cdf995cdc06e83@s5r6.in-berlin.de>
Message-ID: <tkrat.05a3377b9f48299a@s5r6.in-berlin.de>
References: <tkrat.dc97d52c76a2dc07@s5r6.in-berlin.de>
 <tkrat.a8cdf995cdc06e83@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Henrik Kurelid <henrik@kurelid.se>
Subject: firedtv: add parameter to fake ca_system_ids in CA_INFO

The Digital Everywhere firmware have the shortcoming that ca_info_enq and
ca_info are not supported. This means that we can never retrieve the correct
ca_system_id to present in the CI message CA_INFO. Currently the driver uses
the application id retrieved using app_info_req and app_info, but this id
only match the correct ca_system_id as given in ca_info in some cases.
This patch adds a parameter to the driver in order for the user to override
what will be returned in the CA_INFO CI message. Up to four ca_system_ids can
be specified.
This is needed for users with CAMs that have different manufacturer id and
ca_system_id and that uses applications that take this into account, like
MythTV.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (rebased, type of num_fake_ca_system_ids, format of comment)
---

Update:  I found a sparse warning after the fact. num_fake_ca_system_ids
is meant to be unsigned, not signed.  Sorry that I missed it in my first
posting; it was hidden by an unrelated sparse error in
include/linux/skbuff.h which was introduced by commit 14d18a81.  I need
to have a word (again) with the author of this commit.

 drivers/media/dvb/firewire/firedtv-avc.c |   31 ++++++++++++++++++++---
 1 file changed, 27 insertions(+), 4 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -130,6 +130,20 @@ MODULE_PARM_DESC(debug, "Verbose logging
 	", FCP payloads = "		__stringify(AVC_DEBUG_FCP_PAYLOADS)
 	", or a combination, or all = -1)");
 
+/*
+ * This is a workaround since there is no vendor specific command to retrieve
+ * ca_info using AVC. If this parameter is not used, ca_system_id will be
+ * filled with application_manufacturer from ca_app_info.
+ * Digital Everywhere have said that adding ca_info is on their TODO list.
+ */
+static unsigned int num_fake_ca_system_ids;
+static int fake_ca_system_ids[4] = { -1, -1, -1, -1 };
+module_param_array(fake_ca_system_ids, int, &num_fake_ca_system_ids, 0644);
+MODULE_PARM_DESC(fake_ca_system_ids, "If your CAM application manufacturer "
+		 "does not have the same ca_system_id as your CAS, you can "
+		 "override what ca_system_ids are presented to the "
+		 "application by setting this field to an array of ids.");
+
 static const char *debug_fcp_ctype(unsigned int ctype)
 {
 	static const char *ctypes[] = {
@@ -977,7 +991,7 @@ int avc_ca_info(struct firedtv *fdtv, ch
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
-	int pos, ret;
+	int i, pos, ret;
 
 	mutex_lock(&fdtv->avc_mutex);
 
@@ -1004,9 +1018,18 @@ int avc_ca_info(struct firedtv *fdtv, ch
 	app_info[0] = (EN50221_TAG_CA_INFO >> 16) & 0xff;
 	app_info[1] = (EN50221_TAG_CA_INFO >>  8) & 0xff;
 	app_info[2] = (EN50221_TAG_CA_INFO >>  0) & 0xff;
-	app_info[3] = 2;
-	app_info[4] = r->operand[pos + 0];
-	app_info[5] = r->operand[pos + 1];
+	if (num_fake_ca_system_ids == 0) {
+		app_info[3] = 2;
+		app_info[4] = r->operand[pos + 0];
+		app_info[5] = r->operand[pos + 1];
+	} else {
+		app_info[3] = num_fake_ca_system_ids * 2;
+		for (i = 0; i < num_fake_ca_system_ids; i++) {
+			app_info[4 + i * 2] =
+				(fake_ca_system_ids[i] >> 8) & 0xff;
+			app_info[5 + i * 2] = fake_ca_system_ids[i] & 0xff;
+		}
+	}
 	*len = app_info[3] + 4;
 out:
 	mutex_unlock(&fdtv->avc_mutex);

-- 
Stefan Richter
-=====-==-=- --== ----=
http://arcgraph.de/sr/

