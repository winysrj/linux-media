Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48931 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753238AbdHWGwO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 02:52:14 -0400
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Yong <yong.deng@magewell.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <5082b6d6-29a7-f101-8cba-13fce8983c89@xs4all.nl>
 <20170822110148.734c01b69dacc57fa08965d1@magewell.com>
 <8dd8c350-cd45-5cd9-65cc-67102944811f@xs4all.nl>
 <20170822201731.hyjqrbkhggaoomfl@flea.home>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3392c717-10ea-4d6e-4c25-9be0bbec004e@xs4all.nl>
Date: Wed, 23 Aug 2017 08:52:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170822201731.hyjqrbkhggaoomfl@flea.home>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2017 10:17 PM, Maxime Ripard wrote:
> On Tue, Aug 22, 2017 at 08:43:35AM +0200, Hans Verkuil wrote:
>>>>> +static int sun6i_video_link_setup(struct media_entity *entity,
>>>>> +				  const struct media_pad *local,
>>>>> +				  const struct media_pad *remote, u32 flags)
>>>>> +{
>>>>> +	struct video_device *vdev = media_entity_to_video_device(entity);
>>>>> +	struct sun6i_video *video = video_get_drvdata(vdev);
>>>>> +
>>>>> +	if (WARN_ON(video == NULL))
>>>>> +		return 0;
>>>>> +
>>>>> +	return sun6i_video_formats_init(video);
>>>>
>>>> Why is this called here? Why not in video_init()?
>>>
>>> sun6i_video_init is in the driver probe context. sun6i_video_formats_init
>>> use media_entity_remote_pad and media_entity_to_v4l2_subdev to find the
>>> subdevs.
>>> The media_entity_remote_pad can't work before all the media pad linked.
>>
>> A video_init is typically called from the notify_complete callback.
>> Actually, that's where the video_register_device should be created as well.
>> When you create it in probe() there is possibly no sensor yet, so it would
>> be a dead video node (or worse, crash when used).
>>
>> There are still a lot of platform drivers that create the video node in the
>> probe, but it's not the right place if you rely on the async loading of
>> subdevs.
> 
> That's not really related, but I'm not really sure it's a good way to
> operate. This essentially means that you might wait forever for a
> component in your pipeline to be probed, without any chance of it
> happening (not compiled, compiled as a module and not loaded, hardware
> defect preventing the driver from probing properly, etc), even though
> that component might not be essential.

We're talking straightforward video pipelines here. I.e. a source, some
processing units and a DMA engine at the end. There is no point in
creating a video node if the pipeline is not complete since you need
the full pipeline.

I've had bad experiences in the past where video nodes were created too
soon and part of the internal state was still incomplete, causing at best
weird behavior and at worst crashes.

More complex devices are a whole different ballgame.

Regards,

	Hans

> This is how DRM operates, and you sometimes end up in some very dumb
> situations where you wait for say, the DSI controller to probe, while
> you only care about HDMI in your system.
> 
> But this seems to be on of the hot topic these days, so we might
> discuss it further in some other thread :)
> 
> Maxime
> 
