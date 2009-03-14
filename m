Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110803.mail.gq1.yahoo.com ([67.195.13.226]:26062 "HELO
	web110803.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755084AbZCNNUi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 09:20:38 -0400
Message-ID: <303413.9301.qm@web110803.mail.gq1.yahoo.com>
Date: Sat, 14 Mar 2009 06:20:35 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS based cards
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Sat, 3/14/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS based cards
> To: "Patrick Boettcher" <patrick.boettcher@desy.de>
> Cc: "Uri Shkolnik" <urishk@yahoo.com>, "Michael Krufky" <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
> Date: Saturday, March 14, 2009, 1:29 PM
> On Sat, 14 Mar 2009 12:02:02 +0100
> (CET)
> Patrick Boettcher <patrick.boettcher@desy.de>
> wrote:
> 
> > Hi Mauro,
> > 
> > (sorry for hijacking) (since when do we like top-posts
> ? ;) )
> 
> You're welcome.
> 
> > On Sat, 14 Mar 2009, Mauro Carvalho Chehab wrote:
> > 
> > > Hi Uri,
> > >
> > > The patch looks sane, but I'd like to have a
> better picture of the Siano
> > > device, to better understand this interface.
> > >
> > > The basic question is: why do we need an SDIO
> interface for a DVB device? For
> > > what reason this interface is needed?
> > 
> > The answer is relatively easy: Some hosts only have a
> SDIO interface, so 
> > no USB, no PCI, no I2C, no MPEG2-streaming interface.
> So, the device has 
> > to provide a SDIO interface in order to read and write
> register and to 
> > make DMAs to get the data to the host. Think of your
> cell-phone, or your 
> > PDA.
> > 
> > There are some/a lot of vendors who use Linux in their
> commercial 
> > mobile-TV product and there are some component-makers
> like Siano, who are 
> > supporting those vendors through GPL drivers.
> 
> Ok, so, if I understand well, the SDIO interface will be
> used just like we
> currently use the I2C or USB bus, right?
> 
> So, we should create some glue between DVB and SDIO bus
> just like we have with
> PCI, USB, I2C, etc.
> 
> Ideally something like (using the design we currently have
> with dvb-usb):
> 
> +------------+
> | DVB driver |
> +------------+
>       |
>       V
> +----------+
> | DVB SDIO |
> +----------+
>       |
>       V
> +----------+
> | DVB Core |
> +----------+
> 
> Is that what you're thinking?
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Hi all, 

Patrick, thanks for helping me, you can write stuff I can't (at least in public channels).

Ignoring for a moment DTV and Siano - most application processors which are used for portable devices (cellular phones, PDA, others), either do not have USB port at all, or it is strongly preferred not to use it for inner device communication (due high power consumption and electrical noise from the 480MHz USB bus). In those devices, if there is a USB port, it is used mostly to connect the device externally to a PC or other external entity (than the power comes from the PC).


Regarding the rough Siano's architecture (I can't extend too much) -

The device interface driver (USB, SDIO, SPP....) is on the bottom, used for control and data (C&D) exchanged with the SMS chip-set based device.

The Siano's "core" component is in the middle - it is a kind of an hub that routes the C&D from the device(s) interface(s) to the selected adapter.
The "core" also responsible for various common (for all interfaces and adapters) logic stuff (like firmware download, IR, ....).

The top component in the Siano's architecture, is the adapter. This component is responsible for the connectivity (and abstraction) toward the selected sub-system API (such as DVB-API v3, or S2/DVB-API v5, or other).

Hope I made it little clearer.


Regards,

Uri




      
