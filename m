Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34854 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751056AbdFZSyV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 14:54:21 -0400
Date: Mon, 26 Jun 2017 13:54:19 -0500
From: Rob Herring <robh@kernel.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
Message-ID: <20170626185419.4puto5zwexdct2fy@rob-hp-laptop>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 22, 2017 at 05:05:37PM +0200, Hugues Fruchet wrote:
> From: "H. Nikolaus Schaller" <hns@goldelico.com>
> 
> This adds documentation of device tree bindings
> for the OV965X family camera sensor module.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  .../devicetree/bindings/media/i2c/ov965x.txt       | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov965x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov965x.txt b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
> new file mode 100644
> index 0000000..0e0de1f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
> @@ -0,0 +1,37 @@
> +* Omnivision OV9650/9652/9655 CMOS sensor
> +
> +The Omnivision OV965x sensor support multiple resolutions output, such as
> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
> +output format.
> +
> +Required Properties:
> +- compatible: should be one of
> +	"ovti,ov9650"
> +	"ovti,ov9652"
> +	"ovti,ov9655"
> +- clocks: reference to the mclk input clock.
> +
> +Optional Properties:
> +- resetb-gpios: reference to the GPIO connected to the resetb pin, if any.

reset-gpios and state it is active low.

> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.

powerdown-gpios and state it is active ???.

Those are semi-standard names.

With that,

Acked-by: Rob Herring <robh@kernel.org>
