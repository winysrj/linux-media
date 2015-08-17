Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60824 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbbHQUfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2015 16:35:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ZRR7Z-0001l9-NI
	for linux-media@vger.kernel.org; Mon, 17 Aug 2015 22:35:05 +0200
Received: from ip-84-119-160-38.unity-media.net ([84.119.160.38])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 17 Aug 2015 22:35:05 +0200
Received: from sp170388 by ip-84-119-160-38.unity-media.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 17 Aug 2015 22:35:05 +0200
To: linux-media@vger.kernel.org
From: BadTenMan <sp170388@hotmail.com>
Subject: Re: terratec HTC XS HD USB
Date: Mon, 17 Aug 2015 20:28:58 +0000 (UTC)
Message-ID: <loom.20150817T222801-896@post.gmane.org>
References: <CAE1c1rTnU3svGTKgv3-u0DS3Tb+KKZHmn0=4fp1CrUZZ8b8gGA@mail.gmail.com> <CAE1c1rTkF2S612YN_NAbA6UP8xVTXzA8ys6WKhPX9ZXx0j07aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert N <nrobert13 <at> gmail.com> writes:

> 
> I will reply my own question. it seems that w_scan is able to find the
> muxes/services if I push the antenna cable only half way into the
> tuner stick. I assume my problem is related to RF signal strength. is
> there a range of valid strengths?
> 
> On Fri, Nov 21, 2014 at 5:13 PM, Robert N <nrobert13 <at> gmail.com> wrote:
> > Hi,
> >
> > I'm trying to get my USB tuner stick working on an openwrt, but
> > getting some errors.
> >
> > using w_scan to scan the available channels, gives:
> >
> > 113000: sr6900 (time: 00:11) (time: 00:12) signal ok:
> >         QAM_64   f = 113000 kHz S6900C999
> > start_filter:1410: ERROR: ioctl DMX_SET_FILTER failed: 97 Message too long
> > Info: NIT(actual) filter timeout
> >
> > I know the 113Mhz is a valid MUX, because tuner works well under windows.
> >
> > Any hints what could be the reason of the error messages?
> >
> > Thanks.
> 


Hi Robert,

I am trying to do achieve the exact same thing as you.
My hardware:
TP-Link Archer C5 with OpenWRT 14.07 Barrier Breaker
Terratec HTC XS HD USB
(http://www.terratec.net/details.php?artnr=Cinergy+HTC+USB+XS+HD)

I built OpenWRT from source which worked fine. But now after inserting the
kernel modules for the TV stick and the firmware, I can't get tvheadend to
perform a scan and w_scan to find anything.

First it threw the same error as you encountered (that's how I found you).
Thanks to your trick the error is gone, but still no signal, it recognizes a
valid mux at 121Mhz, but no channels.

My dmesg looks good, just as on the Ubuntu machine where the stick works.

I don't know the specifications (RF signal strength) of the stick, but it
seems that it is a little bit vulnerable to signal errors. On the Ubuntu
machine it sometimes has stuttering video for me.

Have you found a solution to make the stick work?
If you could share it that would be really great.

Best Regards,
BadTenMan

