Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45860 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbeJaH1M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 03:27:12 -0400
Date: Tue, 30 Oct 2018 17:31:49 -0500
From: Rob Herring <robh@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        enrico.scholz@sigma-chemnitz.de, akinobu.mita@gmail.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH v2 6/6] dt-bindings: media: mt9m111: add pclk-sample
 property
Message-ID: <20181030223149.GA24283@bogus>
References: <20181029182410.18783-1-m.felsch@pengutronix.de>
 <20181029182410.18783-7-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029182410.18783-7-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Oct 2018 19:24:10 +0100, Marco Felsch wrote:
> Add the pclk-sample property to the list of optional properties
> for the mt9m111 camera sensor.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
