Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:33858 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0CIIio (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 03:38:44 -0500
Subject: Re: v4l2 subdevices and fops
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <201003081903.17928.hverkuil@xs4all.nl>
References: <1243448117.8697.790.camel@alkaloid.netup.ru>
	 <4B84BA3A.3090809@redhat.com>
	 <1268052265.27183.83.camel@masi.mnp.nokia.com>
	 <201003081903.17928.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 10:38:30 +0200
Message-ID: <1268123910.27183.89.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

On Mon, 2010-03-08 at 19:03 +0100, ext Hans Verkuil wrote:
> On Monday 08 March 2010 13:44:25 m7aalton wrote:
> > Hello.
> > 
> > I'm writing a radio driver which uses subdevice file operations to
> > handle RDS reception and transmission. Some IOCTL call-backs to the main
> > device are easy to pass to the subdevice driver. To me it seems that
> > adding the fops pointer to the following struct in v4l2-subdev.h would
> > make passing the file operation call-backs equally convenient.
> > 
> > struct v4l2_subdev_ops {
> > 	const struct v4l2_subdev_core_ops  *core;
> > 	const struct v4l2_subdev_tuner_ops *tuner;
> > 	const struct v4l2_subdev_audio_ops *audio;
> > 	const struct v4l2_subdev_video_ops *video;
> > 	const struct v4l2_subdev_pad_ops   *pad;
> > };
> > 
> > Could I expand the above struct in the way I described? Have I missed
> > something? Do you understand what I'm saying? :-)
> 
> Yes, I understand :-)
> 
> It is possible to add rds ops. The question is whether it is used often enough
> to warrant the addition of a new rds_ops struct. Until recently rds was a rare
> beast to see inside a driver. If the rds ops are general enough to be used in
> more than one subdev driver, then I think you should make a proposal. If the
> rds ops are unique to your driver, though, then it should be done through
> the core ops ioctl callback.

I mean file operation like open, close, read and write, which should be
general enough. Our driver just passes through the RDS data... But it's
probably best if we send the patches to this list so that everyone can
comment. It may need a couple of iterations before it gets accepted.

Thanks,

Matti

> Regards,
> 
> 	Hans
> 
> > 
> > Cheers,
> > Matti 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 


