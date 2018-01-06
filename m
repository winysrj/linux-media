Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52987 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753014AbeAFVIL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Jan 2018 16:08:11 -0500
MIME-Version: 1.0
Message-ID: <trinity-ff9e0b66-eb15-4bc5-855b-e774e1f0c204-1515272841898@3c-app-gmx-bs80>
From: "Josef Griebichler" <griebichler.josef@gmx.at>
To: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hannes Frederic Sowa" <hannes@redhat.com>,
        "Jesper Dangaard Brouer" <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
Subject: Aw: Re: dvb usb issues since kernel 4.9
Content-Type: text/plain; charset=UTF-8
Date: Sat, 6 Jan 2018 22:07:21 +0100
In-Reply-To: <20180106175420.275e24e7@recife.lan>
References: <trinity-35b3a044-b548-4a31-9646-ed9bc83e6846-1513505978471@3c-app-gmx-bs03>
 <20171217120634.pmmuhdqyqmbkxrvl@gofer.mess.org>
 <20171217112738.4f3a4f9b@recife.lan>
 <trinity-1fa14556-8596-44b1-95cb-b8919d94d2d4-1515251056328@3c-app-gmx-bs15>
 <20180106175420.275e24e7@recife.lan>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

thanks for adding the people involved!
Yes arm and x86 are affected.
Bisecting was not done by me on a x86_64 machine on mainline kernel and not raspbian kernel (https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=75965#post75965). In the mentioned post you also find the bisect log.

I'm using a dvb-s/s2 usb tv card (technotrend s2-4600 with firmware dvb-fe-ds3103.fw, components M88DS3103, M88TS2022), so not only dvb-c is affected.

Yes kernel 4.14.10 with revert of the mentioned commit works as before on kernel 4.8 with rpi3.

I hope this is of some help.

Regards,
Josef

Hi Josef,

Em Sat, 6 Jan 2018 16:04:16 +0100
"Josef Griebichler" <griebichler.josef@gmx.at> escreveu:

> Hi,
>
> the causing commit has been identified.
> After reverting commit https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4cd13c21b207e80ddb1144c576500098f2d5f882
> its working again.

Just replying to me won't magically fix this. The ones that were involved on
this patch should also be c/c, plus USB people. Just added them.

> Please have a look into the thread https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?pageNo=13[https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?pageNo=13]
> here are several users aknowledging the revert solves their issues with usb dvb cards.

I read the entire (long) thread there. In order to make easier for the
others, from what I understand, the problem happens on both x86 and arm,
although almost all comments there are mentioning tests with raspbian
Kernel (with uses a different USB host driver than the upstream one).

It happens when watching digital TV DVB-C channels, with usually means
a sustained bit rate of 11 MBps to 54 MBps.

The reports mention the dvbsky, with uses USB URB bulk transfers.
On every several minutes (5 to 10 mins), the stream suffer "glitches"
caused by frame losses.

The part of the thread that contains the bisect is at:
https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=75965#post75965[https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=75965#post75965]

It indirectly mentions another comment on the thread with points
to:
https://github.com/raspberrypi/linux/issues/2134[https://github.com/raspberrypi/linux/issues/2134]

There, it says that this fix part of the issues:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=34f41c0316ed52b0b44542491d89278efdaa70e4[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=34f41c0316ed52b0b44542491d89278efdaa70e4]

but it affects URB packet losses on a lesser extend.

The main issue is really the logic changes a the core softirq logic.

Using Kernel 4.14.10 on a Raspberry Pi 3 with 4cd13c2 commit reverted
fixed the issue.

Joseph, is the above right? Anything else to mention? Does the
same issue affect also on x86 with vanilla Kernel 4.14.10?

-

It seems that the original patch were designed to solve some IRQ issues
with network cards with causes data losses on high traffic. However,
it is also causing bad effects on sustained high bandwidth demands
required by DVB cards, at least on some USB host drivers.

Alan/Greg/Eric/David:

Any ideas about how to fix it without causing regressions to
network?

Regards,
Mauro

> Gesendet: Sonntag, 17. Dezember 2017 um 14:27 Uhr
> Von: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>
> An: "Sean Young" <sean@mess.org>
> Cc: "Josef Griebichler" <griebichler.josef@gmx.at>, lcaumont2@gmail.com, gregkh@linuxfoundation.org, linux-media@vger.kernel.org, linux-usb@vger.kernel.org
> Betreff: Re: dvb usb issues since kernel 4.9
> Em Sun, 17 Dec 2017 12:06:37 +0000
> Sean Young <sean@mess.org> escreveu:
>
> > Hi Josef,
>
> Em Sun, 17 Dec 2017 11:19:38 +0100
> "Josef Griebichler" <griebichler.josef@gmx.at> escreveu:
>
> > > Hello Mr. Caumont,
> > >
> > > since switch to kernel 4.9 there are several users which have issues with their usb dvb cards.
> > > Some get artifacts when watching livetv, I'm getting discontinuity errors in tvheadend when recording.
> > > I'm using latest test build of LibreElec with kernel 4.14.6 but the issues are still there.
> > > There's an librelec forum thread for this topic
> > > https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/[https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/]
> > > and also an open kernel bug
> > > https://bugzilla.kernel.org/show_bug.cgi?id=197835[https://bugzilla.kernel.org/show_bug.cgi?id=197835][https://bugzilla.kernel.org/show_bug.cgi?id=197835[https://bugzilla.kernel.org/show_bug.cgi?id=197835]]
> > >
> > > This is my dmesg http://sprunge.us/WRIE[http://sprunge.us/WRIE][http://sprunge.us/WRIE[http://sprunge.us/WRIE]]
> > > and tvh service log http://sprunge.us/bEiE[http://sprunge.us/bEiE][http://sprunge.us/bEiE[http://sprunge.us/bEiE]]
> > >
> > > I saw in kernel changelog that you made an improvement/change for dvb und usb (commit 9a11204d2b26324636ff54f8d28095ed5dd17e91)
> > >
> > > Is there anything that can be done to improve our situation or are we forced to stay with kernel 4.8?
> > >
> > > Thanks for support!
> > >
> > > Josef
> >
> > Between kernel v4.8 and v4.9 there are many changes, and it is unlikely that
> > commit 9a11204d2b26324636ff54f8d28095ed5dd17e91 is responsible for this.
>
> Let me add linux-media@vger.kernel.org and linux-usb@vger.kernel.org ML.
>
> Josef, Please be sure that your e-mailer won't be sending e-mails with
> HTML tags on it, otherwise the ML server will automatically drop.
>
> > What would be really helpful is if you could find out which commit did
> > cause a regression. This can be done by bisecting the kernel. There are
> > various guides to this:
> >
> > https://wiki.ubuntu.com/Kernel/KernelBisection[https://wiki.ubuntu.com/Kernel/KernelBisection][https://wiki.ubuntu.com/Kernel/KernelBisection[https://wiki.ubuntu.com/Kernel/KernelBisection]]
> > or
> > https://wiki.archlinux.org/index.php/Bisecting_bugs[https://wiki.archlinux.org/index.php/Bisecting_bugs][https://wiki.archlinux.org/index.php/Bisecting_bugs[https://wiki.archlinux.org/index.php/Bisecting_bugs]]
> >
> > Once the commit has been identified we can work together to narrow it down
> > to the exact change, and then work together on a fix.
>
> Yeah, we need more data in order to start tracking it. I suspect,
> however, that a simple git bisect may not work in this case, due to the
> USB changes that forbids DMA on stack that was added to Kernel 4.9, if
> the card Josef is using was affected by such change.
>
> Probably, he'll need to disable CONFIG_VMAP_STACK in the middle
> of bisect (e. g. when the patch that implements it is added),
> or to cherry-pick any needed DMA fixup patch on the top of Kernel
> 4.8 before starting bisect.
>
> It is also worth mentioning what's the USB host controller that
> are used, and what's the media driver, as this could be an issue
> there.
>
> That's said, from the bug report, it seems that this is
> happening on RPi3. Could you please test it also on a PC? That
> will help to identify if the bug is at RPi's host driver or
> on media drivers.
>
> With regards to RPi3, there are actually two different drivers
> for it: one used on Raspbian Kernel, and another one upstream.
> They're completely different ones.
>
> What driver are you using?
>
> Thanks,
> Mauro



Thanks,
Mauro
