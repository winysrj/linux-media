Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46735 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdLZVx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 16:53:56 -0500
Date: Tue, 26 Dec 2017 15:53:54 -0600
From: Rob Herring <robh@kernel.org>
To: Priit Laes <plaes@plaes.org>
Cc: Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
Subject: Re: [linux-sunxi] [PATCH v4 1/2] dt-bindings: media: Add Allwinner
 V3s Camera Sensor Interface (CSI)
Message-ID: <20171226215354.7h3lvo3w5qb5piuy@rob-hp-laptop>
References: <1513935689-35415-1-git-send-email-yong.deng@magewell.com>
 <20171222100008.nmmzwhtmputizn7d@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171222100008.nmmzwhtmputizn7d@plaes.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 22, 2017 at 10:00:08AM +0000, Priit Laes wrote:
> On Fri, Dec 22, 2017 at 05:41:29PM +0800, Yong Deng wrote:
> > Add binding documentation for Allwinner V3s CSI.
> > 
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> >  .../devicetree/bindings/media/sun6i-csi.txt        | 51 ++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > new file mode 100644
> > index 0000000..b5bfe3f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > @@ -0,0 +1,51 @@
> > +Allwinner V3s Camera Sensor Interface
> > +------------------------------
> 
> Not sure whether syntax for these files is proper reStructuredText/Markdown,
> but the underline-ish style expects the title and underline having same length.

The binding files are not rst/md format, but still the comment is just 
good style.

Rob
