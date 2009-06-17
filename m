Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbZFQO2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 10:28:09 -0400
Date: Wed, 17 Jun 2009 11:28:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
Message-ID: <20090617112802.152a6d64@pedra.chehab.org>
In-Reply-To: <4A38CCAF.5060202@redhat.com>
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
	<20090617065621.23515ab7@pedra.chehab.org>
	<4A38CCAF.5060202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2009 12:59:59 +0200
Hans de Goede <hdegoede@redhat.com> escreveu:

> 
> 
> On 06/17/2009 11:56 AM, Mauro Carvalho Chehab wrote:
> > Em Wed, 17 Jun 2009 09:43:50 +0200 (CEST)
> > "Hans Verkuil"<hverkuil@xs4all.nl>  escreveu:
> >
> >>> I recently have been bying second hand usb webcams left and right
> >>> one of them (a creative unknown model) uses the cpia1 chipset, and
> >>> works with the v4l1 driver currently in the kernel.
> >>>
> >>> One of these days I would like to convert it to a v4l2 driver using
> >>> gspca as basis, this however will cause us to use parallel port support
> >>> (that or we need to keep the old code around for the parallel port
> >>> version).
> >>>
> >>> I personally think that loosing support for the parallel port
> >>> version is ok given that the parallel port itslef is rapidly
> >>> disappearing, what do you think ?
> >> I agree wholeheartedly. If we remove pp support, then we can also remove
> >> the bw-qcam and c-qcam drivers since they too use the parallel port.
> >
> > Maybe I'm too nostalgic, but those are the first V4L drivers. It would be fun
> > to keep supporting them with V4L2 API ;)
> >
> > That's said, while it is probably not that hard to develop a gspca-pp driver,
> > I'm not against removing parallel port support or even removing those drivers
> > due to technical reasons, like the end of V4L1 drivers.
> >
> > By looking at the remaining V4L1 drivers, we have:
> >
> > 	ov511 - already implemented with V4L2 on gspca. Can be easily removed;
> >
> 
> Yip, this one is a done deal :)
> 
> > 	se401, stv680, usbvideo, vicam - USB V4L1 drivers. IMO, it is valuable
> > 		to convert them to gspca;
> >
> 
> I've recently bought a (second hand) stv680 cam, haven't seriously tested it yet,
> so I dunno if it works with the v4l1 driver. I agree it would be good to convert these,
> and I can work on this as time permits, but I won't be converting code I don't have
> HW to test for.
> 
> As for usbvideo that supports (amongst others) the st6422 (from the out of tree
> qc-usb-messenger driver), but only one usb-id ??. I'm currently finishing up adding
> st6422 support to gspca (with all known usb-id's), I have 2 different cams to test this with.

I have here one Logitech quickcam. There are several variants, and the in-tree
and out-tree drivers support different models. I can test it here and give you
a feedback. However, I don't have the original driver for it.

> zc0301
> only supports one usb-id which has not yet been tested with gspca, used to claim a lot more
> usb-id's but didn't actually work with those as it only supported the bridge, not the sensor
> -> remove it now ?

I have one zc0301 cam that works with this driver. The last time I checked, it
didn't work with gspca. I'll double check.

> et61x251
> Only supports using this bridge in combination with one type of sensor where as gspca
> supports 2 type of sensors. gspca support is untested AFAIK.
> -> ?
> 
> sn9c102
> Supports a large number of cams also supported by gspca's sonixb / sonixj driver, we're using
> #ifdef .... macros to detect if both are being build at the same time to include usb-id's only
> in one of the 2.

Btw, it would be interesting to work with the out-of-tree microdia driver,
since there are some models that are supported only by the alternative driver. 
> 
> As seems normal for drivers from this author the driver used to claim a lot of usb-id's it
> couldn't actually work with as it only supported the bridge, not the sensor. We've removed all
> those and are now slowly moving over the remaining usb-ids to gspca as things get tested
> with gspca.
> -> Keep on moving over usb-id's then when only a few are left, drop it

It makes no sense to have two drivers for the same cams. Once having support
for all USB ID's, we can mark the alternative driver as deprecated and remove
it at the next kernel version.



Cheers,
Mauro
