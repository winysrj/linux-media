Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50006 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbbBBPet (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:34:49 -0500
Message-ID: <1422891282.6112.15.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] Add BGR888_1X24 and GBR888_1X24 media bus formats
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de, linux-media@vger.kernel.org
Date: Mon, 02 Feb 2015 16:34:42 +0100
In-Reply-To: <20150202132421.6f2ecbd3.m.chehab@samsung.com>
References: <1417614811-15634-1-git-send-email-p.zabel@pengutronix.de>
	 <54CF92DD.6020308@xs4all.nl> <1422890460.6112.9.camel@pengutronix.de>
	 <20150202132421.6f2ecbd3.m.chehab@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 02.02.2015, 13:24 -0200 schrieb Mauro Carvalho Chehab:
> Em Mon, 02 Feb 2015 16:21:00 +0100
> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
> 
> > Am Montag, den 02.02.2015, 16:08 +0100 schrieb Hans Verkuil:
> > > On 12/03/2014 02:53 PM, Philipp Zabel wrote:
> > > > This patch adds two more 24-bit RGB formats. BGR888 is more or less common,
> > > > GBR888 is used on the internal connection between the IPU display interface
> > > > and the TVE (VGA DAC) on i.MX53 SoCs.
> > > > 
> > > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > This three-part patch series doesn't apply. Is it on top of another patch
> > > series?
> > 
> > It is on top of "Add RGB444_1X12 and RGB565_1X16 media bus formats" and
> > "Add LVDS RGB media bus formats".
> > 
> > > Anyway, it can't be merged unless it is actually used in a driver.
> > 
> > I'd like to use these in the imx-drm driver, so this is kind of a
> > chicken and egg situation. Shall I submit a patch that uses the defines
> > to dri-devel and reference it here?
> 
> Submit the full patch series with the imx-drm driver, mentioning at the
> V4L2 patch that it will be applied via the DRM tree. We'll review
> and give our ack for it to be applied via DRM tree.

I'll do that, thanks.

regards
Philipp

