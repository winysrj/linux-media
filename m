Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:43106 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZLVUbZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 15:31:25 -0500
Date: Tue, 22 Dec 2009 21:31:23 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 2/6] drivers/media/radio: Correct use after free
Message-ID: <Pine.LNX.4.64.0912222131000.28669@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

It is not clear how to share the unlock in the case where the structure
containing the lock has to be freed.  So the unlock is now duplicated, with
one copy moved before the free.  The unlock label furthermore is no longer
useful and is thus deleted.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
identifier f;
iterator I;
statement S;
@@

*kfree(x);
... when != &x
    when != x = e
    when != I(x,...) S
*x->f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/radio/si470x/radio-si470x-usb.c  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index a96e1b9..a0a79c7 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -590,8 +590,9 @@ int si470x_fops_release(struct file *file)
 			video_unregister_device(radio->videodev);
 			kfree(radio->int_in_buffer);
 			kfree(radio->buffer);
+			mutex_unlock(&radio->disconnect_lock);
 			kfree(radio);
-			goto unlock;
+			goto done;
 		}
 
 		/* cancel read processes */
@@ -601,7 +602,6 @@ int si470x_fops_release(struct file *file)
 		retval = si470x_stop(radio);
 		usb_autopm_put_interface(radio->intf);
 	}
-unlock:
 	mutex_unlock(&radio->disconnect_lock);
 done:
 	return retval;
