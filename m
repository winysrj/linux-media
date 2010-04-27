Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907Ab0D0VVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:21:21 -0400
Message-Id: <201004272111.o3RLBM13019988@imap1.linux-foundation.org>
Subject: [patch 04/11] drivers/media/video: avoid NULL dereference
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	julia@diku.dk, mmcclell@bigfoot.com
From: akpm@linux-foundation.org
Date: Tue, 27 Apr 2010 14:11:21 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

It seems impossible for ov to be NULL at this point.

The semantic match that finds the problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E, E1;
identifier f;
statement S1,S3;
iterator iter;
@@

if ((E == NULL && ...) || ...)
{
  ... when != false ((E == NULL && ...) || ...)
      when != true  ((E != NULL && ...) || ...)
      when != iter(E,...) S1
      when != E = E1
(
  sizeof(E->f)
|
* E->f
)
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mark McClelland <mmcclell@bigfoot.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ov511.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/media/video/ov511.c~drivers-media-video-avoid-null-dereference drivers/media/video/ov511.c
--- a/drivers/media/video/ov511.c~drivers-media-video-avoid-null-dereference
+++ a/drivers/media/video/ov511.c
@@ -5916,11 +5916,6 @@ ov51x_disconnect(struct usb_interface *i
 	mutex_lock(&ov->lock);
 	usb_set_intfdata (intf, NULL);
 
-	if (!ov) {
-		mutex_unlock(&ov->lock);
-		return;
-	}
-
 	/* Free device number */
 	ov511_devused &= ~(1 << ov->nr);
 
_
