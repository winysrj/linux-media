Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57631 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbdBCKmC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 05:42:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Todor Tomov <ttomov@mm-sol.com>
Cc: Todor Tomov <todor.tomov@linaro.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v7 2/2] media: Add a driver for the ov5645 camera sensor.
Date: Fri, 03 Feb 2017 12:42:22 +0200
Message-ID: <8305074.Jmm0xYKjpK@avalon>
In-Reply-To: <5893559F.7040607@mm-sol.com>
References: <1479119076-26363-1-git-send-email-todor.tomov@linaro.org> <1479119076-26363-3-git-send-email-todor.tomov@linaro.org> <5893559F.7040607@mm-sol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Thursday 02 Feb 2017 17:51:59 Todor Tomov wrote:
> Hi,
> 
> Just to point it here - there is one more one-line correction needed below:
>
> On 11/14/2016 12:24 PM, Todor Tomov wrote:
> > The ov5645 sensor from Omnivision supports up to 2592x1944
> > and CSI2 interface.
> > 
> > The driver adds support for the following modes:
> > - 1280x960
> > - 1920x1080
> > - 2592x1944
> > 
> > Output format is packed 8bit UYVY.
> > 
> > Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> > ---
> > 
> >  drivers/media/i2c/Kconfig  |   12 +
> >  drivers/media/i2c/Makefile |    1 +
> >  drivers/media/i2c/ov5645.c | 1352 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1365 insertions(+)
> >  create mode 100644 drivers/media/i2c/ov5645.c
> 
> <snip>
> 
> > diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> > new file mode 100644
> > index 0000000..2b33bc6
> > --- /dev/null
> > +++ b/drivers/media/i2c/ov5645.c
> > @@ -0,0 +1,1352 @@
> 
> <snip>
> 
> > +static int ov5645_entity_init_cfg(struct v4l2_subdev *subdev,
> > +				  struct v4l2_subdev_pad_config *cfg)
> > +{
> > +	struct v4l2_subdev_format fmt = { 0 };
> > +	struct ov5645 *ov5645 = to_ov5645(subdev);
> 
> This variable is unused and should be removed.

I've applied the two patches to my tree and fixed this. My plan is to send a 
pull request for v4.12 to give Rob time to ack the DT bindings.

> > +
> > +	fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
> > +	fmt.format.width = 1920;
> > +	fmt.format.height = 1080;
> > +
> > +	ov5645_set_format(subdev, cfg, &fmt);
> > +
> > +	return 0;
> > +}
> 
> <snip>

-- 
Regards,

Laurent Pinchart

