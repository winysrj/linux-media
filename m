Return-path: <linux-media-owner@vger.kernel.org>
Received: from aotearoadigitalarts.org.nz ([72.14.179.101]:58694 "EHLO
	linode.halo.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2FYABB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 20:01:01 -0400
Received: from 203-97-236-46.cable.telstraclear.net ([203.97.236.46] helo=[192.168.1.42])
	by linode.halo.gen.nz with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <douglas@paradise.net.nz>)
	id 1SiwP2-0004HJ-Uf
	for linux-media@vger.kernel.org; Mon, 25 Jun 2012 11:39:37 +1200
Message-ID: <4FE7AA34.8090304@paradise.net.nz>
Date: Mon, 25 Jun 2012 12:00:52 +1200
From: Douglas Bagnall <douglas@paradise.net.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Avoid sysfs oops when an rc_dev's raw device is absent
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some reason, when the lirc daemon learns that a usb remote control
has been unplugged, it wants to read the sysfs attributes of the
disappearing device. This is useful for uncovering transient
inconsistencies, but less so for keeping the system running when such
inconsistencies exist.

Under some circumstances (like every time I unplug my dvb stick from
my laptop), lirc catches an rc_dev whose raw event handler has been
removed (presumably by ir_raw_event_unregister), and proceeds to
interrogate the raw protocols supported by the NULL pointer.

This patch avoids the NULL dereference, and ignores the issue of how
this state of affairs came about in the first place.
---
 drivers/media/rc/rc-main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6e16b09..58789c9 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -775,10 +775,12 @@ static ssize_t show_protocols(struct device *device,
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = dev->rc_map.rc_type;
 		allowed = dev->allowed_protos;
-	} else {
+	} else if (dev->raw) {
 		enabled = dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
 	}
+	else
+		return -EINVAL;
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
-- 
1.7.9.5

