Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1440 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1AYHiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 02:38:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC PATCH 02/12] sh_mobile_ceu_camera: implement the control handler.
Date: Tue, 25 Jan 2011 08:37:56 +0100
Cc: linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl> <4ef0bba6ffe2a932c43cdc99d22fe0da0e6bfcd5.1294786597.git.hverkuil@xs4all.nl> <Pine.LNX.4.64.1101222120110.31015@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101222120110.31015@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250837.56488.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 22, 2011 21:31:52 Guennadi Liakhovetski wrote:
> On Wed, 12 Jan 2011, Hans Verkuil wrote:
> 
> > And since this is the last and only host driver that uses controls, also
> > remove the now obsolete control fields from soc_camera.h.
> > 
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > ---
> >  drivers/media/video/sh_mobile_ceu_camera.c |   95 ++++++++++++---------------
> >  include/media/soc_camera.h                 |    4 -
> >  2 files changed, 42 insertions(+), 57 deletions(-)
> > 
> > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> > index 954222b..f007f57 100644
> > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> > @@ -112,6 +112,7 @@ struct sh_mobile_ceu_dev {
> >  
> >  	unsigned int image_mode:1;
> >  	unsigned int is_16bit:1;
> > +	unsigned int added_controls:1;
> >  };
> >  
> >  struct sh_mobile_ceu_cam {
> > @@ -133,6 +134,12 @@ struct sh_mobile_ceu_cam {
> >  	enum v4l2_mbus_pixelcode code;
> >  };
> >  
> > +static inline struct soc_camera_device *to_icd(struct v4l2_ctrl *ctrl)
> 
> I've been told a while ago not to use "inline" in .c files, and to let the 
> compiler decide instead. Also this file has no inline directives in it 
> until now, please, keep it that way.

OK.

> > +{
> > +	return container_of(ctrl->handler, struct soc_camera_device,
> > +							ctrl_handler);
> > +}
> > +
> >  static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
> >  {
> >  	unsigned long flags;
> > @@ -490,6 +497,33 @@ out:
> >  	return IRQ_HANDLED;
> >  }
> >  
> > +static int sh_mobile_ceu_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct soc_camera_device *icd = to_icd(ctrl);
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct sh_mobile_ceu_dev *pcdev = ici->priv;
> > +
> > +	ici = to_soc_camera_host(icd->dev.parent);
> > +	pcdev = ici->priv;
> 
> These two are redundant.

Must have missed that. Will remove these lines.

> 
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_SHARPNESS:
> > +		switch (icd->current_fmt->host_fmt->fourcc) {
> > +		case V4L2_PIX_FMT_NV12:
> > +		case V4L2_PIX_FMT_NV21:
> > +		case V4L2_PIX_FMT_NV16:
> > +		case V4L2_PIX_FMT_NV61:
> > +			ceu_write(pcdev, CLFCR, !ctrl->val);
> > +			return 0;
> > +		}
> > +		break;
> > +	}
> > +	return -EINVAL;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops sh_mobile_ceu_ctrl_ops = {
> > +	.s_ctrl = sh_mobile_ceu_s_ctrl,
> > +};
> > +
> >  /* Called with .video_lock held */
> >  static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
> >  {
> > @@ -500,6 +534,14 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
> >  	if (pcdev->icd)
> >  		return -EBUSY;
> >  
> > +	if (!pcdev->added_controls) {
> > +		v4l2_ctrl_new_std(&icd->ctrl_handler, &sh_mobile_ceu_ctrl_ops,
> > +				V4L2_CID_SHARPNESS, 0, 1, 1, 0);
> 
> Hm, am I missing something with this new API? You register a handler for 
> only one control ID, and in the handler itself you check once more, which 
> ID it is?...

I can remove the check, but having a switch, even if only for one control,
makes it very easy later to add additional controls. But if you prefer not
to have that, then I can easily remove it.
 
> > +		if (icd->ctrl_handler.error)
> > +			return icd->ctrl_handler.error;
> > +		pcdev->added_controls = 1;
> > +	}
> > +
> >  	dev_info(icd->dev.parent,
> >  		 "SuperH Mobile CEU driver attached to camera %d\n",
> >  		 icd->devnum);
> 
> Thanks
> Guennadi

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
