Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-86.mail.aliyun.com ([115.124.20.86]:56609 "EHLO
        out20-86.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbdHWCc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 22:32:56 -0400
Date: Wed, 23 Aug 2017 10:32:16 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-Id: <20170823103216.e43283308c195c4a80d929fa@magewell.com>
In-Reply-To: <20170822174339.6woauylgzkgqxygk@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
        <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
        <20170728160233.xooevio4hoqkgfaq@flea.lan>
        <20170731111640.d5a8e580a48183cfce85943d@magewell.com>
        <20170822174339.6woauylgzkgqxygk@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 22 Aug 2017 19:43:39 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi Yong,
> 
> On Mon, Jul 31, 2017 at 11:16:40AM +0800, Yong wrote:
> > > > @@ -143,6 +143,7 @@ source "drivers/media/platform/am437x/Kconfig"
> > > >  source "drivers/media/platform/xilinx/Kconfig"
> > > >  source "drivers/media/platform/rcar-vin/Kconfig"
> > > >  source "drivers/media/platform/atmel/Kconfig"
> > > > +source "drivers/media/platform/sun6i-csi/Kconfig"
> > > 
> > > We're going to have several different drivers in v4l eventually, so I
> > > guess it would make sense to move to a directory of our own.
> > 
> > Like this?
> > drivers/media/platform/sunxi/sun6i-csi
> 
> Yep.
> 
> > > > +static int sun6i_graph_notify_complete(struct v4l2_async_notifier *notifier)
> > > > +{
> > > > +	struct sun6i_csi *csi =
> > > > +			container_of(notifier, struct sun6i_csi, notifier);
> > > > +	struct sun6i_graph_entity *entity;
> > > > +	int ret;
> > > > +
> > > > +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> > > > +
> > > > +	/* Create links for every entity. */
> > > > +	list_for_each_entry(entity, &csi->entities, list) {
> > > > +		ret = sun6i_graph_build_one(csi, entity);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +	}
> > > > +
> > > > +	/* Create links for video node. */
> > > > +	ret = sun6i_graph_build_video(csi);
> > > > +	if (ret < 0)
> > > > +		return ret;
> > > 
> > > Can you elaborate a bit on the difference between a node parsed with
> > > _graph_build_one and _graph_build_video? Can't you just store the
> > > remote sensor when you build the notifier, and reuse it here?
> > 
> > There maybe many usercases:
> > 1. CSI->Sensor.
> > 2. CSI->MIPI->Sensor.
> > 3. CSI->FPGA->Sensor1
> >             ->Sensor2.
> > FPGA maybe some other video processor. FPGA, MIPI, Sensor can be
> > registered as v4l2 subdevs. We do not care about the driver code
> > of them. But they should be linked together here.
> > 
> > So, the _graph_build_one is used to link CSI port and subdevs. 
> > _graph_build_video is used to link CSI port and video node.
> 
> So the graph_build_one is for the two first cases, and the
> _build_video for the latter case?

No. 
The _graph_build_one is used to link the subdevs found in the device 
tree. _build_video is used to link the closest subdev to video node.
Video node is created in the driver, so the method to get it's pad is
diffrent to the subdevs.

> 
> If so, you should take a look at the last iteration of the
> subnotifiers rework by Nikas Söderlund (v4l2-async: add subnotifier
> registration for subdevices).
> 
> It allows subdevs to register notifiers, and you don't have to build
> the graph from the video device, each device and subdev can only care
> about what's next in the pipeline, but not really what's behind it.
> 
> That would mean in your case that you can only deal with your single
> CSI pad, and whatever subdev driver will use it care about its own.

Do you mean the subdevs create pad link in the notifier registered by
themself ?
If so, _graph_build_one is needless. But how to make sure the pipeline
has linked correctly when operateing the pipeline. 
I will lookt at this in more detail.

> 
> > This part is also difficult to understand for me. The one CSI module
> > have only one DMA channel(single port). But thay can be linked to 
> > different physical port (Parallel or MIPI)(multiple ep) by IF select
> > register.
> > 
> > For now, the binding can have several ep, the driver will just pick
> > the first valid one.
> 
> Yeah, I'm not really sure how we could deal with that, but I guess we
> can do it later on.
> 
> > > 
> > > > +struct sun6i_csi_ops {
> > > > +	int (*get_supported_pixformats)(struct sun6i_csi *csi,
> > > > +					const u32 **pixformats);
> > > > +	bool (*is_format_support)(struct sun6i_csi *csi, u32 pixformat,
> > > > +				  u32 mbus_code);
> > > > +	int (*s_power)(struct sun6i_csi *csi, bool enable);
> > > > +	int (*update_config)(struct sun6i_csi *csi,
> > > > +			     struct sun6i_csi_config *config);
> > > > +	int (*update_buf_addr)(struct sun6i_csi *csi, dma_addr_t addr);
> > > > +	int (*s_stream)(struct sun6i_csi *csi, bool enable);
> > > > +};
> > > 
> > > Didn't we agreed on removing those in the first iteration? It's not
> > > really clear at this point whether they will be needed at all. Make
> > > something simple first, without those ops. When we'll support other
> > > SoCs we'll have a better chance at seeing what and how we should deal
> > > with potential quirks.
> > 
> > OK. But without ops, it is inappropriate to sun6i_csi and sun6i_csi.
> > Maybe I should merge the two files.
> 
> I'm not sure what you meant here, but if you think that's appropriate,
> please go ahead.
> 
> > > > +		return IRQ_HANDLED;
> > > > +	}
> > > > +
> > > > +	if (status & CSI_CH_INT_STA_FD_PD) {
> > > > +		sun6i_video_frame_done(&sdev->csi.video);
> > > > +	}
> > > > +
> > > > +	regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> > > 
> > > Isn't it redundant with the one you did in the condition a bit above?
> > > 
> > > You should also check that your device indeed generated an
> > > interrupt. In the occurence of a spourious interrupt, your code will
> > > return IRQ_HANDLED, which is the wrong thing to do.
> > > 
> > > I think you should reverse your logic a bit here to make this
> > > easier. You should just check that your status flags are indeed set,
> > > and if not just bail out and return IRQ_NONE.
> > > 
> > > And if they are, go on with treating your interrupt.
> > 
> > OK. I will add check for status flags.
> > BTW, how can a spurious interrupt occurred?
> 
> Usually it's either through some interference, or some poorly designed
> controller. This is unlikely, but it's something you should take into
> account.
> 
> Thanks!
> Maxime
> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com


Thanks,
Yong
