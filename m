Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45743 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2JPVqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 17:46:05 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1630153eaa.19
        for <linux-media@vger.kernel.org>; Tue, 16 Oct 2012 14:46:03 -0700 (PDT)
Message-ID: <507DD597.4050907@gmail.com>
Date: Tue, 16 Oct 2012 23:45:59 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, s.nawrocki@samsung.com,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
References: <1323115006-4385-1-git-send-email-snjw23@gmail.com> <20111205224155.GB938@valkosipuli.localdomain> <4EE364C7.1090805@gmail.com> <5079B869.3040609@gmail.com> <507A82DB.9070104@gmail.com> <20121014183032.GD21261@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121014183032.GD21261@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/14/2012 08:30 PM, Sakari Ailus wrote:
> Currently the flash control reference states that "The V4L2 flash controls
> are intended to provide generic access to flash controller devices. Flash
> controller devices are typically used in digital cameras".
> 
> Whether or not higher level controls should be part of the same class is a
> valid question. The controls intended to expose certain frames with flash
> are quite different from those used to control the low-level flash chip: the
> user is fully responsible for timing and the flash sequence.
> 
> For higher level controls that could be implemented using the low-level
> controls for the end user, the user would likely prefer to say things like
> "please give me a frame exposed with flash". Since the timing is no longer
> implemented by the user, the user would need to know which frames have been
> exposed and how, at least in a general case. Getting around this could
> involve configuring the sensor before starting streaming. Perhaps this is an
> assumption we could accept now, before we have proper means for passing
> frame-related parameters to user space.

Yes, right. This auto strobe control seems to be a higher level one, since
we have a firmware program that is taking care of some things that normally
would be done through the existing Flash class controls by a user space
application/library.

I'm not really sure if we need a new class. It's even hard to name it.
I don't see such an auto strobe control as a high level one, from an end 
application POV. It's more like the existing controls are low level.

With V4L2 device profiles, when eventually we create them... it might not
matter if we create separate flash control class for flash controllers,
camera sensors, each one low or high level.

I agree with your remarks regarding pre-configuring a sensor. Frame meta
data could carry relevant information, but so far we don't have standard
solution for that.

>>> V4L2_CID_FLASH_HW_STROBE_AUTO
>>>
>>> with options:
>>> 	V4L2_FLASH_HW_STROBE_OFF
>>> 	V4L2_FLASH_HW_STROBE_AUTO
>>> 	V4L2_FLASH_HW_STROBE_ON
>>
>> The _HW prefix probably needs to be removed there.
> 
> V4L2_CID_FLASH_STROBE_AUTO sounds good to me as such.
> 
> Do you always need to streamoff first, after which these the sensors perform
> a single capture with flash enabled, or how does it work? How about the
> subsequent captures; will they be done with flash enabled as well (requiring
> a possible flash cool-off time) or will the flash be disabled for them?

Currently a streamoff is needed in general. The pipeline needs to be
reconfigured for different resolution/image format. The flash should be 
fired as configured per each capture request. I imagine sensor could delay 
actual capture when the Flash is not ready, due to required cool-off/
re-charge time. Such an information would need to be provided to the sensor 
somehow, e.g. with a private ioctl. I don't have much experience yet with 
more advanced Flash circuits/controls. 

So V4L2_FLASH_STROBE_ON would mean, for each executed capture request the 
Flash is to be triggered unconditionally.

> For something more complex we'd require something else than a control
> interface; possibly a private IOCTL to set frame-specific flash parameters.

Yes, I agree with that. Per frame meta data is needed to figure out, e.g. 
which frame has been exposed with flash and which one without.

> Albeit I think that this control would be very different from what the rest
> of the controls in the class do, I don't see a better place for it either. I
> wouldn't mind hearing others' opinions, though.

Maybe we could consider just documenting this kind of controls in a separate 
section ?

>> OTOH it seems V4L2_CID_FLASH_LED_MODE and V4L2_CID_FLASH_TORCH_INTENSITY
>> could do the same. V4L2_CID_FLASH_LED_MODE would be switching between
>> Flash and Torch function and V4L2_CID_FLASH_TORCH_INTENSITY would be
>> turning flash LED on/off.
> 
> You don't even need to set torch intensity. I'd suppose this is maximum by
> default, or may not be controllable in the first place. All you need to do
> to turn the flash off is to set the V4L2_CID_FLASH_LED_MODE to
> V4L2_FLASH_LED_MODE_NONE. If you want torch, set it to
> V4L2_FLASH_LED_MODE_TORCH.

Indeed, thanks for opening my eyes. :)

> I wonder if TC_FLASH_CONT_ENABLE enables torch, or something else.

Yes, it just enables the LED permanently.

> What about pre-flash? :-)

Good question, I think an interface to adjust this feature is needed as well.
So parameters like pre-flash count, time period between pre-and main flash 
strobe, or pre-flash status can be configured/retrieved. My knowledge is 
rather limited on that topic yet though.

--
Regards,
Sylwester
