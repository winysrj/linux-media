Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39541 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZHLUbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 16:31:17 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 12 Aug 2009 15:31:11 -0500
Subject: RE: [PATCH v0 4/5] V4L: vpif_capture driver for DM6467
Message-ID: <A69FA2915331DC488A831521EAE36FE40145288A8A@dlee06.ent.ti.com>
References: <1249599957-21797-1-git-send-email-m-karicheri2@ti.com>
 <200908071008.51699.hverkuil@xs4all.nl>
In-Reply-To: <200908071008.51699.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Thanks for reviewing this. I have some questions though against your comments. Please see below for details..

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>First of all I've reviewed the other patches in this series and they look
>OK
>to me. So you can add
>Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>for patches 1, 2, 3 and 5.
>
Will do.

>> +	ret = vpif_check_format(ch, &common->fmt.fmt.pix, 0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Enable streamon on the sub device */
>> +	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev,
>> +					 vpif_obj.sd[ch->curr_sd_index]->grp_id,
>> +					 video, s_stream, 1);
>> +
>> +	if (ret && (ret != -ENOIOCTLCMD)) {
>> +		vpif_dbg(1, debug, "stream on failed in subdev\n");
>> +		return ret;
>> +	}
>
>I strongly recommend that instead of calling the subdev for the current
>input
>indirectly using v4l2_device_call_until_err() you use the v4l2_subdev
>pointer
>associated with the current input directly. So typically when the input is
>changed you update a ch->curr_sd pointer to the associated struct
>v4l2_subdev.
>
>After that you can just call v4l2_subdev_call(ch->sd, video, s_stream, 1).
>Much more concise.
>
>In addition the v4l2_device_call_until_err() macro will replace the
>ENOIOCTLCMD
>error by 0. The idea behind this macro is that you have an unknown number
>of
>subdevs (>= 0) that might be interested in this command, but if no one is,
>then
>that's fine too. So in the code above the extra check to see whether the
>return code was -ENOIOCTLCMD is not needed in the case of
>v4l2_device_call_until_err(). But it is needed if you switch to
>v4l2_subdev_call().
>
So in short what you are suggesting is to replace all instances of v4l2_device_call_until_err() with v4l2_subdev_call() since after input selection we know exactly which sub device to direct the application
request to.
>> +	.fops		= &vpif_fops,
>> +	.minor		= -1,
>> +	.ioctl_ops	= &vpif_ioctl_ops,
>> +	.current_norm	= V4L2_STD_625_50,
>
>No need to set current_norm since it's overridden by g_std.
>
You mean s_std() right?

>Note: I've just found a bug in the default handling of VIDIOC_G_PARM in
>v4l2-ioctl.c since that uses current_norm even when g_std is defined.
>I will make a fix for that. As a general remark I have to say that I
>never liked that v4l2-ioctl has default handling for g_std. It's a
>dangerous
>construction that will definitely fail whenever you have both video and vbi
>device nodes.
>
Ok. Understood.

So I will make the next set of patches with the changes suggested by you and It would be ready for merge to your tree as well as to v4l-dvb linux-next tree (through your pull request to Mauro)

Thanks and regards,

Murali
