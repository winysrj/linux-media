Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41288 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727404AbeI1Amp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 20:42:45 -0400
Date: Thu, 27 Sep 2018 13:23:11 -0500
From: Rob Herring <robh@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 3/7] [media] ad5820: DT new optional field enable-gpios
Message-ID: <20180927182311.GA27227@bogus>
References: <20180920204751.29117-1-ricardo.ribalda@gmail.com>
 <20180920204751.29117-3-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920204751.29117-3-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2018 at 10:47:47PM +0200, Ricardo Ribalda Delgado wrote:
> Document new enable-gpio field. It can be used to disable the part

enable-gpios

> without turning down its regulator.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  Documentation/devicetree/bindings/media/i2c/ad5820.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> index 5940ca11c021..9ccd96d3d5f0 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> @@ -8,6 +8,12 @@ Required Properties:
>  
>    - VANA-supply: supply of voltage for VANA pin
>  
> +Optional properties:
> +
> +   - enable-gpios : GPIO spec for the XSHUTDOWN pin. Note that the polarity of
> +the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the enable
> +GPIO deasserts the XSHUTDOWN signal and vice versa).

shutdown-gpios is also standard and seems like it would make more sense 
here. Yes, it is a bit redundant to have both, but things just evolved 
that way and we don't want to totally abandon the hardware names (just 
all the variants).

Rob
