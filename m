Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42812 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbZJJHAm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2009 03:00:42 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MwVvw-0003xE-FH
	for linux-media@vger.kernel.org; Sat, 10 Oct 2009 09:00:05 +0200
Received: from 124-168-110-190.dyn.iinet.net.au ([124.168.110.190])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 10 Oct 2009 09:00:04 +0200
Received: from tom by 124-168-110-190.dyn.iinet.net.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 10 Oct 2009 09:00:04 +0200
To: linux-media@vger.kernel.org
From: Tom Clift <tom@clift.name>
Subject: Re: My DVB-card is flooding the consol with 
Date: Sat, 10 Oct 2009 06:54:58 +0000 (UTC)
Message-ID: <loom.20091010T083344-450@post.gmane.org>
References: <20090615113315.0fdfbe62.bhepple@promptu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bob Hepple <bhepple <at> promptu.com> writes:

> To add another data-point, I am also getting this error with the same
> board ... as far as I have been able to test, it's something that was
> OK in 2.6.27, regressed in 2.6.28 and is still a problem in 2.6.30.
> 
> Note that this is the rev.1 DViCO
...
> I get spammed by this console message every 1 second and the board does not
> operate:
> [ 375.385180] dvb-usb: bulk message failed: -110 (4/0)
...
> So I put in a new disc and installed Fedora-10 (2.6.27) with the same
> firmware: /lib/firmware/xc3028-v27.fw
> ... and it's working fine now.

Same here.  I hadn't touched my kernel for some time for fear of breaking things
(getting it working was a trial).  Recently tried with a new kernel on a
different drive and the card didn't work.

Working on: 2.6.22 (Gentoo) with patches by Michael Krufky and Australian
firmware by Chris Pascoe.

Not working on: 2.6.28 (Mythbuntu 9.04) both stock and built from the v4l-dvb
repo.

I also tried a 2.6.30 kernel and an earlier 2.6.28 kernel with both the stock
driver and built from the v4l-dvb repo - none worked.  Also tried going back to
older v4l-dvb revisions, but this was hit and miss as they often wouldn't build
(the few successful builds didn't work).  Unfortunately I can't easily try a
2.6.27 kernel, but if it comes to that I can probably re-install with an older
distro.

Bob, I'd agree that it seems the DViCO Dual Digital 4 rev.1 was working in
2.6.27, regressed in 2.6.28, and still not working in 2.6.30.

I'd like to hear from anyone who has a DD4 rev.1 working in 2.6.30 or later.
I'm also in Australia, but this time I don't think that is a factor (unlike the
firmware shenanigans several years ago).  Just a hunch though.

For the record, my dmesg shows:
----
[  178.599125] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, t
ype: xc2028 firmware, ver 2.7
[  178.609325] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 000
0000000000000.
[  183.165027] xc2028 2-0061: Loading firmware for type=D2633 DTV7 (90), id 00
00000000000000.
[  183.245019] xc2028 2-0061: Loading SCODE for type=SCODE HAS_IF_5260 (600000
00), id 0000000000000000.
[  185.400150] dvb-usb: recv bulk message failed: -110
[  185.400162] zl10353: write to reg 62 failed (err = -121)!
[  187.400099] dvb-usb: bulk message failed: -110 (5/0)
[  187.400112] zl10353: write to reg 50 failed (err = -121)!
[  189.411540] dvb-usb: bulk message failed: -110 (2/0)
[  191.408114] dvb-usb: bulk message failed: -110 (4/0)
[  191.408124] cxusb: i2c read failed
[  193.508151] dvb-usb: bulk message failed: -110 (4/0)
[  193.508160] cxusb: i2c read failed
----
(last 2 lines repeating)

- Tom

