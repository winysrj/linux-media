Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55337 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbcCUTsW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 15:48:22 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
 <56EC2294.603@xs4all.nl> <56EC3BF3.5040100@xs4all.nl>
 <20160321114045.00f200a0@recife.lan> <56F00DAA.8000701@xs4all.nl>
 <56F01AE7.6070508@xs4all.nl> <20160321145034.6fa4e677@recife.lan>
 <56F038A0.1010004@xs4all.nl> <56F03C40.4090909@osg.samsung.com>
 <56F0461A.1070809@xs4all.nl> <56F04969.6070908@osg.samsung.com>
 <56F04BF3.2000006@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56F04FFC.3080706@osg.samsung.com>
Date: Mon, 21 Mar 2016 16:48:12 -0300
MIME-Version: 1.0
In-Reply-To: <56F04BF3.2000006@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 03/21/2016 04:30 PM, Hans Verkuil wrote:

[snip]

>>>>
>>>> Can you please provide an example of a media pipeline that user-space should
>>>> use with this approach? AFAICT whatever PADs are created when initiliazing
>>>> the PADs for an entity, will be exposed to user-space in the media graph.
>>>>
>>>> So I'm not understading how it will be used in practice. I don't mean that
>>>> your approach is not correct, is just I'm not getting it :)
>>>
>>> Why would userspace need to use the pads? This is for legacy drivers (right?)
>>> where the pipeline is fixed anyway.
>>>
>>
>> I asked because the user needs to setup the links in the media pipeline to
>> choose  which input connection will be linked to the tvp5150 decoder. But it
>> doesn't matter if we are going with the single sink pad approach since the
>> user will always do something like:
> 
> Why? The user will use an application that uses ENUM/S/G_INPUT for this. We're
> talking legacy drivers ('interface centric drivers' would be a better description)
> where we don't even expose the v4l-subdevX device nodes. Explicitly programming
> a media pipeline is something you do for complex devices (embedded systems and
> the like). Not for simple and generally fixed pipelines. Utterly pointless.
>

Mauro was talking about legacy 'interface centric' PC-consumer's hardware but
my test system is an embedded board that also has a tvp5150 decoder. The
board has an OMAP3 and the tvp5150 is attached to the SoC ISP. Is this one:

https://www.isee.biz/products/igep-expansion-boards/igepv2-expansion

As you can see, the board has 2 RCA connectors and each one is routed a tvp5150
composite input and both connectors can be used for S-Video. So the user needs
to setup the pipeline manually to choose which input connection to use.

But on a second read of the thread, it seems that you were referring to the
meta-pads only for the 'interace centric' drivers so maybe I misunderstood you.

Sorry for the noise if that was the case.
 
>>
>> $ media-ctl -r -l '"Composite0":0->"tvp5150 1-005c":0[1]'
>>
>> IOW, there will always choose the only connection source pad and tvp5150 sink.
>>
>> There will be two source pads for the tvp5150 though, 1 for video and other
>> for VBI. But I guess this is not an issue since that's easier to standardize.
> 
> Not all devices have VBI. Some devices may have *only* VBI (although the last
> driver of that kind was removed from the kernel a long time ago), there may
> be multiple video source pads, and when we add HDMI I can think of a lot more
> complex scenarios. So source pads shouldn't have their pad indices imposed on
> them by outside 'arrangements'. It is really the wrong approach, regardless of
> whether we talk about sink or source pads.
>

Ok, thanks for the explanation.
 
> Regards,
> 
> 	Hans
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
