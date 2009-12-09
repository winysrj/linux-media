Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp124.mail.ukl.yahoo.com ([77.238.184.55]:44304 "HELO
	smtp124.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752552AbZLIJXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 04:23:00 -0500
Message-ID: <4B1F6AE3.20303@yahoo.co.uk>
Date: Wed, 09 Dec 2009 09:16:19 +0000
From: Lukasz Sokol <el_es_cr@yahoo.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org, rob@esdelle.co.uk
Subject: Re: WinTV HVR-900 USB (B3C0)
References: <4B1E8E4D.9010101@esdelle.co.uk>
In-Reply-To: <4B1E8E4D.9010101@esdelle.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rob Beard wrote:
> Hi folks,
> 
> I've borrowed a WinTV HVR-900 USB stick from a friend of mine to see if
> I can get any reception in my area before forking out for one however
> I've run in to a couple of problems and wondered if anyone had used one
> of these sticks?
> 
[snip]
> 
> I just wondered if anyone else had one of these sticks actually working
> under Ubuntu 9.10?  (I'm running kernel 2.6.31-16-generic-pae).
> 
> Rob
> 


Hi Rob,
this device uses empia chips.

I have a similar situation with Pinnacle Hybrid Pro 330e (yes, 3_3_0e) : the only
driver that works (and was great at it) was Markus Rechberger's em28xx-new project.
(my device has cx88 tuner IIRC). The em28xx-new project had some modifications to
some tuner drivers too. They were based both on RE and documentation for which
Markus had NDA's signed (a vague recollection of past googling).

The mainline kernel unfortunately does not support it out of the box, and it is not only
about the firmware you have to download; There is something severely nonfunctional.

Why am I writing in past tense ?
This driver (em28xx-new) has recently been abandoned, and its author went proprietary.
I was using a ubuntu package prepared by some ubuntu user, named gborzi.
Unfortunately the package cannot apply to more recent kernels any more.
The last kernel it worked with, was 2.6.27-14 (Ubuntu terminology) and I'm stuck with it.

I have emailed Markus but he seems to have lost any interest in the em28xx-new...
can't blame him though, he gave his reasons, some of them unfortunately true. 

To v4l developers : as it is the case now that we can consider em28xx-new abandonware,
could somebody see, what got devices like ours working in his driver, and push it to 
mainline, please ? Just the DVB support would be fine...

To Markus : the above is not a call to _steal_your_code_ but merely to somebody have
a look and modify the mainline drivers so it could support A 5 YEAR OLD DEVICE like mine.
People could employ a 'clean room' like in alternative to Broadcom (b43) development.

At least mine, is a 5 YEARS OLD design (bought in 2006).
On my computer, which was middle spec 5 years ago, I've always had problems with this device
under Windows (XP) : 100% CPU on max frequency (1.6GHz) all the time, when playing.
Under Linux, stock Ubuntu 8.10 Kaffeine, and em28xx-new, it is max 30% CPU at lowest freq (800MHz)).

Stock em28xx driver only supports analog (with no sound under stock tvtime, supposedly patched tvtime required).

el es
