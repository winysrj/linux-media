Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.clear.net.nz ([203.97.33.64]:40967 "EHLO
	smtp3.clear.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab2HGWFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 18:05:17 -0400
Date: Wed, 08 Aug 2012 10:05:10 +1200
From: Douglas Bagnall <douglas@paradise.net.nz>
Subject: [PATCH] [media] Unlock the rc_dev lock when the raw device is missing
In-reply-to: <20120807161013.GC3922@herton-Z68MA-D2H-B3>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Message-id: <50219116.6070103@paradise.net.nz>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------010307000605070405010405
References: <20120806173851.GE2979@herton-Z68MA-D2H-B3>
 <1344304698.13142.154.camel@deadeye.wl.decadent.org.uk>
 <5020CAB4.2080607@paradise.net.nz> <20120807161013.GC3922@herton-Z68MA-D2H-B3>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010307000605070405010405
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/08/12 04:10, Herton Ronaldo Krzesinski wrote:
> As it's desired for stable, this could also have
> "Cc: stable@vger.kernel.org" when applied, so it's picked up
> "automatically" when lands in mainline. Also nitpicking some more,
> may be the patch could have a Reported-by line added.

OK. Here it is again, with CC: stable, Reported-by Ben, and Herton's
Acked-by.

thanks,

Douglas


--------------010307000605070405010405
Content-Type: text/x-patch;
 name="0001-Unlock-the-rc_dev-lock-when-the-raw-device-is-missin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Unlock-the-rc_dev-lock-when-the-raw-device-is-missin.pa";
 filename*1="tch"

>From 47aadfdaa5a6e5c3d8f1bf2b5be4c4a4156085ee Mon Sep 17 00:00:00 2001
From: Douglas Bagnall <douglas@paradise.net.nz>
Date: Tue, 7 Aug 2012 19:30:36 +1200
Subject: [PATCH] Unlock the rc_dev lock when the raw device is missing

As pointed out by Ben Hutchings, after commit 720bb6436, the lock was
being taken and not released when an rc_dev has a NULL raw device.

Cc: <stable@vger.kernel.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Douglas Bagnall <douglas@paradise.net.nz>
Acked-by: Herton R. Krzesinski <herton.krzesinski@canonical.com>
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



--------------010307000605070405010405--
