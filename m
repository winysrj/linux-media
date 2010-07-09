Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41596 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390Ab0GIRTH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 13:19:07 -0400
Received: by iwn7 with SMTP id 7so2406104iwn.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 10:19:06 -0700 (PDT)
Message-ID: <4C375A07.7010205@gmail.com>
Date: Fri, 09 Jul 2010 13:19:03 -0400
From: Ivan <ivan.q.public@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 [eb1a:2860]
References: <4C353039.4030202@gmail.com>	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>	<4C360E64.3020703@gmail.com>	<AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>	<4C362C6E.5050104@gmail.com>	<AANLkTikCrka3EyqhjP7z6wYQa4Z8exDa9Dwda60OLsVJ@mail.gmail.com>	<4C363692.5000600@gmail.com>	<4C364416.3000809@gmail.com> <AANLkTimRQaFDzKTXAIxIs2lT7ldrMwMNIFSJN4VzJOQQ@mail.gmail.com> <4C364CD3.3080106@gmail.com> <4C371A74.4080901@redhat.com>
In-Reply-To: <4C371A74.4080901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2010 08:47 AM, Mauro Carvalho Chehab wrote:
> I never saw the em28xx scaler generating such vertical stripes. This
> could be a mplayer or a video adapter driver problem. Are you using a
> proprietary video driver? You may try to use ffmeg or mencoder to
> generate a mpeg file at 640x480 and then try to play it on another
> player (preferably on another machine), to see if this problem
> disappears.

Huh? Does there even *exist* a proprietary linux driver for my card? And 
because you never saw stripes with em28xx, they must not exist? :^P

You might want to reread the thread-- we already figured the stripes out.

>>>> v4l2: 1199 frames successfully processed, -3 frames dropped.
>
> This is not a V4L issue.

I'm aware of that by now.

> A negative number of dropping frames makes no sense. It is probably a
> mplayer bug. I would try to get a newer version of mplayer and double
> check.

Newer than latest svn? :^D

If you look at the mplayer code that calculates the supposed number of 
frames dropped (it's in stream/tvi_v4l2.c), it would seem that it's just 
an indicator of how close the stream came to the nominal framerate 
(30000/1001 in my case).

In other words, if mplayer sees an actual framerate of less than 29.97 
coming from v4l, it assumes (perhaps incorrectly) that this is because 
some frames were dropped. If you do the same calculation when the actual 
framerate is greater than 29.97, you get a negative number of dropped 
frames. It looks weird, but it makes a kind of sense if you know what it 
really means.
