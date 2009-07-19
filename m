Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbZGSNu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 09:50:58 -0400
Date: Sun, 19 Jul 2009 10:50:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: acano@fastmail.fm
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx i2s volume control
Message-ID: <20090719105049.0cb1690c@pedra.chehab.org>
In-Reply-To: <20090718182251.GA974@localhost.localdomain>
References: <20090718182251.GA974@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 18 Jul 2009 14:22:51 -0400
acano@fastmail.fm escreveu:

> How do you control the i2s volume output on empia boards?

the em28xx chip doesn't control volume. This is done at the audio chip. 

For ac97 chips, the volume is inside the em28xx driver, since we don't have a
v4l2 device driver for it yet.

On the cases where the volume is on an i2s chips like msp34xx, the volume
control is done at the i2c driver, that should be exporting such controls via
v4l2 dev/subdev API, by calling:
	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);

This way, any application can control the volume via the proper ioctl's.

While trying to see why are you asking this, I noticed that the em28xx driver,
due to historic reasons, had an implementation that may cause confusion.

I just add there two patches that will make it clearer.

There aren't any functional changes with those patches (I tested here on
devices with msp34xx and with ac202 ac97), except for the fact that now the
qv4l2 will show the volume as a slider.



Cheers,
Mauro
