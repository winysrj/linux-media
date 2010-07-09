Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55879 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0GITCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 15:02:09 -0400
Received: by iwn7 with SMTP id 7so2499141iwn.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 12:02:08 -0700 (PDT)
Message-ID: <4C37722F.8000102@gmail.com>
Date: Fri, 09 Jul 2010 15:02:07 -0400
From: Ivan <ivan.q.public@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 [eb1a:2860]
References: <4C353039.4030202@gmail.com>	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>	<4C360E64.3020703@gmail.com>	<AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>	<4C362C6E.5050104@gmail.com>	<AANLkTikCrka3EyqhjP7z6wYQa4Z8exDa9Dwda60OLsVJ@mail.gmail.com>	<4C363692.5000600@gmail.com>	<4C364416.3000809@gmail.com>	<AANLkTimRQaFDzKTXAIxIs2lT7ldrMwMNIFSJN4VzJOQQ@mail.gmail.com>	<4C364CD3.3080106@gmail.com>	<4C371A74.4080901@redhat.com>	<4C375A07.7010205@gmail.com>	<4C376479.2030101@redhat.com> <AANLkTilSonpCN_gzfsOYVaMpXbmfPFVi6Wdxb06dK7W1@mail.gmail.com>
In-Reply-To: <AANLkTilSonpCN_gzfsOYVaMpXbmfPFVi6Wdxb06dK7W1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2010 02:12 PM, Devin Heitmueller wrote:
> On Fri, Jul 9, 2010 at 2:03 PM, Mauro Carvalho Chehab wrote:
>> Well, it depends. What are your video adapter card? ATI? Nvidia?

Sorry Mauro, I misread your earlier comment. I thought you were talking 
about the capture device, not my graphics card. My video driver is 
indeed proprietary (Nvidia) and has terrible tearing issues, but at 
least it doesn't do anything as bad as introduce vertical stripes with 
periodicity 4.3. :^D

> The problem he's having now with the latest is the picture appears to
> be shifted. I have to wonder if perhaps I screwed something up when I
> did the VBI support, in that it may not work properly when the scaler
> is in use.
>
> I will have to do some testing.

By the way, if you can't find other hardware that exhibits the same 
problem, let me know what I can do to help.

I tried other picture resolutions and found that the shifting only 
happens when the picture height is the full 480. If you fix the height 
at 480 and let the width vary, the picture is shifted over by 1/4 of the 
width (or 3/4, depending how you look at it), except when the width is 
very close to 720. At width 718 the shift is more like 1/3, and then at 
width 720 the picture isn't shifted at all. Here are some tarred up 
snapshots if you want to take a look:

http://ifile.it/hpui0j4/em28xx-height480.tar

Ivan
