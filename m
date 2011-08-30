Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:59987 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1H3Qsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 12:48:50 -0400
Message-ID: <4E5D1470.9090702@mlbassoc.com>
Date: Tue, 30 Aug 2011 10:48:48 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: Getting started with OMAP3 ISP
References: <4E56734A.3080001@mlbassoc.com> <4E5CEECC.6040804@mlbassoc.com> <4E5CF118.3050903@mlbassoc.com> <201108301620.09365.laurent.pinchart@ideasonboard.com> <4E5CFA0B.3010207@mlbassoc.com> <CA+2YH7sfhWz_ubLExnGKmyLKOVKGOXYOmH6a1Hoy8ssJeMQnWQ@mail.gmail.com> <4E5D0E69.6020909@mlbassoc.com> <CA+2YH7t1SFoJvYYxVCmZrgo-mpvQMMnEnvG5Ocdioe4T8d29Cw@mail.gmail.com>
In-Reply-To: <CA+2YH7t1SFoJvYYxVCmZrgo-mpvQMMnEnvG5Ocdioe4T8d29Cw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-08-30 10:36, Enrico wrote:
> On Tue, Aug 30, 2011 at 6:23 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> Thanks, I'll give it a look.
>>
>> Your note says that /dev/video* is properly registered.  Does this
>> mean that udev created them for you on boot as well?  If so, what
>> version of udev are you using?  What's your root file system setup?
>> n.b. I'm using an OpenEmbedded variant, Poky
>
> They are not created on boot but when i modprobe omap3-isp (and
> tvp5150 gets automatically loaded).
>
> Udev is version 173 and i'm using Angstrom, an OpenEmbedded (core) variant too.
>
> Anyway when developing the patch it happened to me too that i had
> those subdev open errors, but if i remember correctly only for tvp5150
> so it was something wrong in my code.
>
> And if i continue to remember correctly it was because you had to set
> the V4L2_SUBDEV_FL_HAS_DEVNODE after calling v4l2_i2c_subdev_init.
> Seems nonsense but this is what i remember, actually this is what the
> mt9v032 driver does.

Yes, without that setting, the tvp device doesn't register a proper v4l_subdev node.

I'm getting the devices created, i.e. they exist in /sys, but just
not in /dev.  I'll see if I can run a new udev - maybe that will fix it.

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
