Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35823 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbbGQHpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 03:45:16 -0400
Received: by lblf12 with SMTP id f12so56750313lbl.2
        for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 00:45:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150717071354.GO3709@valkosipuli.retiisi.org.uk>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
 <1434127598-11719-3-git-send-email-ricardo.ribalda@gmail.com> <20150717071354.GO3709@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 17 Jul 2015 09:44:54 +0200
Message-ID: <CAPybu_3ihYfTXnFRVLtdx9SV9HqZdm4xR8JiUkfV6Y4bQvFyqQ@mail.gmail.com>
Subject: Re: [RFC v3 02/19] media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

Thanks for your review!

On Fri, Jul 17, 2015 at 9:13 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

>>  #define VIDIOC_QUERY_EXT_CTRL        _IOWR('V', 103, struct v4l2_query_ext_ctrl)
>> +#define VIDIOC_G_DEF_EXT_CTRLS       _IOWR('V', 104, struct v4l2_ext_controls)
>
> I assume that if an application uses pointer controls, then it'd obtain the
> default values using VIDIOC_G_DEF_EXT_CTRLS. This suggests all drivers
> should support this from the very beginning, and the application would not
> work on older kernels that don't have the IOCTL implemented.

This patchset add supports for the Ioctl for all the in-tree drivers.
out of tree drivers that use v4l2-ctrl will also work, so we are only
leaving behind out out tree drivers that dont use v4l2-ctrl.
Applications will neither not in old kernels if we do an
implementation with VIDIOC_QUERY_EXT_CTRL.


>
> Instead of adding a new IOCTL, have you thought about the possibility of
> doing this through VIDIOC_QUERY_EXT_CTRL? That's how the default control
> value is passed to the user now, and I think it'd look odd to add a new
> IOCTL for just that purpose.
>
> One option could be making the default_value field a union such as the one
> in struct v4l2_ext_control. If the control type is such that the value is
> stored in the memory, one of the pointer fields of the union is used
> instead.
>
> As the user cannot be expected to know the size beforehand, the pointer
> value may only be used if it's non-zero. This might require a new field
> rather than making default_value a union for backward compatibility, as the
> documentation does not instruct the user to zero the default_value field.
>
> What do you think?
>
> The result would be no added redundancy, and less driver modifications, as
> the drivers also don't need to support multiple interfaces for passing
> control default values.

Although this also a valid option, the implementation by userland can
be a bit tricky, I dont like the idea of passing a pointer to the
kernel without telling it how much memory it has available for
writing.

There is also the problem of legacy applications that do not memset to
zero the reserved fields.... Those application may crash quite badly
if we change
VIDIOC_QUERY_EXT_CTRL the way you suggests

Finally, it is difficult for the user to know if the driver supports
this extra functionality on the ioctl before hand. On my
implementataion -ENOTTY is a pretty good indication of what is the
problem.


Best regards!


-- 
Ricardo Ribalda
