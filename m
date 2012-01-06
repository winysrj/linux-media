Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758394Ab2AFAF1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 19:05:27 -0500
Message-ID: <4F063ABE.3020806@redhat.com>
Date: Thu, 05 Jan 2012 22:05:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lars Hanisch <dvb@flensrocker.de>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to
 one frontend
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com> <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com> <4F05EE24.50209@flensrocker.de>
In-Reply-To: <4F05EE24.50209@flensrocker.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-01-2012 16:38, Lars Hanisch wrote:
> Hi,
> 
>  First: I'm no driver but an application developer.
> 
> Am 05.01.2012 17:40, schrieb Devin Heitmueller:
>> On Thu, Jan 5, 2012 at 10:37 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com>  wrote:
>>> With all these series applied, it is now possible to use frontend 0
>>> for all delivery systems. As the current tools don't support changing
>>> the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
>>> be used to change between them:
>>
>> Hi Mauro,
>>
>> While from a functional standpoint I think this is a good change (and
>> we probably should have done it this way all along), is there not
>> concern that this could be interpreted by regular users as a
>> regression?  Right now they get two frontends, and they can use all
>> their existing tools.  We're moving to a model where if users upgraded
>> their kernel they would now require some new userland tool to do
>> something that the kernel was allowing them to do previously.
>>
>> Sure, it's not "ABI breakage" in the classic sense but the net effect
>> is the same - stuff that used to work stops working and now they need
>> new tools or to recompile their existing tools to include new
>> functionality (which as you mentioned, none of those tools have
>> today).
> 
> Since now there isn't any consistent behaviour of hybrid multifrontend devices.
> Some create multiple frontends but only one demux/dvr (like drx-k), others create 
> all devices for every delivery system (HVR 4000). But they all could only be opened 
> mutually exclusive. In case of vdr (my favourite app) you have to trick with udev,
> symlinks, "remove unwanted frontends" etc. to get the devices in a shape so the 
> application can use it. I don't know how mythtv is handling such devices, but I 
> think there will be something like driver-dependend code in the one or other way.
> 
> The spec isn't really meaningful for hybrid devices. Maybe we should start 
> there and claim something the driver developer can follow.

We had some discussions about that at the KS workshop. All people there
agreed that the better is to use one frontend by physical device.

So, in the end of the day, all drivers should behave like what those DRX-K
patches are doing.

>> Perhaps you would consider some sort of module option that would let
>> users fall back to the old behavior?
> 
>  That would be fine but better would be a module option that will 
>  initialize frontend0 to the "connected" delivery system. In case of DVB-C/-T
>  you don't switch frequently from one to the other. You would need extra hardware 
>  like a splitter which switches inputs if there are e.g. 5V for an active antenna
>  (which means: switch to the dvb-t-input). Is there any DVB-T card which can supply
>  such voltage? And is it controllable via an ioctl (like LNB power supply in DVB-S)?

This is called LNA. A proper LNA support is missing. I think we should 
add a DVBv5 property to control it, on the devices that supports this feature.

The DRX-K chips described at the drxk_hard.c don't support such feature, but
there are other devices that supports it.

Btw, there are some DRX-K devices with two separate demods and two separate
frontends. A driver option won't work on such devices, as one frontend may
be connected to DVB-C, and the other one to DVB-T.

Also, the user may have more than one device of the same type (I have 3 sticks here
with em28xx/drx-k) that could be used simultaneously. Again, a modprobe
parameter won't fit, if the user wants to use some devices for one type, and
the other ones for the second type.

> 
>  Anyway, I think, if there's finally a solution so all drivers behave the same,
>  the tools and applications will handle this new model in the near future.

Yes, that's what we expect ;)

The DTV_ENUM_DELSYS and DTV_DELIVERY_SYSTEM properties are enough to
properly support such devices.
> 
>  Please do something... :-)
> 
> Regards,
> Lars.
> 
>>
>> Devin
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

