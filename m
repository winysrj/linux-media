Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46254 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732400AbeGJT6Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 15:58:25 -0400
Message-ID: <e31090c371ae7f7999b0aa983a20f33451cc89fb.camel@collabora.com>
Subject: Re: [PATCH v5 18/22] media: platform: Add Sunxi-Cedrus VPU decoder
 driver
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Date: Tue, 10 Jul 2018 16:57:34 -0300
In-Reply-To: <20180710080114.31469-19-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
         <20180710080114.31469-19-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Paul,

My comments on v4 of course apply here as well.

One other thing...

On Tue, 2018-07-10 at 10:01 +0200, Paul Kocialkowski wrote:
> This introduces the Sunxi-Cedrus VPU driver that supports the VPU
> found
> in Allwinner SoCs, also known as Video Engine. It is implemented
> through
> a v4l2 m2m decoder device and a media device (used for media
> requests).
> So far, it only supports MPEG2 decoding.
> 
> Since this VPU is stateless, synchronization with media requests is
> required in order to ensure consistency between frame headers that
> contain metadata about the frame to process and the raw slice data
> that
> is used to generate the frame.
> 
> This driver was made possible thanks to the long-standing effort
> carried out by the linux-sunxi community in the interest of reverse
> engineering, documenting and implementing support for Allwinner VPU.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> 
[..]
> +
> +static irqreturn_t cedrus_bh(int irq, void *data)
> +{
> +	struct cedrus_dev *dev = data;
> +	struct cedrus_ctx *ctx;
> +
> +	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
> +	if (!ctx) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "Instance released before the end of
> transaction\n");
> +		return IRQ_HANDLED;
> +	}
> +
> +	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> +

I don't like the fact that v4l2_m2m_job_finish calls .device_run
reentrantly. Let me try to make v4l2_m2m_job_finish() safe to be called
in atomic context, so hopefully drivers can just call it in the top-
half.

You are returning the buffers in the top-half, so this is just a matter
or better design, not a performance improvement.

Thanks,
Eze
