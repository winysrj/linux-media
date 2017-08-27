Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55794
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751182AbdH0Psm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 11:48:42 -0400
Date: Sun, 27 Aug 2017 12:48:30 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Cc: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: Re: [PATCH v3 14/14] [media] cxd2880 : Update MAINTAINERS file for
 CXD2880 driver
Message-ID: <20170827124657.1feb8f36@vento.lan>
In-Reply-To: <47f57a12-65fc-beb7-a330-eb38690ccdfc@sony.com>
References: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
        <20170816044733.21869-1-Yasunari.Takiguchi@sony.com>
        <47f57a12-65fc-beb7-a330-eb38690ccdfc@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Aug 2017 17:02:05 +0900
"Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com> escreveu:

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> I add an e-mail address and re-send this mail again.
> 
> This is MAINTAINERS file update about the driver for
> the Sony CXD2880 DVB-T2/T tuner + demodulator.

Patches 12-14 look OK to me (although I didn't try to compile).

You can likely fold them into a single patch adding an entry to 
MAINTAINERS and the driver to Kconfig/Makefile.

Regards,
Mauro

> 
> [Change list]
> Changes in V3
>    MAINTAINERS
>       -no change
> 
> Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
> Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
> Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
> Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
> Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6f7721d1634c..12a80c33c194 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8302,6 +8302,15 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Supported
>  F:	drivers/media/dvb-frontends/cxd2841er*
>  
> +MEDIA DRIVERS FOR CXD2880
> +M:	Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> +L:	linux-media@vger.kernel.org
> +W:	http://linuxtv.org/
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Supported
> +F:	drivers/media/dvb-frontends/cxd2880/*
> +F:	drivers/media/spi/cxd2880*
> +
>  MEDIA DRIVERS FOR FREESCALE IMX
>  M:	Steve Longerbeam <slongerbeam@gmail.com>
>  M:	Philipp Zabel <p.zabel@pengutronix.de>



Thanks,
Mauro
