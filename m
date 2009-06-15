Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3894 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZFOW3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 18:29:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and DM6446
Date: Tue, 16 Jun 2009 00:29:00 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <200906141610.21618.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40139DF9582@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139DF9582@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906160029.01328.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 15 June 2009 23:47:07 Karicheri, Muralidharan wrote:
> Hans,
>
> I am not clear about some of your comments. Please see below with a [MK]
> prefix.
>

<snip>

> >> +	/* set if client specific interface param is available */
> >> +	if (subdev->pdata) {
> >> +		/* each client will have different interface requirements */
> >> +		if (!strcmp(subdev->name, "tvp5146")) {
> >> +			struct tvp514x_platform_data *pdata = subdev->pdata;
> >> +
> >> +			if (pdata->hs_polarity)
> >> +				vpfe_dev->vpfe_if_params.hdpol =
> >> +					VPFE_PINPOL_POSITIVE;
> >> +			else
> >> +				vpfe_dev->vpfe_if_params.hdpol =
> >> +					VPFE_PINPOL_NEGATIVE;
> >> +
> >> +			if (pdata->vs_polarity)
> >> +				vpfe_dev->vpfe_if_params.vdpol =
> >> +					VPFE_PINPOL_POSITIVE;
> >> +			else
> >> +				vpfe_dev->vpfe_if_params.hdpol =
> >> +					VPFE_PINPOL_NEGATIVE;
> >
> >This won't work. Instead this should be data associated with the
> >platform_data.
> >I.e. the platform_data for the dm355/dm6446 contains not only the subdev
> >information, but for each subdev also the information on how to setup
> > the vpfe
> >polarities. You cannot derive that information from what subdevs are
> > used since
> >the board designer might have added e.g. inverters or something like
> > that. Such
> >information can only come from the platform_data.
>
> [MK] I know this code is not correct. But I was waiting for the
> discussion on my bus parameter patch to make this change. Currently
> TVP514x driver that you have reviewed configure output bus based on
> route->output parameter set by s_route(). This doesn't make sense. The
> input param make sense since application can choose between Composite and
> S-Video inputs. There is only one bus going out of the sub device to
> vpfe. So the output selection @ sub device is redundant. I think the
> output is part of as the bus parameter structure I added in the bus
> parameter patch which is under review. It can be read by TVP514x from the
> platform data (using the structure added by my patch) and can be
> overridden by s_bus(). Do you expect the bridge driver and sub devices
> having platform data for bus type (For example, BT.656)? It appears to be
> required only for sub device and bridge driver can configure the ccdc
> based on sub device bus type.  But for polarities I need to define them
> for both sides. comments?

Part of the current functionality of s_route will be taken over by s_bus. 
But right now this is all we have. Usually the output argument of s_route 
is used by audio devices that have multiple output pins. Most video devices 
have only one output so it does not normally apply to those. But without an 
s_bus function it is (ab)used to set things like bus parameters. One can 
argue that those parameters define the output of the chip but it will 
definitely be nicer to set this with a proper s_bus call.

Polarities have to be set for each side, that's correct. The other 
parameters are common for both. Although I can think of scenarios where the 
bus width can differ between host and subdev (e.g. subdev sends data on 8 
pins and the host captures on 10 with the least significant two pins pulled 
low). But that's probably really paranoid of me :-)

>
> >> +		} else {
> >> +			v4l2_err(&vpfe_dev->v4l2_dev, "No interface params"
> >> +				" defined for subdevice, %d\n", route->output);
> >> +			return -EFAULT;
> >> +		}
> >> +	}
> >> +	return ccdc_dev->hw_ops.set_hw_if_params(&vpfe_dev->vpfe_if_params);
> >> +}
> >> +
> >> +/*
> >> +
> >> +	struct vpfe_fh *fh;
> >> +
> >> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_open\n");
> >> +
> >> +	if (!vpfe_dev->cfg->num_subdevs) {
> >> +		v4l2_err(&vpfe_dev->v4l2_dev, "No decoder registered\n");
> >> +		return -ENODEV;
> >> +	}
> >
> >Why would this be an error? I might have an FPGA connected instead or
> > some other non-i2c device that doesn't require any setup from this
> > driver.
>
> [MK] What you mean by this? Are you saying an FPGA logic will implement
> the decoder hardware? That is quite possible, so also it could be
> non-i2c. But my understanding was that sub device can be anything that
> basically implement the sub device API and need not always be an i2c
> device. So for FPGA or some other bus based device, the bridge device
> doesn't care how the command to change input, detect standard etc are
> communicated by the sub device driver to its hardware. It could be
> writing into some FPGA register or sending a proprietary protocol
> command. Is my understanding correct? In that case each of the above
> (FPGA or non-i2c) is a sub device and at least one sub device should be
> available before application can do any useful operation with the capture
> device. So the check is required. Am I missing something here?

First of all, this isn't a blocking issue at all. This is more a 
nice-to-have.

The reason I mentioned it is because of how we use this (or the dm646x to be 
precise) at my work: the dm646x is connected to our FPGA so we had to make 
dummy encoder/decoder drivers to allow it to work with that driver. What 
made that somewhat annoying is that those dummy drivers really didn't do 
anything since the FPGA isn't programmed from the linux kernel at all. So 
we have basically dead code in our kernel just to satisfy a dm646x driver 
requirement.

And you are right: a subdev is bus independent, so it is perfectly possible 
to make a dummy subdev instead. The key phrase was really 'doesn't require 
any setup'. It would be nice to be able to use this driver 'standalone' 
without requiring a subdev. Something to think about.

And apologies for my poor review comment, that was phrased rather badly.

>
> >> +
> >> +unlock_out:
> >> +	mutex_unlock(&vpfe_dev->lock);
> >> +	return ret;
> >> +}
> >> +
> >> +
> >> +static int vpfe_queryctrl(struct file *file, void *priv,
> >> +				struct v4l2_queryctrl *qc)
> >> +{
> >> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> >> +	struct vpfe_subdev_info *sub_dev = vpfe_dev->current_subdev;
> >> +
> >> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_queryctrl\n");
> >> +
> >> +	if (qc->id >= V4L2_CID_PRIVATE_BASE) {
> >> +		/* It is ccdc CID */
> >> +		if (ccdc_dev->hw_ops.queryctrl)
> >> +			return ccdc_dev->hw_ops.queryctrl(qc);
> >> +	}
> >> +	/* pass it to sub device */
> >> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sub_dev-
> >>grp_id,
> >> +					  core, queryctrl, qc);
> >> +}
> >> +
> >> +static int vpfe_g_ctrl(struct file *file, void *priv,
> >> +			struct v4l2_control *ctrl)
> >> +{
> >> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> >> +	struct vpfe_subdev_info *sub_dev = vpfe_dev->current_subdev;
> >> +
> >> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_ctrl\n");
> >> +
> >> +	if (ctrl->id >= V4L2_CID_PRIVATE_BASE) {
> >> +		/* It is ccdc CID */
> >> +		if (ccdc_dev->hw_ops.get_control)
> >> +			return ccdc_dev->hw_ops.get_control(ctrl);
> >> +	}
> >
> >Don't use these PRIVATE_BASE controls. See also this post regarding
> >the current situation regarding private controls:
> >
> >http://www.mail-archive.com/linux-omap%40vger.kernel.org/msg07999.html
>
> [MK] Looks like it is better to add it to TBD and address it when I add
> camera interface support.

OK, but please make sure it is revisited. Improving the control handling 
code in the v4l2 framework is very high on my TODO list since it is getting 
really annoying to implement in drivers. And the inconsistent driver 
support isn't helping applications either.

I really hope I'll have time for it in the next few weeks.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
