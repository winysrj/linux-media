Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweb5.versatel.de ([82.140.32.141]:34312 "EHLO
	mxweb5.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab2AES7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 13:59:12 -0500
Received: from cinnamon-sage.de (i577A35D2.versanet.de [87.122.53.210])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id q05IcVKe015172
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 19:38:31 +0100
Received: from 192.168.23.2:50127 by cinnamon-sage.de for <dheitmueller@kernellabs.com>,<mchehab@redhat.com>,<linux-media@vger.kernel.org> ; 05.01.2012 19:38:31
Message-ID: <4F05EE24.50209@flensrocker.de>
Date: Thu, 05 Jan 2012 19:38:28 +0100
From: Lars Hanisch <dvb@flensrocker.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to
 one frontend
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com> <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com>
In-Reply-To: <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

  First: I'm no driver but an application developer.

Am 05.01.2012 17:40, schrieb Devin Heitmueller:
> On Thu, Jan 5, 2012 at 10:37 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> With all these series applied, it is now possible to use frontend 0
>> for all delivery systems. As the current tools don't support changing
>> the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
>> be used to change between them:
>
> Hi Mauro,
>
> While from a functional standpoint I think this is a good change (and
> we probably should have done it this way all along), is there not
> concern that this could be interpreted by regular users as a
> regression?  Right now they get two frontends, and they can use all
> their existing tools.  We're moving to a model where if users upgraded
> their kernel they would now require some new userland tool to do
> something that the kernel was allowing them to do previously.
>
> Sure, it's not "ABI breakage" in the classic sense but the net effect
> is the same - stuff that used to work stops working and now they need
> new tools or to recompile their existing tools to include new
> functionality (which as you mentioned, none of those tools have
> today).

  Since now there isn't any consistent behaviour of hybrid multifrontend devices. Some create multiple frontends but 
only one demux/dvr (like drx-k), others create all devices for every delivery system (HVR 4000). But they all could only 
be opened mutually exclusive. In case of vdr (my favourite app) you have to trick with udev, symlinks, "remove unwanted 
frontends" etc. to get the devices in a shape so the application can use it. I don't know how mythtv is handling such 
devices, but I think there will be something like driver-dependend code in the one or other way.

  The spec isn't really meaningful for hybrid devices. Maybe we should start there and claim something the driver 
developer can follow.

> Perhaps you would consider some sort of module option that would let
> users fall back to the old behavior?

  That would be fine but better would be a module option that will initialize frontend0 to the "connected" delivery 
system. In case of DVB-C/-T you don't switch frequently from one to the other. You would need extra hardware like a 
splitter which switches inputs if there are e.g. 5V for an active antenna (which means: switch to the dvb-t-input). Is 
there any DVB-T card which can supply such voltage? And is it controllable via an ioctl (like LNB power supply in DVB-S)?

  Anyway, I think, if there's finally a solution so all drivers behave the same, the tools and applications will handle 
this new model in the near future.

  Please do something... :-)

Regards,
Lars.

>
> Devin
>
