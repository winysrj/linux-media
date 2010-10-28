Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39205 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab0J1RKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 13:10:45 -0400
Received: by yxk8 with SMTP id 8so1060188yxk.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 10:10:44 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Oct 2010 18:10:44 +0100
Message-ID: <AANLkTikKrB_PckALLnoX=g2Fm8X1jVRjCCYYB8xD_yBp@mail.gmail.com>
Subject: via-camera crash on unload (but possibly a wider v4l2 issue)
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I can reproduce a crash on via-camera module unload. Running latest
linux-next. Simple modprobe then rmmod reproduces it.
I guess cafe_ccic is affected too.

BUG: unable to handle kernel paging request at 6b6b6b6b
IP: device_del

I've diagnosed it, but don't know the solution.

viacam_remove() calls v4l2_device_unregister()

v4l2_device_unregister() starts to unregister all the subdevs
	list_for_each_entry_safe(sd, next, &v4l2_dev->subdevs, list) {
		v4l2_device_unregister_subdev(sd);

So the subdev has been unregistered.
Still inside v4l2_device_unregister, it then realises its an i2c
subdev and unregisters it at the i2c layer:

		if (sd->flags & V4L2_SUBDEV_FL_IS_I2C) {
...
				i2c_unregister_device(client);

i2c_unregister_device() calls device_unregister()
...which calls device_del()
...which calls bus_remove_device()
...which calls device_release_driver()
...which calls __device_release_driver()
...which calls i2c_device_remove()
...which calls ov7670_remove()

This is where the badness starts.

ov7670_remove() calls v4l2_device_unregister_subdev *on the same
subdev that was released above*. Can't lead to good things.
ov7670_remove() then frees its ov7670_info structure (which contains
the v4l2_subdev structure) (eek)

then v4l2_device_unregister() continues, and it checks:
		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
sd->flags is now freed, so it reads 6b6b6b6b, so we go on:
				spi_unregister_device(spi);

and this calls device_unregister() on more of our freed memory
and now things have gone wrong enough for a BUG() to happen

Thoughts?

Daniel
