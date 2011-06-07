Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:54698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1FGHEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 03:04:42 -0400
Date: Tue, 7 Jun 2011 09:04:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <kassey1216@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: soc-camera: MIPI flags are not sensor flags
In-Reply-To: <BANLkTikFAgYcWLw=Pn142sXLVoqv9GtW7g@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1106070847480.31635@axis700.grange>
References: <Pine.LNX.4.64.1106061917080.11169@axis700.grange>
 <BANLkTikFAgYcWLw=Pn142sXLVoqv9GtW7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kassey

On Tue, 7 Jun 2011, Kassey Lee wrote:

> hi, Guennadi:
>         I'm a little confused.
>         there is possible that a board will connect the sensor with
> [1234] lanes.
>         so this means it could be a board-specific flags too ?

Yes, this is certainly possible. But first of all, please, look at 
soc_camera_bus_param_compatible(), which is where we have added those MIPI 
flags, along with other SOCAM_* flags. That was a bug - you certainly 
cannot mix different flags in one bitmask. With a definition like

#define SOCAM_MIPI_1LANE               (1 << 5)

it just messes up with

#define SOCAM_VSYNC_ACTIVE_LOW		(1 << 5)

etc. So, to use these flags to configure the connection between the camera 
and the host, these MIPI_*LANE flags has to belong to the same value 
range. Of course, it is possible, that a camera driver need platform data 
to find out, how many lanes it has connected. But that can be handled 
privately by each such driver, similar to buswidth on parallel 
connections. I would suggest using the .query_bus_param() callback in 
struct soc_camera_link for that. You can have a look at mt9m001 for an 
example.

Thanks
Guennadi

> 
> thanks!
> 
> Best regards
> Kassey
> Application Processor Systems Engineering, Marvell Technology Group Ltd.
> Shanghai, China.
> 
> On Tue, Jun 7, 2011 at 1:17 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > SOCAM_MIPI_[1234]LANE flags are not board-specific sensor flags, they
> > are bus configuration flags.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  include/media/soc_camera.h |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index 238bd33..e34b5e6 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -109,12 +109,6 @@ struct soc_camera_host_ops {
> >  #define SOCAM_SENSOR_INVERT_HSYNC      (1 << 2)
> >  #define SOCAM_SENSOR_INVERT_VSYNC      (1 << 3)
> >  #define SOCAM_SENSOR_INVERT_DATA       (1 << 4)
> > -#define SOCAM_MIPI_1LANE               (1 << 5)
> > -#define SOCAM_MIPI_2LANE               (1 << 6)
> > -#define SOCAM_MIPI_3LANE               (1 << 7)
> > -#define SOCAM_MIPI_4LANE               (1 << 8)
> > -#define SOCAM_MIPI     (SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | \
> > -                       SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)
> >
> >  struct i2c_board_info;
> >  struct regulator_bulk_data;
> > @@ -270,6 +264,12 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
> >  #define SOCAM_PCLK_SAMPLE_FALLING      (1 << 13)
> >  #define SOCAM_DATA_ACTIVE_HIGH         (1 << 14)
> >  #define SOCAM_DATA_ACTIVE_LOW          (1 << 15)
> > +#define SOCAM_MIPI_1LANE               (1 << 16)
> > +#define SOCAM_MIPI_2LANE               (1 << 17)
> > +#define SOCAM_MIPI_3LANE               (1 << 18)
> > +#define SOCAM_MIPI_4LANE               (1 << 19)
> > +#define SOCAM_MIPI     (SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | \
> > +                       SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)
> >
> >  #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
> >                              SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
> > --
> > 1.7.2.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
