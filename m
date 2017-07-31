Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-37.mail.aliyun.com ([115.124.20.37]:48694 "EHLO
        out20-37.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdGaDRA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 23:17:00 -0400
Date: Mon, 31 Jul 2017 11:16:40 +0800
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
Message-Id: <20170731111640.d5a8e580a48183cfce85943d@magewell.com>
In-Reply-To: <20170728160233.xooevio4hoqkgfaq@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
        <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
        <20170728160233.xooevio4hoqkgfaq@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, 28 Jul 2017 18:02:33 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi, 
> 
> Thanks for the second iteration!
> 
> On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > and CSI1 is used for parallel interface. This is not documented in
> > datasheet but by testing and guess.
> > 
> > This patch implement a v4l2 framework driver for it.
> > 
> > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > ISP's support are not included in this patch.
> > 
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> 
> There's a significant amount of checkpatch warnings (and quite
> important checks) in your driver. You should fix everything checkpatch
> --strict reports.

OK. I will check and fix.

> 
> > ---
> >  drivers/media/platform/Kconfig                   |   1 +
> >  drivers/media/platform/Makefile                  |   2 +
> >  drivers/media/platform/sun6i-csi/Kconfig         |   9 +
> >  drivers/media/platform/sun6i-csi/Makefile        |   3 +
> >  drivers/media/platform/sun6i-csi/sun6i_csi.c     | 545 +++++++++++++++
> >  drivers/media/platform/sun6i-csi/sun6i_csi.h     | 203 ++++++
> >  drivers/media/platform/sun6i-csi/sun6i_csi_v3s.c | 827 +++++++++++++++++++++++
> >  drivers/media/platform/sun6i-csi/sun6i_csi_v3s.h | 206 ++++++
> >  drivers/media/platform/sun6i-csi/sun6i_video.c   | 663 ++++++++++++++++++
> >  drivers/media/platform/sun6i-csi/sun6i_video.h   |  61 ++
> >  10 files changed, 2520 insertions(+)
> >  create mode 100644 drivers/media/platform/sun6i-csi/Kconfig
> >  create mode 100644 drivers/media/platform/sun6i-csi/Makefile
> >  create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi.c
> >  create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi.h
> >  create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi_v3s.c
> >  create mode 100644 drivers/media/platform/sun6i-csi/sun6i_csi_v3s.h
> >  create mode 100644 drivers/media/platform/sun6i-csi/sun6i_video.c
> >  create mode 100644 drivers/media/platform/sun6i-csi/sun6i_video.h
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index 0c741d1..8371a87 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -143,6 +143,7 @@ source "drivers/media/platform/am437x/Kconfig"
> >  source "drivers/media/platform/xilinx/Kconfig"
> >  source "drivers/media/platform/rcar-vin/Kconfig"
> >  source "drivers/media/platform/atmel/Kconfig"
> > +source "drivers/media/platform/sun6i-csi/Kconfig"
> 
> We're going to have several different drivers in v4l eventually, so I
> guess it would make sense to move to a directory of our own.

Like this?
drivers/media/platform/sunxi/sun6i-csi

