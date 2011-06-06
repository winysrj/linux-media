Return-path: <mchehab@pedra>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:45027 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753530Ab1FFOls convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 10:41:48 -0400
Received: by mail-gy0-f175.google.com with SMTP id 1so1657041gyf.20
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 07:41:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1106061629450.11169@axis700.grange>
References: <Pine.LNX.4.64.1106061358310.11169@axis700.grange>
 <BANLkTi=fMRyKqRTb_Twt9wSt_H9_eg_rrQ@mail.gmail.com> <Pine.LNX.4.64.1106061629450.11169@axis700.grange>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 6 Jun 2011 09:41:27 -0500
Message-ID: <BANLkTi=Mybwpr-eBgcFL_iU5ypsZ=mqq6g@mail.gmail.com>
Subject: Re: [PATCH/RFC] V4L: add media bus configuration subdev operations
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Mon, Jun 6, 2011 at 9:37 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Sergio
>
> On Mon, 6 Jun 2011, Aguirre, Sergio wrote:
>
>> Hi Guennadi,
>>
>> Thanks for the patch.
>>
>> On Mon, Jun 6, 2011 at 7:31 AM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > Add media bus configuration types and two subdev operations to get
>> > supported mediabus configurations and to set a specific configuration.
>> > Subdevs can support several configurations, e.g., they can send video data
>> > on 1 or several lanes, can be configured to use a specific CSI-2 channel,
>> > in such cases subdevice drivers return bitmasks with all respective bits
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
>> > therefore the original Sob. After this we only would have to switch to the
>> > control framework:) Please, comment.
>> >
>> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
>> > index 971c7fa..0983b7b 100644
>> > --- a/include/media/v4l2-mediabus.h
>> > +++ b/include/media/v4l2-mediabus.h
>> > @@ -13,6 +13,76 @@
>> >
>> >  #include <linux/v4l2-mediabus.h>
>> >
>> > +/* Parallel flags */
>> > +/* Can the client run in master or in slave mode */
>> > +#define V4L2_MBUS_MASTER                       (1 << 0)
>> > +#define V4L2_MBUS_SLAVE                                (1 << 1)
>> > +/* Which signal polarities it supports */
>> > +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH            (1 << 2)
>> > +#define V4L2_MBUS_HSYNC_ACTIVE_LOW             (1 << 3)
>> > +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH            (1 << 4)
>> > +#define V4L2_MBUS_VSYNC_ACTIVE_LOW             (1 << 5)
>> > +#define V4L2_MBUS_PCLK_SAMPLE_RISING           (1 << 6)
>> > +#define V4L2_MBUS_PCLK_SAMPLE_FALLING          (1 << 7)
>> > +#define V4L2_MBUS_DATA_ACTIVE_HIGH             (1 << 8)
>> > +#define V4L2_MBUS_DATA_ACTIVE_LOW              (1 << 9)
>> > +/* Which datawidths are supported */
>> > +#define V4L2_MBUS_DATAWIDTH_4                  (1 << 10)
>> > +#define V4L2_MBUS_DATAWIDTH_8                  (1 << 11)
>> > +#define V4L2_MBUS_DATAWIDTH_9                  (1 << 12)
>> > +#define V4L2_MBUS_DATAWIDTH_10                 (1 << 13)
>> > +#define V4L2_MBUS_DATAWIDTH_15                 (1 << 14)
>> > +#define V4L2_MBUS_DATAWIDTH_16                 (1 << 15)
>> > +
>> > +#define V4L2_MBUS_DATAWIDTH_MASK       (V4L2_MBUS_DATAWIDTH_4 | V4L2_MBUS_DATAWIDTH_8 | \
>> > +                                        V4L2_MBUS_DATAWIDTH_9 | V4L2_MBUS_DATAWIDTH_10 | \
>> > +                                        V4L2_MBUS_DATAWIDTH_15 | V4L2_MBUS_DATAWIDTH_16)
>> > +
>> > +/* Serial flags */
>> > +/* How many lanes the client can use */
>> > +#define V4L2_MBUS_CSI2_1_LANE                  (1 << 0)
>> > +#define V4L2_MBUS_CSI2_2_LANE                  (1 << 1)
>> > +#define V4L2_MBUS_CSI2_3_LANE                  (1 << 2)
>> > +#define V4L2_MBUS_CSI2_4_LANE                  (1 << 3)
>> > +/* On which channels it can send video data */
>> > +#define V4L2_MBUS_CSI2_CHANNEL_0                       (1 << 4)
>> > +#define V4L2_MBUS_CSI2_CHANNEL_1                       (1 << 5)
>> > +#define V4L2_MBUS_CSI2_CHANNEL_2                       (1 << 6)
>> > +#define V4L2_MBUS_CSI2_CHANNEL_3                       (1 << 7)
>> > +/* Does it support only continuous or also non-contimuous clock mode */
>>
>> Typo: non-continuous
>
> Right, thanks:)
>
>> > +#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK                (1 << 8)
>>
>> Doesn't having above bit disabled, imply a non-continuous clock already?
>
> Well, actually, yes, we coult drop one of these, because continuous clock
> mode is obligatory, so, we can just always assume, that all clients
> support it and only check whether they _also_ support non-continuous.
> Similarly when setting - if the non-continuous flag is not set, obviously,
> the subdev has to configure the continuous mode. But if we ever encounter
> a device, that only supports the non-continuous mode, we get a problem:)
> Also, maybe the driver for some reason decides not to accept the
> continuous mode, so, I think, it's better to keep both.

