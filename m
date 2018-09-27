Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:33018 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbeI0Xpn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 19:45:43 -0400
Date: Thu, 27 Sep 2018 19:26:21 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH 3/4] media: dt-bindings: media: Document
 pclk-max-frequency property
Message-ID: <20180927172621.5ohzrplohwdipubv@flea>
References: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
 <1538059567-8381-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1538059567-8381-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Thu, Sep 27, 2018 at 04:46:06PM +0200, Hugues Fruchet wrote:
> This optional property aims to inform parallel video devices
> of the maximum pixel clock frequency admissible by host video
> interface. If bandwidth of data to be transferred requires a
> pixel clock which is higher than this value, parallel video
> device could then typically adapt framerate to reach
> this constraint.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index baf9d97..fa4c112 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -147,6 +147,8 @@ Optional endpoint properties
>    as 0 (normal). This property is valid for serial busses only.
>  - strobe: Whether the clock signal is used as clock (0) or strobe (1). Used
>    with CCP2, for instance.
> +- pclk-max-frequency: maximum pixel clock frequency admissible by video
> +  host interface.

That seems to be a property of the capture device, not the camera
itself. Can't that be negotiated through the media API?

Maxime

-- 
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
