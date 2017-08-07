Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42839 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752698AbdHGISA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 04:18:00 -0400
Message-ID: <1502093851.2490.4.camel@pengutronix.de>
Subject: Re: [PATCH] media: i2c: OV5647: gate clock lane before stream on
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jacob Chen <jacobchen110@gmail.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, roliveir@synopsys.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        vladimir_zapolskiy@mentor.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        sakari.ailus@linux.intel.com, Jacob Chen <jacob-chen@iotwrt.com>,
        slongerbeam@gmail.com, robh+dt@kernel.org, lolivei@synopsys.com
Date: Mon, 07 Aug 2017 10:17:31 +0200
In-Reply-To: <CAFLEztQHYWAk39+gQCD0XkKPVqmUY5kPZydWgw8+zu53+D2_pA@mail.gmail.com>
References: <1500950041-5449-1-git-send-email-jacob-chen@iotwrt.com>
         <CAFLEztQHYWAk39+gQCD0XkKPVqmUY5kPZydWgw8+zu53+D2_pA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

On Mon, 2017-08-07 at 15:11 +0800, Jacob Chen wrote:
> Hi all,
> 
> 2017-07-25 10:34 GMT+08:00 Jacob Chen <jacob-chen@iotwrt.com>:
> > According to datasheet, BIT5 in reg-0x4800 are used to
> > enable/disable clock lane gate.
> >
> > It's wrong to make clock lane free running before
> > sensor stream on was called, while the mipi phy
> > are not initialized.
> >
> > Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>>
> > ---
> >  drivers/media/i2c/ov5647.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
> > index 95ce90f..d3e6fd0 100644
> > --- a/drivers/media/i2c/ov5647.c
> > +++ b/drivers/media/i2c/ov5647.c
> > @@ -253,6 +253,10 @@ static int ov5647_stream_on(struct v4l2_subdev *sd)
> >  {
> >         int ret;
> >
> > +       ret = ov5647_write(sd, 0x4800, 0x04);
> > +       if (ret < 0)
> > +               return ret;
> > +
> >         ret = ov5647_write(sd, 0x4202, 0x00);
> >         if (ret < 0)
> >                 return ret;
> > @@ -264,6 +268,10 @@ static int ov5647_stream_off(struct v4l2_subdev *sd)
> >  {
> >         int ret;
> >
> > +       ret = ov5647_write(sd, 0x4800, 0x25);
> > +       if (ret < 0)
> > +               return ret;
> > +
> >         ret = ov5647_write(sd, 0x4202, 0x0f);
> >         if (ret < 0)
> >                 return ret;
> > @@ -320,7 +328,7 @@ static int __sensor_init(struct v4l2_subdev *sd)
> >                         return ret;
> >         }
> >
> > -       return ov5647_write(sd, 0x4800, 0x04);
> > +       return ov5647_stream_off(sd);
> >  }
> >
> >  static int ov5647_sensor_power(struct v4l2_subdev *sd, int on)
> > --
> > 2.7.4
> >
> 
> Can anyone comment on it?
> 
> I saw there is a same discussion in  https://patchwork.kernel.org/patch/9569031/
> There is a comment in i.MX CSI2 driver.
> "
> Configure MIPI Camera Sensor to put all Tx lanes in LP-11 state.
> This must be carried out by the MIPI sensor's s_power(ON) subdev
> op.
> "
> That's what this patch do, sensor driver should make sure that clock
> lanes are in stop state while not streaming.

This is not the same, as far as I can tell. BIT(5) is just clock lane
gating, as you describe above. To put the bus into LP-11 state, BIT(2)
needs to be set.

regards
Philipp
