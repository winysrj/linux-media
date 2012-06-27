Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:32124 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2F0K42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 06:56:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: About s_std_output
Date: Wed, 27 Jun 2012 12:56:15 +0200
Cc: LMML <linux-media@vger.kernel.org>
References: <CAHG8p1DaJPWwSxmMqk6Jkx8JO8m69OuTYpwHvhsB54e8RAMRVA@mail.gmail.com> <201206271155.17164.hverkuil@xs4all.nl> <CAHG8p1CM6JNRn4o+Zt2sauMZ0kVCq9UY7U8MYajnZQXpoe=b1w@mail.gmail.com>
In-Reply-To: <CAHG8p1CM6JNRn4o+Zt2sauMZ0kVCq9UY7U8MYajnZQXpoe=b1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206271256.15143.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 27 June 2012 12:14:34 Scott Jiang wrote:
> 2012/6/27 Hans Verkuil <hverkuil@xs4all.nl>:
> > On Wed 27 June 2012 11:37:24 Scott Jiang wrote:
> >> Hi Hans,
> >>
> >> I noticed there are two s_std ops in core and video for output. And
> >> some drivers call video->s_std_out and then core->s_std in their S_STD
> >> iotcl. Could anyone share me the story why we have
> >> s_std_output/g_std_output/g_tvnorms_output ops in video instead of
> >> making use of s_std/g_std in core?
> >
> > The core class is for common, often used ops. Setting the standard for
> > capture devices is very common, so it is in core. Setting the standard
> > for output devices is much less common (there aren't that many output
> > devices in the kernel), so that stayed in the video class.
> >
> My question is why we can't reuse s_std/g_std for output device. We
> use same VIDIOC_S_STD/VIDIOC_G_STD ioctl for both input and output.

Ah, no. There some drivers that can do both capture and display (ivtv in
particular). The capture and output part are independent and each have their
own video node. So there is no confusion about whether the VIDIOC_S_STD is
for capture or for output. But internally the S_STD ioctl is converted to a
s_std or s_std_output broadcast to all i2c devices using v4l2_device_call_all().

You don't want the s_std for the output to interfere with the s_std for
input i2c devices or vice versa, hence the separate s_std_output. Note that
this issue is specific to s_std. Many drivers need to broadcast an s_std to
all their i2c devices (the TV receiver, the tuner, the demodulator, possibly
audio demodulator devices as well). Depending on the PCI board these can
exists in various configurations. So you need the broadcast functionality,
and in that case you need to have separate s_std and s_std_output ops.

> 
> > It is a bit arbitrary and I am not sure whether I would make the same
> > choice now.
> >
> So I should ignore s_std/g_std  and use s_std_output/g_std_output in
> encoder driver, right?

Correct.

> 
> > There is no g_tvnorms_output, BTW.
> >
> It really exists.
> struct v4l2_subdev_video_ops {
>         int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32
> output, u32 config);
>         int (*s_crystal_freq)(struct v4l2_subdev *sd, u32 freq, u32 flags);
>         int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
>         int (*g_std_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
>         int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
>         int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
> 

Oops, you are correct. Hmm, odd that nobody needed a g_tvnorms for input.

Regards,

	Hans
