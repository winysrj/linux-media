Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-73.mail.aliyun.com ([115.124.20.73]:36782 "EHLO
        out20-73.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbeALBvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 20:51:35 -0500
Date: Fri, 12 Jan 2018 09:51:14 +0800
From: Yong <yong.deng@magewell.com>
To: maxime.ripard@free-electrons.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        linux-sunxi@googlegroups.com, megous@megous.com
Subject: Re: [linux-sunxi] Re: [PATCH v5 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-Id: <20180112095114.b2414fe44cff7bf7cf6f8822@magewell.com>
In-Reply-To: <20180111132844.mok7upqjycpx3bqm@flea.lan>
References: <1515639966-35902-1-git-send-email-yong.deng@magewell.com>
        <20180111132844.mok7upqjycpx3bqm@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Thu, 11 Jan 2018 14:28:44 +0100
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi Yong,
> 
> On Thu, Jan 11, 2018 at 11:06:06AM +0800, Yong Deng wrote:
> > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > interface and CSI1 is used for parallel interface. This is not
> > documented in datasheet but by test and guess.
> > 
> > This patch implement a v4l2 framework driver for it.
> > 
> > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > ISP's support are not included in this patch.
> > 
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> 
> I've needed this patch in order to fix a NULL pointer dereference:
> http://code.bulix.org/oz6gmb-257359?raw
> 
> This is needed because while it's ok to have a NULL pointer to
> v4l2_subdev_pad_config when you call the subdev set_fmt with
> V4L2_SUBDEV_FORMAT_ACTIVE, it's not with V4L2_SUBDEV_FORMAT_TRY, and
> sensors will assume taht it's a valid pointer.
> 
> Otherwise,
> Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

I revisit some code of subdevs and you are right.

Squash your patch into my driver patch and add your Tested-by in
commit. Is it right?

> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
> 
> -- 
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.


Thanks,
Yong
