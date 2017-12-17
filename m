Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34353 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752395AbdLQN1y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 08:27:54 -0500
Date: Sun, 17 Dec 2017 11:27:38 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Josef Griebichler <griebichler.josef@gmx.at>, lcaumont2@gmail.com,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20171217112738.4f3a4f9b@recife.lan>
In-Reply-To: <20171217120634.pmmuhdqyqmbkxrvl@gofer.mess.org>
References: <trinity-35b3a044-b548-4a31-9646-ed9bc83e6846-1513505978471@3c-app-gmx-bs03>
        <20171217120634.pmmuhdqyqmbkxrvl@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 17 Dec 2017 12:06:37 +0000
Sean Young <sean@mess.org> escreveu:

> Hi Josef,

Em Sun, 17 Dec 2017 11:19:38 +0100
"Josef Griebichler" <griebichler.josef@gmx.at> escreveu:

> > Hello Mr. Caumont,
> >  
> > since switch to kernel 4.9 there are several users which have issues with their usb dvb cards.
> > Some get artifacts when watching livetv, I'm getting discontinuity errors in tvheadend when recording.
> > I'm using latest test build of LibreElec with kernel 4.14.6 but the issues are still there.
> > There's an librelec forum thread for this topic
> > https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/
> > and also an open kernel bug
> > https://bugzilla.kernel.org/show_bug.cgi?id=197835
> >  
> > This is my dmesg http://sprunge.us/WRIE
> > and tvh service log http://sprunge.us/bEiE
> >  
> > I saw in kernel changelog that you made an improvement/change for dvb und usb (commit 9a11204d2b26324636ff54f8d28095ed5dd17e91)
> >  
> > Is there anything that can be done to improve our situation or are we forced to stay with kernel 4.8?
> >  
> > Thanks for support!
> >  
> > Josef
> 
> Between kernel v4.8 and v4.9 there are many changes, and it is unlikely that
> commit 9a11204d2b26324636ff54f8d28095ed5dd17e91 is responsible for this.

Let me add linux-media@vger.kernel.org and linux-usb@vger.kernel.org ML.

Josef, Please be sure that your e-mailer won't be sending e-mails with
HTML tags on it, otherwise the ML server will automatically drop.

> What would be really helpful is if you could find out which commit did
> cause a regression. This can be done by bisecting the kernel. There are
> various guides to this:
> 
> 	https://wiki.ubuntu.com/Kernel/KernelBisection
> or
> 	https://wiki.archlinux.org/index.php/Bisecting_bugs
> 
> Once the commit has been identified we can work together to narrow it down
> to the exact change, and then work together on a fix.

Yeah, we need more data in order to start tracking it. I suspect,
however, that a simple git bisect may not work in this case, due to the
USB changes that forbids DMA on stack that was added to Kernel 4.9, if
the card Josef is using was affected by such change.

Probably, he'll need to disable CONFIG_VMAP_STACK in the middle
of bisect (e. g. when the patch that implements it is added), 
or to cherry-pick any needed DMA fixup patch on the top of Kernel
4.8 before starting bisect.

It is also worth mentioning what's the USB host controller that
are used, and what's the media driver, as this could be an issue
there.

That's said, from the bug report, it seems that this is
happening on RPi3. Could you please test it also on a PC? That
will help to identify if the bug is at RPi's host driver or
on media drivers.

With regards to RPi3, there are actually two different drivers
for it: one used on Raspbian Kernel, and another one upstream.
They're completely different ones.

What driver are you using?

Thanks,
Mauro
