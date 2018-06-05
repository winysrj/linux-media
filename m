Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38547 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbeFEKQ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 06:16:26 -0400
Message-ID: <1528193781.4074.9.camel@pengutronix.de>
Subject: Re: [PATCHv15 09/35] v4l2-ctrls: v4l2_ctrl_add_handler: add
 from_other_dev
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 05 Jun 2018 12:16:21 +0200
In-Reply-To: <3e2c9ea0-bc55-afc3-8a21-53b281c7880d@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
         <20180604114648.26159-10-hverkuil@xs4all.nl>
         <3e2c9ea0-bc55-afc3-8a21-53b281c7880d@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2018-06-04 at 18:22 +0200, Hans Verkuil wrote:
> Steve or Philipp,
> 
> Can one of you verify the imx-media-fim.c patch?
> 
> See the description of the change below:
> 
> On 06/04/2018 01:46 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Add a 'bool from_other_dev' argument: set to true if the two
> > handlers refer to different devices (e.g. it is true when
> > inheriting controls from a subdev into a main v4l2 bridge
> > driver).
> > 
> > This will be used later when implementing support for the
> > request API since we need to skip such controls.
> > 
> > TODO: check drivers/staging/media/imx/imx-media-fim.c change.
> 
> The basic idea is that while controls for a subdev can be
> added ('inherited') to a handler for a another parent subdev or
> video device, they should be marked as belonging to another device.
> 
> This is needed when the Request API is introduced since the request
> should not have two copies of the same control (one belonging to the
> subdev, one inherited by e.g. a video device).
> 
> However, I am not sure if I need to use true or false in the.
> imx_media_fim_add_controls() case. Do the controls added here belong
> to the same csi subdev or do they belong to another device?
> 
> BTW, with 'belongs to' I mean that that's the device driver that
> implements the s_ctrl() call, i.e. actually sets up the hardware.

The FIM controls are created on the CSI subdev
via imx_media_fim_add_controls and then collected by the connected video
capture device:

$ media-ctl -p
[...]
- entity 53: ipu1_csi0 (3 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
[...]
	pad2: Source
		[fmt:AYUV8_1X32/1920x1080@1/30 field:none colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
		-> "ipu1_csi0 capture":0 [ENABLED]
[...]
- entity 57: ipu1_csi0 capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video8
	pad0: Sink
		<- "ipu1_csi0":2 [ENABLED]

$ v4l2-ctl -d /dev/v4l-subdev8 -l

User Controls

                     fim_enable 0x00981990 (bool)   : default=0 value=0
                fim_num_average 0x00981991 (int)    : min=1 max=64 step=1 default=8 value=8
              fim_tolerance_min 0x00981992 (int)    : min=2 max=200 step=1 default=50 value=50
              fim_tolerance_max 0x00981993 (int)    : min=0 max=500 step=1 default=0 value=0
                   fim_num_skip 0x00981994 (int)    : min=0 max=256 step=1 default=2 value=2
         fim_input_capture_edge 0x00981995 (int)    : min=0 max=3 step=1 default=0 value=0
      fim_input_capture_channel 0x00981996 (int)    : min=0 max=1 step=1 default=0 value=0

$ v4l2-ctl -d /dev/video8 -l

User Controls

            audio_sampling_rate 0x00981980 (int)    : min=0 max=768000 step=1 default=0 value=0 flags=read-only
                  audio_present 0x00981981 (bool)   : default=0 value=0 flags=read-only
                     fim_enable 0x00981990 (bool)   : default=0 value=0
                fim_num_average 0x00981991 (int)    : min=1 max=64 step=1 default=8 value=8
              fim_tolerance_min 0x00981992 (int)    : min=2 max=200 step=1 default=50 value=50
              fim_tolerance_max 0x00981993 (int)    : min=0 max=500 step=1 default=0 value=0
                   fim_num_skip 0x00981994 (int)    : min=0 max=256 step=1 default=2 value=2
         fim_input_capture_edge 0x00981995 (int)    : min=0 max=3 step=1 default=0 value=0
      fim_input_capture_channel 0x00981996 (int)    : min=0 max=1 step=1 default=0 value=0

Digital Video Controls

                  power_present 0x00a00964 (bitmask): max=0x00000001 default=0x00000000 value=0x00000001 flags=read-only

I believe this means your patch is correct, as the controls are created
for the CSI subdev, not inherited from another subdev.

regards
Philipp

> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > ---
> >  drivers/media/dvb-frontends/rtl2832_sdr.c     |  5 +-
> >  drivers/media/pci/bt8xx/bttv-driver.c         |  2 +-
> >  drivers/media/pci/cx23885/cx23885-417.c       |  2 +-
> >  drivers/media/pci/cx88/cx88-blackbird.c       |  2 +-
> >  drivers/media/pci/cx88/cx88-video.c           |  2 +-
> >  drivers/media/pci/saa7134/saa7134-empress.c   |  4 +-
> >  drivers/media/pci/saa7134/saa7134-video.c     |  2 +-
> >  .../media/platform/exynos4-is/fimc-capture.c  |  2 +-
> >  drivers/media/platform/rcar-vin/rcar-core.c   |  2 +-
> >  drivers/media/platform/rcar_drif.c            |  2 +-
> >  .../media/platform/soc_camera/soc_camera.c    |  3 +-
> >  drivers/media/platform/vivid/vivid-ctrls.c    | 46 +++++++++----------
> >  drivers/media/usb/cx231xx/cx231xx-417.c       |  2 +-
> >  drivers/media/usb/cx231xx/cx231xx-video.c     |  4 +-
> >  drivers/media/usb/msi2500/msi2500.c           |  2 +-
> >  drivers/media/usb/tm6000/tm6000-video.c       |  2 +-
> >  drivers/media/v4l2-core/v4l2-ctrls.c          | 11 +++--
> >  drivers/media/v4l2-core/v4l2-device.c         |  3 +-
> >  drivers/staging/media/imx/imx-media-dev.c     |  2 +-
> >  drivers/staging/media/imx/imx-media-fim.c     |  2 +-
> >  include/media/v4l2-ctrls.h                    |  8 +++-
> >  21 files changed, 61 insertions(+), 49 deletions(-)
> > 
> 
> <snip>
> 
> > diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> > index 289d775c4820..08799beaea42 100644
> > --- a/drivers/staging/media/imx/imx-media-dev.c
> > +++ b/drivers/staging/media/imx/imx-media-dev.c
> > @@ -391,7 +391,7 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
> >  
> >  		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
> >  					    sd->ctrl_handler,
> > -					    NULL);
> > +					    NULL, true);
> >  		if (ret)
> >  			return ret;
> >  	}
> > diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
> > index 6df189135db8..8cf773eef9da 100644
> > --- a/drivers/staging/media/imx/imx-media-fim.c
> > +++ b/drivers/staging/media/imx/imx-media-fim.c
> > @@ -463,7 +463,7 @@ int imx_media_fim_add_controls(struct imx_media_fim *fim)
> >  {
> >  	/* add the FIM controls to the calling subdev ctrl handler */
> >  	return v4l2_ctrl_add_handler(fim->sd->ctrl_handler,
> > -				     &fim->ctrl_handler, NULL);
> > +				     &fim->ctrl_handler, NULL, false);
> >  }
> >  EXPORT_SYMBOL_GPL(imx_media_fim_add_controls);
> >  
> 
> 
