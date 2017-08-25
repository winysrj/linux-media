Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55855 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932649AbdHYNbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 09:31:32 -0400
Subject: Re: [PATCH v2 1/3] media: open.rst: better document device node
 naming
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1503665390.git.mchehab@s-opensource.com>
 <65c6702e967614245c261b54d9f3fb0e69ec93d0.1503665390.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1c670bfe-aedf-3b3a-5fe6-ed224fd85496@xs4all.nl>
Date: Fri, 25 Aug 2017 15:31:27 +0200
MIME-Version: 1.0
In-Reply-To: <65c6702e967614245c261b54d9f3fb0e69ec93d0.1503665390.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/08/17 14:52, Mauro Carvalho Chehab wrote:
> Right now, only kAPI documentation describes the device naming.
> However, such description is needed at the uAPI too. Add it,
> and describe how to get an unique identify for a given device.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 40 ++++++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index afd116edb40d..9b98d10d5153 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -7,12 +7,12 @@ Opening and Closing Devices
>  ***************************
>  
>  
> -Device Naming
> -=============
> +V4L2 Device Node Naming
> +=======================
>  
>  V4L2 drivers are implemented as kernel modules, loaded manually by the
>  system administrator or automatically when a device is first discovered.
> -The driver modules plug into the "videodev" kernel module. It provides
> +The driver modules plug into the ``videodev`` kernel module. It provides
>  helper functions and a common application interface specified in this
>  document.
>  
> @@ -20,8 +20,38 @@ Each driver thus loaded registers one or more device nodes with major
>  number 81 and a minor number between 0 and 255. Minor numbers are
>  allocated dynamically unless the kernel is compiled with the kernel
>  option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers
> -are allocated in ranges depending on the device node type (video, radio,
> -etc.).
> +are allocated in ranges depending on the device node type.
> +
> +The existing V4L2 device node types are:
> +
> +======================== ======================================================
> +Default device node name Usage
> +======================== ======================================================
> +``/dev/videoX``		 Video input/output devices
> +``/dev/vbiX``		 Vertical blank data (i.e. closed captions, teletext)
> +``/dev/radioX``		 Radio tuners

add: and modulators.

> +``/dev/swradioX``	 Software Defined Radio tuners

Ditto.

> +``/dev/v4l-touchX``	 Touch sensors
> +======================== ======================================================
> +
> +Where ``X`` is a non-negative number.
> +
> +.. note::
> +
> +   1. The actual device node name is system-dependent, as udev rules may apply.
> +   2. There's not warranty that ``X`` will remain the same for the same

"There is no"

> +      device, as the number depends on the device driver's probe order.
> +      If you need an unique name, udev default rules produce
> +      ``/dev/v4l/by-id/`` and ``/dev/v4l/by-path/`` that can use to uniquelly

      ``/dev/v4l/by-id/`` and ``/dev/v4l/by-path/`` directories containing links
	that be can used to uniquely

> +      identify a V4L2 device node::
> +
> +	$ tree /dev/v4l
> +	/dev/v4l
> +	├── by-id
> +	│   └── usb-OmniVision._USB_Camera-B4.04.27.1-video-index0 -> ../../video0
> +	└── by-path
> +	    └── pci-0000:00:14.0-usb-0:2:1.0-video-index0 -> ../../video0
> +
>  
>  Many drivers support "video_nr", "radio_nr" or "vbi_nr" module
>  options to select specific video/radio/vbi node numbers. This allows the
> 

With these changes:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans
