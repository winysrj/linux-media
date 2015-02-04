Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49182 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161044AbbBDOnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 09:43:09 -0500
Date: Wed, 4 Feb 2015 16:43:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 1/3] Add BGR888_1X24 and GBR888_1X24 media bus formats
Message-ID: <20150204144302.GD32575@valkosipuli.retiisi.org.uk>
References: <1417614811-15634-1-git-send-email-p.zabel@pengutronix.de>
 <54CF92DD.6020308@xs4all.nl>
 <1422890460.6112.9.camel@pengutronix.de>
 <20150202132421.6f2ecbd3.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150202132421.6f2ecbd3.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Philipp,

On Mon, Feb 02, 2015 at 01:24:21PM -0200, Mauro Carvalho Chehab wrote:
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

Just remember that as these patches change the RGB and YUV formats in
media-bus-format.h --- it's very easy to get a conflict and even overlapping
IDs defined this way if / when someone else submits a patch to these. There
usually have been a few format related patches per minor release. So I'd
personally still put these patches through linux-media, and just accept that
a driver will use them later on.

Just my 5 euro cents. :-)

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
