Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34032 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbeEQJCb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 05:02:31 -0400
Received: by mail-lf0-f67.google.com with SMTP id r25-v6so7629701lfd.1
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 02:02:30 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: media: rcar_vin: fix style for ports and
 endpoints
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20180516233212.30931-1-niklas.soderlund+renesas@ragnatech.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <53a2030d-32de-6887-4527-56f885e9f845@cogentembedded.com>
Date: Thu, 17 May 2018 12:02:28 +0300
MIME-Version: 1.0
In-Reply-To: <20180516233212.30931-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5/17/2018 2:32 AM, Niklas Söderlund wrote:

> The style for referring to ports and endpoint are wrong. Refer to them
> using lowercase and a unit address, port@x and endpoint@x.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

    More typos, yay! :-)

> ---
>   .../devicetree/bindings/media/rcar_vin.txt    | 20 +++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index c2c57dcf73f4851b..a574b9c037c05a3c 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -45,23 +45,23 @@ The per-board settings Gen2 platforms:
>   The per-board settings Gen3 platforms:
>   
>   Gen3 platforms can support both a single connected parallel input source
> -from external SoC pins (port0) and/or multiple parallel input sources
> -from local SoC CSI-2 receivers (port1) depending on SoC.
> +from external SoC pins (port@0) and/or multiple parallel input sources
> +from local SoC CSI-2 receivers (port@1) depending on SoC.
>   
>   - renesas,id - ID number of the VIN, VINx in the documentation.
>   - ports
> -    - port 0 - sub-node describing a single endpoint connected to the VIN
> +    - port@0 - sub-node describing a single endpoint connected to the VIN
>         from external SoC pins described in video-interfaces.txt[1].
> -      Describing more then one endpoint in port 0 is invalid. Only VIN
> -      instances that are connected to external pins should have port 0.
> -    - port 1 - sub-nodes describing one or more endpoints connected to
> +      Describing more then one endpoint in port@0 is invalid. Only VIN

    s/then/than/.

> +      instances that are connected to external pins should have port@0.
> +    - port@1 - sub-nodes describing one or more endpoints connected to
>         the VIN from local SoC CSI-2 receivers. The endpoint numbers must
>         use the following schema.
[...]

MBR, Sergei
