Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35579 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdLDUYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 15:24:45 -0500
Date: Mon, 4 Dec 2017 14:24:43 -0600
From: Rob Herring <robh@kernel.org>
To: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] media: ov7740: Document device tree bindings
Message-ID: <20171204202443.jiizsqu6yfpsugj4@rob-hp-laptop>
References: <20171204065858.3138-1-wenyou.yang@microchip.com>
 <20171204065858.3138-2-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171204065858.3138-2-wenyou.yang@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 04, 2017 at 02:58:57PM +0800, Wenyou Yang wrote:
> Add the device tree binding documentation for the ov7740 sensor driver.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> ---
> 
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
>  - Explicitly document the "remote-endpoint" property.
> 
> Changes in v2: None
> 
>  .../devicetree/bindings/media/i2c/ov7740.txt       | 47 ++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt

Please add acks when posting new versions.

Rob
