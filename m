Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1919 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0CHSC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Mar 2010 13:02:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: matti.j.aaltonen@nokia.com
Subject: Re: v4l2 subdevices and fops
Date: Mon, 8 Mar 2010 19:03:17 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1243448117.8697.790.camel@alkaloid.netup.ru> <4B84BA3A.3090809@redhat.com> <1268052265.27183.83.camel@masi.mnp.nokia.com>
In-Reply-To: <1268052265.27183.83.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003081903.17928.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 March 2010 13:44:25 m7aalton wrote:
> Hello.
> 
> I'm writing a radio driver which uses subdevice file operations to
> handle RDS reception and transmission. Some IOCTL call-backs to the main
> device are easy to pass to the subdevice driver. To me it seems that
> adding the fops pointer to the following struct in v4l2-subdev.h would
> make passing the file operation call-backs equally convenient.
> 
> struct v4l2_subdev_ops {
> 	const struct v4l2_subdev_core_ops  *core;
> 	const struct v4l2_subdev_tuner_ops *tuner;
> 	const struct v4l2_subdev_audio_ops *audio;
> 	const struct v4l2_subdev_video_ops *video;
> 	const struct v4l2_subdev_pad_ops   *pad;
> };
> 
> Could I expand the above struct in the way I described? Have I missed
> something? Do you understand what I'm saying? :-)

Yes, I understand :-)

It is possible to add rds ops. The question is whether it is used often enough
to warrant the addition of a new rds_ops struct. Until recently rds was a rare
beast to see inside a driver. If the rds ops are general enough to be used in
more than one subdev driver, then I think you should make a proposal. If the
rds ops are unique to your driver, though, then it should be done through
the core ops ioctl callback.

Regards,

	Hans

> 
> Cheers,
> Matti 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
