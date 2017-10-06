Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34020 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751807AbdJFMsZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 08:48:25 -0400
Date: Fri, 6 Oct 2017 15:48:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 5/7] media: open.rst: Adjust some terms to match the
 glossary
Message-ID: <20171006124822.xjppck3ks4as3zqf@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <9a2db3c52a3d894728d6ed29681f49e8745f98a9.1506550930.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a2db3c52a3d894728d6ed29681f49e8745f98a9.1506550930.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Sep 27, 2017 at 07:23:47PM -0300, Mauro Carvalho Chehab wrote:
> As we now have a glossary, some terms used on open.rst
> require adjustments.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index f603bc9b49a0..0daf0c122c19 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -143,7 +143,7 @@ Related Devices
>  Devices can support several functions. For example video capturing, VBI
>  capturing and radio support.
>  
> -The V4L2 API creates different nodes for each of these functions.
> +The V4L2 API creates different V4L2 device nodes for each of these functions.

A V4L2 device node is an instance of the V4L2 API. At the very least we
should call them "V4L2 device node types", not device nodes only. This
simply would suggests they're separate.

s/creates/defines/ ?

>  
>  The V4L2 API was designed with the idea that one device node could
>  support all functions. However, in practice this never worked: this
> @@ -153,17 +153,17 @@ switching a device node between different functions only works when
>  using the streaming I/O API, not with the
>  :ref:`read() <func-read>`/\ :ref:`write() <func-write>` API.
>  
> -Today each device node supports just one function.
> +Today each V4L2 device node supports just one function.
>  
>  Besides video input or output the hardware may also support audio
>  sampling or playback. If so, these functions are implemented as ALSA PCM
>  devices with optional ALSA audio mixer devices.
>  
>  One problem with all these devices is that the V4L2 API makes no
> -provisions to find these related devices. Some really complex devices
> -use the Media Controller (see :ref:`media_controller`) which can be
> -used for this purpose. But most drivers do not use it, and while some
> -code exists that uses sysfs to discover related devices (see
> +provisions to find these related V4L2 device nodes. Some really complex
> +hardware use the Media Controller (see :ref:`media_controller`) which can
> +be used for this purpose. But several drivers do not use it, and while some
> +code exists that uses sysfs to discover related V4L2 device nodes (see
>  libmedia_dev in the
>  `v4l-utils <http://git.linuxtv.org/cgit.cgi/v4l-utils.git/>`__ git
>  repository), there is no library yet that can provide a single API

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
