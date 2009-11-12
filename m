Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3391 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZKLGS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 01:18:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH] V4L: adding digital video timings APIs
Date: Thu, 12 Nov 2009 07:18:26 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1256164939-21803-1-git-send-email-m-karicheri2@ti.com> <200911051356.29540.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40155936998@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155936998@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911120718.26622.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 11 November 2009 22:45:15 Karicheri, Muralidharan wrote:
> Hans,
> 
> >> [MK] Could you explain this to me? In my prototype, I had tvp5146 that
> >> implements S_STD and tvp7002 that implements S_PRESET. Since bridge
> >driver
> >> has all the knowledge about the sub devices and their capabilities, it
> >can
> >> set the flag for each of the input that it supports (currently I am
> >> setting this flag in the board setup file that describes all the inputs
> >using v4l2_input structure). So it is a matter of setting relevant cap flag
> >in this file for each of the input based on what the sub device supports. I
> >am not sure how core can figure this out?
> >
> >The problem is that we don't want to go through all drivers in order to set
> >the input/output capability flags. However, v4l2_ioctl.c can easily check
> >whether the v4l2_ioctl_ops struct has set vidioc_s_std, vidioc_s_dv_preset
> >and/or vidioc_s_dv_timings and fill in the caps accordingly. If this is
> >done
> >before the vidioc_enum_input/output is called, then the driver can override
> >what v4l2_ioctl.c did if that is needed.
> >
> 
> Why do we need to do that? Why not leave it to the bridge driver to set that
> flag since it knows all encoder/decoder connected to it and whether current encoder/decoder has support for S_STD or S_PRESET looking at the sub dev ops.
> If we set them at the core, as you explained, then bridge driver needs to
> override it. That is not clean IMO.

Actually, the bridge driver only needs to override if it has multiple inputs
where the capability flags differ (i.e. some inputs only support S_STD and
others only support S_DV_PRESET).

In all other cases the core will fill it in correctly.

Doing it in the core ensures that the capability flags will be filled in so
drivers don't need to remember doing this. The alternative is that you have to
go through ALL existing drivers and add the new SUPPORTS_STD capability flag.

But even then I am pretty certain that people will forget to set this flag
for new upcoming drivers.

So I prefer to have this set in the core and only drivers that have mixed
inputs/outputs need to do a bit more work.

Regards,

	Hans

> 
> Murali
> 
> >Regards,
> >
> >	Hans
> >
> >--
> >Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
