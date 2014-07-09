Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42127 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaGIW2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 18:28:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric Balletbo Serra <eballetbo@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.16] mt9p031 fixes
Date: Thu, 10 Jul 2014 00:29:46 +0200
Message-ID: <13027564.FRBYDsomnf@avalon>
In-Reply-To: <CAFqH_50BgmxuW1Q_4ofdDB7t=O2jw=jTGmBm+NWn1tBMtFWRjQ@mail.gmail.com>
References: <6639318.OE0dlORGdR@avalon> <CAFqH_50BgmxuW1Q_4ofdDB7t=O2jw=jTGmBm+NWn1tBMtFWRjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

On Wednesday 09 July 2014 17:56:59 Enric Balletbo Serra wrote:
> 2014-05-16 2:45 GMT+02:00 Laurent Pinchart wrote:
> > Hi Mauro,
> > 
> > The following changes since commit
> > ba0d342ecc21fbbe2f6c178f4479944d1fb34f3b:
> >   saa7134-alsa: include vmalloc.h (2014-05-13 23:05:15 -0300)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/media.git sensors/next
> > 
> > for you to fetch changes up to a3a7145c6cecbd9752311b8ae1e431f6755ad5f3:
> >   mt9p031: Fix BLC configuration restore when disabling test pattern
> > 
> > (2014-05-16 02:43:50 +0200)
> > 
> > ----------------------------------------------------------------
> > 
> > Laurent Pinchart (2):
> >       mt9p031: Really disable Black Level Calibration in test pattern mode
> >       mt9p031: Fix BLC configuration restore when disabling test pattern
> >  
> >  drivers/media/i2c/mt9p031.c | 53 ++++++++++++++++++++++++++++++----------
> > 
> >  1 file changed, 39 insertions(+), 14 deletions(-)
> 
> I'm trying to test omap3-isp and a board with mt9p031 sensor with
> current mainline. For now I'm using tag version 3.15 (which is close
> to current mainline). First, when I tried to use the test patterns I
> only saw a black screen, but after applying these two patches I saw an
> improvement, although I can see the test pattern correctly.
> 
> After some modifications the subdevs_group for my board is as follows:
> 
> +static struct isp_v4l2_subdevs_group igep00x0_camera_subdevs[] = {
> +       {
> +               .subdevs = cam0020_primary_subdevs,
> +               .interface = ISP_INTERFACE_PARALLEL,
> +               .bus = {
> +                       .parallel = {
> +                               /* CAM[11:0] */
> +                               .data_lane_shift = ISP_LANE_SHIFT_2,
> +                               /* Sample on falling edge */
> +                               .clk_pol = 1,
> +                       }
> +               },
> +       },
> +       { },
> +};
> 
> As I have some problems I would ask some questions, maybe you can help me.
> 
> In the past in the data_lane_shift was ISP_LANE_SHIFT_0, but now, it
> seems I should to use ISP_LANE_SHIFT_2 (CAM[11:0] - as I saw in the
> include file). ISP_LANE_SHIFT_0 is for CAM[13:0] but OMAP3 has only 12
> data bus signals. Is that right ?

Not really. The CCDC input is actually 16 bits wide. The ISP parallel bus is 
limited to 12 bits, the CSI2 receivers output up to 14 bits, and the bridge 
can merge two 8-bit samples into a 16-bit sample for YUV formats.

When using a 12 bit parallel sensor, unless you want to restrict the dynamic 
of the input image, you should use a data lane shift value of 0. This will 
cause the CAMEXT[13:0] signal to be mapped to CAM[13:0]. As the parallel bus 
is limited to 12 bits, the CAM[13:12] bits will be set to zero. When capturing 
from the CCDC output to memory each pixel will be stored on 16 bits, with bits 
[15:12] set to zero, and bits [11:0] containing image data. When forwarding 
data to the preview engine, which has an input width of 10 bits, the ISP 
driver will configure the CCDC video port to output bits [11:2] to the preview 
engine, dropping the two LSBs. 

> Another thing is I'm not able to capture the image correctly, also if
> if configure to ouput a test pattern, doesn't looks good. See as
> example [1] and [2]. Do you know what could be the problem ?
> 
> For your information these are the pipeline that I'm using :
> 
>   media-ctl -v -r -l '"mt9p031 1-005d":0->"OMAP3 ISP CCDC":0[1],
> "OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP
> preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3
> ISP resizer output":0[1]'
> 
>   media-ctl -v -f '"mt9p031 1-005d":0[SGRBG12 720x480], "OMAP3 ISP
> CCDC":2[SGRBG8 720x480], "OMAP3 ISP preview":1[UYVY 720x480], "OMAP3
> ISP resizer":1[UYVY 720x480]'

I would configure the pipeline with SGRBG10 at the output of the CCDC. The 
resolutions you request through the pipeline can't be achieved exactly, as the 
sensor can only perform binning/skipping to downscale. The resizer will take 
care to scale the image to the requested 720x480, but it will get distorted. 
You should use media-ctl -p to see what resolutions the above command actually 
sets, and fix the configuration with appropriate cropping if you want to keep 
the sensor aspect ratio intact.

> # Set Vertical Color Bars as test pattern
>   yavta -w '0x009f0903 9' /dev/v4l-subdev8
> 
> # Capture data with
>   yavta  -f UYVY -s 720x480 --capture=5 --skip=1 --file=image-# /dev/video6
> 
> # And convert with
>   raw2rgbpnm -s 720x480 image-00000.uyuv image-00000.pnm
> 
> Thanks in advance and any help will be appreciate.
> 
> Regards,
>   Enric
> 
> [1] http://downloads.isee.biz/pub/files/tmp/9-Vertical Color Bars.pnm
> [2] http://downloads.isee.biz/pub/files/tmp/9-Vertical Color Bars.uyvy

-- 
Regards,

Laurent Pinchart

