Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36267 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424793AbdD1Iwf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 04:52:35 -0400
Received: by mail-lf0-f52.google.com with SMTP id c80so30283632lfh.3
        for <linux-media@vger.kernel.org>; Fri, 28 Apr 2017 01:52:34 -0700 (PDT)
Subject: Re: [PATCH 4/5] arm64: dts: r8a7795: salvator-x: enable VIN, CSI and
 ADV7482
To: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
 <1493317564-18026-5-git-send-email-kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <05b07c91-c41a-a3ae-d660-06eff84cd453@cogentembedded.com>
Date: Fri, 28 Apr 2017 11:52:31 +0300
MIME-Version: 1.0
In-Reply-To: <1493317564-18026-5-git-send-email-kbingham@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 4/27/2017 9:26 PM, Kieran Bingham wrote:

> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> Provide bindings between the VIN, CSI and the ADV7482 on the r8a7795.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts | 129 +++++++++++++++++++++
>  1 file changed, 129 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts b/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
> index 27b9bae60dc0..a20623faa9d2 100644
> --- a/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
> +++ b/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
[...]
> @@ -387,6 +403,50 @@
>  	};
>  };
>
> +&i2c4 {
> +	status = "okay";
> +
> +	clock-frequency = <100000>;
> +
> +	video_receiver@70 {

    Hyphens are preferred in the node names.

[...]

MBR, Sergei
