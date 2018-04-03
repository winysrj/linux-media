Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:34996 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755300AbeDCMYC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 08:24:02 -0400
Subject: Re: [PATCH v9 2/2] media: V3s: Add support for Allwinner CSI.
To: Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
References: <1520302562-1577-1-git-send-email-yong.deng@magewell.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <218b07cd-4490-517e-1dff-ada7d73dfcf1@xs4all.nl>
Date: Tue, 3 Apr 2018 14:23:50 +0200
MIME-Version: 1.0
In-Reply-To: <1520302562-1577-1-git-send-email-yong.deng@magewell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/18 03:16, Yong Deng wrote:
> Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> interface and CSI1 is used for parallel interface. This is not
> documented in datasheet but by test and guess.
> 
> This patch implement a v4l2 framework driver for it.
> 
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
> 
> Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Tested-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Yong Deng <yong.deng@magewell.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans
