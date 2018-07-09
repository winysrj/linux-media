Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34808 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754492AbeGIM4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 08:56:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 02/12] media-ioc-g-topology.rst: document new 'index' field
Date: Mon, 09 Jul 2018 15:57:08 +0300
Message-ID: <7583578.SNIIlXvzgM@avalon>
In-Reply-To: <20180629114331.7617-3-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday, 29 June 2018 14:43:21 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the new struct media_v2_pad 'index' field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../media/uapi/mediactl/media-ioc-g-topology.rst     | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst index
> a3f259f83b25..bae2b4db89cc 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> @@ -176,7 +176,7 @@ desired arrays with the media graph elements.
>      *  -  struct media_v2_intf_devnode
>         -  ``devnode``
>         -  Used only for device node interfaces. See
> -	  :c:type:`media_v2_intf_devnode` for details..
> +	  :c:type:`media_v2_intf_devnode` for details.
> 
> 
>  .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
> @@ -218,7 +218,15 @@ desired arrays with the media graph elements.
>         -  Pad flags, see :ref:`media-pad-flag` for more details.
> 
>      *  -  __u32
> -       -  ``reserved``\ [5]
> +       -  ``index``
> +       -  Pad index, starts at 0. Only valid if
> ``MEDIA_V2_PAD_HAS_INDEX(media_version)`` +	  returns true. The
> ``media_version`` is defined in struct
> +	  :c:type:`media_device_info` and can be retrieved using
> +	  :ref:`MEDIA_IOC_DEVICE_INFO`. Pad indices are stable. If new pads are
> added
> +	  for an entity in the future, then those will be added at the end.

Same comment as for 01/12, I don't think we need to care about backward 
compatibility as this API clearly could not have been used by application. 
Apart from that the documentation update looks good to me.

> +    *  -  __u32
> +       -  ``reserved``\ [4]
>         -  Reserved for future extensions. Drivers and applications must set
> this array to zero.

-- 
Regards,

Laurent Pinchart
