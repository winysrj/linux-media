Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1HEUll (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2011 16:41:41 -0400
Message-ID: <4E3C557A.2060103@redhat.com>
Date: Fri, 05 Aug 2011 17:41:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"'Doug Anderson'" <dianders@google.com>
Subject: Re: Guidance regarding deferred I2C transactions
References: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D0@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D0@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-08-2011 17:18, Andrew Chew escreveu:
> I'm looking for some guidance regarding a clean way to support a certain camera module. 
> We are using the soc_camera framework, and in particular, the ov9740.c image sensor driver. 
> 
> This camera module has the camera activity status LED tied to the image sensor's power. 
> This is meant as a security feature, so that there is no way to turn the camera on without 
> the user being informed through the status LED.
> 
> The problem with this is that any I2C transaction to the image sensor necessitates turning 
> the image sensor on, which results in the status LED turning on. Various methods in the soc 
> camera sensor drivers typically perform I2C transactions. For example, probe will check the image 
> sensor registers to validate device presence. However, this results in the LED blinking during probe,
> which can be misconstrued as the camera having taken an actual picture. Opening the /dev/video node
> will also typically blink the status LED for similar reasons (in this case, calling the s_mbus_fmt 
> video op), so any application probing for camera presence will cause the status LED to blink. 
> 
> One way to solve this can be to defer these I2C transactions in the image sensor driver all the way up 
> to the time the image sensor is asked to start streaming frames. However, it seems to me that this breaks 
> the spirit of the probe; applications will successfully probe for camera presence even though the camera 
> isn't actually there. Is this okay?
> 
> Is there a better way to do this? Maybe a more general thing we can add to the V4L2 framework?

Probing for the presence of the device hardware at driver init time seems 
to be the right thing to do, even when the LED blinks. PC keyboard LEDs
also blinks during machine reset, and this is not really annoying. Even
on some embedded devices like some cell phones, LEDs blink during the boot
time.

So, as a general rule, I'd say that the better is to keep the capability of 
probing the hardware at init time, especially since the same sensor may
eventually be used by non SoC drivers.

One strategy that several drivers do, and that solves the issue of blinking
after the device reset is to have a shadow copy of the register contents.
This way, you can defer the device register writes to occur only when you're
actually streaming. E. g. you'll still have the blink at probe time (probably
a longer one), but, after that, the driver can just work with the cached
values, up to the moment it will really start streaming.

Would that strategy work for you?

Regards,
Mauro
