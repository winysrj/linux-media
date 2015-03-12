Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:43386 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbbCLRyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 13:54:11 -0400
Received: by lbvp9 with SMTP id p9so17696060lbv.10
        for <linux-media@vger.kernel.org>; Thu, 12 Mar 2015 10:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
From: Emil Renner Berthing <kernel@esmil.dk>
Date: Thu, 12 Mar 2015 18:53:49 +0100
Message-ID: <CANBLGcxheEoVisGw_HUiQtVL5N4L4XrVQ7mOfSWV82wP5NRQ0g@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] Use media bus formats in imx-drm and add drm
 panel support
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	David Airlie <airlied@linux.ie>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp

On 12 March 2015 at 10:58, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Currently the imx-drm driver misuses the V4L2_PIX_FMT constants to describe the
> pixel format on the parallel bus between display controllers and encoders. Now
> that MEDIA_BUS_FMT is available, use that instead.

I've tested this series on the Hercules eCAFE Slim HD, which uses the
RGB666_1X24_CPADHI format, and it still boots up with screen output.
You can add

Tested-by: Emil Renner Berthing <kernel@esmil.dk>

--
/Emil
