Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f51.google.com ([209.85.210.51]:43239 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbeKRC6V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 21:58:21 -0500
Date: Sat, 17 Nov 2018 10:41:05 -0600
From: Rob Herring <robh@kernel.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: mchehab@kernel.org, robh+dt@kernel.org, todor.tomov@linaro.org,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH] dt-bindings: media: i2c: Fix i2c address for OV5645
 camera sensor
Message-ID: <20181117164105.GA19803@bogus>
References: <20181109075643.17575-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109075643.17575-1-manivannan.sadhasivam@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  9 Nov 2018 13:26:43 +0530, Manivannan Sadhasivam wrote:
> The i2c address for the Omnivision OV5645 camera sensor is 0x3c. It is
> incorrectly mentioned as 0x78 in binding. Hence fix that.
> 
> Fixes: 09c716af36e6 [media] media: i2c/ov5645: add the device tree binding document
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  Documentation/devicetree/bindings/media/i2c/ov5645.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
