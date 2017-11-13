Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-85.mail.aliyun.com ([115.124.20.85]:39516 "EHLO
        out20-85.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbdKMIay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 03:30:54 -0500
Date: Mon, 13 Nov 2017 16:30:29 +0800
From: Yong <yong.deng@magewell.com>
To: yong.deng@magewell.com
Cc: maxime.ripard@free-electrons.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, megous@megous.com
Subject: Re: [linux-sunxi] [PATCH v3 3/3] media: MAINTAINERS: add entries
 for Allwinner V3s CSI
Message-Id: <20171113163029.d0563943558192e36af7c9b0@magewell.com>
In-Reply-To: <1510558631-45511-1-git-send-email-yong.deng@magewell.com>
References: <1510558631-45511-1-git-send-email-yong.deng@magewell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 13 Nov 2017 15:37:11 +0800
Yong Deng <yong.deng@magewell.com> wrote:

> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index adbf693..1ba7782 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3744,6 +3744,14 @@ M:	Jaya Kumar <jayakumar.alsa@gmail.com>
>  S:	Maintained
>  F:	sound/pci/cs5535audio/
>  
> +CSI DRIVERS FOR ALLWINNER V3s
> +M:	Yong Deng <yong.deng@magewell.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/platform/sun6i-csi/

Sorry, the path has been changed to drivers/media/platform/sunxi/sun6i-csi/.
I will fix it.

> +F:	Documentation/devicetree/bindings/media/sun6i-csi.txt
> +
>  CW1200 WLAN driver
>  M:	Solomon Peachy <pizza@shaftnet.org>
>  S:	Maintained
> -- 
> 1.8.3.1
> 
> -- 
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.


Thanks,
Yong
