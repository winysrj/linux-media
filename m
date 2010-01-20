Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:58087 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0ATRTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 12:19:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
Date: Wed, 20 Jan 2010 18:19:32 +0100
Message-Id: <1264007972-6261-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When both remote controller and receiver intfs are handled by
af9015, .probe do nothing for remote intf, but when .disconnect
is called for both of them it touches intfdata every time. For
remote it crashes obviously (as intfdata are unset).

Altough there is test against data being NULL, it is not enough.
It is because someone before us does not set intf drvdata to
NULL. (In this case the hid layer.) But we cannot rely on intf
being NULL anyway.

Fix that by checking bInterfaceNumber in af9015_usb_device_exit
and do actually nothing if it is not 0.

The crash in question:
BUG: unable to handle kernel paging request at 00000000000700c5
IP: [<ffffffffa005f4f9>] dvb_usb_device_exit+0x39/0x60 [dvb_usb]
PGD 192344067 PUD 1921ba067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
CPU 1
Pid: 10515, comm: rmmod Not tainted 2.6.33-rc4-mm1_64 #930 To be filled by O.E.M./To Be Filled By O.E.M.
RIP: 0010:[<ffffffffa005f4f9>]  [<ffffffffa005f4f9>] dvb_usb_device_exit+0x39/0x60 [dvb_usb]
RSP: 0018:ffff88018066bd48  EFLAGS: 00010206
RAX: 00000000000700c5 RBX: ffffffffa0061c8a RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801cab599e0
RBP: ffff88018066bd58 R08: 0000000000000001 R09: 000000000046dd74
R10: 0000000000000005 R11: 0000000000000064 R12: ffff8801caa14090
R13: ffff8801ca886360 R14: ffffffffa00a8668 R15: 0000000000000000
FS:  00007fe2ec1566f0(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000700c5 CR3: 00000001b126e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 10515, threadinfo ffff88018066a000, task ffff88019f1eb880)
Stack:
 ffff8801cab599b0 ffff8801cab599b0 ffff88018066bd78 ffffffffa00a604c
<0> ffff8801ca886360 ffff8801cab599e0 ffff88018066bdc8 ffffffff812fd844
<0> ffffffffa00a8668 ffffffffa00a8600 ffffffffa00a8668 ffff8801cab599e0
Call Trace:
 [<ffffffffa00a604c>] af9015_usb_device_exit+0x3c/0x60 [dvb_usb_af9015]
 [<ffffffff812fd844>] usb_unbind_interface+0x124/0x170
...
Code: e8 8d 4b 22 e1 31 f6 49 89 c4 48 89 df 48 c7 c3 8a 1c 06 a0 e8 a9 4b 22 e1 4d 85 e4 74 18 49 8b 84 24 c0 0c 00 00 48 85 c0 74 0b <48> 8b 18 4c 89 e7 e8 ec fe ff ff 48 89 de 48 c7 c7 40 14 06 a0
RIP  [<ffffffffa005f4f9>] dvb_usb_device_exit+0x39/0x60 [dvb_usb]
 RSP <ffff88018066bd48>
CR2: 00000000000700c5
---[ end trace f25ee66d2135f162 ]---

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/af9015.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index f0d5731..bd20945 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1661,6 +1661,10 @@ static void af9015_usb_device_exit(struct usb_interface *intf)
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	deb_info("%s: \n", __func__);
 
+	/* we do nothing for remote controller interface */
+	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
+		return;
+
 	/* remove 2nd I2C adapter */
 	if (d != NULL && d->desc != NULL)
 		af9015_i2c_exit(d);
-- 
1.6.5.7

