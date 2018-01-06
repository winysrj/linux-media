Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:36625 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1753069AbeAFVoW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Jan 2018 16:44:22 -0500
Date: Sat, 6 Jan 2018 16:44:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        <torvalds@linux-foundation.org>
Subject: Re: dvb usb issues since kernel 4.9
In-Reply-To: <20180106175420.275e24e7@recife.lan>
Message-ID: <Pine.LNX.4.44L0.1801061638220.12069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 6 Jan 2018, Mauro Carvalho Chehab wrote:

> Hi Josef,
> 
> Em Sat, 6 Jan 2018 16:04:16 +0100
> "Josef Griebichler" <griebichler.josef@gmx.at> escreveu:
> 
> > Hi,
> > 
> > the causing commit has been identified.
> > After reverting commit https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4cd13c21b207e80ddb1144c576500098f2d5f882
> > its working again.
> 
> Just replying to me won't magically fix this. The ones that were involved on
> this patch should also be c/c, plus USB people. Just added them.
> 
> > Please have a look into the thread https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?pageNo=13
> > here are several users aknowledging the revert solves their issues with usb dvb cards.
> 
> I read the entire (long) thread there. In order to make easier for the
> others, from what I understand, the problem happens on both x86 and arm,
> although almost all comments there are mentioning tests with raspbian
> Kernel (with uses a different USB host driver than the upstream one).
> 
> It happens when watching digital TV DVB-C channels, with usually means
> a sustained bit rate of 11 MBps to 54 MBps.
> 
> The reports mention the dvbsky, with uses USB URB bulk transfers.
> On every several minutes (5 to 10 mins), the stream suffer "glitches"
> caused by frame losses.
> 
> The part of the thread that contains the bisect is at:
> 	https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=75965#post75965
> 
> It indirectly mentions another comment on the thread with points
> to:
> 	https://github.com/raspberrypi/linux/issues/2134
> 
> There, it says that this fix part of the issues:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=34f41c0316ed52b0b44542491d89278efdaa70e4
> 
> but it affects URB packet losses on a lesser extend.
> 
> The main issue is really the logic changes a the core softirq logic.
> 
> Using Kernel 4.14.10 on a Raspberry Pi 3 with 4cd13c2 commit reverted
> fixed the issue. 
> 
> Joseph, is the above right? Anything else to mention? Does the
> same issue affect also on x86 with vanilla Kernel 4.14.10?
> 
> -
> 
> It seems that the original patch were designed to solve some IRQ issues
> with network cards with causes data losses on high traffic. However,
> it is also causing bad effects on sustained high bandwidth demands
> required by DVB cards, at least on some USB host drivers.
> 
> Alan/Greg/Eric/David:
> 
> Any ideas about how to fix it without causing regressions to
> network?

It would be good to know what hardware was involved on the x86 system
and to have some timing data.  Can we see the output from lsusb and
usbmon, running on a vanilla kernel that gets plenty of video glitches?

Overall, this may be a very difficult problem to solve.  The
4cd13c21b207 commit was intended to improve throughput at the cost of
increased latency.  But then what do you do when the latency becomes
too high for the video subsystem to handle?

Alan Stern
