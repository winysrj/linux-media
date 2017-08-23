Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:43501 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753691AbdHWLNc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 07:13:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 23 Aug 2017 19:13:31 +0800
From: icenowy@aosc.io
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mark Rutland <mark.rutland@arm.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        linux-sunxi@googlegroups.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Benoit Parrot <bparrot@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Yong <yong.deng@magewell.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Yannick Fertre <yannick.fertre@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
In-Reply-To: <3036789.1NOcar0Ykn@avalon>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <20170822201731.hyjqrbkhggaoomfl@flea.home>
 <3392c717-10ea-4d6e-4c25-9be0bbec004e@xs4all.nl> <3036789.1NOcar0Ykn@avalon>
Message-ID: <8f6b9ca17a987a5aec0bdd47870688ab@aosc.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

在 2017-08-23 15:43，Laurent Pinchart 写道：
> Hi Hans,
> 
> On Wednesday, 23 August 2017 09:52:00 EEST Hans Verkuil wrote:
>> On 08/22/2017 10:17 PM, Maxime Ripard wrote:
>> > On Tue, Aug 22, 2017 at 08:43:35AM +0200, Hans Verkuil wrote:
>> >>>>> +static int sun6i_video_link_setup(struct media_entity *entity,
>> >>>>> +				  const struct media_pad *local,
>> >>>>> +				  const struct media_pad *remote, u32 flags)
>> >>>>> +{
>> >>>>> +	struct video_device *vdev = media_entity_to_video_device(entity);
>> >>>>> +	struct sun6i_video *video = video_get_drvdata(vdev);
>> >>>>> +
>> >>>>> +	if (WARN_ON(video == NULL))
>> >>>>> +		return 0;
>> >>>>> +
>> >>>>> +	return sun6i_video_formats_init(video);
>> >>>>
>> >>>> Why is this called here? Why not in video_init()?
>> >>>
>> >>> sun6i_video_init is in the driver probe context.
>> >>> sun6i_video_formats_init use media_entity_remote_pad and
>> >>> media_entity_to_v4l2_subdev to find the subdevs.
>> >>> The media_entity_remote_pad can't work before all the media pad linked.
>> >>
>> >> A video_init is typically called from the notify_complete callback.
>> >> Actually, that's where the video_register_device should be created as
>> >> well. When you create it in probe() there is possibly no sensor yet, so
>> >> it would be a dead video node (or worse, crash when used).
>> >>
>> >> There are still a lot of platform drivers that create the video node in
>> >> the probe, but it's not the right place if you rely on the async loading
>> >> of subdevs.
>> >
>> > That's not really related, but I'm not really sure it's a good way to
>> > operate. This essentially means that you might wait forever for a
>> > component in your pipeline to be probed, without any chance of it
>> > happening (not compiled, compiled as a module and not loaded, hardware
>> > defect preventing the driver from probing properly, etc), even though
>> > that component might not be essential.
>> 
>> We're talking straightforward video pipelines here. I.e. a source, 
>> some
>> processing units and a DMA engine at the end.
> 
> As a first step possibly, but many SoCs have ISPs that are not 
> supported by
> the initial camera driver version.

I think here it's also the situation.

Allwinner SoCs beyond sun6i (which is this driver targeting at) has an 
ISP
internally called "HawkView ISP", and there's no document of it (even 
the
source code is only released in recent several months).

> 
>> There is no point in creating a video node if the pipeline is not 
>> complete
>> since you need the full pipeline.
>> 
>> I've had bad experiences in the past where video nodes were created 
>> too
>> soon and part of the internal state was still incomplete, causing at 
>> best
>> weird behavior and at worst crashes.
> 
> Drivers obviously need to be fixed if they are buggy in that regard. 
> Such race
> conditions are definitely something I keep an eye on when reviewing 
> code.
> 
>> More complex devices are a whole different ballgame.
>> 
>> > This is how DRM operates, and you sometimes end up in some very dumb
>> > situations where you wait for say, the DSI controller to probe, while
>> > you only care about HDMI in your system.
>> >
>> > But this seems to be on of the hot topic these days, so we might
>> > discuss it further in some other thread :)
