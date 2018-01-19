Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:37809 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754267AbeASVOL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 16:14:11 -0500
Date: Fri, 19 Jan 2018 15:14:09 -0600
From: Rob Herring <robh@kernel.org>
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, megous@megous.com,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-sunxi@googlegroups.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/2] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
Message-ID: <20180119211409.ubysuyvhkmfotbdg@rob-hp-laptop>
References: <1515639823-35782-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515639823-35782-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 11, 2018 at 11:03:43AM +0800, Yong Deng wrote:
> Add binding documentation for Allwinner V3s CSI.
> 
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  .../devicetree/bindings/media/sun6i-csi.txt        | 59 ++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt

Reviewed-by: Rob Herring <robh@kernel.org>
