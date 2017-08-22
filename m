Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53727 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdHVUvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 16:51:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Yong <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
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
Date: Tue, 22 Aug 2017 23:52:12 +0300
Message-ID: <4387854.RiNf2zWZcD@avalon>
In-Reply-To: <20170822201731.hyjqrbkhggaoomfl@flea.home>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com> <8dd8c350-cd45-5cd9-65cc-67102944811f@xs4all.nl> <20170822201731.hyjqrbkhggaoomfl@flea.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, 22 August 2017 23:17:31 EEST Maxime Ripard wrote:
> On Tue, Aug 22, 2017 at 08:43:35AM +0200, Hans Verkuil wrote:
> >>>> +static int sun6i_video_link_setup(struct media_entity *entity,
> >>>> +				  const struct media_pad *local,
> >>>> +				  const struct media_pad *remote, u32 flags)
> >>>> +{
> >>>> +	struct video_device *vdev = media_entity_to_video_device(entity);
> >>>> +	struct sun6i_video *video = video_get_drvdata(vdev);
> >>>> +
> >>>> +	if (WARN_ON(video == NULL))
> >>>> +		return 0;
> >>>> +
> >>>> +	return sun6i_video_formats_init(video);
> >>> 
> >>> Why is this called here? Why not in video_init()?
> >> 
> >> sun6i_video_init is in the driver probe context.
> >> sun6i_video_formats_init use media_entity_remote_pad and
> >> media_entity_to_v4l2_subdev to find the subdevs.
> >> The media_entity_remote_pad can't work before all the media pad linked.
> > 
> > A video_init is typically called from the notify_complete callback.
> > Actually, that's where the video_register_device should be created as
> > well. When you create it in probe() there is possibly no sensor yet, so it
> > would be a dead video node (or worse, crash when used).
> > 
> > There are still a lot of platform drivers that create the video node in
> > the probe, but it's not the right place if you rely on the async loading
> > of subdevs.
> 
> That's not really related, but I'm not really sure it's a good way to
> operate. This essentially means that you might wait forever for a
> component in your pipeline to be probed, without any chance of it
> happening (not compiled, compiled as a module and not loaded, hardware
> defect preventing the driver from probing properly, etc), even though
> that component might not be essential.

I agree with Maxime here, we should build the media device incrementally, and 
offer userspace access early on without waiting for all pieces to be 
available. If properly implemented (there should definitely be so crash) I 
don't see any drawback to that approach.

> This is how DRM operates, and you sometimes end up in some very dumb
> situations where you wait for say, the DSI controller to probe, while
> you only care about HDMI in your system.
> 
> But this seems to be on of the hot topic these days, so we might
> discuss it further in some other thread :)

Or here :-)

-- 
Regards,

Laurent Pinchart
