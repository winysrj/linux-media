Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39878 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0JTSBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 14:01:41 -0400
Received: by wyb28 with SMTP id 28so4032718wyb.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 11:01:40 -0700 (PDT)
Message-ID: <4CBF2E7F.6090706@googlemail.com>
Date: Wed, 20 Oct 2010 20:01:35 +0200
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Old patches sent via the Mailing list
References: <4CBB689F.1070100@redhat.com>	 <1287358617.2320.12.camel@morgan.silverblock.net>	 <4CBBE5F6.6030201@redhat.com>  <4CBE7BFA.6020507@googlemail.com> <1287576040.2679.3.camel@morgan.silverblock.net>
In-Reply-To: <1287576040.2679.3.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 20.10.2010 14:00, Andy Walls wrote:
> On Wed, 2010-10-20 at 07:19 +0200, Sven Barth wrote:
>> Am 18.10.2010 08:15, schrieb Mauro Carvalho Chehab:
>>> Em 17-10-2010 21:36, Andy Walls escreveu:
>
>>>>> The last time I sent this list, I was about to travel, and I may have missed some comments, or maybe I
>>>>> may just forgot to update. But I suspect that, for the list bellow, most of them are stuff where the
>>>>> driver maintainer just forgot at limbo.
>>>>>
>>>>>>  From the list of patches under review, we have:
>>>>>
>>>>> Waiting for new patch, signed, from Sven Barth<pascaldragon@googlemail.com>
>>>>>     Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400                       http://patchwork.kernel.org/patch/94960   Sven Barth<pascaldragon@googlemail.com>
>>>>
>>>> Sven,
>>>>
>>>> We need a "Signed-off-by: " for your submitted patch:
>>>>
>>>> http://www.linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Sign_your_work
>>>>
>>>> Note, your patch has an obvious, unintentional white space change for
>>>> "if (std == V4L2_STD_NTSC_M_JP)", so could you fix that up and send a
>>>> new signed off version?
>
>>
>> Eh... I thought I had superseeded it with the patch from 10th July (mail
>> title: [PATCH] Add support for AUX_PLL on cx2583x chips). It included a
>> "Signed-of by" from me as well as "Acked by" from Mike and Andy and I
>> also excluded the whitespace change ^^
>
> Hi Sven,
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg20296.html
>
> So you have.  How embarrassing.<:}

Well... it's a bit hard to keep the overview in this list. ;) I only saw 
this thread about "old patches" by pure luck.

And thank you for digging up the link, I only had the mail version lying 
around.

[And finally I won't have to patch v4l manually anymore... yippieh! I'm 
looking forward to 2.6.37 :D (Good that I use a distro (ArchLinux) that 
has a rolling release style ^^) ]

Regards,
Sven
