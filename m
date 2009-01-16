Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZAPBg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 20:36:29 -0500
Received: from 200.220.139.66.nipcable.com ([200.220.139.66] helo=pedra.chehab.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1LNddM-0002Xv-8G
	for linux-media@vger.kernel.org; Fri, 16 Jan 2009 01:36:28 +0000
Date: Thu, 15 Jan 2009 23:35:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-media@vger.kernel.org
Subject: Fw: [PATCH] E506r-composite-input
Message-ID: <20090115233528.7f458d34@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/hOIpbqWD2OjgyesOMB8aYpc"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/hOIpbqWD2OjgyesOMB8aYpc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Message sent to the wrong address... it is not *-owner ;)

Forwarded message:

Date: Thu, 15 Jan 2009 21:58:55 +0900
From: Tim Farrington <timf@iinet.net.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,  linux-media-owner@vger.kernel.org
Subject: [PATCH] E506r-composite-input


Make correction to composite input plus svideo input
to Avermedia E506R

Signed-off-by: Tim Farrington timf@iinet.net.au







Cheers,
Mauro

--MP_/hOIpbqWD2OjgyesOMB8aYpc
Content-Type: text/x-patch; name=E506r_composite.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=E506r_composite.patch

Only in .: E506r_composite.patch
diff -upr ./linux/drivers/media/video/saa7134/saa7134-cards.c ../a/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
--- ./linux/drivers/media/video/saa7134/saa7134-cards.c	2009-01-15 21:42:05.000000000 +0900
+++ ../a/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-01-15 21:45:29.000000000 +0900
@@ -4362,13 +4362,13 @@ struct saa7134_board saa7134_boards[] = 
 			 .amux = TV,
 			 .tv   = 1,
 		 }, {
-			 .name = name_comp,
-			 .vmux = 0,
+			 .name = name_comp1,
+			 .vmux = 3,
 			 .amux = LINE1,
 		 }, {
 			 .name = name_svideo,
 			 .vmux = 8,
-			 .amux = LINE1,
+			 .amux = LINE2,
 		 } },
 		 .radio = {
 			 .name = name_radio,

--MP_/hOIpbqWD2OjgyesOMB8aYpc--
