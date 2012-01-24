Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab2AXSr3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 13:47:29 -0500
Message-ID: <4F1EFCB4.4070201@redhat.com>
Date: Tue, 24 Jan 2012 16:47:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lars Hanisch <dvb@flensrocker.de>
CC: Christian Brunner <chb@muc.de>, linux-media@vger.kernel.org,
	thomas.schloeter@gmx.net
Subject: Re: [PATCH] dvb: satellite channel routing (unicable) support
References: <20110928190421.GA13539@sir.fritz.box> <4E837ACF.60804@flensrocker.de> <4F1EAB97.6060301@redhat.com> <4F1EF8C1.2000508@flensrocker.de>
In-Reply-To: <4F1EF8C1.2000508@flensrocker.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-01-2012 16:30, Lars Hanisch escreveu:
> Hi,
> 
> Am 24.01.2012 14:01, schrieb Mauro Carvalho Chehab:
> [...]
>>>   That would be awesome to have this functionality in the kernel. I maintained the "unicable"-patch for the vdr (written by some guy from the vdr-portal.de who sadly doesn't seem to respond to mails via that forum anymore).
>>>   It would be great if all the work could be summarized in one ioctl.
>>
>> I don't think that SCR/Unicable, bandstacking, LNBf settings, rotor
>> control, etc. should belong to the Kernel. There are too many variants,
>> and several of them are not properly standardized or properly implemented.
>> Also, the actual options to use will depend on what type of DiSEqC components
>> used on his particular setup. So, it would be very difficult to write
>> something at the Kernel that will fit in all cases.
>>
>> What the Kernel should support is the capability of sending/receiving DiSEqC
>> commands, allowing userspace libraries to do the job of setting it. Such
>> feature is already there, so there's no need to change anything there.
>>
>> That's said, I'm working on a library to be used by applications that want
>> to talk with DVB devices. Together, with the library, there are a scanning
>> tool and a zapping tool.
>>
>> So, inspired by this patch, and using a public tech note about SCR/Unicable [1],
>> I wrote an Unicable patch for such library:
>>
>>     http://git.linuxtv.org/v4l-utils.git/commit/6c2c00ed3722465ed781ad49567e34dc7a5f92e7
>>
>> I'm currently without DVB-S/DVB-S2 antennas, so, I was not able to test it.
>>
>> It would be very nice if you could help us by testing if those tools are
>> working with DVB-S with SCR, and, if not, help fixing its support.
> 
>  Maybe the absence of a good libdvb lead to such patches as the SCR-patch. 

Yes, that's my opinion too. That's one of the reasons why I'm writing it, even for
hardware that I can't test. I even added an option to read and write from a few
commonly used file formats.

> I understand why such functionality should not be in the kernel. Hopefully the 
> libdvb will combine all nice features for dvb hardware so no application has to build
> its own implementations. Another advantage will be that there will be only one place 
> where to configure your hardware setup (like SCR, "use only specific delivery system 
> of hybrid cards" etc.).

Yes. Currently, I think that there are very few things missing there. The only two
I'm aware of are:
	- DiSEqC rotor control;
	- SCR auto-discovery, for bi-directional DiSEqC hardware;
	- ATSC-specific tables parsing (for libscan);
	- DVB-S2 non-emulated-mode descriptor.

>  I myself have only DVB-C but I know someone with a SCR-setup and will try to convince him to test this.

Thank you!
Mauro
