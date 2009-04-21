Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:35327 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752789AbZDUDJG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 23:09:06 -0400
Message-ID: <933650.33930.qm@web110816.mail.gq1.yahoo.com>
Date: Mon, 20 Apr 2009 20:09:04 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel module
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Mon, 4/20/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel module
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "LinuxML" <linux-media@vger.kernel.org>
> Date: Monday, April 20, 2009, 11:50 PM
> On Mon, 20 Apr 2009 11:16:32 -0700
> (PDT)
> Uri Shkolnik <urishk@yahoo.com>
> wrote:
> 
> > > From: Mauro Carvalho Chehab <mchehab@infradead.org>
> > > Subject: Re: [PATCH] [0904_14] Siano: assemble
> all components to one kernel module
> > > To: "Uri Shkolnik" <urishk@yahoo.com>
> > > Cc: "LinuxML" <linux-media@vger.kernel.org>
> > > Date: Monday, April 20, 2009, 9:03 PM
> > > On Sun, 5 Apr 2009 04:42:11 -0700
> > > (PDT)
> > > Uri Shkolnik <urishk@yahoo.com>
> > > wrote:
> > > 
> > > > 
> > > > # HG changeset patch
> > > > # User Uri Shkolnik <uris@siano-ms.com>
> > > > # Date 1238756860 -10800
> > > > # Node ID
> 616e696ce6f0c0d76a1aaea8b36e0345112c5ab6
> > > > # Parent 
> > > f65a29f0f9a66f82a91525ae0085a15f00ac91c2
> > > > [PATCH] [0904_14] Siano: assemble all
> components to
> > > one kernel module
> > > > 
> > > > From: Uri Shkolnik <uris@siano-ms.com>
> > > > 
> > > > Previously, the support for Siano-based
> devices
> > > > has been combined from several kernel
> modules. 
> > > > This patch assembles all into single kernel
> module.
> > > 
> > > Why? It seems better to keep it more modular.
> > > 
> > > Cheers,
> > > Mauro
> > > 
> > 
> > The driver remains as modular as it was before
> (regarding sources files).
> > Why to load smsusb.ko and than load smsdvb.ko and than
> load usbcore.ko? (and ir and endian... and...)
> > 
> > The driver handles any device (or devices) with Siano
> silicon on it, simple as that.
> > 
> > The new build method (Makefile and Kconfig) after the
> patches (yet to be fully submitted), build the driver to
> match the system it targets. (If USB exist than it builds
> the USB interface driver (otherwise it doesn't) and links it
> to the single module, same for SDIO, and any other interface
> driver, same for any clients and any other component).
> 
> Before seeing the other patches, it is hard for me to
> manifest, but, IMO, it is
> better to have the BUS configurable, e. g. just because you
> have USB interface,
> it doesn't mean that you want siano for USB, instead of
> using SDIO.
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


"better to have the BUS configurable, e. g. just because you have USB interface, it doesn't mean that you want siano for USB, instead of using SDIO."

Since the module is using dynamic registration, I don't find it a problem.
When the system has both USB and SDIO buses, both USB and SDIO interface driver will be compiled and linked to the module. When a Siano based device (or multiple Siano devices) will be connected, they will be register internally in the core and activated. Any combination is allow (multiple SDIO, multiple USB and any mix).


Regards,

Uri


      
