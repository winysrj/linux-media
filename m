Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52664 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1FQTnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 15:43:49 -0400
Received: by vws1 with SMTP id 1so2203453vws.19
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2011 12:43:49 -0700 (PDT)
References: <BANLkTiksjC8SyYGdfLbF4eSYhR2c9qEzsw@mail.gmail.com> <loom.20110614T130028-939@post.gmane.org>
In-Reply-To: <loom.20110614T130028-939@post.gmane.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <4B817B90-30D0-458B-B62F-6F300DF9C3C6@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Latest media-tree results in system hang, an no IR.
Date: Fri, 17 Jun 2011 15:43:42 -0400
To: JD <jdg8tb@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 14, 2011, at 7:10 AM, JD wrote:

> JD <jdg8tb <at> gmail.com> writes:
> 
>> 
>> With the latest media-tree, any access to my TV card (using tvtime and
>> mplayer to watch through composite) results in my Arch Linux (2.6.39)
>> system freezing. Here is the relavent part of my dmesg upon the
>> freeze:
>> 
>> http://codepad.org/q5MxDqAI
>> 
>> I compiled the latest media-tree in order to, finally, get my infrared
>> receiver working, however it still does not.
>> An entry is made in /proc/bus/input/devices which points to
>> /dev/input/event5; however. the /dev/lirc device node is not present,
>> and using "irw" does not seem to recognise any input.
>> 
>> Is anyone else experiencing such issues, and has anyone managed to get
>> IR actually working on the HVR-1120.
>> 
>> Thanks.
>> 
> 
> 
> I've have just tried this again on a fresh install of Arch Linux (Linux media
> 2.6.39-ARCH #1); however it is still a no-go.
> 
> My steps are as follows:
> 
> 1. git clone git://linuxtv.org/media_build.git
> 2. ./build.sh (reports it built fine with no errors)
> 3. reboot system (errors are now reported during boot-up, see dmesg)
> 
> 4. try to access tv card using any program (mplayer or tvtime to watch
> composite), my X server crashes, I am thrown out to a TTY and the system appears
> unresponsive.
> 
> 
> dmesg (line 720 is where things start to appear interesting):
> http://codepad.org/OaeWUfAp

So thanks to Devin, I've got an 1150 here, which is identical to the 1120,
save swapping out a DVB-T demod for an ATSC demod. I've tried, and I'm not
able to reproduce what you're seeing -- which seems to be triggered by a
udev rule that calls /lib/udev/v4l_id. I see that run here too, but no
hang. I'm on a different distro though, and defaulting to NTSC instead of
PAL, which could be somehow relevant here.

If you disable the udev rule (/lib/udev/rules.d/60-persisten-v4l.rules if
I'm remembering correctly), do things come up okay? It could well be that
for some reason, in your setup, that rule is running while the card isn't
actually all the way initialized.

Assuming that helps, IR *should* be working, though you'll need the two
patches I posted yesterday to make it behave better. With those, the 1150
is handling rc5 and rc6 decode both in-kernel and via lirc userspace just
fine now.


-- 
Jarod Wilson
jarod@wilsonet.com



