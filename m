Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41823 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbcA1JEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:04:10 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 6/12] TW686x: Fix try_fmt() color space
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:04:08 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m337tidqif.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c5d8f28..c781b3c 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -379,6 +379,7 @@ static int tw686x_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.height = height;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * format->depth / 8;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
