Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004AAC43444
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 23:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9086208E3
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 23:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546557451;
	bh=8+1K/65q8YIsxT57Dj8PaUPLu/getQfSgRRydgJ0sYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Cgtub3JnvxA+Q8x+HY0PmOoJEVPAqpeGgTEy4IWmmfkTnBKWuORCtDVRZCLrZbLvG
	 AXAAP/smOek9vmE89wmCgRTSA/TGVJqn1itDkbNXo9XfSHVRGSXi+rzjpYYmuYlMDq
	 loVbHYp5ait7d0n3RQnZbJJmFw30ungJW7Ha8HL4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfACXR0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 18:17:26 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41336 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfACXR0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2019 18:17:26 -0500
Received: by mail-io1-f68.google.com with SMTP id s22so28292971ioc.8;
        Thu, 03 Jan 2019 15:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4JIcbvjrZmcvoDvGz4q9vihXqUpjv7JgO3AxNDPJtnQ=;
        b=Cco/m2rBgKxKt8LOhU9ExkGhfl/N1YxzEraTyiATH6sbSy8QWxhsrh/WCFeOGfCtKe
         DS4GooMrSemUysyNtKfN5Y2mbcPA7Q0PYB2WdoI+3C2WNOK4cDoMlRK+eBpdt5ikt4M7
         CHWZ5AsUqA0SJnWezYKnXjHfugWBPFUi1e02taHxIGSZyPKesfVNFwRBwQ5m1uJ+SJJV
         Oc/BMTizUs61vcDVX6G/YvpVEhlK0xbDl75bJfFOIVrxPZ0d8dLQ8lkS6AygdmB27MDu
         5LN9Rm9XnkcJrEbSxBRjs5FqFLF8ynwjR4kskr/3qDLRVvzg37+jAe4PO4F6HxdogKpY
         8DoQ==
X-Gm-Message-State: AJcUukfpOBWuHU7gbBUdlqUXs7VqQPd3TruSp2neLjWbTWylKRerjKZB
        gJ1NiXEpcGus6tTkPzmrfw==
X-Google-Smtp-Source: ALg8bN4IeHDJUp9viaThDIRN53a8vKbQuwUlWNqHSXFO6QbsDLCuVGcQIXAjHM+aUZNT8RlP7GHzmw==
X-Received: by 2002:a5d:9518:: with SMTP id d24mr22117091iom.280.1546557444057;
        Thu, 03 Jan 2019 15:17:24 -0800 (PST)
Received: from localhost ([24.51.61.172])
        by smtp.gmail.com with ESMTPSA id j129sm24122918itb.41.2019.01.03.15.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Jan 2019 15:17:23 -0800 (PST)
Date:   Thu, 3 Jan 2019 17:17:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Yunfei Dong <yunfei.dong@mediatek.com>
Cc:     Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Qianqian Yan <qianqian.yan@mediatek.com>
Subject: Re: [PATCH 1/3] media: dt-bindings: media: Fix MTK document for
 vcodec
Message-ID: <20190103231722.GA22018@bogus>
References: <1545978785-31375-1-git-send-email-yunfei.dong@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545978785-31375-1-git-send-email-yunfei.dong@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 28, 2018 at 02:33:03PM +0800, Yunfei Dong wrote:
> Fix MTK binding document for MT8173 dtsi changed in order
> to use standard CCF interface.
> MT8173 SoC from Mediatek.

A better subject would be "add 'assigned-clocks' to vcodec examples".

> 
> Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
> Signed-off-by: Qianqian Yan <qianqian.yan@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-vcodec.txt   | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> index 2a615d84a682..b6b5dde6abd8 100644
> --- a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> +++ b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> @@ -66,6 +66,15 @@ vcodec_dec: vcodec@16000000 {
>                    "vencpll",
>                    "venc_lt_sel",
>                    "vdec_bus_clk_src";
> +    assigned-clocks = <&topckgen CLK_TOP_VENC_LT_SEL>,
> +                      <&topckgen CLK_TOP_CCI400_SEL>,
> +                      <&topckgen CLK_TOP_VDEC_SEL>,
> +                      <&apmixedsys CLK_APMIXED_VCODECPLL>,
> +                      <&apmixedsys CLK_APMIXED_VENCPLL>;
> +    assigned-clock-parents = <&topckgen CLK_TOP_VCODECPLL_370P5>,
> +                             <&topckgen CLK_TOP_UNIVPLL_D2>,
> +                             <&topckgen CLK_TOP_VCODECPLL>;
> +    assigned-clock-rates = <0>, <0>, <0>, <1482000000>, <800000000>;
>    };
>  
>    vcodec_enc: vcodec@18002000 {
> @@ -105,4 +114,8 @@ vcodec_dec: vcodec@16000000 {
>                    "venc_sel",
>                    "venc_lt_sel_src",
>                    "venc_lt_sel";
> +    assigned-clocks = <&topckgen CLK_TOP_VENC_SEL>,
> +                      <&topckgen CLK_TOP_VENC_LT_SEL>;
> +    assigned-clock-parents = <&topckgen CLK_TOP_VENCPLL_D2>,
> +                             <&topckgen CLK_TOP_UNIVPLL1_D2>;
>    };
> -- 
> 2.19.1
> 
