Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932896AbeF2JyT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 05:54:19 -0400
Date: Fri, 29 Jun 2018 06:54:15 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 02/10] media-ioc-g-topology.rst: document new 'index'
 field
Message-ID: <20180629065415.2f0d7ec4@coco.lan>
In-Reply-To: <20180628131208.28009-3-hverkuil@xs4all.nl>
References: <20180628131208.28009-1-hverkuil@xs4all.nl>
        <20180628131208.28009-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Jun 2018 15:12:00 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the new struct media_v2_pad 'index' field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../media/uapi/mediactl/media-ioc-g-topology.rst      | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> index a3f259f83b25..24ab34b22df2 100644
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
> @@ -218,7 +218,14 @@ desired arrays with the media graph elements.
>         -  Pad flags, see :ref:`media-pad-flag` for more details.
>  
>      *  -  __u32
> -       -  ``reserved``\ [5]
> +       -  ``index``
> +       -  0-based pad index. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
> +	  returns true. The ``media_version`` is defined in struct
> +	  :c:type:`media_device_info` and can be retrieved using
> +	  :ref:`MEDIA_IOC_DEVICE_INFO`.

"0-based pad index"...

what you mean by that? If what you want to say is that it starts
with zero, I would use a clearer text, like:

"Pad index, starting from zero."

It is probably worth saying that the pad index could vary on newer
versions of the Kernel.

> +
> +    *  -  __u32
> +       -  ``reserved``\ [4]
>         -  Reserved for future extensions. Drivers and applications must set
>  	  this array to zero.
>  



Thanks,
Mauro
