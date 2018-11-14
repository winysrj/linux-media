Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42882 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728033AbeKNU5A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 15:57:00 -0500
Date: Wed, 14 Nov 2018 12:54:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v12 0/2] Initial Allwinner V3s CSI Support
Message-ID: <20181114105413.4gcfwt4cmchh6zsf@valkosipuli.retiisi.org.uk>
References: <1540886988-27696-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540886988-27696-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2018 at 04:09:48PM +0800, Yong Deng wrote:
> I can't make v4l2-compliance always happy.
> The V3s CSI support many pixformats. But they are not always available.
> It's dependent on the input bus format (MEDIA_BUS_FMT_*). 
> Example:
> V4L2_PIX_FMT_SBGGR8: MEDIA_BUS_FMT_SBGGR8_1X8
> V4L2_PIX_FMT_YUYV: MEDIA_BUS_FMT_YUYV8_2X8
> But I can't get the subdev's format code before starting stream as the
> subdev may change it. So I can't know which pixformats are available.
> So I exports all the pixformats supported by SoC.
> The result is the app (v4l2-compliance) is likely to fail on streamon.
> 
> This patchset add initial support for Allwinner V3s CSI.
> 
> Allwinner V3s SoC features a CSI module with parallel interface.
> 
> This patchset implement a v4l2 framework driver and add a binding 
> documentation for it. 

Applied with this diff from Maxime:

<URL:http://code.bulix.org/vf7b6g-504515?raw>

The MAINTAINERS entry was also moved to the first patch.

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
