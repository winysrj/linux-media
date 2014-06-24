Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40482 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752966AbaFXPNl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 11:13:41 -0400
Date: Tue, 24 Jun 2014 16:13:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Denis Carikli <denis@eukrea.com>,
	Sascha Hauer <kernel@pengutronix.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v14 04/10] imx-drm: use defines for clock polarity
	settings
Message-ID: <20140624151323.GU32514@n2100.arm.linux.org.uk>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-4-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402913484-25910-4-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 16, 2014 at 12:11:18PM +0200, Denis Carikli wrote:
> Signed-off-by: Denis Carikli <denis@eukrea.com>

It would be nice to have a little more explanation in the commit messages
for these patches.  If you'd like to send me better commit messages for
these patches, I'll add them to what I already have:

	imx-drm: use defines for clock polarity settings

	imx-drm: add RGB666 support for parallel display.

It may also be worth describing the RGB666 format in the commit message
for:

	v4l2: add new V4L2_PIX_FMT_RGB666 pixel format.

And... getting some more acks for these patches would be very useful,
I think I'd like to see Sascha's ack for these... Sascha?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
