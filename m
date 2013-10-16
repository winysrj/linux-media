Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240Ab3JPKYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 06:24:14 -0400
Message-id: <525E6949.5010805@samsung.com>
Date: Wed, 16 Oct 2013 12:24:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Milo Kim <milo.kim@ti.com>, Bryan Wu <cooloney@gmail.com>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-pwm@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Bryan Wu <bryan.wu@canonical.com>, media-workshop@linuxtv.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] V2: Agenda for the Edinburgh mini-summit
References: <201309101134.32883.hansverk@cisco.com> <3335821.8epFKWiJXY@avalon>
 <CAK5ve-JHEaNrNiYwdMdEiEsD0LnqHG-MEAQv4D-962fYK0=g4A@mail.gmail.com>
 <2523390.YEHU3IBNqR@avalon>
 <CAK5ve-+N=GyNk-ryR0LbiUcT0TErFTwK60-vHNEf7112dNyh_A@mail.gmail.com>
 <525DF0C7.9090407@ti.com>
In-reply-to: <525DF0C7.9090407@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 16/10/13 03:49, Milo Kim wrote:
> General LED trigger APIs were created not for the application interface 
> but for any kernel space driver.
> The LED camera trigger APIs are used by a camera driver, not application.
> 
> Some LED devices provide basic LED functionalities and high current 
> features like a flash and a torch.(eg. LM3554, LM3642)
> The reason why I added the LED camera trigger is
>    "for providing multiple operations(LEDs, flash and torch) by one LED 
> device driver".
> 
> For example,
> A LED indicator is controlled via the LED sysfs.
> And flash and torch are controlled by a camera driver - calls exported 
> LED trigger function, ledtrig_flash_ctrl().
> 
> My understanding is the V4L2 subsystem provides rich IOCTLs for the 
> media device.
> I agree that the V4L2 is more proper interface for camera *application*.
> 
> So, my suggestion is:
>    - If a device has only flash/torch functionalities, then register the 
> driver as the V4L2 sub-device.

Presumably it's not something we want. I think a core module is needed
so drivers can expose both sysfs LED API and V4L2 Flash API with minimal
effort for a single device. Then LED API would be extended with standard
attributes for Torch/Flash and user applications can use either sysfs
or V4L2 subdev/controls API. No need to worry that for some of the devices
the kernel will expose only the sysfs and for some only the V4L2 interface.

Also for some multifunction devices integrating features like PMIC,
clock generator, Flash/Torch LED driver, etc. the LED might be used for
different purpose than originally intended. E.g. Torch LED as an
indicator. So it is not correct IMO to select a specific API based on
device's primary purpose only. I think there should be more flexibility.

>    - If a device provides not only flash/torch but also LED features, 
> then create the driver as the MFD.
> 
> For example, LM3555 (and AS3645A) is used only for the camera.
> Then, this driver is registered as the V4L2 sub-device.
> (drivers/media/i2c/as3645a.c) - no change at all.
> 
> On the other hands, LM3642 has an indicator mode with flash/torch.
> Then, it will consist of 3 parts - MFD core, LED(indicator) and 
> V4L2(flash/torch).
> 
> Then, ledtrig-camera will be removed after we complete to change the 
> driver structure.

I'm not sure it needs to be removed. We will still have hardware and
software triggered Flash LEDs. What would provide ledtrig-camera's
current functionality when you remove it ?

--
Regards,
Sylwester
