Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab0GIU5K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jul 2010 16:57:10 -0400
Message-ID: <4C378D35.3080007@redhat.com>
Date: Fri, 09 Jul 2010 17:57:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Ivan <ivan.q.public@gmail.com>, linux-media@vger.kernel.org
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 	[eb1a:2860]
References: <4C353039.4030202@gmail.com>	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>	<4C360E64.3020703@gmail.com>	<AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>	<4C362C6E.5050104@gmail.com>	<AANLkTikCrka3EyqhjP7z6wYQa4Z8exDa9Dwda60OLsVJ@mail.gmail.com>	<4C363692.5000600@gmail.com>	<4C364416.3000809@gmail.com>	<AANLkTimRQaFDzKTXAIxIs2lT7ldrMwMNIFSJN4VzJOQQ@mail.gmail.com>	<4C364CD3.3080106@gmail.com>	<4C371A74.4080901@redhat.com>	<4C375A07.7010205@gmail.com>	<4C376479.2030101@redhat.com> <AANLkTilSonpCN_gzfsOYVaMpXbmfPFVi6Wdxb06dK7W1@mail.gmail.com>
In-Reply-To: <AANLkTilSonpCN_gzfsOYVaMpXbmfPFVi6Wdxb06dK7W1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-07-2010 15:12, Devin Heitmueller escreveu:
> On Fri, Jul 9, 2010 at 2:03 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 09-07-2010 14:19, Ivan escreveu:
>>> On 07/09/2010 08:47 AM, Mauro Carvalho Chehab wrote:
>>>> I never saw the em28xx scaler generating such vertical stripes. This
>>>> could be a mplayer or a video adapter driver problem. Are you using a
>>>> proprietary video driver? You may try to use ffmeg or mencoder to
>>>> generate a mpeg file at 640x480 and then try to play it on another
>>>> player (preferably on another machine), to see if this problem
>>>> disappears.
>>>
>>> Huh? Does there even *exist* a proprietary linux driver for my card? And because you never saw stripes with em28xx, they must not exist? :^P
>>
>> Well, it depends. What are your video adapter card? ATI? Nvidia?
> 
> Mauro,
> 
> His issue with the "vertical stripes" has been fixed when he updated
> to the latest v4l-dvb code.  It's the issue I fixed a couple of months
> ago with the saa7113 chroma gain behavior when there is an overdriven
> signal.  The problem he's having now with the latest is the picture
> appears to be shifted.  I have to wonder if perhaps I screwed
> something up when I did the VBI support, in that it may not work
> properly when the scaler is in use.
> 
> I will have to do some testing.

I meant that vertical risk that appeared when scaling is on. I never saw em28xx
scaler doing something like that. It maybe some bug at mplayer or at the nvidia
proprietary driver. We know that this driver has serious issues with their Xv
support, and that it do some evil things when allocating kernel memory.

Cheers,
Mauro.
