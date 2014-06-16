Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59041 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754926AbaFPKPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:15:06 -0400
Date: Mon, 16 Jun 2014 11:14:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Denis Carikli <denis@eukrea.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v14 01/10] [media] v4l2: add new V4L2_PIX_FMT_RGB666
	pixel format.
Message-ID: <20140616101445.GW23430@n2100.arm.linux.org.uk>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 16, 2014 at 12:11:15PM +0200, Denis Carikli wrote:
> That new macro is needed by the imx_drm staging driver
>   for supporting the QVGA display of the eukrea-cpuimx51 board.

As I said probably around v10 time, I already have this patch queued,
and I was going to send it to Greg before the previous merge window,
but due to the number of patches I was already carrying, it was lost
amongst the trees.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
