Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0A0U6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 15:58:45 -0500
Message-ID: <4B60A8F3.9010807@redhat.com>
Date: Wed, 27 Jan 2010 18:58:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: TJ <one.timothy.jones@gmail.com>
CC: mythtv-dev@mythtv.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pete Eberlein <pete@sensoray.com>, jelle-mythtv-dev@foks.us
Subject: Re: [mythtv] go7007 based devices
References: <4B48C1B5.5000207@gmail.com> <4B552F15.4000305@foks.us> <4B580B53.1060500@gmail.com> <201001271308.06650.hverkuil@xs4all.nl> <4B609C0F.9080503@gmail.com>
In-Reply-To: <4B609C0F.9080503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TJ wrote:
> 
> Hans Verkuil wrote:
>> On Thursday 21 January 2010 09:07:47 TJ wrote:
>>> Jelle Foks wrote:
>>>> TJ wrote:
>>>>> I am curious how many people are successfully using go7007 based
>>>>> capture devices
>>>>> with mythtv. I've done some patch work on go7007 driver to make it v4l2
>>>>> compliant and was thinking of updating mythtv to stop using
>>>>> proprietary go7007
>>>>> ioctls, but wanted to feel the ground first.
>>>>> -TJ
>>>>>
>>>>> PS: jelle you on this list?
>>>>>   
>>>> Yep, I'm on it, but I guess I don't check on it very often ;-)...
>>> You sure don't :)
>>>
>>>> Myself, I'm using a bunch of plextors (with the go7007 chip), both
>>>> M402's without tuner and TV402's with tuner on my mythbackend in the
>>>> closet, using Ubuntu with a 2.6.31-11-generic-pae kernel and drivers
>>>> that I made by combining the driver from the kernel staging tree and an
>>>> older version that still worked, as I posted (with more details) on my
>>>> blog at http://go70007.imploder.org . Somebody replied on the blog that
>>>> it also works on 2.6.32.2, on ARM even... I actually don't know who
>>>> maintains the go7007 driver in the staging tree, but I don't think it
>>>> was the v4l guys.
>> Actually, it is. So the linux-media list is the appropriate place to post patches on.
>> It is currently maintained by Pete Eberlein from Sensoray.
>>
>>> Try this patch. It runs against kernel source. I tried it on 2.6.32, 2.6.32-r1
>>> and -r2. I basically did some general cleanup on the go7007 driver in the kernel
>>> tree, added few standard v4l2 commands and *temporarily* put back in proprietary
>>> go7007 ioctls from your package for continued mythtv support. I also added
>>> support for ADS Tech DVD Xpress DX2 board (which was the main reason I got into
>>> it). It runs well on my DX2 boxes. I've got about 100 of them and am currently
>>> testing it on 5.
>> Please post this as well to the linux-media list. It would be great if someone would be
>> willing to do more work on this driver and get it out of staging into the mainline. It's
>> getting close, but it's not there yet.
>>
>> Regards,
>>
>> 	Hans
>>
> 
> Hans, My brother, pardon my ignorance, but would you please be so kind and shed
> some light for me on which way I should go.
> 
> I was in touch with Pete on linux-media list and he's done quite a bit of work
> on updating the driver in the current linux-media hg tree.
> 
> My patch runs against official linux kernel 2.6.32.x but won't run against hg tree.
> 
> So, my thoughts were to go 2 ways:
> 
> 1. Update my patch against current linux development kernel (2.6.33-rc5? or
> -next?) and submit it to be included with the next kernel release. It would
> still be in the staging category, but at least people will be able to
> immediately take advantage of the following things:
> 
>  - ADS Tech DX2 support (which I added, actually ported from some earlier release)
>  - Mythtv support (as I included original ioctls)
>  - Mythtv will now be able to be patched to use standard ioctls (I also kept and
> expanded all standard ioctls)
>  - I found and fixt a few minor bugs
> 
> 2. Keep working against current linux-media hg tree and tell people to hang
> tight. This might take a while though, cuz between now and Sept-Oct this year I
> won't be able to put a lot of time into it (worken on a big project).
> 
> The things I dunno about and would appreciate anyone shedding some light on are:
> 
> a. Is the current linux-media hg tree going to be included in 2.6.33 kernel? If
> so, then option 1 above is out of the question and I will keep working with Pete
> on the current hg driver.
> 
> b. If the things didn't change much in the kernel tree since 2.6.32, I can
> probably quickly update my patch and submit it for inclusion into 2.6.33.
> 
> If that's the case, which kernel should I make the patch against? Should I just
> git 2.6.33-rc5?
> 
> Who do I submit my patch to?
> 
> Again sorry for my ignorance, I don't do much collaborative work, but I am
> willing to help out the community. :)

Let me answer to your questions:

The better is to generate your patch against the development -git tree:
	http://git.linuxtv.org/v4l-dvb.git

This tree is merged upstream, at the upstream linux-next tree, and have all the patches that
will go to 2.6.34 (patches against -rc trees are only for bug fixes).

As the -hg tree has the same code as -git (it is manually updated when a change happens
on -git), it is safe to generate your patch against -hg.

The patch is handled by me, but you should send it to linux-media@vger.kernel.org only. If the
patch doesn't have any whitespace trobules, it will be catched by http://patchwork.kernel.org,
and I'll be able to see it at the web interface.

You can read more about how to submit a patch at:
	http://linuxtv.org/wiki/index.php/Maintaining_Git_trees
	http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

and at the kernel development section of our wiki:
	http://linuxtv.org/wiki/
> 
> -TJ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

