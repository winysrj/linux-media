Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3741 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbZHLUkL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 16:40:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH v0 4/5] V4L: vpif_capture driver for DM6467
Date: Wed, 12 Aug 2009 22:40:08 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1249599957-21797-1-git-send-email-m-karicheri2@ti.com> <200908071008.51699.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40145288A8A@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40145288A8A@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908122240.08057.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 12 August 2009 22:31:11 Karicheri, Muralidharan wrote:
> Hans,
> 
> Thanks for reviewing this. I have some questions though against your comments. Please see below for details..
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
> 
> >First of all I've reviewed the other patches in this series and they look
> >OK
> >to me. So you can add
> >Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> >for patches 1, 2, 3 and 5.
> >
> Will do.
> 
> >> +	ret = vpif_check_format(ch, &common->fmt.fmt.pix, 0);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	/* Enable streamon on the sub device */
> >> +	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev,
> >> +					 vpif_obj.sd[ch->curr_sd_index]->grp_id,
> >> +					 video, s_stream, 1);
> >> +
> >> +	if (ret && (ret != -ENOIOCTLCMD)) {
> >> +		vpif_dbg(1, debug, "stream on failed in subdev\n");
> >> +		return ret;
> >> +	}
> >
> >I strongly recommend that instead of calling the subdev for the current
> >input
> >indirectly using v4l2_device_call_until_err() you use the v4l2_subdev
> >pointer
> >associated with the current input directly. So typically when the input is
> >changed you update a ch->curr_sd pointer to the associated struct
> >v4l2_subdev.
> >
> >After that you can just call v4l2_subdev_call(ch->sd, video, s_stream, 1).
> >Much more concise.
> >
> >In addition the v4l2_device_call_until_err() macro will replace the
> >ENOIOCTLCMD
> >error by 0. The idea behind this macro is that you have an unknown number
> >of
> >subdevs (>= 0) that might be interested in this command, but if no one is,
> >then
> >that's fine too. So in the code above the extra check to see whether the
> >return code was -ENOIOCTLCMD is not needed in the case of
> >v4l2_device_call_until_err(). But it is needed if you switch to
> >v4l2_subdev_call().
> >
> So in short what you are suggesting is to replace all instances of v4l2_device_call_until_err() with v4l2_subdev_call() since after input selection we know exactly which sub device to direct the application
> request to.

Yes. I think that is the best approach here.

> >> +	.fops		= &vpif_fops,
> >> +	.minor		= -1,
> >> +	.ioctl_ops	= &vpif_ioctl_ops,
> >> +	.current_norm	= V4L2_STD_625_50,
> >
> >No need to set current_norm since it's overridden by g_std.
> >
> You mean s_std() right?

Hmm, that was a bad sentence of mine. What I meant is that if you define the
g_std function, then the current_norm will not be used by the v4l2-ioctl code.
If you do not give it a g_std function, then the v4l2-ioctl code will return
current_norm instead. So you either have a g_std function and do not setup
current_norm, or you use current_norm and omit g_std.

Personally I think that current_norm handling only confuses people and all
drivers should just make a g_std function.

> 
> >Note: I've just found a bug in the default handling of VIDIOC_G_PARM in
> >v4l2-ioctl.c since that uses current_norm even when g_std is defined.
> >I will make a fix for that. As a general remark I have to say that I
> >never liked that v4l2-ioctl has default handling for g_std. It's a
> >dangerous
> >construction that will definitely fail whenever you have both video and vbi
> >device nodes.
> >
> Ok. Understood.
> 
> So I will make the next set of patches with the changes suggested by you and It would be ready for merge to your tree as well as to v4l-dvb linux-next tree (through your pull request to Mauro)

Excellent news!

Regards,

	Hans

> 
> Thanks and regards,
> 
> Murali
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
