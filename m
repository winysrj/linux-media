Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58292 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbcHFUee (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2016 16:34:34 -0400
Received: from acerpc.lan ([84.163.206.196]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MGSgq-1bRmic3cye-00DEit for
 <linux-media@vger.kernel.org>; Sat, 06 Aug 2016 22:34:30 +0200
From: Georg Wild <georg.wild@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Segfault in dvbv5-scan
Date: Sat, 06 Aug 2016 22:34:30 +0200
Message-ID: <4767396.pAn5xf8Txs@acerpc.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently got segmentation faults when using dvbv5-scan (dvbv5-scan 
-l UNIVERSAL -S1 /usr/share/dvbv5/dvb-s/Astra-19.2E).

I found out that this happened due to (d->length < len) in int isdbt_desc_delivery_init for some transponder, which results in irrealistic d->num_freqs. I did not trace back why this happens, but suggest the patch below to get at least rid of the segfault.

Additionally I found a memory leak:
1. dvb-dev.c, dvb_dev_alloc: dvb is alloc'd, dvb->d is returned, the rest is never freed.


Regards
Georg



---------------- lib/libdvbv5/descriptors/desc_isdbt_delivery.c ----------------
index 4a0f294..6623ca4 100644
@@ -36,7 +36,12 @@ int isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms,
 
 	bswap16(d->bitfield);
 
-	d->num_freqs = (d->length - len)/ sizeof(uint16_t);
+	if (d->length < len) {
+		dvb_perror("d->length>len!!");
+		d->num_freqs=0;
+	}
+	else
+	  d->num_freqs = (d->length - len)/ sizeof(uint16_t);
 	if (!d->num_freqs)
 		return 0;
 	d->frequency = malloc(d->num_freqs * sizeof(*d->frequency));

--------------------------- lib/libdvbv5/dvb-file.c ---------------------------
index 33481e5..169c0b5 100644
@@ -1274,6 +1274,7 @@ int dvb_store_channel(struct dvb_file **dvb_file,
 			return 0;
 	}
 
+	if (dvb_scan_handler->sdt->service)
 	dvb_sdt_service_foreach(service, dvb_scan_handler->sdt) {
 		char *channel = NULL;
 		char *vchannel = NULL;


