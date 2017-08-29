Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49202 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750758AbdH2IeK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 04:34:10 -0400
Date: Tue, 29 Aug 2017 11:34:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v5 2/7] media: open.rst: better document device node
 naming
Message-ID: <20170829083406.c3lkpaj33ybngvil@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
 <f63c7412638307f3f58dc114b64339755741feb6.1503924361.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f63c7412638307f3f58dc114b64339755741feb6.1503924361.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Aug 28, 2017 at 09:53:56AM -0300, Mauro Carvalho Chehab wrote:
> Right now, only kAPI documentation describes the device naming.
> However, such description is needed at the uAPI too. Add it,
> and describe how to get an unique identify for a given device.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 39 ++++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index afd116edb40d..fc0037091814 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -7,12 +7,14 @@ Opening and Closing Devices
>  ***************************
>  
>  
> -Device Naming
> -=============
> +.. _v4l2_device_naming:
> +
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
> @@ -23,6 +25,37 @@ option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers
>  are allocated in ranges depending on the device node type (video, radio,
>  etc.).
>  
> +The existing V4L2 device node types are:
> +
> +======================== ======================================================
> +Default device node name Usage
> +======================== ======================================================
> +``/dev/videoX``		 Video input/output devices
> +``/dev/vbiX``		 Vertical blank data (i.e. closed captions, teletext)
> +``/dev/radioX``		 Radio tuners and modulators
> +``/dev/swradioX``	 Software Defined Radio tuners and modulators
> +``/dev/v4l-touchX``	 Touch sensors

Should we document V4L2 sub-device nodes here as well? They are implemented
by the V4L2 core as well as the other device node types.

Their purpose is somewhat different, though, and I think we'll need to make
that explicit somehow.

> +======================== ======================================================
> +
> +Where ``X`` is a non-negative number.
> +
> +.. note::
> +
> +   1. The actual device node name is system-dependent, as udev rules may apply.
> +   2. There is no warranty that ``X`` will remain the same for the same

s/warranty/guarantee/

> +      device, as the number depends on the device driver's probe order.
> +      If you need an unique name, udev default rules produce
> +      ``/dev/v4l/by-id/`` and ``/dev/v4l/by-path/`` directoiries containing

"directories"

> +      links that can be used uniquely to identify a V4L2 device node::
> +
> +	$ tree /dev/v4l
> +	/dev/v4l
> +	├── by-id
> +	│   └── usb-OmniVision._USB_Camera-B4.04.27.1-video-index0 -> ../../video0
> +	└── by-path
> +	    └── pci-0000:00:14.0-usb-0:2:1.0-video-index0 -> ../../video0
> +
> +
>  Many drivers support "video_nr", "radio_nr" or "vbi_nr" module
>  options to select specific video/radio/vbi node numbers. This allows the
>  user to request that the device node is named e.g. /dev/video5 instead

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
