Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:55813 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752087AbcLJUxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 15:53:21 -0500
Subject: [PATCH 4/4] [media] bt8xx: Less function calls in dst_ca_ioctl()
 after error detection
To: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <eee59395-e2aa-fdce-68f0-1a3e630f08d0@users.sourceforge.net>
Date: Sat, 10 Dec 2016 21:53:09 +0100
MIME-Version: 1.0
In-Reply-To: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 10 Dec 2016 21:30:10 +0100

The kfree() function was called in up to three cases
by the dst_ca_ioctl() function during error handling
even if the passed variable contained a null pointer.

This issue was detected by using the Coccinelle software.

* Split a condition check for memory allocation failures so that
  each pointer from these function calls will be checked immediately.

  See also background information:
  Topic "CWE-754: Improper check for unusual or exceptional conditions"
  Link: https://cwe.mitre.org/data/definitions/754.html

  Fixes: b57e5578f913a304e97cb66aa0044a894ca47f2f ("Fixes some sync issues between V4L/DVB development and GIT")

* Replace the specification of data structures by pointer dereferences
  to make the corresponding size determination a bit safer.

* Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/bt8xx/dst_ca.c | 51 +++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 04d06c564602..50cdb53c9e8a 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -559,16 +559,27 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	int result = 0;
 
 	mutex_lock(&dst_ca_mutex);
-	dvbdev = file->private_data;
-	state = (struct dst_state *)dvbdev->priv;
-	p_ca_message = kmalloc(sizeof (struct ca_msg), GFP_KERNEL);
-	p_ca_slot_info = kmalloc(sizeof (struct ca_slot_info), GFP_KERNEL);
-	p_ca_caps = kmalloc(sizeof (struct ca_caps), GFP_KERNEL);
-	if (!p_ca_message || !p_ca_slot_info || !p_ca_caps) {
+	p_ca_message = kmalloc(sizeof(*p_ca_message), GFP_KERNEL);
+	if (!p_ca_message) {
 		result = -ENOMEM;
-		goto free_mem_and_exit;
+		goto unlock;
+	}
+
+	p_ca_slot_info = kmalloc(sizeof(*p_ca_slot_info), GFP_KERNEL);
+	if (!p_ca_slot_info) {
+		result = -ENOMEM;
+		goto free_message;
 	}
 
+	p_ca_caps = kmalloc(sizeof(*p_ca_caps), GFP_KERNEL);
+	if (!p_ca_caps) {
+		result = -ENOMEM;
+		goto free_slot_info;
+	}
+
+	dvbdev = file->private_data;
+	state = (struct dst_state *)dvbdev->priv;
+
 	/*	We have now only the standard ioctl's, the driver is upposed to handle internals.	*/
 	switch (cmd) {
 	case CA_SEND_MSG:
@@ -576,7 +587,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		if ((ca_send_message(state, p_ca_message, arg)) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_SEND_MSG Failed !");
 			result = -1;
-			goto free_mem_and_exit;
+			goto free_caps;
 		}
 		break;
 	case CA_GET_MSG:
@@ -584,7 +595,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		if ((ca_get_message(state, p_ca_message, arg)) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_MSG Failed !");
 			result = -1;
-			goto free_mem_and_exit;
+			goto free_caps;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_MSG Success !");
 		break;
@@ -598,7 +609,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		if ((ca_get_slot_info(state, p_ca_slot_info, arg)) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_SLOT_INFO Failed !");
 			result = -1;
-			goto free_mem_and_exit;
+			goto free_caps;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_SLOT_INFO Success !");
 		break;
@@ -607,7 +618,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		if ((ca_get_slot_caps(state, p_ca_caps, arg)) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_CAP Failed !");
 			result = -1;
-			goto free_mem_and_exit;
+			goto free_caps;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_CAP Success !");
 		break;
@@ -616,7 +627,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		if ((ca_get_slot_descr(state, p_ca_message, arg)) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_GET_DESCR_INFO Failed !");
 			result = -1;
-			goto free_mem_and_exit;
+			goto free_caps;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_DESCR_INFO Success !");
 		break;
@@ -625,7 +636,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		if ((ca_set_slot_descr()) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_SET_DESCR Failed !");
 			result = -1;
-			goto free_mem_and_exit;
+			goto free_caps;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_DESCR Success !");
 		break;
@@ -634,17 +645,19 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		if ((ca_set_pid()) < 0) {
 			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_SET_PID Failed !");
 			result = -1;
-			goto free_mem_and_exit;
+			goto free_caps;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_PID Success !");
 	default:
 		result = -EOPNOTSUPP;
 	}
- free_mem_and_exit:
-	kfree (p_ca_message);
-	kfree (p_ca_slot_info);
-	kfree (p_ca_caps);
-
+free_caps:
+	kfree(p_ca_caps);
+free_slot_info:
+	kfree(p_ca_slot_info);
+free_message:
+	kfree(p_ca_message);
+unlock:
 	mutex_unlock(&dst_ca_mutex);
 	return result;
 }
-- 
2.11.0

