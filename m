Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66731C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E51D20830
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553551052;
	bh=2UXH/nieM7kz0Of9oivkO4olTzi9QypOlRbjsDwKFbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OLnr2pd4hrx6SFlLcoHyepW5d84Wds7bHrqE52GN6fzLKFC0tCTr1Ldwz79CU3N0e
	 Ylu771R8P71OOzICgI3Hyc/7S3v598ciiP5Jv5tFix2KFYvTi2O3q36oCvncVkuVWY
	 fWib0KUyGORYi9rJLXZG/3oj8/9tbdUsSQisMScc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfCYV5b (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:57:31 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39368 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfCYV5b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 17:57:31 -0400
Received: by mail-ot1-f66.google.com with SMTP id f10so9567933otb.6;
        Mon, 25 Mar 2019 14:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=10sriBIAmSJ6IRfrTfFYBqT5ofmD7czWfLFAY9Ej6Zo=;
        b=HMJV4fYyUhaRPVjNPMYKky9J6t3VKeEq9kZ1QnybnfXEnWdQGpSV4eJsEkNK83LXq9
         OE+SCWt7SIe8DsjyQmeqY7RgtcTxfEp+Jkg30V1o62WVOH3XHxFW9YW2kwoSMXa53FKu
         2O0DJUmu0GsMaTmOtW6dGzVEzvME076faw2q6qNeh2cyMh/4aij22xtu6Mvck+C85umi
         CM/fYukITIflEQx+spiY9fbMD1zUGSNcL9VwytO1Np7YvUQjK44/hPv5o4YQW2k6lfKn
         Wm+x9cDy9hnHzS6/HyE9XSWGdFdMSIiZfvg6zUNui0KpBJ6IYdLhELEqntmlHbiodbXn
         ubUg==
X-Gm-Message-State: APjAAAUrd+Ep2DNi6VLZvZ6rnY7/1kRb3aOp/i9STGKBDsmdYWvxDLRL
        V6mzigxq1S9EvBMA5qJXiw==
X-Google-Smtp-Source: APXvYqya80aROpDRMbwxrqj8cBCb/e1L4DHLEs3UON/x1zFYaYpxd1DVY4jqVxXqpqbQuN/zGdrqmw==
X-Received: by 2002:a9d:7d95:: with SMTP id j21mr9473449otn.141.1553551050146;
        Mon, 25 Mar 2019 14:57:30 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 92sm6842993oti.60.2019.03.25.14.57.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 14:57:29 -0700 (PDT)
Date:   Mon, 25 Mar 2019 16:57:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jerry-ch Chen <Jerry-Ch.chen@mediatek.com>
Cc:     hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        tfiga@chromium.org, matthias.bgg@gmail.com, mchehab@kernel.org,
        yuzhao@chromium.org, zwisler@chromium.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, frederic.chen@mediatek.com,
        jungo.lin@mediatek.com, Rynn.Wu@mediatek.com,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH V0 5/7] dts: arm64: mt8183: Add FD nodes
Message-ID: <20190325215728.GA32712@bogus>
References: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
 <1550648893-42050-6-git-send-email-Jerry-Ch.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550648893-42050-6-git-send-email-Jerry-Ch.chen@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Feb 20, 2019 at 03:48:11PM +0800, Jerry-ch Chen wrote:
> This patch adds nodes for Face Detection (FD) unit. FD is embedded
> in Mediatek SoCs and works with the co-processor to perform face
> detection on the input data and image and output detected face result.
> 
> Signed-off-by: Jerry-ch Chen <jerry-ch.chen@mediatek.com>
> ---
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
> index b3d8dfd..45c7e2f 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
> @@ -440,6 +440,26 @@
>  			#clock-cells = <1>;
>  		};
>  
> +		fd_smem: fd_smem {
> +			compatible = "mediatek,fd_smem";
> +			mediatek,larb = <&larb5>;
> +			iommus = <&iommu M4U_PORT_CAM_IMGI>;

This doesn't look like an actual h/w device...

> +		};
> +
> +		fd:fd@1502b000 {

space after the :  ^
> +			compatible = "mediatek,fd";

Should be SoC specific.

> +			mediatek,larb = <&larb5>;
> +			mediatek,vpu = <&vpu>;
> +			iommus = <&iommu M4U_PORT_CAM_FDVT_RP>,
> +				 <&iommu M4U_PORT_CAM_FDVT_WR>,
> +				 <&iommu M4U_PORT_CAM_FDVT_RB>;
> +			reg = <0 0x1502b000 0 0x1000>;
> +			interrupts = <GIC_SPI 269 IRQ_TYPE_LEVEL_LOW>;
> +			clocks = <&imgsys CLK_IMG_FDVT>;
> +			clock-names = "FD_CLK_IMG_FD";
> +			smem_device = <&fd_smem>;
> +		};
> +
>  		vdecsys: syscon@16000000 {
>  			compatible = "mediatek,mt8183-vdecsys", "syscon";
>  			reg = <0 0x16000000 0 0x1000>;
> -- 
> 1.9.1
> 
