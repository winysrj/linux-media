Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55515 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933107AbeCSNLM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 09:11:12 -0400
Received: by mail-wm0-f66.google.com with SMTP id t7so2217642wmh.5
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 06:11:11 -0700 (PDT)
Subject: Re: [PATCH 1/3] dt-bindings: display: dw_hdmi.txt
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180319114345.29837-1-hverkuil@xs4all.nl>
 <20180319114345.29837-2-hverkuil@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <1ed321a1-cdfd-6e86-bb8d-4ca8ffeb6369@baylibre.com>
Date: Mon, 19 Mar 2018 14:11:09 +0100
MIME-Version: 1.0
In-Reply-To: <20180319114345.29837-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/03/2018 12:43, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Some boards have both a DesignWare and their own CEC controller.
> The CEC pin is only hooked up to their own CEC controller and not
> to the DW controller.
> 
> Add the cec-disable property to disable the DW CEC controller.
> 
> This particular situation happens on Amlogic boards that have their
> own meson CEC controller.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt
> index 33bf981fbe33..4a13f4858bc0 100644
> --- a/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt
> @@ -27,6 +27,9 @@ responsible for defining whether each property is required or optional.
>    - "isfr" is the internal register configuration clock (mandatory).
>    - "cec" is the HDMI CEC controller main clock (optional).
>  
> +- cec-disable: Do not use the DWC CEC controller since the CEC line is not
> +  hooked up even though the CEC DWC IP is present.
> +
>  - ports: The connectivity of the DWC HDMI TX with the rest of the system is
>    expressed in using ports as specified in the device graph bindings defined
>    in Documentation/devicetree/bindings/graph.txt. The numbering of the ports
> 

Acked-by: Neil Armstrong <narmstrong@baylibre.com>
