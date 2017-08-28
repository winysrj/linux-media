Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:48038 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdH1HBD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 03:01:03 -0400
Date: Mon, 28 Aug 2017 15:00:42 +0800
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
Message-Id: <20170828150042.1832cfd1bfbeadf1e62e8019@magewell.com>
In-Reply-To: <20170825134114.rwttrmzw5gbtwdx2@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
        <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
        <20170728160233.xooevio4hoqkgfaq@flea.lan>
        <20170731111640.d5a8e580a48183cfce85943d@magewell.com>
        <20170822174339.6woauylgzkgqxygk@flea.lan>
        <20170823103216.e43283308c195c4a80d929fa@magewell.com>
        <20170825134114.rwttrmzw5gbtwdx2@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Fri, 25 Aug 2017 15:41:14 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi Yong,
> 
> On Wed, Aug 23, 2017 at 10:32:16AM +0800, Yong wrote:
> > > > > > +static int sun6i_graph_notify_complete(struct v4l2_async_notifier *notifier)
> > > > > > +{
> > > > > > +	struct sun6i_csi *csi =
> > > > > > +			container_of(notifier, struct sun6i_csi, notifier);
> > > > > > +	struct sun6i_graph_entity *entity;
> > > > > > +	int ret;
> > > > > > +
> > > > > > +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> > > > > > +
> > > > > > +	/* Create links for every entity. */
> > > > > > +	list_for_each_entry(entity, &csi->entities, list) {
> > > > > > +		ret = sun6i_graph_build_one(csi, entity);
> > > > > > +		if (ret < 0)
> > > > > > +			return ret;
> > > > > > +	}
> > > > > > +
> > > > > > +	/* Create links for video node. */
> > > > > > +	ret = sun6i_graph_build_video(csi);
> > > > > > +	if (ret < 0)
> > > > > > +		return ret;
> > > > > 
> > > > > Can you elaborate a bit on the difference between a node parsed with
> > > > > _graph_build_one and _graph_build_video? Can't you just store the
> > > > > remote sensor when you build the notifier, and reuse it here?
> > > > 
> > > > There maybe many usercases:
> > > > 1. CSI->Sensor.
> > > > 2. CSI->MIPI->Sensor.
> > > > 3. CSI->FPGA->Sensor1
> > > >             ->Sensor2.
> > > > FPGA maybe some other video processor. FPGA, MIPI, Sensor can be
> > > > registered as v4l2 subdevs. We do not care about the driver code
> > > > of them. But they should be linked together here.
> > > > 
> > > > So, the _graph_build_one is used to link CSI port and subdevs. 
> > > > _graph_build_video is used to link CSI port and video node.
> > > 
> > > So the graph_build_one is for the two first cases, and the
> > > _build_video for the latter case?
> > 
> > No. 
> > The _graph_build_one is used to link the subdevs found in the device 
> > tree. _build_video is used to link the closest subdev to video node.
> > Video node is created in the driver, so the method to get it's pad is
> > diffrent to the subdevs.
> 
> Sorry for being slow here, I'm still not sure I get it.
> 
> In summary, both the sun6i_graph_build_one and sun6i_graph_build_video
> will iterate over each endpoint, will retrieve the remote entity, and
> will create the media link between the CSI pad and the remote pad.
> 
> As far as I can see, there's basically two things that
> sun6i_graph_build_one does that sun6i_graph_build_video doesn't:
>   - It skips all the links that would connect to one of the CSI sinks
>   - It skips all the links that would connect to a remote node that is
>     equal to the CSI node.
> 
> I assume the latter is because you want to avoid going in an infinite
> loop when you would follow one of the CSI endpoint (going to the
> sensor), and then follow back the same link in the opposite
> direction. Right?

Not exactly. But any way, some code is true redundant here. I will 
make some improve.

> 
> I'm confused about the first one though. All the pads you create in
> your driver are sink pads, so wouldn't that skip all the pads of the
> CSI nodes?
> 
> Also, why do you iterate on all the CSI endpoints, when there's only
> of them? You want to anticipate the future binding for devices with
> multiple channels?
> 
> > > 
> > > If so, you should take a look at the last iteration of the
> > > subnotifiers rework by Nikas Söderlund (v4l2-async: add subnotifier
> > > registration for subdevices).
> > > 
> > > It allows subdevs to register notifiers, and you don't have to build
> > > the graph from the video device, each device and subdev can only care
> > > about what's next in the pipeline, but not really what's behind it.
> > > 
> > > That would mean in your case that you can only deal with your single
> > > CSI pad, and whatever subdev driver will use it care about its own.
> > 
> > Do you mean the subdevs create pad link in the notifier registered by
> > themself ?
> 
> Yes.
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
