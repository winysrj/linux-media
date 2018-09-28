Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34882 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbeI1NZc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 09:25:32 -0400
Date: Fri, 28 Sep 2018 10:03:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH 3/4] media: dt-bindings: media: Document
 pclk-max-frequency property
Message-ID: <20180928070312.a22olexufppfejes@valkosipuli.retiisi.org.uk>
References: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
 <1538059567-8381-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538059567-8381-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

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

Is there a limit on the pixel clock or the link frequency?

We do have a property for the link frequency and a control for the pixel
lock as well as for the link frequency. Could these be used for the
purpose?

The link frequency in general should be specified for the board, and that
limits the pixel clock as well in the case the bus transfers a given number
of pixels per clock.

The OMAP3ISP driver also address this by reading back the pixel clock from
the sensor before starting streaming.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
