Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0JRGPz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 02:15:55 -0400
Message-ID: <4CBBE5F6.6030201@redhat.com>
Date: Mon, 18 Oct 2010 04:15:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: LMML <linux-media@vger.kernel.org>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Jarod Wilson <jarod@redhat.com>,
	Richard Zidlicky <rz@linux-m68k.org>,
	Antti Palosaari <crope@iki.fi>,
	Sven Barth <pascaldragon@googlemail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Henrik Kurelid <henke@kurelid.se>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: Old patches sent via the Mailing list
References: <4CBB689F.1070100@redhat.com> <1287358617.2320.12.camel@morgan.silverblock.net>
In-Reply-To: <1287358617.2320.12.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-10-2010 21:36, Andy Walls escreveu:
> On Sun, 2010-10-17 at 19:20 -0200, Mauro Carvalho Chehab wrote:
>> Hi,
>>
>> I did a large effort during this weekend to handle the maximum amount of patches, in order to have them
>> ready for 2.6.37. While there are still some patches marked as NEW at patchwork, and a few pending pull
>> requests (mostly related to more kABI changes), there are still a list of patches that are marked as
>> Under review. Except for 4 patches from me, related to Doc (that I'm keeping in this list just to remind
>> me that I'll need to fix them when I have some time - just some automation stuff at DocBook), all other
>> patches marked as Under review are stuff that I basically depend on others.
>>
>> The last time I sent this list, I was about to travel, and I may have missed some comments, or maybe I
>> may just forgot to update. But I suspect that, for the list bellow, most of them are stuff where the
>> driver maintainer just forgot at limbo.
>>
>> >From the list of patches under review, we have:
>>
>> Waiting for new patch, signed, from Sven Barth <pascaldragon@googlemail.com>
>>   Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400                       http://patchwork.kernel.org/patch/94960   Sven Barth <pascaldragon@googlemail.com>
> 
> Sven,
> 
> We need a "Signed-off-by: " for your submitted patch:
> 
> http://www.linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Sign_your_work
> 
> Note, your patch has an obvious, unintentional white space change for
> "if (std == V4L2_STD_NTSC_M_JP)", so could you fix that up and send a
> new signed off version?
> 
> 
> Mauro,
> 
> This patch makes obvious sense to me: don't perform audio register
> updates on a chip that doesn't have an audio processing block.  Sven's
> approach was based on my recommended approach, after his initial
> discovery on how to get his audio working.
> 
> Do we really need an S.O.B for something that appears to be common
> sense, and wouldn't have been implemented any other way, even if I had
> implemented it?

The original patch were in the middle of a discussion, no proper description,
bad whitespacing, etc. It is better to let the patch author to fix those issues,
as they learn more about how to submit a patch.

Anyway, I agree with you, the patch is obvious, and can proceed without the SOB.
I did the usual CodingStyle fixups, put part of your above comment as the patch
description, together with your ack and moved it forward. One patch less on my queue ;)

Cheers,
Mauro
