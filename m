Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-85.mail.aliyun.com ([115.124.20.85]:38458 "EHLO
        out20-85.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756416AbdLVK4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 05:56:14 -0500
Date: Fri, 22 Dec 2017 18:55:47 +0800
From: Yong <yong.deng@magewell.com>
To: Priit Laes <plaes@plaes.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v4 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-Id: <20171222185547.356dbc3ebe76d0ebec88d052@magewell.com>
In-Reply-To: <20171222102156.cfemen6ouxxxbrem@plaes.org>
References: <1513936020-35569-1-git-send-email-yong.deng@magewell.com>
        <20171222102156.cfemen6ouxxxbrem@plaes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, 22 Dec 2017 10:21:56 +0000
Priit Laes <plaes@plaes.org> wrote:

> On Fri, Dec 22, 2017 at 05:47:00PM +0800, Yong Deng wrote:
> > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > and CSI1 is used for parallel interface. This is not documented in
> > datasheet but by testing and guess.
> > 
> > This patch implement a v4l2 framework driver for it.

...

> > +	if ((sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_PARALLEL
> > +	      || sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_BT656)
> > +	     && sdev->csi.v4l2_ep.bus.parallel.bus_width == 16) {
> > +		switch (pixformat) {
> > +		case V4L2_PIX_FMT_HM12:
> > +		case V4L2_PIX_FMT_NV12:
> > +		case V4L2_PIX_FMT_NV21:
> > +		case V4L2_PIX_FMT_NV16:
> > +		case V4L2_PIX_FMT_NV61:
> > +		case V4L2_PIX_FMT_YUV420:
> > +		case V4L2_PIX_FMT_YVU420:
> > +		case V4L2_PIX_FMT_YUV422P:
> > +			switch (mbus_code) {
> > +			case MEDIA_BUS_FMT_UYVY8_1X16:
> > +			case MEDIA_BUS_FMT_VYUY8_1X16:
> > +			case MEDIA_BUS_FMT_YUYV8_1X16:
> > +			case MEDIA_BUS_FMT_YVYU8_1X16:
> > +				return true;
> > +			}
> > +			break;
> > +		}
> Should we add default cases and warning messages here for debug purposes?

OK. I will add all the default cases and messages.

Thanks,
Yong
