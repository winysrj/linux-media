Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40116 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbeKNWKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 17:10:08 -0500
Received: by mail-pf1-f196.google.com with SMTP id x2-v6so7815059pfm.7
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 04:07:09 -0800 (PST)
Date: Wed, 14 Nov 2018 17:36:52 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, robh+dt@kernel.org, todor.tomov@linaro.org,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: media: i2c: Fix external clock frequency
 for OV5645
Message-ID: <20181114120652.GA26112@Mani-XPS-13-9360>
References: <20181114103935.24559-1-manivannan.sadhasivam@linaro.org>
 <20181114105712.j5jkspfasujiyqzs@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114105712.j5jkspfasujiyqzs@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2018 at 12:57:12PM +0200, Sakari Ailus wrote:
> Hi Manivannan,
> 
> On Wed, Nov 14, 2018 at 04:09:35PM +0530, Manivannan Sadhasivam wrote:
> > Commit "4adb0a0432f4 media: ov5645: Supported external clock is 24MHz"
> > modified the external clock frequency to be 24MHz instead of the
> > 23.88MHz in driver. Hence, make the same change in corresponding bindings
> > doc and mention the acceptable tolerance.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/media/i2c/ov5645.txt | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> > index fd7aec9f8e24..b155583469a4 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> > @@ -8,7 +8,8 @@ Required Properties:
> >  - compatible: Value should be "ovti,ov5645".
> >  - clocks: Reference to the xclk clock.
> >  - clock-names: Should be "xclk".
> > -- clock-frequency: Frequency of the xclk clock.
> > +- clock-frequency: Frequency of the xclk clock. Should be 24MHz with 1%
> > +                   acceptable tolerance.
> 
> DT bindings are for documenting the hardware, not the driver implementation.
> The sensor supports a range AFAIU, not a specific frequency.
>

Agree! That's my bad.

> The bit below seems good.
> 

Okay. Will remove the above change and send v2.

Thanks,
Mani

> >  - enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH. This corresponds
> >    to the hardware pin PWDNB which is physically active low.
> >  - reset-gpios: Chip reset GPIO. Polarity is GPIO_ACTIVE_LOW. This corresponds to
> > @@ -37,7 +38,7 @@ Example:
> >  
> >  			clocks = <&clks 200>;
> >  			clock-names = "xclk";
> > -			clock-frequency = <23880000>;
> > +			clock-frequency = <24000000>;
> >  
> >  			vdddo-supply = <&camera_dovdd_1v8>;
> >  			vdda-supply = <&camera_avdd_2v8>;
> > -- 
> > 2.17.1
> > 
> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
