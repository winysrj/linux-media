Return-path: <mchehab@pedra>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab0JAVOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 17:14:16 -0400
Message-Id: <201010012113.o91LDfOS020980@imap1.linux-foundation.org>
Subject: [patch 2/2] drivers/media/video/cx23885/cx23885-core.c: fix cx23885_dev_checkrevision()
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	i2g2r2@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 01 Oct 2010 14:13:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrew Morton <akpm@linux-foundation.org>

It was missing the `break'.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=18672

Reported-by: Igor <i2g2r2@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx23885/cx23885-core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/cx23885/cx23885-core.c~drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision drivers/media/video/cx23885/cx23885-core.c
--- a/drivers/media/video/cx23885/cx23885-core.c~drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision
+++ a/drivers/media/video/cx23885/cx23885-core.c
@@ -815,6 +815,7 @@ static void cx23885_dev_checkrevision(st
 	case 0x0e:
 		/* CX23887-15Z */
 		dev->hwrevision = 0xc0;
+		break;
 	case 0x0f:
 		/* CX23887-14Z */
 		dev->hwrevision = 0xb1;
_
