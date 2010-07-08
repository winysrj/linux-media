Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43583 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0GHUCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 16:02:30 -0400
Received: by eya25 with SMTP id 25so167158eya.19
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 13:02:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C362C6E.5050104@gmail.com>
References: <4C353039.4030202@gmail.com>
	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>
	<4C360E64.3020703@gmail.com>
	<AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>
	<4C362C6E.5050104@gmail.com>
Date: Thu, 8 Jul 2010 16:02:28 -0400
Message-ID: <AANLkTikCrka3EyqhjP7z6wYQa4Z8exDa9Dwda60OLsVJ@mail.gmail.com>
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
	[eb1a:2860]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ivan <ivan.q.public@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 8, 2010 at 3:52 PM, Ivan <ivan.q.public@gmail.com> wrote:
> On 07/08/2010 01:52 PM, Devin Heitmueller wrote:
>>
>> The vertical stripes were a problem with the anti-alias filter
>> configuration, which I fixed a few months ago (and probably just
>> hasn't made it into your distribution).  Just install the current
>> v4l-dvb code and it should go away:
>>
>> http://linuxtv.org/repo
>
> Yep, that gets rid of the vertical stripes but adds in a lovely horizontal
> shift:
>
> http://www3.picturepush.com/photo/a/3763906/img/3763906.png
>
> Also, vertical lines look slightly more ragged than they did before, to my
> eye at least.
>
> I'm also encountering this old compilation problem:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg06865.html
>
> I worked around it by disabling firedtv in v4l/.config. (I'm running
> 2.6.32-23-generic on Ubuntu Lucid.)
>
> Ivan
>

The "jagged vertical lines" is probably this issue, which was fixed in
git but the fix hasn't hit the hg repository yet:

http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=9db74cf24c038292d353d746cec11f6da368ef4c

The "horizontal shift" issue is interesting.  Does that happen every
time?  And did you unplug/replug the device?  Try to reboot?

Regarding the compilation issue, yeah it's annoying.  Perhaps someday
the Ubuntu people will fix their kernel packaging process.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
