Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:56373 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755434AbdJJICd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:02:33 -0400
Subject: Re: [PATCH v7 7/7] media: open.rst: add a notice about subdev-API on
 vdev-centric
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <628a25e694c33ab6dd1ea061bc4d766ec4fe30ef.1506550930.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5d748df3-3a0b-d62b-1fe3-3c018d8a1d6e@xs4all.nl>
Date: Tue, 10 Oct 2017 10:02:28 +0200
MIME-Version: 1.0
In-Reply-To: <628a25e694c33ab6dd1ea061bc4d766ec4fe30ef.1506550930.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2017 12:23 AM, Mauro Carvalho Chehab wrote:
> The documentation doesn't mention if vdev-centric hardware
> control would have subdev API or not.
> 
> Add a notice about that, reflecting the current status, where
> three drivers use it, in order to support some subdev-specific
> controls.

Just to note that there is a pull request pending from me that
removes this from the cobalt driver. So once that's merged there
are only two drivers that do this.

Anyway:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index 75ccc9d6614d..ed011ed123cc 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -47,6 +47,13 @@ the periferal can be used. For such devices, the sub-devices' configuration
>  can be controlled via the :ref:`sub-device API <subdev>`, which creates one
>  device node per sub-device.
>  
> +.. note::
> +
> +   A **vdevnode-centric** may also optionally expose V4L2 sub-devices via
> +   :ref:`sub-device API <subdev>`. In that case, it has to implement
> +   the :ref:`media controller API <media_controller>` as well.
> +
> +
>  .. attention::
>  
>     Devices that require **MC-centric** media hardware control should
> 
