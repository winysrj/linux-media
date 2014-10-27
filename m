Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:56120 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaJ0Obd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 10:31:33 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NE300F5JXOK8860@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Oct 2014 10:31:32 -0400 (EDT)
Date: Mon, 27 Oct 2014 12:31:28 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/7] v4l-utils/libdvbv5: fix auto generation of channel
 names
Message-id: <20141027123128.45aff774.m.chehab@samsung.com>
In-reply-to: <1414323983-15996-2-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-2-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Oct 2014 20:46:17 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> when channel name was not available, it was generated from unset variables,
> and leaked memory.
> ---
>  lib/libdvbv5/dvb-file.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)


I suspect that you're using an older version of the git respository.
The patch didn't apply. After forcing it, the patch became the enclosed
change.

I suspect, however, that this will actually cause a core dump, as
get_program_and_store() is called with a NULL parameter for channel,
when !SDT.

Are you sure that such memory leak still happens with the current
version? I remember I tested it with valgrind and was unable to find
any case where a memory leak was happening.

For now, I'll be just applying this change on a separate patch:

-               r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
+               r = asprintf(&channel, "%.2f%cHz#%d", freq / 1000000.,
+                       dvb_fe_is_satellite(parms->p.current_sys) ? 'G' : 'M',
+                       service_id);

If you're still noticing this bug, please send a fix against the latest
upstream version.

Regards,
Mauro

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 479f47eda862..bbed60832e92 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1141,8 +1141,11 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 		if (!channel && entry->props[j].cmd == DTV_FREQUENCY)
 			freq = parms->dvb_prop[j].u.data;
 	}
-	if (!channel) {
-		r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
+	if (!*channel) {
+		free(channel);
+		r = asprintf(&channel, "%.2f%cHz#%d", freq / 1000000.,
+			dvb_fe_is_satellite(parms->p.current_sys) ? 'G' : 'M',
+			service_id);
 		if (r < 0)
 			dvb_perror("asprintf");
 		dvb_log("Storing Service ID %d: '%s'", service_id, channel);
@@ -1240,13 +1243,20 @@ int dvb_store_channel(struct dvb_file **dvb_file,
 			if (!warned) {
 				dvb_log("WARNING: no SDT table - storing channel(s) without their names");
 				warned = 1;
+
+			rc = asprintf(&channel, "#%d", service_id);
+			if (rc < 0) {
+				dvb_perror("asprintf");
+				return rc;
 			}
 
 			rc = get_program_and_store(parms, *dvb_file, dvb_scan_handler,
 						   service_id, NULL, NULL,
 						   get_detected, get_nit);
-			if (rc < 0)
+			if (rc < 0) {
+				free(channel);
 				return rc;
+			}
 		}
 
 		return 0;
