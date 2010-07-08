Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60082 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab0GHVdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 17:33:14 -0400
Received: by iwn7 with SMTP id 7so1326915iwn.19
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 14:33:14 -0700 (PDT)
Message-ID: <4C364416.3000809@gmail.com>
Date: Thu, 08 Jul 2010 17:33:10 -0400
From: Ivan <ivan.q.public@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 [eb1a:2860]
References: <4C353039.4030202@gmail.com>	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>	<4C360E64.3020703@gmail.com>	<AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>	<4C362C6E.5050104@gmail.com> <AANLkTikCrka3EyqhjP7z6wYQa4Z8exDa9Dwda60OLsVJ@mail.gmail.com> <4C363692.5000600@gmail.com>
In-Reply-To: <4C363692.5000600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2010 04:35 PM, Ivan wrote:
> On 07/08/2010 04:02 PM, Devin Heitmueller wrote:
>> On Thu, Jul 8, 2010 at 3:52 PM, Ivan<ivan.q.public@gmail.com> wrote:
>>> Yep, that gets rid of the vertical stripes but adds in a lovely
>>> horizontal
>>> shift:
>>>
>>> http://www3.picturepush.com/photo/a/3763906/img/3763906.png
>>
>> The "horizontal shift" issue is interesting. Does that happen every
>> time? And did you unplug/replug the device? Try to reboot?
>
> Reboot? What is this, Windoze? :^D
>
> But yeah, it's consistent across unplugs/replugs/reboots.

Ok, the horizontal shift disappears if I switch to 720x480 instead of 
640x480.

Does the card always output 720x480 (in NTSC mode anyway), then, and any 
scaling is done by V4L?

I also have a question about dropped frames. After running mplayer or 
mencoder, I see a line like:

v4l2: 1199 frames successfully processed, -3 frames dropped.

I can only guess that the negative number means that V4L received frames 
at a slightly faster rate than the expected 30000/1001 fps. In my case, 
it would seem that my SNES is producing something more like 30.05 fps, 
and so V4L reports a "negative" dropped frame every 12.5 seconds or so.

It would also seem that V4L doesn't actually discard any frames, but 
still passes them on to mplayer/mencoder, because mencoder shows an 
encoding fps of 30.04 (and it will skip a frame every 12.5 seconds or so 
unless you pass it -noskip).

Am I right about all this?

Ivan
