Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:43224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0JPE2u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 00:28:50 -0400
Message-ID: <4CB929FB.3020609@infradead.org>
Date: Sat, 16 Oct 2010 01:28:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] ov7670: remove QCIF mode
References: <20101008210412.E85769D401B@zog.reactivated.net>	<20101008151110.127a62fe@bike.lwn.net> <AANLkTi=Lsu0JXgQ5ZGja0w7q6+wzQA1gmpx9b724UH+Z@mail.gmail.com>
In-Reply-To: <AANLkTi=Lsu0JXgQ5ZGja0w7q6+wzQA1gmpx9b724UH+Z@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-10-2010 18:15, Daniel Drake escreveu:
> On 8 October 2010 22:11, Jonathan Corbet <corbet@lwn.net> wrote:
>> I'm certainly not attached to this mode, but...does it harm anybody if
>> it's there?
> 
> Yes. Applications like gstreamer will pick this resolution if its the
> closest resolution to the target file resolution. On XO-1 we always
> pick a low res so gstreamer picks this one. And we end up with a video
> that only records a miniscule portion of the FOV.
> 
> All the other settings of the camera scale the image so that the whole
> FOV is covered. But this one records at normal resolution, only
> sending a small center portion of the FOV. The same pixels can be read
> by recording at full res and then just cutting out the center bit.

Seems an application-specific issue to me. I would accept a patch at cafe-ccic
limiting the minimum resolution (as it is device-specific), but I agree with
Jon that limiting it at the sensor is not a good thing to do. 

Getting full res means to require higher bandwidths at the bus (and this may be
a problem if someone wants to have more than one camera, and the bridge is USB).
Also, it will eat more CPU to downscale.

Cheers,
mauro
