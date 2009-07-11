Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:48467 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZGKLCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2009 07:02:54 -0400
Received: by qyk31 with SMTP id 31so1211812qyk.33
        for <linux-media@vger.kernel.org>; Sat, 11 Jul 2009 04:02:53 -0700 (PDT)
MIME-Version: 1.0
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Sat, 11 Jul 2009 20:02:33 +0900
Message-ID: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
Subject: About v4l2 subdev s_config (for core) API?
To: v4l2_linux <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The thing is - Is it possible to make the subdev device not to be
turned on in registering process using any of v4l2_i2c_new_subdev*** ?
You can say that I can ignore the i2c errors in booting process, but I
think it is not a pretty way.

And for the reason I'm asking you about this, I need you to consider
following conditions I carry.

1. ARM embedded platform especially mobile handset.
2. Mass production which is very concerned about power consumption.
3. Strict and automated test process in product line.

So, what I want to ask you is about s_config subdev call which is
called from every single I2C subdev load in some kind of probe
procedure. As s_config is supposed to do, it tries to initialize
subdev device. which means it needs to turn on the subdev to make that
initialized.

But as I mentioned above if we make the product go through the product
line, it turns on the subdev device even though nobody intended to
turn the subdev on. It might be an issue in product vendor's point of
view, because there should be a crystal clear reason for the
consumption of power the subdev made. I'm working on camera device and
speaking of which, camera devices are really power consuming device
and some camera devices even take ages to be initialized as well.

So far I hope I made a good explanation about why I'm asking you about
following question.
By the way, it seems to be similar to the issue I've faced whe using
old i2c driver model..I mean probing i2c devices on boot up sequence.
Cheers,

Nate


-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
