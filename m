Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZCNL3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 07:29:46 -0400
Date: Sat, 14 Mar 2009 08:29:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: Uri Shkolnik <urishk@yahoo.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS
 based cards
Message-ID: <20090314082916.5f5ae403@pedra.chehab.org>
In-Reply-To: <alpine.LRH.1.10.0903141154310.5517@pub4.ifh.de>
References: <469952.82552.qm@web110812.mail.gq1.yahoo.com>
	<20090314075154.2e2af9e7@pedra.chehab.org>
	<alpine.LRH.1.10.0903141154310.5517@pub4.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009 12:02:02 +0100 (CET)
Patrick Boettcher <patrick.boettcher@desy.de> wrote:

> Hi Mauro,
> 
> (sorry for hijacking) (since when do we like top-posts ? ;) )

You're welcome.

> On Sat, 14 Mar 2009, Mauro Carvalho Chehab wrote:
> 
> > Hi Uri,
> >
> > The patch looks sane, but I'd like to have a better picture of the Siano
> > device, to better understand this interface.
> >
> > The basic question is: why do we need an SDIO interface for a DVB device? For
> > what reason this interface is needed?
> 
> The answer is relatively easy: Some hosts only have a SDIO interface, so 
> no USB, no PCI, no I2C, no MPEG2-streaming interface. So, the device has 
> to provide a SDIO interface in order to read and write register and to 
> make DMAs to get the data to the host. Think of your cell-phone, or your 
> PDA.
> 
> There are some/a lot of vendors who use Linux in their commercial 
> mobile-TV product and there are some component-makers like Siano, who are 
> supporting those vendors through GPL drivers.

Ok, so, if I understand well, the SDIO interface will be used just like we
currently use the I2C or USB bus, right?

So, we should create some glue between DVB and SDIO bus just like we have with
PCI, USB, I2C, etc.

Ideally something like (using the design we currently have with dvb-usb):

+------------+
| DVB driver |
+------------+
      |
      V
+----------+
| DVB SDIO |
+----------+
      |
      V
+----------+
| DVB Core |
+----------+

Is that what you're thinking?


Cheers,
Mauro
