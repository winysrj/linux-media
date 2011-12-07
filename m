Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.thermoteknix.com ([188.223.91.156]:57461 "EHLO
	mailgate.thermoteknix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1LGLop (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 06:44:45 -0500
Message-ID: <4EDF51AA.3040503@thermoteknix.com>
Date: Wed, 07 Dec 2011 11:44:42 +0000
From: Adam Pledger <a.pledger@thermoteknix.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: Omap3 ISP + Gstreamer v4l2src
References: <4EDF1DA2.5000106@thermoteknix.com> <201112071134.24567.laurent.pinchart@ideasonboard.com> <4EDF477D.8080507@matrix-vision.de>
In-Reply-To: <4EDF477D.8080507@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Michael,

<snip>
>> Please note that BT.656 support is still experimental, so issues are not
>> unexpected.

Yes, I was aware that this is not yet fully baked.

<snip>
>>> My question is, should this "just work"? It was my understanding that
>>> once the pipeline was configured with media-ctl then the CCDC output 
>>> pad
>>> should behave like a standard V4L2 device node.
>>
>>
>> That's more or less correct. There have been a passionate debate 
>> regarding
>> what a "standard V4L2 device node" is. Not all V4L2 ioctls are 
>> mandatory, and
>> no driver implements them all. The OMAP3 ISP driver implements a very 
>> small
>> subset of the V4L2 API, and it wasn't clear whether that still 
>> qualified as
>> V4L2. After discussions we decided that the V4L2 specification will 
>> document
>> profiles, with a set of required ioctls for each of them. The OMAP3 ISP
>> implements the future video streaming profile.
>>
>> I'm not sure what ioctls v4l2src consider as mandatory. The above error
>> related to a CTRL ioctl (possibly VIDIOC_QUERYCTRL), which isn't 
>> implemented
>> by the OMAP3 ISP driver and will likely never be. I don't think that 
>> should be
>> considered as mandatory.
>>
>> I think that v4l2src requires the VIDIOC_ENUMFMT ioctl, which isn't
>> implemented in the OMAP3 ISP driver. That might change in the future, 
>> but I'm
>> not sure yet whether it will. In any case, you might have to modify 
>> v4l2src
>> and/or the OMAP3 ISP driver for now. Some patches have been posted a 
>> while ago
>> to this mailing list.
>
> Here was my submission for ENUM_FMT support:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg29640.html
>
> I submitted this in order to be able to use the omap3-isp with 
> GStreamer.  I missed the discussion about V4L2 "profiles", but when I 
> submitted that patch we discussed whether ENUM_FMT was mandatory. 
> After I pointed out that the V4L2 spec states plainly that it _is_ 
> mandatory, I thought Laurent basically agreed that it was reasonable.
>
> Laurent, what do you think about adding ENUM_FMT support now?

Thank you both for clarifying the current situation regarding omap3isp / 
MCF (and Michael for the previous patch, which I will take a look at). 
This addresses quite a few questions that I have been mulling over in 
the last few days.

<snip>

Best Regards

Adam

