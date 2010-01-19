Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:49196 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755478Ab0ASU3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 15:29:45 -0500
Subject: Re: RE: How to use saa7134 gpio via gpio-sysfs?
From: hermann pitton <hermann-pitton@arcor.de>
To: Gordon Smith <spider.karma+linux-media@gmail.com>
Cc: Will Tate <willytate@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	William Tate <wtate@rtd.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <2df568dc1001190924y7b55b3e4h5b553cd25cfb33bf@mail.gmail.com>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
	 <1263622815.3178.31.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001160400230.4729@shell2.speakeasy.net>
	 <1263686928.3394.4.camel@pc07.localdom.local>
	 <1263689544.8899.3.camel@pc07.localdom.local>
	 <1263769323.3182.8.camel@pc07.localdom.local>
	 <EAF55B080F530E428574542A7925428705EA7F1C66@INTMBX1.RTD.com>
	 <1263854400.6804.15.camel@pc07.localdom.local>
	 <9006a0b61001181511w66712d2fkb2c2f5ca60825489@mail.gmail.com>
	 <1263859318.6804.31.camel@pc07.localdom.local>
	 <2df568dc1001190924y7b55b3e4h5b553cd25cfb33bf@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 19 Jan 2010 21:24:31 +0100
Message-Id: <1263932671.5384.52.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Gordon,

Am Dienstag, den 19.01.2010, 10:24 -0700 schrieb Gordon Smith:
> On Mon, Jan 18, 2010 at 5:01 PM, hermann pitton <hermann-pitton@arcor.de> wrote:
> > Hello,
> >
> > Am Montag, den 18.01.2010, 18:11 -0500 schrieb Will Tate:
> >> I'm not sure why access in userspace would be required.  I checked the
> >> schematic today and all the GPIO pins are used to communicate with the
> >> SAA6752HS on board for compression.  We do not bring the GPIO off the
> >> board anywhere.
> >
> > thank you very much. I was still expecting that and did not get Gordon's
> > point, but must admit to have been totally unaware about the DI/O
> > features. RTD did all the hardware implementations themselves.
> >
> > Very nice job that time.
> >
> >> Gordon and I have spoken previously about the RTD software for digital
> >> I/O breaking with the migration of pcf8574 driver to the pcf857x.  So,
> >> perhaps he intended to use GPIO until I can fix the digital I/O
> >> software.
> >
> > Ah, good to know. BTW, we had the mpeg encoder broken unnoticed for some
> > kernels, but due to fixes by Dmitri Belimov and extensions by Hans
> > Verkuil, we are much better on it these days. Enjoy.
> >
> > Always let us know, if we can do anything or at least make it public for
> > those interested to work on it.
> >
> > Thanks,
> > Hermann
> >
> 
> Hello Hermann, good to hear from you again.
> 
> It looks like I was off track regarding GPIO. In 2.6.30 the pcf8574
> module that was used for digital I/O earlier was no longer available
> and something I read lead me to believe I should use gpio-sysfs
> instead. I'm sorry for the noise.
> 
> - Gordon

no problem at all.

It was quite interesting to think about such gpio use.

If such a card appears in the future, we can point to the thread you
started here and have already, thanks to Trent, a collection of good
ideas and comments.

Cheers,
Hermann


