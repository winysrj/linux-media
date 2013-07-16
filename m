Return-path: <linux-media-owner@vger.kernel.org>
Received: from belief.htu.tuwien.ac.at ([128.131.95.14]:33919 "EHLO
	belief.htu.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387Ab3GPW06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 18:26:58 -0400
Date: Wed, 17 Jul 2013 00:04:18 +0200
From: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
To: linux-media@vger.kernel.org
Subject: Possible problem with stk1160 driver
Message-ID: <20130716220418.GC10973@deadlock.dhs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am not quite sure if the problem is in the driver or if the user space
applications are doing something in a weird or wrong way, I hope you can
help me.

I have one of those easycap 4x-input devices with a Syntek chip:
Bus 001 Device 002: ID 05e1:0408 Syntek Semiconductor Co., Ltd STK1160 Video Capture Device

I'm on 3.9.9-201.fc18.i686.PAE kernel, using the stk1160 driver.

It generally works fine, I can, for example, open the video device using VLC,
select one of the inputs and get the picture.

However, programs like motion or zoneminder fail, I am not quite sure if it
is something that they might be doing or if it is a problem in the driver.

Basically, for both of the above, the problem is that VIDIOC_S_INPUT fails
with EBUSY.

I do not see any errors in the message log, only:
Jul 16 21:27:24 localhost kernel: [ 9477.574448] stk1160: queue_setup: buffer
+count 8, each 829440 bytes
Jul 16 21:27:24 localhost kernel: [ 9477.595667] stk1160: setting alternate 5

I somewhat assume that it works with VLC because when switching the input you
more or less "open a new device", while zoneminder/motion might try to
change the input while actually streaming.

I'd appreciate any help or hint, also in case if you think that it's not the
driver issue, maybe you have an idea what I should be looking for (i.e.
what other operations might cause the VIDIOC_S_INPUT ioctl to fail?).

Kind regards,
Sergey

