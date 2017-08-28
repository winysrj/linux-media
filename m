Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38083 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751223AbdH1JhT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 05:37:19 -0400
Subject: Re: [PATCH v4 5/7] media: open.rst: Adjust some terms to match the
 glossary
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1503747774.git.mchehab@s-opensource.com>
 <74aaf6a89c1df7378c502318c94a4c58e83254b0.1503747774.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <278e346e-9bfe-fd51-8c36-5cce2181ff8f@xs4all.nl>
Date: Mon, 28 Aug 2017 11:37:16 +0200
MIME-Version: 1.0
In-Reply-To: <74aaf6a89c1df7378c502318c94a4c58e83254b0.1503747774.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/08/17 13:53, Mauro Carvalho Chehab wrote:
> As we now have a glossary, some terms used on open.rst
> require adjustments.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/media/uapi/v4l/open.rst | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index 51acb8de8ba8..64b1de047b1b 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -147,7 +147,7 @@ Related Devices
>  Devices can support several functions. For example video capturing, VBI
>  capturing and radio support.
>  
> -The V4L2 API creates different nodes for each of these functions.
> +The V4L2 API creates different V4L2 device nodes for each of these functions.
>  
>  The V4L2 API was designed with the idea that one device node could
>  support all functions. However, in practice this never worked: this
> @@ -157,17 +157,17 @@ switching a device node between different functions only works when
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
> 
