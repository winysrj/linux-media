Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42996 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756898AbaKTJmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 04:42:22 -0500
Date: Thu, 20 Nov 2014 11:36:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v6 1/2] media: Add registration helpers for V4L2 flash
Message-ID: <20141120093637.GX8907@valkosipuli.retiisi.org.uk>
References: <1411399309-16418-1-git-send-email-j.anaszewski@samsung.com>
 <1411399309-16418-2-git-send-email-j.anaszewski@samsung.com>
 <5469DD4F.1040706@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5469DD4F.1040706@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

Thank you for your thoughtful writing on the subject.

Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 09/22/2014 05:21 PM, Jacek Anaszewski wrote:
>> This patch adds helper functions for registering/unregistering
>> LED class flash devices as V4L2 subdevs. The functions should
>> be called from the LED subsystem device driver. In case the
>> support for V4L2 Flash sub-devices is disabled in the kernel
>> config the functions' empty versions will be used.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   drivers/media/v4l2-core/Kconfig      |   11 +
>>   drivers/media/v4l2-core/Makefile     |    2 +
>>   drivers/media/v4l2-core/v4l2-flash.c |  502
>> ++++++++++++++++++++++++++++++++++
>>   include/media/v4l2-flash.h           |  135 +++++++++
>>   4 files changed, 650 insertions(+)
>>   create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
>>   create mode 100644 include/media/v4l2-flash.h
> 
> [...]
> 
> After discussing on IRC the way of using compound controls for
> v4l2-flash sub-device I started to re-implement the patch but
> encountered subsequent issues, which make my inclination for
> abiding by the current version of the patch (separate v4l2-flash
> device for each sub-led) even stronger.
> 
> Let's list arguments for both options:
> 
> 1. Single v4l2-flash sub-device for a flash device that can control
>    several sub-leds:
> 
> a) a flash device driver has one related i2c device
> b) there exist hardware designs where some registers are
>    shared between sub-leds (e.g. flash timeout, flash status)
> 
> 2. Separate v4l2-flash sub-device for each sub-led of a flash device
> 
> a) LED Flash class drivers create separate LED Flash device for
>   sub-leds (enforced by led-triggers design). This way there is
>   a simple one-to-one "LED Flash device" - "v4l2-flash sub-device"
>   relation.
> b) if a single v4l2-flash sub-device was to control several
>   LED Flash devices then array controls would have to be
>   used for accessing the settings of every LED Flash device.
>   This poses following issues:
>     - the type of each V4L2 Flash control would have to be
>       set to the compound one (e.g. V4L2_CTRL_TYPE_U32), which in
>       turn would make the menu controls unavailable for querying
>       and displaying e.g. in qv4l2. Also the types as bitmask, button
>       would have to be avoided.

Good point. Currently the button control type is used for the strobe
control. For two leds we'd need an array of two button controls.

>     - All elements of an array control have to have the same
>       constraints and it would make impossible setting different min,
>       max values (e.g. current, timeout, external strobe) for each
>       sub-led. All the advantageous v4l2-ctrl mechanism related
>       to validating and caching controls would have to be avoided
>       and the user space would only get feedback in the form of
>       failing ioctl when the value to be set is not properly aligned

True. This is quite unpleasant to the user indeed.

>     - it is not possible to set only one element of the control
>       array and thus the settings of each sub-led would have to be
>       cached to avoid superfluous device register access
>       (functionality already secured by non-array v4l2-controls)

Agreed. But this is still a relatively minor nuisance in the implementation.

>     - the flash devices supporting single led could be provided
>       with standard non-array controls, but it would produce
>       cumbersome v4l2-flash code and inconsistent user space interface

> From the above it looks like the option 2. has much more advantages.
> The argument 1.a doesn't seem to be so vital in view of the fact
> that LED subsystem already breaks it. The argument 1.b can be obviated
> by caching the relevant values in the driver as it is for max77693-led.
> 
> I think that choosing option 2. would allow for avoiding much work
> that is already done in v4l2-ctrls.c. Moreover it would keep the
> V4L2 Flash controls maintainable with qv4l2.

Fair enough.

My remaining concerns in using two sub-devices to expose the LEDs to user
space are thus:

- Software strobe synchronisation. This one is important. There's no way to
  push a button control from two sub-devices at the same time. AFAIR your
  device lets the user to strobe the LEDs separately, but they are still
  controlled through a single register. Either we could implement the strobe
  only for the first LED, and it'd also affect the other. Alternatively we
  could add one more boolean control to the second LED (while both
  sub-devices would have the strobe button) to tell the strobe is
  synchronous with the other sub-device.

- Faults. There's usually just a single set of faults. Do we expose them for
  both sub-devices, even if they are the same? I think I'd do just that.
  Reading the faults on either sub-device will reset both.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
