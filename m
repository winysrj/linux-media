Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:42342 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752545AbZESQAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:00:43 -0400
Message-ID: <561517.25190.qm@web110811.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 09:00:42 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_53] Siano: smscore - remove redundant define
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242749102 -10800
# Node ID dfcfb90798d3a27cb174019b17fffdee9ce7b2b9
# Parent  b71383c9ab1cd51cc307b488ef4397f6eb345cef
[09051_53] Siano: smscore - remove redundant define

From: Uri Shkolnik <uris@siano-ms.com>

Remove redundant define.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r b71383c9ab1c -r dfcfb90798d3 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 19 19:00:49 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 19 19:05:02 2009 +0300
@@ -645,7 +645,6 @@ extern void smscore_onresponse(struct sm
 extern void smscore_onresponse(struct smscore_device_t *coredev,
 			       struct smscore_buffer_t *cb);
 
-#if 1
 extern int smscore_get_common_buffer_size(struct smscore_device_t *coredev);
 extern int smscore_map_common_buffer(struct smscore_device_t *coredev,
 				      struct vm_area_struct *vma);
@@ -653,7 +652,6 @@ extern int smscore_get_fw_filename(struc
 				   int mode, char *filename);
 extern int smscore_send_fw_file(struct smscore_device_t *coredev,
 				u8 *ufwbuf, int size);
-#endif
 
 extern
 struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev);



      
