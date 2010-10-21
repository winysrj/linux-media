Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab0JULon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 07:44:43 -0400
Message-ID: <4CC027A5.8090008@redhat.com>
Date: Thu, 21 Oct 2010 09:44:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sven Barth <pascaldragon@googlemail.com>
CC: Andy Walls <awalls@md.metrocast.net>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Old patches sent via the Mailing list
References: <4CBB689F.1070100@redhat.com>	 <1287358617.2320.12.camel@morgan.silverblock.net>	 <4CBBE5F6.6030201@redhat.com>  <4CBE7BFA.6020507@googlemail.com> <1287576040.2679.3.camel@morgan.silverblock.net> <4CBF2E7F.6090706@googlemail.com>
In-Reply-To: <4CBF2E7F.6090706@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-10-2010 16:01, Sven Barth escreveu:
> On 20.10.2010 14:00, Andy Walls wrote:
>> On Wed, 2010-10-20 at 07:19 +0200, Sven Barth wrote:
>>> Am 18.10.2010 08:15, schrieb Mauro Carvalho Chehab:
>>>> Em 17-10-2010 21:36, Andy Walls escreveu:
>>
>>>>>> The last time I sent this list, I was about to travel, and I may have missed some comments, or maybe I
>>>>>> may just forgot to update. But I suspect that, for the list bellow, most of them are stuff where the
>>>>>> driver maintainer just forgot at limbo.
>>>>>>
>>>>>>>  From the list of patches under review, we have:
>>>>>>
>>>>>> Waiting for new patch, signed, from Sven Barth<pascaldragon@googlemail.com>
>>>>>>     Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400                       http://patchwork.kernel.org/patch/94960   Sven Barth<pascaldragon@googlemail.com>
>>>>>
>>>>> Sven,
>>>>>
>>>>> We need a "Signed-off-by: " for your submitted patch:
>>>>>
>>>>> http://www.linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Sign_your_work
>>>>>
>>>>> Note, your patch has an obvious, unintentional white space change for
>>>>> "if (std == V4L2_STD_NTSC_M_JP)", so could you fix that up and send a
>>>>> new signed off version?
>>
>>>
>>> Eh... I thought I had superseeded it with the patch from 10th July (mail
>>> title: [PATCH] Add support for AUX_PLL on cx2583x chips). It included a
>>> "Signed-of by" from me as well as "Acked by" from Mike and Andy and I
>>> also excluded the whitespace change ^^
>>
>> Hi Sven,
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg20296.html
>>
>> So you have.  How embarrassing.<:}
> 
> Well... it's a bit hard to keep the overview in this list. ;) I only saw this thread about "old patches" by pure luck.
> 
> And thank you for digging up the link, I only had the mail version lying around.
> 
> [And finally I won't have to patch v4l manually anymore... yippieh! I'm looking forward to 2.6.37 :D (Good that I use a distro (ArchLinux) that has a rolling release style ^^) ]
> 

OK, I've replaced the non-signed patch to the signed one, at the new branch I've
created for the patches that I'll send during the merge window (staging/v2.6.37-rc1).

The reason why the new patch were not catched is that the emailer broke long lines on
your patch, so, patchwork didn't catch it.

Please, next time, be sure that you'll submit your patch with an emailer that don't break
long lines.

Thanks,
Mauro
