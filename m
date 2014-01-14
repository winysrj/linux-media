Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25094 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaANK3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 05:29:17 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZD00MEWZSRRL40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jan 2014 10:29:15 +0000 (GMT)
Message-id: <52D51179.8030102@samsung.com>
Date: Tue, 14 Jan 2014 11:29:13 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: randy <lxr1234@hotmail.com>, Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com
Subject: Re: using MFC memory to memery encoder,
 start stream and queue order problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl>
 <02c701cf07b6$565cd340$031679c0$%debski@samsung.com>
 <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl>
 <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
 <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl>
 <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com>
 <52CD725E.5060903@hotmail.com> <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl>
 <52CFD5DF.6050801@samsung.com> <BLU0-SMTP37B0A51F0A2D2F1E79A730ADB30@phx.gbl>
 <52D3BCB7.1060309@samsung.com> <52D3CB84.6090406@samsung.com>
 <BLU0-SMTP3546CDA7E88F73435A3A876ADBC0@phx.gbl>
 <001701cf107b$0927aa50$1b76fef0$%debski@samsung.com>
 <BLU0-SMTP183F0EEECCB365900DE2315ADBF0@phx.gbl>
In-reply-to: <BLU0-SMTP183F0EEECCB365900DE2315ADBF0@phx.gbl>
Content-type: multipart/mixed; boundary=------------000602010600090002030800
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000602010600090002030800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/14/2014 06:17 AM, randy wrote:
> Yes, it make encoder work. But sadness ./mfc-encode -m /dev/video1 -c
> h264,header_mode=1 -d 1 will still output a zero demo.out without
> header-mode or set it to zero will works.
> What is the problem?

It seems infradead repo is not synchronized with our internal repo.
Please apply attached patch.

Regards
Andrzej


--------------000602010600090002030800
Content-Type: text/x-patch;
 name="0001-Do-not-stop-encoding-after-empty-buffers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Do-not-stop-encoding-after-empty-buffers.patch"

>From bccf89a62a2e45cd45f4bf5d4adff9ec8a16b3bd Mon Sep 17 00:00:00 2001
From: Andrzej Hajda <a.hajda@samsung.com>
Date: Mon, 20 May 2013 09:24:23 +0200
Subject: [PATCH] Do not stop encoding after empty buffers

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 v4l2-mfc-encoder/func_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/v4l2-mfc-encoder/func_dev.c b/v4l2-mfc-encoder/func_dev.c
index c3fff54..3cddef1 100644
--- a/v4l2-mfc-encoder/func_dev.c
+++ b/v4l2-mfc-encoder/func_dev.c
@@ -76,13 +76,13 @@ int func_deq_buf(struct io_dev *dev, enum io_dir dir)
 	for (i = 0; i < bufs->nplanes; ++i)
 		bufs->bytesused[bufs->nplanes * idx + i] = lens[i];
 
-	dbg("Dequeued buffer %d/%d from %d:%d", idx, bufs->count, dev->fd, dir);
+	dbg("Dequeued buffer %d/%d from %d:%d ret=%d", idx, bufs->count, dev->fd, dir, ret);
 
 	--dev->io[dir].nbufs;
 
 	++dev->io[dir].counter;
 
-	if (ret <= 0 || (dev->io[dir].limit &&
+	if (ret < 0 || (dev->io[dir].limit &&
 				dev->io[dir].limit <= dev->io[dir].counter)) {
 		dev->io[dir].state = FS_END;
 		dbg("End on %d:%d", dev->fd, dir);
-- 
1.8.3.2


--------------000602010600090002030800--
