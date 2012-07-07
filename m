Return-path: <linux-media-owner@vger.kernel.org>
Received: from aotearoadigitalarts.org.nz ([72.14.179.101]:57872 "EHLO
	linode.halo.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2GGD2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 23:28:08 -0400
Message-ID: <4FF7ACBD.1040609@paradise.net.nz>
Date: Sat, 07 Jul 2012 15:27:57 +1200
From: Douglas Bagnall <douglas@paradise.net.nz>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Avoid sysfs oops when an rc_dev's raw device is absent
References: <4FE7AA34.8090304@paradise.net.nz> <4FF64C60.1070804@redhat.com>
In-Reply-To: <4FF64C60.1070804@redhat.com>
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

Version 2 incorporates changes recommended by Mauro Carvalho Chehab
(-ENODEV instead of -EINVAL, and a signed-off-by).

Signed-off-by: Douglas Bagnall <douglas@paradise.net.nz>
---
 drivers/media/rc/rc-main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6e16b09..9880926 100644
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
+		return -ENODEV;
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
