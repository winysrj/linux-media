Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47653 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbbCMJGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 05:06:34 -0400
Message-ID: <1426237574.3083.22.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/10] Use media bus formats in imx-drm and add drm
 panel support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Emil Renner Berthing <kernel@esmil.dk>
Cc: Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org
Date: Fri, 13 Mar 2015 10:06:14 +0100
In-Reply-To: <CANBLGcxheEoVisGw_HUiQtVL5N4L4XrVQ7mOfSWV82wP5NRQ0g@mail.gmail.com>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
	 <CANBLGcxheEoVisGw_HUiQtVL5N4L4XrVQ7mOfSWV82wP5NRQ0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 12.03.2015, 18:53 +0100 schrieb Emil Renner Berthing:
> Hi Philipp
> 
> On 12 March 2015 at 10:58, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Currently the imx-drm driver misuses the V4L2_PIX_FMT constants to describe the
> > pixel format on the parallel bus between display controllers and encoders. Now
> > that MEDIA_BUS_FMT is available, use that instead.
> 
> I've tested this series on the Hercules eCAFE Slim HD, which uses the
> RGB666_1X24_CPADHI format, and it still boots up with screen output.
> You can add
> 
> Tested-by: Emil Renner Berthing <kernel@esmil.dk>

Thanks for testing! I'll add that to the relevant patches (5-7).

regards
Philipp