> 
> > +	dev_dbg(csi->dev, "creating links for entity %s\n", local->name);
> > +
> > +	while (1) {
> > +		/* Get the next endpoint and parse its link. */
> > +		next = of_graph_get_next_endpoint(entity->node, ep);
> > +		if (next == NULL)
> > +			break;
> > +
> > +		of_node_put(ep);
> > +		ep = next;
> > +
> > +		dev_dbg(csi->dev, "processing endpoint %s\n", ep->full_name);
> > +
> > +		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
> > +		if (ret < 0) {
> > +			dev_err(csi->dev, "failed to parse link for %s\n",
> > +				ep->full_name);
> > +			continue;
> > +		}
> > +
> > +		/* Skip sink ports, they will be processed from the other end of
> > +		 * the link.
> > +		 */
> > +		if (link.local_port >= local->num_pads) {
> > +			dev_err(csi->dev, "invalid port number %u on %s\n",
> > +				link.local_port,
> > +				to_of_node(link.local_node)->full_name);
> > +			v4l2_fwnode_put_link(&link);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		local_pad = &local->pads[link.local_port];
> > +
> > +		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
> > +			dev_dbg(csi->dev, "skipping sink port %s:%u\n",
> > +				to_of_node(link.local_node)->full_name,
> > +				link.local_port);
> > +			v4l2_fwnode_put_link(&link);
> > +			continue;
> > +		}
> > +
> > +		/* Skip video node, they will be processed separately. */
> > +		if (link.remote_node == of_fwnode_handle(csi->dev->of_node)) {
> > +			dev_dbg(csi->dev, "skipping CSI port %s:%u\n",
> > +				to_of_node(link.local_node)->full_name,
> > +				link.local_port);
> > +			v4l2_fwnode_put_link(&link);
> > +			continue;
> > +		}
> > +
> > +		/* Find the remote entity. */
> > +		ent = sun6i_graph_find_entity(csi,
> > +					      to_of_node(link.remote_node));
> > +		if (ent == NULL) {
> > +			dev_err(csi->dev, "no entity found for %s\n",
> > +				to_of_node(link.remote_node)->full_name);
> > +			v4l2_fwnode_put_link(&link);
> > +			ret = -ENODEV;
> > +			break;
> > +		}
> > +
> > +		remote = ent->entity;
> > +
> > +		if (link.remote_port >= remote->num_pads) {
> > +			dev_err(csi->dev, "invalid port number %u on %s\n",
> > +				link.remote_port,
> > +				to_of_node(link.remote_node)->full_name);
> > +			v4l2_fwnode_put_link(&link);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		remote_pad = &remote->pads[link.remote_port];
> > +
> > +		v4l2_fwnode_put_link(&link);
> > +
> > +		/* Create the media link. */
> > +		dev_dbg(csi->dev, "creating %s:%u -> %s:%u link\n",
> > +			local->name, local_pad->index,
> > +			remote->name, remote_pad->index);
> > +
> > +		ret = media_create_pad_link(local, local_pad->index,
> > +					    remote, remote_pad->index,
> > +					    link_flags);
> > +		if (ret < 0) {
> > +			dev_err(csi->dev,
> > +				"failed to create %s:%u -> %s:%u link\n",
> > +				local->name, local_pad->index,
> > +				remote->name, remote_pad->index);
> > +			break;
> > +		}
> > +	}
> 
> It's not really clear to me what you're trying to do here. Your
> binding only states that it has a single port, with an endpoint to
> your sensor.
> 
> Can't you just use of_graph_get_endpoint_by_regs(0, 0) ?
> 
> This will get you the endpoint you need, that you can parse later on
> with v4l2_fwnode_endpoint_parse.

See below.

> 
> > +
> > +	of_node_put(ep);
> > +	return ret;
> > +}
> > +
> > +static int sun6i_graph_build_video(struct sun6i_csi *csi)
> > +{
> > +	u32 link_flags = MEDIA_LNK_FL_ENABLED;
> > +	struct device_node *node = csi->dev->of_node;
> > +	struct media_entity *source;
> > +	struct media_entity *sink;
> > +	struct media_pad *source_pad;
> > +	struct media_pad *sink_pad;
> > +	struct sun6i_graph_entity *ent;
> > +	struct v4l2_fwnode_link link;
> > +	struct device_node *ep = NULL;
> > +	struct device_node *next;
> > +	struct sun6i_video *video = &csi->video;
> > +	int ret = 0;
> > +
> > +	dev_dbg(csi->dev, "creating link for video node\n");
> > +
> > +	while (1) {
> > +		/* Get the next endpoint and parse its link. */
> > +		next = of_graph_get_next_endpoint(node, ep);
> > +		if (next == NULL)
> > +			break;
> > +
> > +		of_node_put(ep);
> > +		ep = next;
> > +
> > +		dev_dbg(csi->dev, "processing endpoint %s\n", ep->full_name);
> > +
> > +		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
> > +		if (ret < 0) {
> > +			dev_err(csi->dev, "failed to parse link for %s\n",
> > +				ep->full_name);
> > +			continue;
> > +		}
> > +
> > +		/* Save the video port settings */
> > +		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep),
> > +						 &csi->v4l2_ep);
> > +		if (ret) {
> > +			ret = -EINVAL;
> > +			dev_err(csi->dev, "Could not parse the endpoint\n");
> > +			v4l2_fwnode_put_link(&link);
> > +			break;
> > +		}
> > +
> > +		dev_dbg(csi->dev, "creating link for video node %s\n",
> > +			video->vdev.name);
> > +
> > +		/* Find the remote entity. */
> > +		ent = sun6i_graph_find_entity(csi,
> > +					      to_of_node(link.remote_node));
> > +		if (ent == NULL) {
> > +			dev_err(csi->dev, "no entity found for %s\n",
> > +				to_of_node(link.remote_node)->full_name);
> > +			v4l2_fwnode_put_link(&link);
> > +			ret = -ENODEV;
> > +			break;
> > +		}
> > +
> > +		if (link.remote_port >= ent->entity->num_pads) {
> > +			dev_err(csi->dev, "invalid port number %u on %s\n",
> > +				link.remote_port,
> > +				to_of_node(link.remote_node)->full_name);
> > +			v4l2_fwnode_put_link(&link);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		source = ent->entity;
> > +		source_pad = &source->pads[link.remote_port];
> > +		sink = &video->vdev.entity;
> > +		sink_pad = &video->pad;
> > +
> > +		v4l2_fwnode_put_link(&link);
> > +
> > +		/* Create the media link. */
> > +		dev_dbg(csi->dev, "creating %s:%u -> %s:%u link\n",
> > +			source->name, source_pad->index,
> > +			sink->name, sink_pad->index);
> > +
> > +		ret = media_create_pad_link(source, source_pad->index,
> > +					    sink, sink_pad->index,
> > +					    link_flags);
> > +		if (ret < 0) {
> > +			dev_err(csi->dev,
> > +				"failed to create %s:%u -> %s:%u link\n",
> > +				source->name, source_pad->index,
> > +				sink->name, sink_pad->index);
> > +			break;
> > +		}
> > +
> > +		/* Notify video node */
> > +		ret = media_entity_call(sink, link_setup, sink_pad, source_pad,
> > +					link_flags);
> > +		if (ret == -ENOIOCTLCMD)
> > +			ret = 0;
> > +
> > +		/* found one */
> > +		break;
> > +	}
> > +
> > +	of_node_put(ep);
> > +	return ret;
> > +}
> > +
> > +static int sun6i_graph_notify_complete(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct sun6i_csi *csi =
> > +			container_of(notifier, struct sun6i_csi, notifier);
> > +	struct sun6i_graph_entity *entity;
> > +	int ret;
> > +
> > +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> > +
> > +	/* Create links for every entity. */
> > +	list_for_each_entry(entity, &csi->entities, list) {
> > +		ret = sun6i_graph_build_one(csi, entity);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	/* Create links for video node. */
> > +	ret = sun6i_graph_build_video(csi);
> > +	if (ret < 0)
> > +		return ret;
> 
> Can you elaborate a bit on the difference between a node parsed with
> _graph_build_one and _graph_build_video? Can't you just store the
> remote sensor when you build the notifier, and reuse it here?

There maybe many usercases:
1. CSI->Sensor.
2. CSI->MIPI->Sensor.
3. CSI->FPGA->Sensor1
            ->Sensor2.
FPGA maybe some other video processor. FPGA, MIPI, Sensor can be
registered as v4l2 subdevs. We do not care about the driver code
of them. But they should be linked together here.

So, the _graph_build_one is used to link CSI port and subdevs. 
_graph_build_video is used to link CSI port and video node.

This part is also difficult to understand for me. The one CSI module
have only one DMA channel(single port). But thay can be linked to 
different physical port (Parallel or MIPI)(multiple ep) by IF select
register.

For now, the binding can have several ep, the driver will just pick
the first valid one.

> 
> > +struct sun6i_csi_ops {
> > +	int (*get_supported_pixformats)(struct sun6i_csi *csi,
> > +					const u32 **pixformats);
> > +	bool (*is_format_support)(struct sun6i_csi *csi, u32 pixformat,
> > +				  u32 mbus_code);
> > +	int (*s_power)(struct sun6i_csi *csi, bool enable);
> > +	int (*update_config)(struct sun6i_csi *csi,
> > +			     struct sun6i_csi_config *config);
> > +	int (*update_buf_addr)(struct sun6i_csi *csi, dma_addr_t addr);
> > +	int (*s_stream)(struct sun6i_csi *csi, bool enable);
> > +};
> 
> Didn't we agreed on removing those in the first iteration? It's not
> really clear at this point whether they will be needed at all. Make
> something simple first, without those ops. When we'll support other
> SoCs we'll have a better chance at seeing what and how we should deal
> with potential quirks.

OK. But without ops, it is inappropriate to sun6i_csi and sun6i_csi.
Maybe I should merge the two files.

> 
> > +#ifdef DEBUG
> > +static void sun6i_csi_dump_regs(struct sun6i_csi_dev *sdev)
> > +{
> > +	struct regmap *regmap = sdev->regmap;
> > +	u32 val;
> > +
> > +	regmap_read(regmap, CSI_EN_REG, &val);
> > +	printk("CSI_EN_REG=0x%x\n",		val);
> > +	regmap_read(regmap, CSI_IF_CFG_REG, &val);
> > +	printk("CSI_IF_CFG_REG=0x%x\n",		val);
> > +	regmap_read(regmap, CSI_CAP_REG, &val);
> > +	printk("CSI_CAP_REG=0x%x\n",		val);
> > +	regmap_read(regmap, CSI_SYNC_CNT_REG, &val);
> > +	printk("CSI_SYNC_CNT_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_FIFO_THRS_REG, &val);
> > +	printk("CSI_FIFO_THRS_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_PTN_LEN_REG, &val);
> > +	printk("CSI_PTN_LEN_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_PTN_ADDR_REG, &val);
> > +	printk("CSI_PTN_ADDR_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_VER_REG, &val);
> > +	printk("CSI_VER_REG=0x%x\n",		val);
> > +	regmap_read(regmap, CSI_CH_CFG_REG, &val);
> > +	printk("CSI_CH_CFG_REG=0x%x\n",		val);
> > +	regmap_read(regmap, CSI_CH_SCALE_REG, &val);
> > +	printk("CSI_CH_SCALE_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_F0_BUFA_REG, &val);
> > +	printk("CSI_CH_F0_BUFA_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_F1_BUFA_REG, &val);
> > +	printk("CSI_CH_F1_BUFA_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_F2_BUFA_REG, &val);
> > +	printk("CSI_CH_F2_BUFA_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_STA_REG, &val);
> > +	printk("CSI_CH_STA_REG=0x%x\n",		val);
> > +	regmap_read(regmap, CSI_CH_INT_EN_REG, &val);
> > +	printk("CSI_CH_INT_EN_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_INT_STA_REG, &val);
> > +	printk("CSI_CH_INT_STA_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_FLD1_VSIZE_REG, &val);
> > +	printk("CSI_CH_FLD1_VSIZE_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_HSIZE_REG, &val);
> > +	printk("CSI_CH_HSIZE_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_VSIZE_REG, &val);
> > +	printk("CSI_CH_VSIZE_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_BUF_LEN_REG, &val);
> > +	printk("CSI_CH_BUF_LEN_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_FLIP_SIZE_REG, &val);
> > +	printk("CSI_CH_FLIP_SIZE_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_FRM_CLK_CNT_REG, &val);
> > +	printk("CSI_CH_FRM_CLK_CNT_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_ACC_ITNL_CLK_CNT_REG, &val);
> > +	printk("CSI_CH_ACC_ITNL_CLK_CNT_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_FIFO_STAT_REG, &val);
> > +	printk("CSI_CH_FIFO_STAT_REG=0x%x\n",	val);
> > +	regmap_read(regmap, CSI_CH_PCLK_STAT_REG, &val);
> > +	printk("CSI_CH_PCLK_STAT_REG=0x%x\n",	val);
> > +}
> > +#endif
> 
> You can already dump a regmap through debugfs, that's redundant.
> 
> > +
> > +static void sun6i_csi_setup_bus(struct sun6i_csi_dev *sdev)
> > +{
> > +	struct v4l2_fwnode_endpoint *endpoint = &sdev->csi.v4l2_ep;
> > +	unsigned char bus_width;
> > +	u32 flags;
> > +	u32 cfg;
> > +
> > +	bus_width = endpoint->bus.parallel.bus_width;
> > +
> > +	regmap_read(sdev->regmap, CSI_IF_CFG_REG, &cfg);
> > +
> > +	cfg &= ~(CSI_IF_CFG_CSI_IF_MASK | CSI_IF_CFG_MIPI_IF_MASK |
> > +		 CSI_IF_CFG_IF_DATA_WIDTH_MASK |
> > +		 CSI_IF_CFG_CLK_POL_MASK | CSI_IF_CFG_VREF_POL_MASK |
> > +		 CSI_IF_CFG_HREF_POL_MASK | CSI_IF_CFG_FIELD_MASK);
> > +
> > +	switch (endpoint->bus_type) {
> > +	case V4L2_MBUS_CSI2:
> > +		cfg |= CSI_IF_CFG_MIPI_IF_MIPI;
> > +		break;
> > +	case V4L2_MBUS_PARALLEL:
> > +		cfg |= CSI_IF_CFG_MIPI_IF_CSI;
> > +
> > +		flags = endpoint->bus.parallel.flags;
> > +
> > +		cfg |= (bus_width == 16) ? CSI_IF_CFG_CSI_IF_YUV422_16BIT :
> > +					   CSI_IF_CFG_CSI_IF_YUV422_INTLV;
> > +
> > +		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
> > +			cfg |= CSI_IF_CFG_FIELD_POSITIVE;
> > +
> > +		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> > +			cfg |= CSI_IF_CFG_VREF_POL_POSITIVE;
> > +		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> > +			cfg |= CSI_IF_CFG_HREF_POL_POSITIVE;
> > +
> > +		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> > +			cfg |= CSI_IF_CFG_CLK_POL_FALLING_EDGE;
> > +		break;
> > +	case V4L2_MBUS_BT656:
> > +		cfg |= CSI_IF_CFG_MIPI_IF_CSI;
> > +
> > +		flags = endpoint->bus.parallel.flags;
> > +
> > +		cfg |= (bus_width == 16) ? CSI_IF_CFG_CSI_IF_BT1120 :
> > +					   CSI_IF_CFG_CSI_IF_BT656;
> > +
> > +		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
> > +			cfg |= CSI_IF_CFG_FIELD_POSITIVE;
> > +
> > +		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> > +			cfg |= CSI_IF_CFG_CLK_POL_FALLING_EDGE;
> > +		break;
> > +	default:
> > +		BUG();
> 
> BUG() will generate a kernel panic, which seems a bit too extreme :)
> How about a warning instead?

OK.

> 
> > +static int set_power(struct sun6i_csi *csi, bool enable)
> > +{
> > +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +	struct regmap *regmap = sdev->regmap;
> > +	int ret;
> > +
> > +	if (!enable) {
> > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> > +
> > +		clk_disable_unprepare(sdev->clk_ram);
> > +		clk_disable_unprepare(sdev->clk_mod);
> > +		clk_disable_unprepare(sdev->clk_ahb);
> > +		reset_control_assert(sdev->rstc_ahb);
> > +		return 0;
> > +	}
> > +
> > +	ret = clk_prepare_enable(sdev->clk_ahb);
> > +	if (ret) {
> > +		dev_err(sdev->dev, "Enable ahb clk err %d\n", ret);
> > +		return ret;
> > +	}
> 
> The ahb clock doesn't need to be running all the time, at least since
> the SoCs that have a reset line for every
> controller. regmap_init_mmio_clk will take care of enabling it only
> when you access the registers, which is what you need.

I will check this.

> 
> > +	ret = clk_prepare_enable(sdev->clk_mod);
> > +	if (ret) {
> > +		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = clk_prepare_enable(sdev->clk_ram);
> > +	if (ret) {
> > +		dev_err(sdev->dev, "Enable clk_dram_csi clk err %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	if (!IS_ERR_OR_NULL(sdev->rstc_ahb)) {
> 
> A missing reset line should not be allowed to probe, just like the
> clocks aren't, so this condition should never fail (and therefore is
> basically useless).

OK.

> 
> > +		ret = reset_control_deassert(sdev->rstc_ahb);
> > +		if (ret) {
> > +			dev_err(sdev->dev, "reset err %d\n", ret);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, CSI_EN_CSI_EN);
> > +
> > +	return 0;
> > +}
> > +
> > +static int update_config(struct sun6i_csi *csi,
> > +			 struct sun6i_csi_config *config)
> > +{
> > +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +
> > +	if (config == NULL)
> > +		return -EINVAL;
> > +
> > +	memcpy(&csi->config, config, sizeof(csi->config));
> > +
> > +	sun6i_csi_setup_bus(sdev);
> > +	sun6i_csi_set_format(sdev);
> > +	sun6i_csi_set_window(sdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> > +{
> > +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +	/* transform physical address to bus address */
> > +	dma_addr_t bus_addr = addr - 0x40000000;
> 
> Like Baruch noticed, you should use PHYS_OFFSET here. The A80 for
> example has a different RAM base address.

OK. I will try it again.

> 
> > +
> > +	regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
> > +		     (bus_addr + sdev->planar_offset[0]) >> 2);
> > +	if (sdev->planar_offset[1] != -1)
> > +		regmap_write(sdev->regmap, CSI_CH_F1_BUFA_REG,
> > +			     (bus_addr + sdev->planar_offset[1]) >> 2);
> > +	if (sdev->planar_offset[2] != -1)
> > +		regmap_write(sdev->regmap, CSI_CH_F2_BUFA_REG,
> > +			     (bus_addr + sdev->planar_offset[2]) >> 2);
> > +
> > +	return 0;
> > +}
> > +
> > +static int set_stream(struct sun6i_csi *csi, bool enable)
> > +{
> > +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +	struct regmap *regmap = sdev->regmap;
> > +
> > +	if (!enable) {
> > +		regmap_update_bits(regmap, CSI_CAP_REG, CSI_CAP_CH0_VCAP_ON, 0);
> > +		regmap_write(regmap, CSI_CH_INT_EN_REG, 0);
> > +		return 0;
> > +	}
> > +
> > +	regmap_write(regmap, CSI_CH_INT_STA_REG, 0xFF);
> > +	regmap_write(regmap, CSI_CH_INT_EN_REG,
> > +		     CSI_CH_INT_EN_HB_OF_INT_EN |
> > +		     CSI_CH_INT_EN_FIFO2_OF_INT_EN |
> > +		     CSI_CH_INT_EN_FIFO1_OF_INT_EN |
> > +		     CSI_CH_INT_EN_FIFO0_OF_INT_EN |
> > +		     CSI_CH_INT_EN_FD_INT_EN |
> > +		     CSI_CH_INT_EN_CD_INT_EN);
> > +
> > +	regmap_update_bits(regmap, CSI_CAP_REG, CSI_CAP_CH0_VCAP_ON,
> > +			   CSI_CAP_CH0_VCAP_ON);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct sun6i_csi_ops csi_ops = {
> > +	.get_supported_pixformats	= get_supported_pixformats,
> > +	.is_format_support		= is_format_support,
> > +	.s_power			= set_power,
> > +	.update_config			= update_config,
> > +	.update_buf_addr		= update_buf_addr,
> > +	.s_stream			= set_stream,
> > +};
> > +
> > +static irqreturn_t sun6i_csi_isr(int irq, void *dev_id)
> > +{
> > +	struct sun6i_csi_dev *sdev = (struct sun6i_csi_dev *)dev_id;
> > +	struct regmap *regmap = sdev->regmap;
> > +	u32 status;
> > +
> > +	regmap_read(regmap, CSI_CH_INT_STA_REG, &status);
> > +
> > +	if ((status & CSI_CH_INT_STA_FIFO0_OF_PD) ||
> > +	    (status & CSI_CH_INT_STA_FIFO1_OF_PD) ||
> > +	    (status & CSI_CH_INT_STA_FIFO2_OF_PD) ||
> > +	    (status & CSI_CH_INT_STA_HB_OF_PD)) {
> > +		regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN,
> > +				   CSI_EN_CSI_EN);
> 
> You need to enable / disable it at every frame? How do you deal with
> double buffering? (or did you choose to ignore it for now?)

Quoting Baruch's reply:
These *_OF_PD status bits indicate an overflow error condition.

> 
> > +		return IRQ_HANDLED;
> > +	}
> > +
> > +	if (status & CSI_CH_INT_STA_FD_PD) {
> > +		sun6i_video_frame_done(&sdev->csi.video);
> > +	}
> > +
> > +	regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> 
> Isn't it redundant with the one you did in the condition a bit above?
> 
> You should also check that your device indeed generated an
> interrupt. In the occurence of a spourious interrupt, your code will
> return IRQ_HANDLED, which is the wrong thing to do.
> 
> I think you should reverse your logic a bit here to make this
> easier. You should just check that your status flags are indeed set,
> and if not just bail out and return IRQ_NONE.
> 
> And if they are, go on with treating your interrupt.

OK. I will add check for status flags.
BTW, how can a spurious interrupt occurred?

> 
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static const struct regmap_config sun6i_csi_regmap_config = {
> > +	.reg_bits       = 32,
> > +	.reg_stride     = 4,
> > +	.val_bits       = 32,
> > +	.max_register	= 0x1000,
> > +};
> > +
> > +static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
> > +				      struct platform_device *pdev)
> > +{
> > +	struct resource *res;
> > +	void __iomem *io_base;
> > +	int ret;
> > +	int irq;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	io_base = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(io_base))
> > +		return PTR_ERR(io_base);
> > +
> > +	sdev->regmap = devm_regmap_init_mmio(&pdev->dev, io_base,
> > +					    &sun6i_csi_regmap_config);
> > +	if (IS_ERR(sdev->regmap)) {
> > +		dev_err(&pdev->dev, "Failed to init register map\n");
> > +		return PTR_ERR(sdev->regmap);
> > +	}
> > +
> > +	sdev->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
> > +	if (IS_ERR(sdev->clk_ahb)) {
> > +		dev_err(&pdev->dev, "Unable to acquire ahb clock\n");
> > +		return PTR_ERR(sdev->clk_ahb);
> > +	}
> > +	sdev->clk_mod = devm_clk_get(&pdev->dev, "mod");
> > +	if (IS_ERR(sdev->clk_mod)) {
> > +		dev_err(&pdev->dev, "Unable to acquire csi clock\n");
> > +		return PTR_ERR(sdev->clk_mod);
> > +	}
> > +
> > +	sdev->clk_ram = devm_clk_get(&pdev->dev, "ram");
> > +	if (IS_ERR(sdev->clk_ram)) {
> > +		dev_err(&pdev->dev, "Unable to acquire dram-csi clock\n");
> > +		return PTR_ERR(sdev->clk_ram);
> > +	}
> > +
> > +	sdev->rstc_ahb = devm_reset_control_get_optional_shared(&pdev->dev, NULL);
> 
> It is not optional, the reset line is always going to be there (at
> least on the SoCs that have been out so far), and a missing reset line
> in the DT must be reported as an error, since the device will not be
> able to operate properly.

The CSI0 and CSI1 share the same bus clk and reset line. I should use 
the devm_reset_control_get_shared instead.

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
