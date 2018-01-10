Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57044 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752296AbeAJWZM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 17:25:12 -0500
Date: Thu, 11 Jan 2018 00:25:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Yong Deng <yong.deng@magewell.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Message-ID: <20180110222508.4x5kimanevttmqis@valkosipuli.retiisi.org.uk>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
 <20180110153724.l77zpdgxfbzkznuf@flea>
 <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Wed, Jan 10, 2018 at 03:51:07PM +0000, Hugues FRUCHET wrote:
> Good news Maxime !
> 
> Have you seen that you can adapt the polarities through devicetree ?
> 
> +                       /* Parallel bus endpoint */
> +                       ov5640_to_parallel: endpoint {
> [...]
> +                               hsync-active = <0>;
> +                               vsync-active = <0>;
> +                               pclk-sample = <1>;
> +                       };
> 
> Doing so you can adapt to your SoC/board setup easily.
> 
> If you don't put those lines in devicetree, the ov5640 default init 
> sequence is used which set the polarity as defined in below comment:
> ov5640_set_stream_dvp()
> [...]
> +        * Control lines polarity can be configured through
> +        * devicetree endpoint control lines properties.
> +        * If no endpoint control lines properties are set,
> +        * polarity will be as below:
> +        * - VSYNC:     active high
> +        * - HREF:      active low
> +        * - PCLK:      active low
> +        */
> [...]

The properties are at the moment documented as mandatory in DT binding
documentation.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
