Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:32817 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbeI0FEm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 01:04:42 -0400
Date: Wed, 26 Sep 2018 17:49:28 -0500
From: Rob Herring <robh@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 4/9] media: dt-bindings: tvp5150: Add input port
 connectors DT bindings
Message-ID: <20180926224928.GA11753@bogus>
References: <20180918131453.21031-1-m.felsch@pengutronix.de>
 <20180918131453.21031-5-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918131453.21031-5-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Sep 2018 15:14:48 +0200, Marco Felsch wrote:
> The TVP5150/1 decoders support different video input sources to their
> AIP1A/B pins.
> 
> Possible configurations are as follows:
>   - Analog Composite signal connected to AIP1A.
>   - Analog Composite signal connected to AIP1B.
>   - Analog S-Video Y (luminance) and C (chrominance)
>     signals connected to AIP1A and AIP1B respectively.
> 
> This patch extends the device tree bindings documentation to describe
> how the input connectors for these devices should be defined in a DT.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
> Changelog:
> 
> v3:
> - remove examples for one and two inputs
> - replace space by tabs
> 
> v2:
> - adapt port layout in accordance with
>   https://www.spinics.net/lists/linux-media/msg138546.html with the
>   svideo-connector deviation (use only one endpoint)
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt | 92 +++++++++++++++++--
>  1 file changed, 85 insertions(+), 7 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
