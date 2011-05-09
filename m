Return-path: <mchehab@gaivota>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:44930 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536Ab1EITyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:15 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 12/16] tm6000: all audio packets must swab
Date: Mon,  9 May 2011 21:54:00 +0200
Message-Id: <1304970844-20955-12-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

all audio packets must swab


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index a9a5919..ea5ad6c 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -344,17 +344,14 @@ static int copy_streams(u8 *data, unsigned long len,
 				if (vbuf)
 					memcpy(&voutp[pos], ptr, cpysize);
 				break;
-			case TM6000_URB_MSG_AUDIO:
-				/* Need some code to copy audio buffer */
-				if (dev->fourcc == V4L2_PIX_FMT_YUYV) {
-					/* Swap word bytes */
-					int i;
+			case TM6000_URB_MSG_AUDIO: {
+				int i;
+				for (i = 0; i < cpysize; i += 2)
+					swab16s((u16 *)(ptr + i));
 
-					for (i = 0; i < cpysize; i += 2)
-						swab16s((u16 *)(ptr + i));
-				}
 				tm6000_call_fillbuf(dev, TM6000_AUDIO, ptr, cpysize);
 				break;
+			}
 			case TM6000_URB_MSG_VBI:
 				/* Need some code to copy vbi buffer */
 				break;
-- 
1.7.4.2

