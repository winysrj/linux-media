Return-path: <mchehab@gaivota>
Received: from mail.sfc.wide.ad.jp ([203.178.142.146]:44323 "EHLO
	mail.sfc.wide.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0LXFqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 00:46:49 -0500
Message-ID: <4D14325E.9000505@sfc.wide.ad.jp>
Date: Fri, 24 Dec 2010 14:40:46 +0900
From: Ang Way Chuang <wcang@sfc.wide.ad.jp>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Achmad Husni Thamrin <husni@ai3.net>
Subject: [PATCH] cx88-dvb.c: DVB net latency using Hauppauge HVR4000
Content-Type: multipart/mixed;
 boundary="------------040808050207080202040004"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------040808050207080202040004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi linux-media developers,
     We are from School On Internet Asia (SOI Asia) project that uses satellite communication to deliver educational content.
We used Hauppauge HVR 4000 to carry IP traffic over ULE. However, there is an issue with high latency jitter. My boss, Husni,
identified the problem and provided a patch for this problem. We have tested this patch since kernel 2.6.30 on our partner
sites and it hasn't cause any issue. The default buffer size of 32 TS frames on cx88 causes the high latency, so our deployment
changes that to 6 TS frames. This patch made the buffer size tunable, while keeping the default buffer size of 32 TS frames
unchanged. Sorry, I have to use attachment for the patch. I couldn't figure out how to copy and paste the patch without
converting the tab to spaces in thunderbird.

Signed-off-by: Achmad Husni Thamrin <husni@ai3.net>


--------------040808050207080202040004
Content-Type: text/x-patch;
 name="cx88-buffer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx88-buffer.patch"

diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 367a653..90717ee 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -67,6 +67,10 @@ static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug,"enable debug messages [dvb]");
 
+static unsigned int dvb_buf_tscnt = 32;
+module_param(dvb_buf_tscnt, int, 0644);
+MODULE_PARM_DESC(dvb_buf_tscnt, "DVB Buffer TS count [dvb]");
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk(level,fmt, arg...)	if (debug >= level) \
@@ -80,10 +84,10 @@ static int dvb_buf_setup(struct videobuf_queue *q,
 	struct cx8802_dev *dev = q->priv_data;
 
 	dev->ts_packet_size  = 188 * 4;
-	dev->ts_packet_count = 32;
+	dev->ts_packet_count = dvb_buf_tscnt;
 
 	*size  = dev->ts_packet_size * dev->ts_packet_count;
-	*count = 32;
+	*count = dvb_buf_tscnt;
 	return 0;
 }
 

--------------040808050207080202040004--
