Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63061 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2AEMaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 07:30:52 -0500
Received: by werm1 with SMTP id m1so316367wer.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 04:30:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHG8p1AkT2iU7_QXSy7OU+pdnft1ByzUDFTqiRm4QrviL=Cs_A@mail.gmail.com>
References: <CALzAhNVYeeAfS+RycntPyz8nhLqow5CtCdwmxJpuHU6-6Kx8hQ@mail.gmail.com>
	<CAHG8p1AkT2iU7_QXSy7OU+pdnft1ByzUDFTqiRm4QrviL=Cs_A@mail.gmail.com>
Date: Thu, 5 Jan 2012 07:30:50 -0500
Message-ID: <CALzAhNWMzmU4wjb8d3vofLiuKHJeh8iWQemphPQycZB92Nu=Sg@mail.gmail.com>
Subject: Re: subdev support for querying struct v4l2_input *
From: Steven Toth <stoth@kernellabs.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: "Jacob Johan (Hans) Verkuil" <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> In the cx23885 driver as part of vidioc_enum_input call, I have a need
>> to return V4L2_IN_ST_NO_SIGNAL in the status
>> field as part of struct v4l2_input. Thus, when no signal is detected
>> by the video decoder it can be signalled to the calling application.
>>
> v4l2_subdev_video_ops->g_input_status

I'm blind.

That will work, thanks Scott.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
