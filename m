Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:50412 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab0ASAFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 19:05:09 -0500
Subject: Re: RE: How to use saa7134 gpio via gpio-sysfs?
From: hermann pitton <hermann-pitton@arcor.de>
To: Will Tate <willytate@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	William Tate <wtate@rtd.com>,
	Gordon Smith <spider.karma+linux-media@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <9006a0b61001181511w66712d2fkb2c2f5ca60825489@mail.gmail.com>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
	 <1263602137.3184.23.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001151650410.4729@shell2.speakeasy.net>
	 <1263622815.3178.31.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001160400230.4729@shell2.speakeasy.net>
	 <1263686928.3394.4.camel@pc07.localdom.local>
	 <1263689544.8899.3.camel@pc07.localdom.local>
	 <1263769323.3182.8.camel@pc07.localdom.local>
	 <EAF55B080F530E428574542A7925428705EA7F1C66@INTMBX1.RTD.com>
	 <1263854400.6804.15.camel@pc07.localdom.local>
	 <9006a0b61001181511w66712d2fkb2c2f5ca60825489@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Jan 2010 01:01:58 +0100
Message-Id: <1263859318.6804.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Am Montag, den 18.01.2010, 18:11 -0500 schrieb Will Tate:
> I'm not sure why access in userspace would be required.  I checked the
> schematic today and all the GPIO pins are used to communicate with the
> SAA6752HS on board for compression.  We do not bring the GPIO off the
> board anywhere.

thank you very much. I was still expecting that and did not get Gordon's
point, but must admit to have been totally unaware about the DI/O
features. RTD did all the hardware implementations themselves.

Very nice job that time.

> Gordon and I have spoken previously about the RTD software for digital
> I/O breaking with the migration of pcf8574 driver to the pcf857x.  So,
> perhaps he intended to use GPIO until I can fix the digital I/O
> software.

Ah, good to know. BTW, we had the mpeg encoder broken unnoticed for some
kernels, but due to fixes by Dmitri Belimov and extensions by Hans
Verkuil, we are much better on it these days. Enjoy.

Always let us know, if we can do anything or at least make it public for
those interested to work on it.

Thanks,
Hermann


> > On Jan 18, 2010 5:43 PM, "hermann pitton" <hermann-pitton@arcor.de>
> > wrote:
> > 
> > Hi,
> > 
> > Am Montag, den 18.01.2010, 09:13 -0500 schrieb William Tate:
> > 
> > 
> > > Gentlemen, > > I may be able to assist here. Specifically what
> > information/photographs are you l...
> > 
> > Gordon, please explain, why you would like to have access to some of
> > the
> > saa713x gpios on that device from userspace.
> > 
> > Unknown to me previously, it seems RTD already provides software for
> > their customers to use the digital I/Os, but restricted to owners of
> > such devices.
> > 
> > "For an example of how to use VFG73xx digital I/O, please see the
> > Software Product SWP-700010065 “Linux
> > Software (VFG73xx)” available from the RTD web site"
> > 
> > William, is there a desire to have such gpio access from userspace
> > on
> > your side? Trent kindly outlined some details. Please give us some
> > brief
> > explanations in that case.
> > 
> > Thanks for offering your help.
> > 
> > Hermann
> > 


