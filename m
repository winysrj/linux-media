Return-path: <linux-media-owner@vger.kernel.org>
Received: from april.london.02.net ([87.194.255.143]:45161 "EHLO
	april.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZHFUdz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 16:33:55 -0400
From: Derek Jennings <derek@jennings.homelinux.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Hauppauge Nova-T 500 regression in dib0700
Date: Thu, 6 Aug 2009 21:33:46 +0100
Cc: linux-media@vger.kernel.org
References: <200908052337.37908.derek@jennings.homelinux.net> <829197380908051809w6feb0febicd579eec1a03967b@mail.gmail.com>
In-Reply-To: <829197380908051809w6feb0febicd579eec1a03967b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908062133.46473.derek@jennings.homelinux.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 06 August 2009 02:09:06 Devin Heitmueller wrote:
> On Wed, Aug 5, 2009 at 6:37 PM, Derek
>
> Jennings<derek@jennings.homelinux.net> wrote:
> > Hi
> > I have been chasing a problem with my Hauppauge Nova-T 500 Dual DVB-T
> > card and think it is the same problem reported here
> > http://osdir.com/ml/linux-media/2009-02/msg00948.html
> >
> > The card worked perfectly with kernel-2.6.27 with firmware
> > dvb-usb-dib0700-1.10.fw (I had to rename the firmware to
> > dvb-usb-dib0700-1.20.fw to get it to load)
> >
> > With kernel-2.6.29 or 2.6.31 and firmware 1.10 the card would not Lock to
> > the signal (using mythtv)
> > Using firmware 1.20 the card would lock to the signal, but after 1 or 2
> > minutes the usb driver would fail
> >
> > klogd: usb 2-1: new high speed USB device using ehci_hcd and address 2
> > klogd: usb 2-1: New USB device found, idVendor=2040, idProduct=9950
> > klogd: usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > klogd: usb 2-1: Product: WinTV Nova-DT
> > klogd: usb 2-1: Manufacturer: Hauppauge
> > klogd: usb 2-1: SerialNumber: 4028965283
> > klogd: usb 2-1: configuration #1 chosen from 1 choice
> > klogd: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
> > klogd: dvb-usb: will pass the complete MPEG2 transport stream to the
> > software demuxer.
> > klogd: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
> > klogd: DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
> > klogd: MT2060: successfully identified (IF1 = 1239)
> > klogd: dvb-usb: will pass the complete MPEG2 transport stream to the
> > software demuxer.
> > klogd: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
> > klogd: DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
> > klogd: MT2060: successfully identified (IF1 = 1222)
> > klogd: input: IR-receiver inside an USB DVB receiver
> > as /devices/pci0000:00/0000:00:1e.0/0000:04:00.2/usb2/2-1/input/input3
> > klogd: dvb-usb: schedule remote query interval to 50 msecs.
> > klogd: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized
> > and connected.
> >
> > After a few minutes of operation
> >
> > klogd: ehci_hcd 0000:04:00.2: force halt; handhake f8018014 00004000
> > 00000000 -> -110
> >
> > I downloaded and compiled the current v4l source and confirmed it had the
> > same problem.
> >
> > I then removed this commit mentioned in the earlier post from the current
> > v4l source http://linuxtv.org/hg/v4l-dvb/rev/561b447ade77
> > and recompiled the module.
> >
> > SUCCESS! with the commit removed the card works with kernel 2.6.29 and
> > the 1.10 firmware, but not with the 1.20 firmware which will not Lock to
> > the signal.
> >
> > I have no idea why that commit causes problems, but with it removed the
> > operation of the card is just as good as it was under the 2.6.27 kernel.
> >
> > Thanks
> >
> > Derek
>
> Well that is pretty annoying.  :-)
>
> There have been almost no changes to the core dib0700 driver in recent
> releases, suggesting that the issue is that something got broken in
> the onboard Via USB host controller chipset driver which causes it to
> not properly handle bulk read timeouts (the bulk pipe for the IR
> support is on a different endpoint than the data transport so they in
> theory should be unrelated).  This would also explain why nobody is
> reporting problems with any of the other dib0700 designs.
>
> A user mailed me a card which arrived last week.  I will have to see
> if I can take a look when I get a chance.
>
> In the meantime, if you want to try to bisect the kernel between the
> patch you reverted and the current 2.6.31 and see when it stops
> working, that would be very useful (if we can nail it down to one of
> the patches made to the via controller).  While rolling back the patch
> in question appears to make the problem go away, I don't believe it is
> the actual cause of the problem, but rather that it exposed a bug
> introduced later in the Via driver.
>
> Devin

I tried today with kernel-2.27.29  - Worked OK
and also with kernel-2.28.2 - Failed
Looking at the changelog I see the patch I reverted was introduced in 2.28.1 
so it is no surprise the 2.27.29 kernel works.

I will try applying the latest v4l to an earlier 2.27 kernel until I find one 
in which it works.

Thanks for your help

Derek
