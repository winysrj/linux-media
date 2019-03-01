Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471FCC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 14:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C4F42084F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 14:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfCAOfG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:35:06 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:57965 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbfCAOfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 09:35:06 -0500
Received: from [IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48] ([IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zjFegOtioLMwIzjFfgjFfz; Fri, 01 Mar 2019 15:35:04 +0100
Subject: Re: [PATCH RESEND v2 1/2] media: dt-bindings: media: rcar-csi2: Add
 r8a774a1 support
To:     Biju Das <biju.das@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
References: <1551450253-63390-1-git-send-email-biju.das@bp.renesas.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <615b0c46-5939-bdce-e975-8572d42bdbe8@xs4all.nl>
Date:   Fri, 1 Mar 2019 15:35:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <1551450253-63390-1-git-send-email-biju.das@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFfbVXWU5wUa8vAKEu8x2bkUIJsdtErQBN5IPp00VS5vHr8yP2YoSEzScuH5SW3KFQTcp28CouAntr09wbpZYlGd44sXe+UBWiimLfbAEvzXxnrm6jCA
 LB4Rzsr0ZiTbOIlzK0I2LLQG+rH3Syh7vfMJFwaYmiBI0CVYhz0affdz6AQIGWXMejWXWsu1QK7Z6VVVmDm6auVnvrCJfuxSqZ/CSOAa0NwDMeAsmxV8zjxT
 CLYTEnNbRdfCU+dtS5BvBbN+mc7/oab1dWXzyW+7VmzxM7W2GOumr+KvQN2w/+cS0v4MmHWTOIGNjhl9EPL/0ktp7DTHOiMsG8+eTWYpTPivNzyLIHmSZGPk
 y5VpTT0IgaUiRe7/xxiYAxi/Riw74YmgbmcGUc+lTvT7HFSapylA9YrRzkEXkZ8k5Daby6BdPk8kiwEM0QLQR8m71xwkTv6yBo3qOA7rvmx8pOreiFmnq6RR
 OxbKoNDv+kJukyztTnDFRJTM08GLgchkhVORskzpYb+gmqhv9B7sznB63vkrbLtvZQSz5VB9304iKPIiQMhBIViEx7aZ/fIc66i+acfSM2vMd+pV0J0Aj179
 KEDs+jqkA6C7lxVdkDseZPNSLpCiGtAbAGxERnxyenPyNh9DAOzQKIoIJBdeifOuYQWVHh+FzXpYRtKoVCGmbpnc99kE5qmPsQRQsrAv5OejUA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/1/19 3:24 PM, Biju Das wrote:
> Document RZ/G2M (R8A774A1) SoC bindings.

Please resend the whole series, not just the dt-bindings patches.

Also note that the original v1 series said that there were 5 patches in
the series, but only the first 4 were received on linux-media. So I have
no idea what the 5th patch was (dts change perhaps?).

Having a newly posted patch series avoids confusion.

Regards,

	Hans

> 
> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
> 
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
> V1->V2
>    * No change
> ---
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> index d63275e..9932458 100644
> --- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> @@ -8,6 +8,7 @@ R-Car VIN module, which provides the video capture capabilities.
>  Mandatory properties
>  --------------------
>   - compatible: Must be one or more of the following
> +   - "renesas,r8a774a1-csi2" for the R8A774A1 device.
>     - "renesas,r8a774c0-csi2" for the R8A774C0 device.
>     - "renesas,r8a7795-csi2" for the R8A7795 device.
>     - "renesas,r8a7796-csi2" for the R8A7796 device.
> 

