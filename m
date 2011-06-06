Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4115 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab1FFNYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 09:24:47 -0400
Message-ID: <685f5fe9b7d45f0e178eedcec31f862f.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1106061502240.11169@axis700.grange>
References: <Pine.LNX.4.64.1106061358310.11169@axis700.grange>
    <909d9f71c0ed2e9dc6f81a20e20f9f6a.squirrel@webmail.xs4all.nl>
    <Pine.LNX.4.64.1106061502240.11169@axis700.grange>
Date: Mon, 6 Jun 2011 15:24:45 +0200
Subject: Re: [PATCH/RFC] V4L: add media bus configuration subdev operations
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	"Sylwester Nawrocki" <snjw23@gmail.com>,
	"Stan" <svarbanov@mm-sol.com>, "Hans Verkuil" <hansverk@cisco.com>,
	saaguirre@ti.com, "Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans
>
> Thanks for your comments
>
> On Mon, 6 Jun 2011, Hans Verkuil wrote:
>
>> > Add media bus configuration types and two subdev operations to get
>> > supported mediabus configurations and to set a specific configuration.
>> > Subdevs can support several configurations, e.g., they can send video
>> data
>> > on 1 or several lanes, can be configured to use a specific CSI-2
>> channel,
>> > in such cases subdevice drivers return bitmasks with all respective
>> bits
>> > set. When a set-configuration operation is called, it has to specify a
>> > non-ambiguous configuration.
>> >
>> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> > ---
>> >
>> > This change would allow a re-use of soc-camera and "standard" subdev
>> > drivers. It is a modified and extended version of
>> >
>> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/29408
>> >
>> > therefore the original Sob. After this we only would have to switch to
>> the
>> > control framework:) Please, comment.
>> >
>> > diff --git a/include/media/v4l2-mediabus.h
>> b/include/media/v4l2-mediabus.h
>> > index 971c7fa..0983b7b 100644
>> > --- a/include/media/v4l2-mediabus.h
>> > +++ b/include/media/v4l2-mediabus.h
>> > @@ -13,6 +13,76 @@
>> >
>> >  #include <linux/v4l2-mediabus.h>
>> >
>> > +/* Parallel flags */
>> > +/* Can the client run in master or in slave mode */
>> > +#define V4L2_MBUS_MASTER			(1 << 0)
>> > +#define V4L2_MBUS_SLAVE				(1 << 1)
>> > +/* Which signal polarities it supports */
>> > +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
>> > +#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
>> > +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
>> > +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
>> > +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
>> > +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
>> > +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
>> > +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
>> > +/* Which datawidths are supported */
>> > +#define V4L2_MBUS_DATAWIDTH_4			(1 << 10)
>> > +#define V4L2_MBUS_DATAWIDTH_8			(1 << 11)
>> > +#define V4L2_MBUS_DATAWIDTH_9			(1 << 12)
>> > +#define V4L2_MBUS_DATAWIDTH_10			(1 << 13)
>> > +#define V4L2_MBUS_DATAWIDTH_15			(1 << 14)
>> > +#define V4L2_MBUS_DATAWIDTH_16			(1 << 15)
>> > +
>> > +#define V4L2_MBUS_DATAWIDTH_MASK	(V4L2_MBUS_DATAWIDTH_4 |
>> > V4L2_MBUS_DATAWIDTH_8 | \
>> > +					 V4L2_MBUS_DATAWIDTH_9 | V4L2_MBUS_DATAWIDTH_10 | \
>> > +					 V4L2_MBUS_DATAWIDTH_15 | V4L2_MBUS_DATAWIDTH_16)
>>
>> This is too limited. Video receivers for example can use 8, 10, 12, 20,
>> 24, 30 and 36 data widths. Perhaps we should have a u64 bitmask instead.
>> Bit 0 is a width of 1, bit 63 is a width of 64. It's much easier to
>> understand.
>
> So, you want a separate 64-bit bitmask field in struct v4l2_mbus_config
> only for parallel bus width? Ok, can do that, np.

I've changed my mind on this. Keep it as is.

Although it would be nice if you can add support for widths 12, 20, 24, 30
and 36. That covers those video receivers/transmitters that I am aware of.

Regards,

      Hans

