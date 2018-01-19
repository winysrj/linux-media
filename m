Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:45249 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752938AbeASVRc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 16:17:32 -0500
From: Icenowy Zheng <icenowy@aosc.io>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>, Yong Deng <yong.deng@magewell.com>,
        Mark Rutland <mark.rutland@arm.com>, megous@megous.com,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-sunxi@googlegroups.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/2] dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
Date: Sat, 20 Jan 2018 05:17:25 +0800
Message-ID: <2315959.AJds7mCBWN@ice-x220i>
In-Reply-To: <20180119211409.ubysuyvhkmfotbdg@rob-hp-laptop>
References: <1515639823-35782-1-git-send-email-yong.deng@magewell.com> <20180119211409.ubysuyvhkmfotbdg@rob-hp-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

在 2018年1月20日星期六 CST 上午5:14:09，Rob Herring 写道：
> On Thu, Jan 11, 2018 at 11:03:43AM +0800, Yong Deng wrote:
> > Add binding documentation for Allwinner V3s CSI.
> > 
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> > 
> >  .../devicetree/bindings/media/sun6i-csi.txt        | 59
> >  ++++++++++++++++++++++ 1 file changed, 59 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

I think other subsystem's maintainer may expect a Acked-by from you here.

Why do you use Reviewed-by here instead?

> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
