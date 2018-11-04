Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38346 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbeKEGOL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 01:14:11 -0500
Received: by mail-ed1-f67.google.com with SMTP id a2-v6so1261066edi.5
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2018 12:57:52 -0800 (PST)
Date: Sun, 4 Nov 2018 21:57:46 +0100
From: Benjamin Valentin <benpicco@googlemail.com>
To: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [RFC] [PATCH] media: rc: Improve responsiveness of Xbox DVD Remote
Message-ID: <20181104215746.113942a9@rechenknecht2k11>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Xbox DVD Remote feels somewhat sluggish, pressing a button
repeatedly is sometimes interpreted as it being kept pressed down.

It seems like the RC subsystem is doing some incorrect heuristics when
in fact the data that comes from the device is already pretty clean.

When looking at rc_keydown(), the timeout parameter for a keypress
seems to be relevant here.

And indeed changing it from the default value of 125000000 to something
lower improves situation greatly.
I'm not sure what the 'correct' value is here - even just setting it to
0 works fine and might even be the proper thing to do as the receiver
dongle seems to do some filtering on it's own?

---
 drivers/media/rc/xbox_remote.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/xbox_remote.c b/drivers/media/rc/xbox_remote.c
index 07ed9be24a60..496f1394216d 100644
--- a/drivers/media/rc/xbox_remote.c
+++ b/drivers/media/rc/xbox_remote.c
@@ -157,6 +157,8 @@ static void xbox_remote_rc_init(struct xbox_remote *xbox_remote)
 	rdev->device_name = xbox_remote->rc_name;
 	rdev->input_phys = xbox_remote->rc_phys;
 
+	rdev->timeout = 1000;
+
 	usb_to_input_id(xbox_remote->udev, &rdev->input_id);
 	rdev->dev.parent = &xbox_remote->interface->dev;
 }
