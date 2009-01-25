Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:36204 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZAYHqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 02:46:55 -0500
Received: by wf-out-1314.google.com with SMTP id 27so6374745wfd.4
        for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 23:46:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ae5231870901242342s29d4000ar87636127e1e28803@mail.gmail.com>
References: <20090123015815.GA22113@shibaya.lonestar.org>
	 <000201c97e3d$9bad71f0$0202a8c0@speedy>
	 <ae5231870901242342s29d4000ar87636127e1e28803@mail.gmail.com>
Date: Sun, 25 Jan 2009 18:16:53 +1030
Message-ID: <ae5231870901242346s7a7757a2j1f97f146a4e74fb9@mail.gmail.com>
Subject: Fwd: [linux-dvb] Leadtek WinFast PxDVR3200 H
From: Robert Golding <robert.golding@gmail.com>
To: DVB4Linux <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/1/25 Wayne and Holly <wayneandholly@alice.it>:
> Hello list,
> I have a Leadtek WinFast PxDVR3200 H that I am attempting to utilise with
> MythTV.  The Wiki site states that experimental support exists for the DVB
> side and that "Successful tuning of typical Australian channels" has been
> achieved.
> I am able to create a channels.conf (attached) using scan, and am then able
> to tune using mythtv-setup, however none of these channels are viewable with
> the mythfrontend due to it being unable to gain a lock.
>
> Relevant bits and pieces:
>
> scan, using the latest it-Varese file scan is able to tune to three of the
> five transponders as per the attached file "scan".  It also scans on
> 800000000Hz but I have no idea why.
>
> The file leadtek.dmesg contains the relevant info from dmesg (and
> messages.log) regarding the initialisation of the card itself.  There are no
> error messages at any time (that I am aware of) despite all of my fiddling
> about.
>
> Of the three transponders that are in my channels.conf file, the third one
> (618000000Hz) causes an error when tuning in mythtv-setup.  It states that
> channels are found but the tsid is incorrect.  As such, only the first two
> successful transponders (706000000 and 602000000) are tuned by myth.
>
> When I attempt to view the tuned channels, myth is unable to gain a lock on
> any of them.  The reported signal strength is about 58% and the S/N varies
> between 3 and 3.8dB.  I am able to tune DVB-T channels on my TV using the
> same aerial cable but am wondering if signal strength is an issue.
>
> I am running it on Kubuntu with a 2.6.24-19 kernel, I have a recent version
> of the v4l-dvb tree (approx Nov 08) and am using firmware version 2.7.  I
> haven't updated the drivers or the firmware as I have no reason to believe
> there are changes that would effect this.  That said, if someone thinks
> there has been changes I will get straight on it.
>
> I am more than happy to provide more debugging info if required (if you are
> willing to tell me where else to look) and appreciate any help provided.
>
> Cheers
> Wayne
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

I have the same card, so this might help.
I was experiencing many frontend problems when I came across a
references in the list to a third party firmware files.
It explained that you had to download and extract the firmware within
to the firmware dir.

I cannot remember exactly what, where and which, however, if you'd
like, I can email the extracted fw.tar.bz2(1.5MB) and
ivtv.firmware.tar.bz2(123KB) files to you.  Then just extract the
contents to your firmware dir (on Gentoo /lib/firmware).

Anyway, long story short, that fixed it for me.  Now I'm just waiting
to be able to use the FM radio.

--
Regards,        Robert

..... Some people can tell what time it is by looking at the sun, but
I have never been able to make out the numbers.
---
Errata: Spelling mistakes are not intentional, however, I don't use
spell checkers because it's too easy to allow the spell checker to
make the decisions and use words that are out of context for that
being written, i.e. their/there, your/you're, threw/through and even
accept/except, not to mention foreign (I'm Australian) English
spelling, i.e. colour/color, socks/sox, etc,.
