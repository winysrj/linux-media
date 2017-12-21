Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-3.mail.aliyun.com ([115.124.20.3]:34453 "EHLO
        out20-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756272AbdLUCko (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 21:40:44 -0500
Date: Thu, 21 Dec 2017 10:40:10 +0800
From: Yong <yong.deng@magewell.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: maxime.ripard@free-electrons.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 3/3] media: MAINTAINERS: add entries for Allwinner
 V3s CSI
Message-Id: <20171221104010.4a3a121f947b0d24cc9b35b8@magewell.com>
In-Reply-To: <20171219114802.gi7db7xhm3eh4udt@valkosipuli.retiisi.org.uk>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
        <1501131697-1359-4-git-send-email-yong.deng@magewell.com>
        <20171219114802.gi7db7xhm3eh4udt@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 Dec 2017 13:48:03 +0200
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> On Thu, Jul 27, 2017 at 01:01:37PM +0800, Yong Deng wrote:
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> >  MAINTAINERS | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 9826a91..b91fa27 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3686,6 +3686,14 @@ M:	Jaya Kumar <jayakumar.alsa@gmail.com>
> >  S:	Maintained
> >  F:	sound/pci/cs5535audio/
> >  
> > +CSI DRIVERS FOR ALLWINNER V3s
> > +M:	Yong Deng <yong.deng@magewell.com>
> > +L:	linux-media@vger.kernel.org
> > +T:	git git://linuxtv.org/media_tree.git
> > +S:	Maintained
> > +F:	drivers/media/platform/sun6i-csi/
> > +F:	Documentation/devicetree/bindings/media/sun6i-csi.txt
> > +
> >  CW1200 WLAN driver
> >  M:	Solomon Peachy <pizza@shaftnet.org>
> >  S:	Maintained
> 
> Please squash to the driver patch. Thanks.

OK.

> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi


Thanks,
Yong
