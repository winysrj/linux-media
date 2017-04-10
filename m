Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55027
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752173AbdDJKVp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 06:21:45 -0400
Date: Mon, 10 Apr 2017 07:21:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dev-capture.rst/dev-output.rst: video standards ioctls
 are optional
Message-ID: <20170410070940.7f55c1b1@vento.lan>
In-Reply-To: <8e21fc74-64a8-8767-8bcf-4b954d4e22c1@xs4all.nl>
References: <8e21fc74-64a8-8767-8bcf-4b954d4e22c1@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Mar 2017 09:56:47 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The documentation for video capture and output devices claims that the video standard
> ioctls are required. This is not the case, they are only required for PAL/NTSC/SECAM
> type inputs and outputs. Sensors do not implement this at all and e.g. HDMI inputs
> implement the DV Timings ioctls.
> 
> Just drop the mention of 'video standard' ioctls.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

This is an API change that has the potential of breaking userspace.

In the past, several applications were failing if VIDIOC_ENUMSTD ioctl is
not implemented. So, I remember we had this discussion before, but I don't
remember the dirty details anymore.

Yet, looking at the code, it seems that we ended by making VIDIOC_ENUMSTD
mandatory and implemented at the core. So, V4L2 core will make this
ioctl available for all drivers. The core implementattion will, however, 
return -ENODATA  if the driver doesn't set video_device.tvnorms, indicating
that standard video timings are not supported.

So, instead of the enclosed patch, the documentation should mention the
standard ioctls, saying that G_STD/S_STD are optional, and ENUMSTD is
mandatory. 

We could include a note about it may return -ENODATA, although the ENUMSTD
documentation already states that it returns -ENODATA:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-enumstd.html

Regards,
Mauro

> ---
> diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
> index 32b32055d070..4218742ab5d9 100644
> --- a/Documentation/media/uapi/v4l/dev-capture.rst
> +++ b/Documentation/media/uapi/v4l/dev-capture.rst
> @@ -42,8 +42,8 @@ Video capture devices shall support :ref:`audio input <audio>`,
>  :ref:`tuner`, :ref:`controls <control>`,
>  :ref:`cropping and scaling <crop>` and
>  :ref:`streaming parameter <streaming-par>` ioctls as needed. The
> -:ref:`video input <video>` and :ref:`video standard <standard>`
> -ioctls must be supported by all video capture devices.
> +:ref:`video input <video>` ioctls must be supported by all video
> +capture devices.
> 
> 
>  Image Format Negotiation
> diff --git a/Documentation/media/uapi/v4l/dev-output.rst b/Documentation/media/uapi/v4l/dev-output.rst
> index 25ae8ec96fdf..342eb4931f5c 100644
> --- a/Documentation/media/uapi/v4l/dev-output.rst
> +++ b/Documentation/media/uapi/v4l/dev-output.rst
> @@ -40,8 +40,8 @@ Video output devices shall support :ref:`audio output <audio>`,
>  :ref:`modulator <tuner>`, :ref:`controls <control>`,
>  :ref:`cropping and scaling <crop>` and
>  :ref:`streaming parameter <streaming-par>` ioctls as needed. The
> -:ref:`video output <video>` and :ref:`video standard <standard>`
> -ioctls must be supported by all video output devices.
> +:ref:`video output <video>` ioctls must be supported by all video
> +output devices.
> 
> 
>  Image Format Negotiation



Thanks,
Mauro