Oh ok, I see now. I wasn't getting that before. :)

Thanks for the explanation.

Regards,
Sergio

>
> Thanks
> Guennadi
>
>>
>> > +#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK     (1 << 9)
>>
>> Regards,
>> Sergio
>>
>> > +
>> > +#define V4L2_MBUS_CSI2_LANES           (V4L2_MBUS_CSI2_1_LANE | V4L2_MBUS_CSI2_2_LANE | \
>> > +                                        V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
>> > +#define V4L2_MBUS_CSI2_CHANNELS                (V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
>> > +                                        V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
>> > +
>> > +/**
>> > + * v4l2_mbus_type - media bus type
>> > + * @V4L2_MBUS_PARALLEL:        parallel interface with hsync and vsync
>> > + * @V4L2_MBUS_BT656:   parallel interface with embedded synchronisation
>> > + * @V4L2_MBUS_CSI2:    MIPI CSI-2 serial interface
>> > + */
>> > +enum v4l2_mbus_type {
>> > +       V4L2_MBUS_PARALLEL,
>> > +       V4L2_MBUS_BT656,
>> > +       V4L2_MBUS_CSI2,
>> > +};
>> > +
>> > +/**
>> > + * v4l2_mbus_config - media bus configuration
>> > + * @type:      interface type
>> > + * @flags:     configuration flags, depending on @type
>> > + * @clk:       output clock, the bridge driver can try to use clk_set_parent()
>> > + *             to specify the master clock to the client
>> > + */
>> > +struct v4l2_mbus_config {
>> > +       enum v4l2_mbus_type type;
>> > +       unsigned long flags;
>> > +       struct clk *clk;
>> > +};
>> > +
>> >  static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
>> >                                const struct v4l2_mbus_framefmt *mbus_fmt)
>> >  {
>> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> > index 1562c4f..6ea25f4 100644
>> > --- a/include/media/v4l2-subdev.h
>> > +++ b/include/media/v4l2-subdev.h
>> > @@ -255,6 +255,10 @@ struct v4l2_subdev_audio_ops {
>> >    try_mbus_fmt: try to set a pixel format on a video data source
>> >
>> >    s_mbus_fmt: set a pixel format on a video data source
>> > +
>> > +   g_mbus_param: get supported mediabus configurations
>> > +
>> > +   s_mbus_param: set a certain mediabus configuration
>> >  */
>> >  struct v4l2_subdev_video_ops {
>> >        int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
>> > @@ -294,6 +298,8 @@ struct v4l2_subdev_video_ops {
>> >                            struct v4l2_mbus_framefmt *fmt);
>> >        int (*s_mbus_fmt)(struct v4l2_subdev *sd,
>> >                          struct v4l2_mbus_framefmt *fmt);
>> > +       int (*g_mbus_param)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
>> > +       int (*s_mbus_param)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
>> >  };
>> >
>> >  /*
>> >
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
