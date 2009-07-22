Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZGVQWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 12:22:10 -0400
Date: Wed, 22 Jul 2009 13:22:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org >> \"linux-media@vger.kernel.org\""
	<linux-media@vger.kernel.org>
Subject: Re: offering bounty for GPL'd dual em28xx support
Message-ID: <20090722132204.774d7af3@pedra.chehab.org>
In-Reply-To: <829197380907220806p4ed7a02bw3beff7c6776a858a@mail.gmail.com>
References: <4A6666CC.7020008@eyemagnet.com>
	<829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	<4A66E59E.9040502@powercraft.nl>
	<829197380907220748kab85c63g6ebbaad07084c255@mail.gmail.com>
	<4A6729CF.8080804@powercraft.nl>
	<829197380907220806p4ed7a02bw3beff7c6776a858a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Jul 2009 11:06:12 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Wed, Jul 22, 2009 at 11:01 AM, Jelle de
> Jong<jelledejong@powercraft.nl> wrote:
> > Funky timing of those mails :D.
> >
> > I saw only after sending my mail that Steve was talking about analog and
> > that this is indeed different. Dual analog tuner support should be
> > possible right? Maybe with some other analog usb chipsets? I don't know
> > what the usb blocksize is or if they are isochronous transfers or bulk
> > or control.
> >
> > I assume the video must be uncompressed transferred over usb because the
> > decoding chip is on the usb device is not capable of doing compression
> > encoding after the analog video decoding? Are there usb devices that do
> > such tricks?
> 
> There were older devices that did compression, mainly designed to fit
> the stream inside of 12Mbps USB.  However, they required onboard RAM
> to buffer the frame which added considerable cost (in addition to the
> overhead of doing the compression), and as a result pretty much all of
> the USB 2.0 designs I have seen do not do any on-chip compression.
> 
> The example which comes to mind is the Hauppauge Win-TV USB which uses
> the usbvision chipset.

pvrusb2 also has compression, provided by an external mpeg encoder. Those
devices are USB 2.0



Cheers,
Mauro
