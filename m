Return-path: <mchehab@pedra>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:44893
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454Ab0IONDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 09:03:01 -0400
Message-ID: <4C90C2A6.1010408@xyzw.org>
Date: Wed, 15 Sep 2010 05:57:10 -0700
From: Brian Rogers <brian@xyzw.org>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	jarod@wilsonet.com, linux-media@vger.kernel.org,
	mchehab@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH] ir-core: Fix null dereferences in the protocols sysfs interface
References: <20100613202718.6044.29599.stgit@localhost.localdomain> <20100613202930.6044.97940.stgit@localhost.localdomain> <4C8797D3.1060606@xyzw.org> <20100908141613.GB22323@redhat.com>
In-Reply-To: <20100908141613.GB22323@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010806040809040904040502"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010806040809040904040502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

  On 09/08/2010 07:16 AM, Jarod Wilson wrote:
> On Wed, Sep 08, 2010 at 07:04:03AM -0700, Brian Rogers wrote:
>> ir_dev->raw is also null. If I check these pointers before using
>> them, and bail out if both are null, then I get a working lircd, but
>> of course the file /sys/devices/virtual/rc/rc0/protocols no longer
>> does anything. On 2.6.35.4, the system never creates the
>> /sys/class/rc/rc0/current_protocol file. Is it the case that the
>> 'protocols' file should never appear, because my card can't support
>> this feature?
> Hm... So protocols is indeed intended for hardware that handles raw IR, as
> its a list of raw IR decoders available/enabled/disabled for the receiver.
> But some devices that do onboard decoding and deal with scancodes still
> need to support changing protocols, as they can be told "decode rc5" or
> "decode nec", etc... My memory is currently foggy on how it was exactly
> that it was supposed to be donee though. :) (Yet another reason I really
> need to poke at the imon driver code again).

How about the attached patch? Does this look like a reasonable solution 
for 2.6.36?

Brian


--------------010806040809040904040502
Content-Type: text/x-patch;
 name="0001-ir-core-Fix-null-dereferences-in-the-protocols-sysfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ir-core-Fix-null-dereferences-in-the-protocols-sysfs.pa";
 filename*1="tch"

>From 7937051c5e2c8b5b0410172d48e62d54bd1906ee Mon Sep 17 00:00:00 2001
From: Brian Rogers <brian@xyzw.org>
Date: Wed, 8 Sep 2010 05:33:34 -0700
Subject: [PATCH] ir-core: Fix null dereferences in the protocols sysfs interface

For some cards, ir_dev->props and ir_dev->raw are both NULL. These cards are
using built-in IR decoding instead of raw, and can't easily be made to switch
protocols.

So upon reading /sys/class/rc/rc?/protocols on such a card, return 'builtin' as
the supported and enabled protocol. Return -EINVAL on any attempts to change
the protocol. And most important of all, don't crash.

Signed-off-by: Brian Rogers <brian@xyzw.org>
---
 drivers/media/IR/ir-sysfs.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 96dafc4..46d4246 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -67,13 +67,14 @@ static ssize_t show_protocols(struct device *d,
 	char *tmp = buf;
 	int i;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = ir_dev->rc_tab.ir_type;
 		allowed = ir_dev->props->allowed_protos;
-	} else {
+	} else if (ir_dev->raw) {
 		enabled = ir_dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
-	}
+	} else
+		return sprintf(tmp, "[builtin]\n");
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
@@ -121,10 +122,14 @@ static ssize_t store_protocols(struct device *d,
 	int rc, i, count = 0;
 	unsigned long flags;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
 		type = ir_dev->rc_tab.ir_type;
-	else
+	else if (ir_dev->raw)
 		type = ir_dev->raw->enabled_protocols;
+	else {
+		IR_dprintk(1, "Protocol switching not supported\n");
+		return -EINVAL;
+	}
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -185,7 +190,7 @@ static ssize_t store_protocols(struct device *d,
 		}
 	}
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
 		ir_dev->rc_tab.ir_type = type;
 		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
-- 
1.7.1


--------------010806040809040904040502--
