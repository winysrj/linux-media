Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821AbZFQJ43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 05:56:29 -0400
Date: Wed, 17 Jun 2009 06:56:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
Message-ID: <20090617065621.23515ab7@pedra.chehab.org>
In-Reply-To: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2009 09:43:50 +0200 (CEST)
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> > I recently have been bying second hand usb webcams left and right
> > one of them (a creative unknown model) uses the cpia1 chipset, and
> > works with the v4l1 driver currently in the kernel.
> >
> > One of these days I would like to convert it to a v4l2 driver using
> > gspca as basis, this however will cause us to use parallel port support
> > (that or we need to keep the old code around for the parallel port
> > version).
> >
> > I personally think that loosing support for the parallel port
> > version is ok given that the parallel port itslef is rapidly
> > disappearing, what do you think ?
> 
> I agree wholeheartedly. If we remove pp support, then we can also remove
> the bw-qcam and c-qcam drivers since they too use the parallel port.

Maybe I'm too nostalgic, but those are the first V4L drivers. It would be fun
to keep supporting them with V4L2 API ;)

That's said, while it is probably not that hard to develop a gspca-pp driver,
I'm not against removing parallel port support or even removing those drivers
due to technical reasons, like the end of V4L1 drivers.

By looking at the remaining V4L1 drivers, we have:

	ov511 - already implemented with V4L2 on gspca. Can be easily removed;

	se401, stv680, usbvideo, vicam - USB V4L1 drivers. IMO, it is valuable
		to convert them to gspca;

	cpia2, pwc - supports both V4L1 and V4L2 API. It shouldn't be hard to convert them
		to vidio_ioctl2 and remove V4L1 API.

	stradis - a saa7146 V4L1 only driver - I never understood this one well, since there is
		already another saa7146 driver running V4L2, used by mxb, hexium_gemini and
		hexium_orion. To make things worse, stradis, mxb and hexium_orion are registering for
		the same PCI device (the generic saa7146 PCI ID). If nobody volunteers to convert
		and test with V4L2, then maybe we can just remove it. The better conversion would
		probably be to use the V4L2 support at the saa7146 driver.

	arv - seems to be a VGA output driver - Only implements 3 ioctls:
		VIDIOCGCAP and VIDIOCGWIN/VIDIOCSWIN. It shouldn't be hard to convert it to V4L2.
		I'm not sure if this is still used in practice.

	bw-qcam, pms, c-qcam, cpia, w9966 - very old drivers that use direct io and/or parport;

IMO, after having all USB ID's for se401, stv680, usbvideo and vicam devices supported
by a V4L2 driver, we can just remove V4L1 ioctls from cpia2 and pwc, and the drivers that
will still remain using only the legacy API can be dropped. Anything more converted will be a bonus



Cheers,
Mauro
