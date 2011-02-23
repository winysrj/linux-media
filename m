Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:33934 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab1BWRwa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 12:52:30 -0500
Subject: Re: PCTV nanoStick T2 in stock - Driver work?
From: Steve Kerrison <steve@stevekerrison.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Nicolas Will <nico@youplala.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTimz43G5kEtjEFK9jxRg=hs5y_fwUdva7DbhcUoH@mail.gmail.com>
References: <1298479744.2698.41.camel@acropora>
	 <AANLkTimz43G5kEtjEFK9jxRg=hs5y_fwUdva7DbhcUoH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 17:45:43 +0000
Message-ID: <1298483143.1967.482.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-02-23 at 12:07 -0500, Devin Heitmueller wrote:
> On Wed, Feb 23, 2011 at 11:49 AM, Nicolas Will <nico@youplala.net> wrote:
> > Hello
> >
> > The DVB-T2 USB stick appears to be in stock in the UK.
> >
> > Product page:
> > http://www.pctvsystems.com/Products/ProductsEuropeAsia/Digitalproducts/PCTVnanoStickT2/tabid/248/language/en-GB/Default.aspx
> >
> > Play.com, Dabs and Amzon.co.uk list it as in stock.
> >
> > Is there any work started on a driver at this point?
> >
> > If no work has started, would a loan/donation of a stick help?
> >
> > What can be done to trigger/accelerate the provision of a driver?
> 
> Somebody would have to break down and reverse engineer the Sony T2
> demod.  I saw something over in mythtv-users where somebody took a
> unit apart and photographed it, and he's suggested that he's started
> working on a driver.
> 
> http://stevekerrison.com/290e/index.html
> 
> Devin
> 
That would be me :)

I have indeed, but don't have much to speak of seeing as when I started
I'd never touched Linux kernel-space driver development.

At the moment I have hardware and usb data from myself and others. I'm
hoping to publish some code that at least initialises the device with
the Sony demod code stub'd so that I and whoever wants to join me, can
attempt to get the demod to spit out some transport streams :)

Donations won't get sony to give me the datasheet, so none requested
right now.

I actually have a free weekend coming up (a rare occurrence) in which I
hope to make some further progress...

Or the short answer: No hardware/donations needed, but things might take
a while!

Regards,
-- 
Steve Kerrison MEng Hons.
http://stevekerrison.com/ 

