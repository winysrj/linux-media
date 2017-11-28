Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:38195 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdK1N6r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 08:58:47 -0500
Date: Tue, 28 Nov 2017 07:58:45 -0600
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
Subject: Re: [PATCH v5 1/2] media: ov7740: Document device tree bindings
Message-ID: <20171128135845.k4fy4ayl3z7fsdvr@rob-hp-laptop>
References: <20171128052259.4957-1-wenyou.yang@microchip.com>
 <20171128052259.4957-2-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128052259.4957-2-wenyou.yang@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 28, 2017 at 01:22:58PM +0800, Wenyou Yang wrote:
> Add the device tree binding documentation for the ov7740 sensor driver.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> ---
> 
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

Acked-by: Rob Herring <robh@kernel.org>
