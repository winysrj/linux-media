Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56168 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729670AbeGMPim (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 11:38:42 -0400
Date: Fri, 13 Jul 2018 12:23:34 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv6 02/12] media-ioc-g-topology.rst: document new 'index'
 field
Message-ID: <20180713122334.68661b55@coco.lan>
In-Reply-To: <20180710084512.99238-3-hverkuil@xs4all.nl>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
        <20180710084512.99238-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Jul 2018 10:45:02 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

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
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> index a3f259f83b25..bae2b4db89cc 100644
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
> +       -  Pad index, starts at 0. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
> +	  returns true. The ``media_version`` is defined in struct
> +	  :c:type:`media_device_info` and can be retrieved using
> +	  :ref:`MEDIA_IOC_DEVICE_INFO`. Pad indices are stable. If new pads are added
> +	  for an entity in the future, then those will be added at the end.

Hmm... Pad indexes may not be stable. That's by the way why we
need a better way to enum it, and the Properties API was thinking
to solve (and why we didn't add PAD index to this ioctl at the
first place). 

The problem happens for example on TV demods and tuners:
different models may have different kinds of output PADs:

	- analog luminance carrier samples;
	- analog chrominance sub-carrier samples;
	- sliced VBI data;
	- audio RF sub-carrier samples;
	- audio mono data;
	- audio stereo data.

The same bridge chip can live with different demods, but need to
setup the pipelines according with the type of the PAD. As right now
we don't have any way to associate a PAD with an specific type of
output, what happens is that the V4L2 core associates a pad number
with an specific type of output. So, drivers may be exposing
PADs that don't exist, in practice, just to make them compatible
with similar subdevs.

Once we add a properties API (or something equivalent), the
PAD numbers will change and subdevs will only expose the ones
that really exists.

Thanks,
Mauro
