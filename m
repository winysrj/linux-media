Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbZDTUuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 16:50:46 -0400
Date: Mon, 20 Apr 2009 17:50:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel
 module
Message-ID: <20090420175041.7adf49f6@pedra.chehab.org>
In-Reply-To: <863162.69571.qm@web110802.mail.gq1.yahoo.com>
References: <863162.69571.qm@web110802.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009 11:16:32 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> > From: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel module
> > To: "Uri Shkolnik" <urishk@yahoo.com>
> > Cc: "LinuxML" <linux-media@vger.kernel.org>
> > Date: Monday, April 20, 2009, 9:03 PM
> > On Sun, 5 Apr 2009 04:42:11 -0700
> > (PDT)
> > Uri Shkolnik <urishk@yahoo.com>
> > wrote:
> > 
> > > 
> > > # HG changeset patch
> > > # User Uri Shkolnik <uris@siano-ms.com>
> > > # Date 1238756860 -10800
> > > # Node ID 616e696ce6f0c0d76a1aaea8b36e0345112c5ab6
> > > # Parent 
> > f65a29f0f9a66f82a91525ae0085a15f00ac91c2
> > > [PATCH] [0904_14] Siano: assemble all components to
> > one kernel module
> > > 
> > > From: Uri Shkolnik <uris@siano-ms.com>
> > > 
> > > Previously, the support for Siano-based devices
> > > has been combined from several kernel modules. 
> > > This patch assembles all into single kernel module.
> > 
> > Why? It seems better to keep it more modular.
> > 
> > Cheers,
> > Mauro
> > 
> 
> The driver remains as modular as it was before (regarding sources files).
> Why to load smsusb.ko and than load smsdvb.ko and than load usbcore.ko? (and ir and endian... and...)
> 
> The driver handles any device (or devices) with Siano silicon on it, simple as that.
> 
> The new build method (Makefile and Kconfig) after the patches (yet to be fully submitted), build the driver to match the system it targets. (If USB exist than it builds the USB interface driver (otherwise it doesn't) and links it to the single module, same for SDIO, and any other interface driver, same for any clients and any other component).

Before seeing the other patches, it is hard for me to manifest, but, IMO, it is
better to have the BUS configurable, e. g. just because you have USB interface,
it doesn't mean that you want siano for USB, instead of using SDIO.

Cheers,
Mauro
