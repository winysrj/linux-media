Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.clear.net.nz ([203.97.33.68]:40245 "EHLO
	smtp5.clear.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2HGINs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 04:13:48 -0400
Date: Tue, 07 Aug 2012 19:58:44 +1200
From: Douglas Bagnall <douglas@paradise.net.nz>
Subject: Re: [3.0.y+] [media] Avoid sysfs oops when an rc_dev's raw device is
 absent
In-reply-to: <1344304698.13142.154.camel@deadeye.wl.decadent.org.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
	Douglas Bagnall <douglas@paradise.net.nz>,
	stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Message-id: <5020CAB4.2080607@paradise.net.nz>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------050303030701010907060103
References: <20120806173851.GE2979@herton-Z68MA-D2H-B3>
 <1344304698.13142.154.camel@deadeye.wl.decadent.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050303030701010907060103
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ben Hutchings wrote: 
> This returns without unlocking dev->lock, which isn't much of an
> improvement.  Please get that fixed in mainline, and then I can apply
> both of the changes to 3.2.y at once.

Oh dear. Quite right. Sorry. Thanks.

Douglas

--------------050303030701010907060103
Content-Type: text/x-patch;
 name="0001-Unlock-the-rc_dev-lock-when-the-raw-device-is-missin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Unlock-the-rc_dev-lock-when-the-raw-device-is-missin.pa";
 filename*1="tch"

>From c1d4df58efb2d13551586d177bcbb4e9af588618 Mon Sep 17 00:00:00 2001
From: Douglas Bagnall <douglas@paradise.net.nz>
Date: Tue, 7 Aug 2012 19:30:36 +1200
Subject: [PATCH] Unlock the rc_dev lock when the raw device is missing

As pointed out by Ben Hutchings, after commit 720bb6436, the lock was
being taken and not released when an rc_dev has a NULL raw device.

Signed-off-by: Douglas Bagnall <douglas@paradise.net.nz>
---
 drivers/media/rc/rc-main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index cabc19c..dcd45d0 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -778,9 +778,10 @@ static ssize_t show_protocols(struct device *device,
 	} else if (dev->raw) {
 		enabled = dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
-	} else
+	} else {
+		mutex_unlock(&dev->lock);
 		return -ENODEV;
-
+	}
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
 		   (long long)enabled);
-- 
1.7.9.5


--------------050303030701010907060103--
