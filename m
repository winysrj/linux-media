Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0BVMQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 07:16:09 -0500
Message-ID: <4B827548.10005@redhat.com>
Date: Mon, 22 Feb 2010 09:15:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	hverkuil@xs4all.nl,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Chroma gain configuration
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com> <1266838852.3095.20.camel@palomino.walls.org>
In-Reply-To: <1266838852.3095.20.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2010-02-21 at 23:07 -0500, Devin Heitmueller wrote:
>> I am doing some work on the saa711x driver, and ran into a case where
>> I need to disable the chroma AGC and manually set the chroma gain.
> 
> Sakari, Hans, or anyone else,
> 
> On a somewhat related note, what is the status of the media controller
> and of file handles per v4l2_subdev.  Will Sakari's V4L file-handle
> changes be all we need for the infrastructure or is there more to be
> done after that?
> 
> I'd like to implement specific "technician controls", something an
> average user wouldn't use, for a few subdevs.

The exposition of a control to the user or not is a decision of the userspace
software developer. We shouldn't be too concerned about it. Eventually,
we can group some controls on a "raw hardware level" group. I don't think we
need a media controller for it. Also, this won't avoid developers to use the media
controller to expose such controls to userspace.
 
>> I see there is an existing boolean control called V4L2_CID_CHROMA_AGC,
>> which would be the logical candidate for allowing the user to disable
>> the chroma AGC.  However, once this is done I still need to expose the
>> ability to set the gain manually (bits 6-0 of register 0x0f).
>>
>> Is there some existing control I am just missing?  Or do I need to do
>> this through a private control.
>>
>> I'm asking because it seems a bit strange that someone would introduce
>> a v4l2 standard control to disable the AGC but not have the ability to
>> manually set the gain once it was disabled.
> 
> Devin,
> 
> Well, I can imagine letting hardware do the initial AGC, and then when
> it is settled manually disabling it to prevent hardware from getting
> "fooled".

I did some tests on it with cx23881/cx23883 chips. At least on cx88, as far
as I remember, the AGC doesn't affect the saturation register, so, this 
trick won't work. 

The issue with cx88 chips is that, with some video input sources, the 
AGC over-saturates the color pattern. So, depending on the analog video
standard and the quality of the source (TV or Composite/Svideo), it gives
more reallistic colors with different AGC/saturation configuration.

Cheers,
Mauro
