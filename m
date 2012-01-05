Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35463 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2AEDO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 22:14:57 -0500
Received: by vcbfk14 with SMTP id fk14so87343vcb.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 19:14:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNVYeeAfS+RycntPyz8nhLqow5CtCdwmxJpuHU6-6Kx8hQ@mail.gmail.com>
References: <CALzAhNVYeeAfS+RycntPyz8nhLqow5CtCdwmxJpuHU6-6Kx8hQ@mail.gmail.com>
Date: Thu, 5 Jan 2012 11:14:56 +0800
Message-ID: <CAHG8p1AkT2iU7_QXSy7OU+pdnft1ByzUDFTqiRm4QrviL=Cs_A@mail.gmail.com>
Subject: Re: subdev support for querying struct v4l2_input *
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: "Jacob Johan (Hans) Verkuil" <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/5 Steven Toth <stoth@kernellabs.com>:
> Hans,
>
> In the cx23885 driver as part of vidioc_enum_input call, I have a need
> to return V4L2_IN_ST_NO_SIGNAL in the status
> field as part of struct v4l2_input. Thus, when no signal is detected
> by the video decoder it can be signalled to the calling application.
>
v4l2_subdev_video_ops->g_input_status

Scott
