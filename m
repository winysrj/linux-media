Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZETBwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 21:52:14 -0400
Date: Tue, 19 May 2009 22:52:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [09051_40] Siano - kconfig update
Message-ID: <20090519225209.3e8485a8@pedra.chehab.org>
In-Reply-To: <349664.18832.qm@web110811.mail.gq1.yahoo.com>
References: <349664.18832.qm@web110811.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 May 2009 11:18:32 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> 
> 
> --- On Tue, 5/19/09, Michael Krufky <mkrufky@linuxtv.org> wrote:
> 
> > From: Michael Krufky <mkrufky@linuxtv.org>
> > Subject: Re: [PATCH] [09051_40] Siano - kconfig update
> > To: "Uri Shkolnik" <urishk@yahoo.com>
> > Cc: "LinuxML" <linux-media@vger.kernel.org>, "Mauro Carvalho Chehab" <mchehab@infradead.org>
> > Date: Tuesday, May 19, 2009, 6:47 PM
> > On Tue, May 19, 2009 at 7:58 AM, Uri
> > Shkolnik <urishk@yahoo.com>
> > wrote:
> > >
> > > # HG changeset patch
> > > # User Uri Shkolnik <uris@siano-ms.com>
> > > # Date 1242734522 -10800
> > > # Node ID c74502f4c8e97bd9cec9656793bbabc11fb72ab4
> > > # Parent  315bc4b65b4f527c4f9bc4fe3290e10f07975437
> > > [09051_40] Siano - kconfig update
> > >
> > > From: Uri Shkolnik <uris@siano-ms.com>
> > >
> > > This patches comes to solve the comments on Siano's
> > patch
> > > 0905_10. It updates the kconfig to support
> > multi-modules build.
> > > Note that the dependency on dvb_core is for the
> > (sms)dvb module
> > > alone, since the drivers set may work with another
> > adapter.
> > >
> > > Priority: normal
> > >
> > > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> > >
> > > diff -r 315bc4b65b4f -r c74502f4c8e9
> > linux/drivers/media/dvb/siano/Kconfig
> > > --- a/linux/drivers/media/dvb/siano/Kconfig     Sun
> > May 17 12:28:55 2009 +0000
> > > +++ b/linux/drivers/media/dvb/siano/Kconfig     Tue
> > May 19 15:02:02 2009 +0300
> > > @@ -2,25 +2,40 @@
> > >  # Siano Mobile Silicon Digital TV device
> > configuration
> > >  #
> > >
> > > -config DVB_SIANO_SMS1XXX
> > > -       tristate "Siano SMS1XXX USB dongle
> > support"
> > > -       depends on DVB_CORE && USB
> > > +config SMS_SIANO_MDTV
> > > +       tristate "Siano SMS1xxx based MDTV
> > receiver"
> > > +       default m
> > >        ---help---
> > > -         Choose Y here if you have a USB dongle
> > with a SMS1XXX chipset.
> > > +       Choose Y or M here if you have MDTV
> > receiver with a Siano chipset.
> > >
> > > -         To compile this driver as a module,
> > choose M here: the
> > > -         module will be called sms1xxx.
> > > +       To compile this driver as a module, choose
> > M here
> > > +       (The modules will be called smsmdtv).
> > >
> > > -config DVB_SIANO_SMS1XXX_SMS_IDS
> > > -       bool "Enable support for Siano Mobile
> > Silicon default USB IDs"
> > > -       depends on DVB_SIANO_SMS1XXX
> > > -       default y
> > > +       Note: All dependents, if selected, will be
> > part of this module.
> > > +
> > > +       Further documentation on this driver can be
> > found on the WWW
> > > +       at http://www.siano-ms.com/
> > > +
> > > +if SMS_SIANO_MDTV
> > > +menu "Siano module components"
> > > +
> > > +# Kernel sub systems support
> > > +config SMS_DVB3_SUBSYS
> > > +       tristate "DVB v.3 Subsystem support"
> > > +       depends on DVB_CORE
> > > +       default m if DVB_CORE
> > >        ---help---
> > > -         Choose Y here if you have a USB dongle
> > with a SMS1XXX chipset
> > > -         that uses Siano Mobile Silicon's default
> > usb vid:pid.
> > > +       Choose if you would like to have DVB v.3
> > kernel sub-system support.
> > >
> > > -         Choose N here if you would prefer to use
> > Siano's external driver.
> > > +# Hardware interfaces support
> > >
> > > -         Further documentation on this driver can
> > be found on the WWW at
> > > -         <http://www.siano-ms.com/>.
> > > +config SMS_USB_DRV
> > > +       tristate "USB interface support"
> > > +       depends on USB
> > > +       default m if USB
> > > +       ---help---
> > > +       Choose if you would like to have Siano's
> > support for USB interface
> > >
> > > +
> > > +endmenu
> > > +endif # SMS_SIANO_MDTV
> > >
> > >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line
> > "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > 
> > 
> > I have two concerns with this patch...
> > 
> > 
> > Issue #1, I dont see why it's important to rename the
> > Kconfig symbol
> > from DVB_SIANO_SMS1XXX to SMS_SIANO_MDTV -- This will just
> > cause
> > breakage of "make oldconfig" in the kernel with no real
> > benefit.
> > 
> > Issue #2, a much bigger issue.....  This patch implies
> > that the Siano
> > driver can be built *with* DVB "v3" support, or without
> > it.  Why would
> > a linux user ever want to built this driver without support
> > for the
> > DVB API ?  (that's a loaded question) ...  Does
> > Siano intend to push
> > their proprietary API into the kernel?
> > 
> > -Mike
> > 
> 
> Regarding #1 - sms1xxx implies that is support only Siano devices from 1xxx families, but actually it support all Siano's chip-sets and various MCPs (Which have different numeration than 1xxx, I can't give details here, sorry). So 1xxx is a misleading name.
> MDTV - much better (you can read it as Mobile Digital TV, or something else)

Changing Kconfig names should be avoided, but your explanation makes sense to
me, provided that you will preserve the newer name.

> Regarding #2 - DVB-API version 3 (dvb-core module) is one of the sub-systems which are supported. The drivers set is also supports DVB-API version 5 (pre-alpha at this stage) and Siano's proprietary sub-system. So, actually you don't have to have dvb-core in order to use Siano's USB interface driver... 

It makes no sense to add a Kconfig item for it in Kernel, since Siano's proprietary sub-system is not part of upstream Linux Kernel.

> Please note that there are DAB radio builds, using Siano chip-sets and drivers... which means you don't need the dvb-core as well, you just need the dab and the Siano's core and interface drivers...

Hmm... it would be interesting if you could later provide a DAB patch for the driver.

> Long time ago I asked you, why you chose to put the Siano sub-tree under media/dvb, since that chip-set can be used (and it is) and be regarded as... radio receiver. I don't mind that the Siano's sub-tree will reside under media/dvb, but it doesn't indicates either that it's bind solely to dvb-core....

This is an already existing trouble we have: splitting drivers into media/dvb,
media/video and media/radio is not correct. There are several drivers that have
DVB, video and radio support. 

The alternative to fix would be a major rearrangement on all drivers. This were
already discussed at the ML, but every time we run away. I suspect that sooner
or later, we'll need to rearrange they. The better proposal we had were to be
as much linear as possible (so, having all drivers under /media for example
would make more sense).



Cheers,
Mauro
