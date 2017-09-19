Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:44428 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdISJU6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 05:20:58 -0400
Received: by mail-lf0-f52.google.com with SMTP id l196so3059592lfl.1
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 02:20:58 -0700 (PDT)
Subject: Re: [PATCHv2 1/2] dt-bindings: adi,adv7511.txt: document cec clock
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170919073331.29007-1-hverkuil@xs4all.nl>
 <20170919073331.29007-2-hverkuil@xs4all.nl>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <505bc74f-6563-ab1d-9aab-7893410aef7e@cogentembedded.com>
Date: Tue, 19 Sep 2017 12:20:56 +0300
MIME-Version: 1.0
In-Reply-To: <20170919073331.29007-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 9/19/2017 10:33 AM, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the cec clock binding.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>   Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> index 06668bca7ffc..4497ae054d49 100644
> --- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> @@ -68,6 +68,8 @@ Optional properties:
>   - adi,disable-timing-generator: Only for ADV7533. Disables the internal timing
>     generator. The chip will rely on the sync signals in the DSI data lanes,
>     rather than generate its own timings for HDMI output.
> +- clocks: from common clock binding: handle to CEC clock.

    It's called "phandle" in the DT speak. :-)
    Are you sure the clock specifier would always be absent?

> +- clock-names: from common clock binding: must be "cec".
>   
>   Required nodes:
>   
[...]

MBR, Sergei
