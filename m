Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:57085 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbZHBBCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Aug 2009 21:02:22 -0400
Subject: Re: USB devices supporting raw or sliced VBI for closed captioning?
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steve Castellotti <sc@eyemagnet.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0907311845r259b129em3bd89b7915718cd5@mail.gmail.com>
References: <1249082438.18313.30.camel@odyssey.sc.user.nz.vpn>
	 <d9def9db0907311845r259b129em3bd89b7915718cd5@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 02:49:19 +0200
Message-Id: <1249174159.3255.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 01.08.2009, 03:45 +0200 schrieb Markus Rechberger:
> Hi,
> 
> On Sat, Aug 1, 2009 at 1:20 AM, Steve Castellotti<sc@eyemagnet.com> wrote:
> >
> >        I was wondering if anyone could please point me at a list or similar
> > resource for USB capture devices which support raw (or sliced) VBI
> > access for producing a closed caption transcript through software such
> > as zbvi-ntsc-cc or ccextractor? Specifically I'm wanting a device
> > capable of S-Video, Composite, or even Component input, not just ATSC,
> > as most USB devices seem focused around these days.
> >
> >        I've managed to get this working with various ivtv and saa713x based
> > PCI devices, but aren't aware of any USB implementations of chipsets
> > which use those drivers.
> >
> >
> >        Searching online, I found this archived message:
> >
> > http://lists.zerezo.com/video4linux/msg16402.html
> >
> > which states:
> >
> >> some em2840 and newer devices are able to capture raw vbi in
> >> linux (sliced vbi isn't possible yet)
> >> em2820, em2800, em2750 do not support vbi at all.
> >
> >
> >        Checking the em28xx driver homepage for recent models, I found this
> > entry:
> >
> > http://mcentral.de/wiki/index.php5/Em2880
> >
> >> officially the em2880 is em2840 + DVB_T
> >
> >
> >        which implies that not only is the "em2880" series a "newer" device,
> > but it should in fact already contain the "em2840" chip specifically
> > mentioned.
> >
> >
> >        Later on that same page, in the list of devices:
> >
> > ATI/AMD TV Wonder 600
> >
> >
> >        and on the manufacturer's page:
> >
> > http://ati.amd.com/products/tvwonder600/usb/index.html
> >
> >
> >        Under the list of "Input Connectors":
> >
> >> S-video input with adapter
> >
> >
> >
> >        Picking up one of these devices, I attempted to tune into the S-Video
> > feed and check the /dev/vbi0 device, but received the same error message
> > as I do with all other em28xx devices encountered thus far:
> >
> >> Cannot capture vbi data with v4l interface:
> >> /dev/vbi0 (AMD ATI TV Wonder HD 600) is not a raw vbi device.
> >
> >
> >
> >        Can anyone please point me in the right direction?
> >
> >        I would much prefer to be certain the next purchase is supported.
> >
> >
> >
> > Thanks!
> >
> 
> we do support Raw VBI for our devices, Sundtek MediaTV Pro for closed
> captioning.
> Alternatively we also have full support for ATSC-analogTV USB devices
> for the US market ([em288x]-[AVFB4910]-[Trident drx-J]-[tda18271]) the
> european product which we are selling is also capable of decoding NTSC
> closed caption.
> 
> http://sundtek.de/shop/Digital-TV-Sticks-oxid/Sundtek-MediaTV-Pro.html
> (this is just the information about the
> European/DVB-T/DVB-C/analogTV(raw VBI) device, we do not have the
> US/ATSC/analogTV(rawVBI) product listed there, although we do offer it
> to business customers) We support it from Linux 2.6.15 on.
> 
> Best Regards,
> Markus Rechberger

Hi,

anything new about how to deal with commercial advertising on lists,
depending totally on our source?

Please have a look.

Cheers,
Hermann




