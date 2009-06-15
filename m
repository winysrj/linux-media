Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47340 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbZFOVrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 17:47:11 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Mon, 15 Jun 2009 16:47:07 -0500
Subject: RE: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and
 DM6446
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF9582@dlee06.ent.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
 <1244739649-27466-2-git-send-email-m-karicheri2@ti.com>
 <200906141610.21618.hverkuil@xs4all.nl>
In-Reply-To: <200906141610.21618.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I am not clear about some of your comments. Please see below with a [MK] prefix.

>> +static int debug;
>> +static u32 numbuffers = 3;
>> +static u32 bufsize = (720 * 576 * 2);
>> +
>> +module_param(numbuffers, uint, S_IRUGO);
>> +module_param(bufsize, uint, S_IRUGO);
>> +module_param(debug, int, 0644);
>> +
>> +
>> +/* Set interface params based on client interface */
>> +static int vpfe_set_hw_if_params(struct vpfe_device *vpfe_dev)
>> +{
>> +	struct vpfe_subdev_info *subdev = vpfe_dev->current_subdev;
>> +	struct v4l2_routing *route =
>> +		&(subdev->routes[vpfe_dev->current_input]);
>> +
>> +	switch (route->output) {
>> +	case OUTPUT_10BIT_422_EMBEDDED_SYNC:
>> +		vpfe_dev->vpfe_if_params.if_type = VPFE_BT656;
>> +		break;
>> +	case OUTPUT_20BIT_422_SEPERATE_SYNC:
>> +		vpfe_dev->vpfe_if_params.if_type = VPFE_YCBCR_SYNC_16;
>> +		break;
>> +	case OUTPUT_10BIT_422_SEPERATE_SYNC:
>> +		vpfe_dev->vpfe_if_params.if_type = VPFE_YCBCR_SYNC_8;
>> +		break;
>> +	default:
>> +		v4l2_err(&vpfe_dev->v4l2_dev, "decoder output"
>> +			" not supported, %d\n", route->output);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* set if client specific interface param is available */
>> +	if (subdev->pdata) {
>> +		/* each client will have different interface requirements */
>> +		if (!strcmp(subdev->name, "tvp5146")) {
>> +			struct tvp514x_platform_data *pdata = subdev->pdata;
>> +
>> +			if (pdata->hs_polarity)
>> +				vpfe_dev->vpfe_if_params.hdpol =
>> +					VPFE_PINPOL_POSITIVE;
>> +			else
>> +				vpfe_dev->vpfe_if_params.hdpol =
>> +					VPFE_PINPOL_NEGATIVE;
>> +
>> +			if (pdata->vs_polarity)
>> +				vpfe_dev->vpfe_if_params.vdpol =
>> +					VPFE_PINPOL_POSITIVE;
>> +			else
>> +				vpfe_dev->vpfe_if_params.hdpol =
>> +					VPFE_PINPOL_NEGATIVE;
>
>This won't work. Instead this should be data associated with the
>platform_data.
>I.e. the platform_data for the dm355/dm6446 contains not only the subdev
>information, but for each subdev also the information on how to setup the
>vpfe
>polarities. You cannot derive that information from what subdevs are used
>since
>the board designer might have added e.g. inverters or something like that.
>Such
>information can only come from the platform_data.
>
[MK] I know this code is not correct. But I was waiting for the discussion on my bus parameter patch to make this change. Currently TVP514x driver that you have reviewed configure output bus based on route->output parameter set by s_route(). This doesn't make sense. The input param make sense since application can choose between Composite and S-Video inputs. There is only one bus going out of the sub device to vpfe. So the output selection @ sub device is redundant. I think the output is part of as the bus parameter structure I added in the bus parameter patch which is under review. It can be read by TVP514x from the platform data (using the structure added by my patch) and can be overridden by s_bus(). Do you expect the bridge driver and sub devices having platform data for bus type (For example, BT.656)? It appears to be required only for sub device and bridge driver can configure the ccdc based on sub device bus type.  But for polarities I need to define them for both sides. comments?

>> +		} else {
>> +			v4l2_err(&vpfe_dev->v4l2_dev, "No interface params"
>> +				" defined for subdevice, %d\n", route->output);
>> +			return -EFAULT;
>> +		}
>> +	}
>> +	return ccdc_dev->hw_ops.set_hw_if_params(&vpfe_dev->vpfe_if_params);
>> +}
>> +
>> +/*
>> +
>> +	struct vpfe_fh *fh;
>> +
>> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_open\n");
>> +
>> +	if (!vpfe_dev->cfg->num_subdevs) {
>> +		v4l2_err(&vpfe_dev->v4l2_dev, "No decoder registered\n");
>> +		return -ENODEV;
>> +	}
>
>Why would this be an error? I might have an FPGA connected instead or some
>other non-i2c device that doesn't require any setup from this driver.
>
[MK] What you mean by this? Are you saying an FPGA logic will implement the decoder hardware? That is quite possible, so also it could be non-i2c. But my understanding was that sub device can be anything that basically implement the sub device API and need not always be an i2c device. So for FPGA or some other bus based device, the bridge device doesn't care how the command to change input, detect standard etc are communicated by the sub device driver to its hardware. It could be writing into some FPGA register or sending a proprietary protocol command. Is my understanding correct? In that case each of the above (FPGA or non-i2c) is a sub device and at least one sub device should be available before application can do any useful operation with the capture device. So the check is required. Am I missing something here?

>
>> +
>> +unlock_out:
>> +	mutex_unlock(&vpfe_dev->lock);
>> +	return ret;
>> +}
>> +
>> +
>> +static int vpfe_queryctrl(struct file *file, void *priv,
>> +				struct v4l2_queryctrl *qc)
>> +{
>> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
>> +	struct vpfe_subdev_info *sub_dev = vpfe_dev->current_subdev;
>> +
>> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_queryctrl\n");
>> +
>> +	if (qc->id >= V4L2_CID_PRIVATE_BASE) {
>> +		/* It is ccdc CID */
>> +		if (ccdc_dev->hw_ops.queryctrl)
>> +			return ccdc_dev->hw_ops.queryctrl(qc);
>> +	}
>> +	/* pass it to sub device */
>> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sub_dev-
>>grp_id,
>> +					  core, queryctrl, qc);
>> +}
>> +
>> +static int vpfe_g_ctrl(struct file *file, void *priv,
>> +			struct v4l2_control *ctrl)
>> +{
>> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
>> +	struct vpfe_subdev_info *sub_dev = vpfe_dev->current_subdev;
>> +
>> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_ctrl\n");
>> +
>> +	if (ctrl->id >= V4L2_CID_PRIVATE_BASE) {
>> +		/* It is ccdc CID */
>> +		if (ccdc_dev->hw_ops.get_control)
>> +			return ccdc_dev->hw_ops.get_control(ctrl);
>> +	}
>
>Don't use these PRIVATE_BASE controls. See also this post regarding
>the current situation regarding private controls:
>
>http://www.mail-archive.com/linux-omap%40vger.kernel.org/msg07999.html
>
[MK] Looks like it is better to add it to TBD and address it when I add camera interface support.
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

