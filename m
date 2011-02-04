Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:53528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1BDHpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 02:45:23 -0500
Date: Fri, 4 Feb 2011 08:45:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: How to support MIPI CSI-2 controller in soc-camera framework?
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF80C@SC-VEXCH2.marvell.com>
Message-ID: <Pine.LNX.4.64.1102040838280.14717@axis700.grange>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
 <201101101133.01636.laurent.pinchart@ideasonboard.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101171826340.16051@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2EF@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101181811590.19950@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF54D@SC-VEXCH2.marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF5AF@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101191701430.620@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF80C@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

Sorry for the delay first of all.

On Wed, 19 Jan 2011, Qing Xu wrote:

> Hi,
> 
> (a general request: could you please configure your mailer to wrap
> Lines at somewhere around 70 characters?)
> very sorry for the un-convenience!
> 
> Thanks for your description! I could verify and try your way on our
> CSI-2 driver.
> Also, our another chip's camera controller support both MIPI and
> traditional parallel(H_sync/V_sync) interface, we hope host can
> negotiate with sensor on MIPI configure, as the sensor could be
> parallel interface or MIPI interface, so I have a proposal as
> follow:
> 
> in soc_camera.h, SOCAM_XXX defines all HW connection properties,
> I thing MIPI(1/2/3/4 lanes) is also a kind of HW connection
> property, and it is mutex with parallel properties(if sensor
> support mipi connection, the HW signal has no parallel property
> any more), once host controller find subdev support MIPI, it will
> enable MIPI functional itself, and if subdev only support parallel,
> it will enable parallel functional itself.

I think, yes, we can add MIPI definitions to soc_camera.h, similar to your 
proposal below, but I don't think we need the "SOCAM_MIPI" macro itself, 
maybe define it as a mask

#define SOCAM_MIPI (SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)

Also, the decision "if MIPI supported by the client always prefer it over 
the parallel connection" doesn't seem to be a meaningful thing to do in 
the driver to me. I would leave the choice of a connection to the platform 
code. In that case your addition to the soc_camera_apply_sensor_flags() 
function becomes unneeded.

Makes sense?

Thanks
Guennadi

> (you can find the proposal in the code which I have sent, refer to 
> pxa955_cam_set_bus_param() in pxa955_cam.c, ov5642_query_bus_param
> In ov5642.c)
> 
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
>                 if (f == SOCAM_PCLK_SAMPLE_RISING || f == SOCAM_PCLK_SAMPLE_FALLING)
>                         flags ^= SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING;
>         }
> +       if (icl->flags & SOCAM_MIPI) {
> +               flags &= SOCAM_MIPI | SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE
> +                                       | SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE;
> +       }
> 
>         return flags;
>  }
> 
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> 
>  #define SOCAM_DATA_ACTIVE_HIGH         (1 << 14)
>  #define SOCAM_DATA_ACTIVE_LOW          (1 << 15)
> 
> +#define SOCAM_MIPI             (1 << 16)
> +#define SOCAM_MIPI_1LANE               (1 << 17)
> +#define SOCAM_MIPI_2LANE               (1 << 18)
> +#define SOCAM_MIPI_3LANE               (1 << 19)
> +#define SOCAM_MIPI_4LANE               (1 << 20)
> +
> 
>  static inline unsigned long soc_camera_bus_param_compatible(
>                         unsigned long camera_flags, unsigned long bus_flags)
>  {
> -       unsigned long common_flags, hsync, vsync, pclk, data, buswidth, mode;
> +       unsigned long common_flags, hsync, vsync, pclk, data, buswidth, mode, mipi;
> 
>         common_flags = camera_flags & bus_flags;
> 
> @@ -261,8 +267,10 @@ static inline unsigned long soc_camera_bus_param_compatible(
>         data = common_flags & (SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_LOW);
>         mode = common_flags & (SOCAM_MASTER | SOCAM_SLAVE);
>         buswidth = common_flags & SOCAM_DATAWIDTH_MASK;
> +       mipi = common_flags & (SOCAM_MIPI | SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE
> +                                               | SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE);
> 
> -       return (!hsync || !vsync || !pclk || !data || !mode || !buswidth) ? 0 :
> +       return ((!hsync || !vsync || !pclk || !data || !mode || !buswidth) && (!mipi)) ? 0 :
>                 common_flags;
>  }
> 
> 
> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: 2011Äê1ÔÂ20ÈÕ 0:20
> To: Qing Xu
> Cc: Laurent Pinchart; Linux Media Mailing List
> Subject: Re: How to support MIPI CSI-2 controller in soc-camera framework?
> 
> (a general request: could you please configure your mailer to wrap lines
> at somewhere around 70 characters?)
> 
> On Tue, 18 Jan 2011, Qing Xu wrote:
> 
> > Hi,
> >
> > Our chip support both MIPI and parallel interface. The HW connection logic is
> > sensor(such as ov5642) -> our MIPI controller(handle DPHY timing/ CSI-2
> > things) -> our camera controller (handle DMA transmitting/ fmt/ size
> > things). Now, I find the driver of sh_mobile_csi2.c, it seems like a
> > CSI-2 driver, but I don't quite understand how it works:
> > 1) how the host controller call into this driver?
> 
> This is a normal v4l2-subdev driver. Platform data for the
> sh_mobile_ceu_camera driver provides a link to CSI2 driver data, then the
> host driver loads the CSI2 driver, which then links itself into the
> subdevice list. Look at arch/arm/mach-shmobile/board-ap4evb.c how the data
> is linked:
> 
> static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
>         .flags = SH_CEU_FLAG_USE_8BIT_BUS,
>         .csi2_dev = &csi2_device.dev,
> };
> 
> and in the hosz driver drivers/media/video/sh_mobile_ceu_camera.c look in
> the sh_mobile_ceu_probe function below the lines:
> 
>         csi2 = pcdev->pdata->csi2_dev;
>         if (csi2) {
> ...
> 
> 
> > 2) how the host controller/sensor negotiate MIPI variable with this
> > driver, such as D-PHY timing(hs_settle/hs_termen/clk_settle/clk_termen),
> > number of lanes...?
> 
> Since I only had a limited number of MIPI setups, I haven't implemented
> maximum flexibility. A part of the parameters is hard-coded, another part
> is provided in the platform driver, yet another part is calculated
> dynamically.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
