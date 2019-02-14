Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313F9C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 07:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A9722229F
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 07:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392512AbfBNHds (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 02:33:48 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59276 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726955AbfBNHds (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 02:33:48 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id uBWWgIMxHLMwIuBWZgOLfO; Thu, 14 Feb 2019 08:33:45 +0100
Subject: Re: [RESEND PATCH v4,1/3] media: dt-bindings: media: add
 'assigned-clocks' to vcodec examples
To:     Yunfei Dong <yunfei.dong@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Qianqian Yan <qianqian.yan@mediatek.com>
References: <1550111093-7057-1-git-send-email-yunfei.dong@mediatek.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3f77d34a-a2a4-a2c1-a4e6-32669ff69357@xs4all.nl>
Date:   Thu, 14 Feb 2019 08:33:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1550111093-7057-1-git-send-email-yunfei.dong@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBugUWMcmJhaAPPMSjla3U+JKeQ1EE/g/hB7syAzumF6XudhzAvX5uiNYtF9J+g5kf29qqmLLPeh6HBnrvaxXZZYmPAAexBFSRhKLEJxv72lpA6dywQg
 3VJYP/HEePYZhzT8yzUXUZZMTW7J5QHI3yIB/1SgA9FEnYxwZ/DeF9lPTlleZluGT0Sdz21Tb87akM55Iorw2qtYOFRCVya185Qvj11ULEQEcQKufGfbgslI
 l9bdwhXDOToFFn1+hGD7TSFnA1L8b7zenmNBr7mFzgyESDiCyiy2OBbUlphxwiuYf5uJyXH5GbQTpqouF5lMjHqtHszrVENh/L/K+XFXqo+i5/zO0MnpVKMC
 NvI9LXjhoT9WCsnzq3USVIxQpn4o5dPfbdL3CltMQAynZSwUWaIcbPp6ZLuhl0X7gfXUOud0s/jNgl0VeBQCaz1PxL651hnPlUkIqtdEMG0uDvn22rZkYxHf
 AW96M5Uxtck2hrm/xgpY4PG4nOgB57mfcjUOVRn8857U7W2U3h3vjZB5L0cMqwLOcPnqc/1TColFrVGZlxVjLdu+W9AlE2XeL3MBIDX9vpruP/hbTskt5kse
 kibisxZYa09XkAXmkZffF4vbTpKOXLpzlZePErCqKheVu8Ap0Lwr/ZVejTx6qaJQfKk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yunfei Dong,

Why is this series resent? Patches 1 and 3 have been merged in our
media master tree already.

Regards,

	Hans

On 2/14/19 3:24 AM, Yunfei Dong wrote:
> Fix MTK binding document for MT8173 dtsi changed in order
> to use standard CCF interface.
> MT8173 SoC from Mediatek.
> 
> Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
> Signed-off-by: Qianqian Yan <qianqian.yan@mediatek.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/media/mediatek-vcodec.txt  |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> index 2a615d8..b6b5dde 100644
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
> 

