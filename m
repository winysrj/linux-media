Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48652 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751151AbeBIMVN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 07:21:13 -0500
Date: Fri, 9 Feb 2018 14:21:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 13/15] media: document and zero reservedX fields in
 media_v2_topology
Message-ID: <20180209122110.ohf2ahn4w2hazg2w@valkosipuli.retiisi.org.uk>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-14-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208083655.32248-14-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Feb 08, 2018 at 09:36:53AM +0100, Hans Verkuil wrote:
> The MEDIA_IOC_G_TOPOLOGY documentation didn't document the reservedX fields.
> Related to that was that the documented type of the num_* fields was also
> wrong.
> 
> The reservedX fields were not set to 0, that is now also fixed.
> 
> Found with v4l2-compliance.

How about splitting the patch between documentation and code? The two are
largely unrelated, and there could be a need to backport the patch zeroing
the fields (but not necessarily the documentation).

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../media/uapi/mediactl/media-ioc-g-topology.rst   | 52 +++++++++++++++++-----
>  drivers/media/media-device.c                       |  4 ++
>  2 files changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> index 870a6c0d1f7a..c8f9ea37db2d 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> @@ -68,7 +68,7 @@ desired arrays with the media graph elements.
>  
>      -  .. row 2
>  
> -       -  __u64
> +       -  __u32
>  
>         -  ``num_entities``
>  
> @@ -76,6 +76,14 @@ desired arrays with the media graph elements.
>  
>      -  .. row 3
>  
> +       -  __u32
> +
> +       -  ``reserved1``
> +
> +       -  Applications and drivers shall set this to 0.
> +
> +    -  .. row 4
> +
>         -  __u64
>  
>         -  ``ptr_entities``
> @@ -85,15 +93,23 @@ desired arrays with the media graph elements.
>  	  the ioctl won't store the entities. It will just update
>  	  ``num_entities``
>  
> -    -  .. row 4
> +    -  .. row 5
>  
> -       -  __u64
> +       -  __u32
>  
>         -  ``num_interfaces``
>  
>         -  Number of interfaces in the graph
>  
> -    -  .. row 5
> +    -  .. row 6
> +
> +       -  __u32
> +
> +       -  ``reserved2``
> +
> +       -  Applications and drivers shall set this to 0.
> +
> +    -  .. row 7
>  
>         -  __u64
>  
> @@ -104,15 +120,23 @@ desired arrays with the media graph elements.
>  	  the ioctl won't store the interfaces. It will just update
>  	  ``num_interfaces``
>  
> -    -  .. row 6
> +    -  .. row 8
>  
> -       -  __u64
> +       -  __u32
>  
>         -  ``num_pads``
>  
>         -  Total number of pads in the graph
>  
> -    -  .. row 7
> +    -  .. row 9
> +
> +       -  __u32
> +
> +       -  ``reserved3``
> +
> +       -  Applications and drivers shall set this to 0.
> +
> +    -  .. row 10
>  
>         -  __u64
>  
> @@ -122,15 +146,23 @@ desired arrays with the media graph elements.
>  	  converted to a 64-bits integer. It can be zero. if zero, the ioctl
>  	  won't store the pads. It will just update ``num_pads``
>  
> -    -  .. row 8
> +    -  .. row 11
>  
> -       -  __u64
> +       -  __u32
>  
>         -  ``num_links``
>  
>         -  Total number of data and interface links in the graph
>  
> -    -  .. row 9
> +    -  .. row 12
> +
> +       -  __u32
> +
> +       -  ``reserved4``
> +
> +       -  Applications and drivers shall set this to 0.
> +
> +    -  .. row 13
>  
>         -  __u64
>  
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index afbf23a19e16..d0e3f61dde52 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -265,6 +265,7 @@ static long media_device_get_topology(struct media_device *mdev,
>  		uentity++;
>  	}
>  	topo->num_entities = i;
> +	topo->reserved1 = 0;
>  
>  	/* Get interfaces and number of interfaces */
>  	i = 0;
> @@ -300,6 +301,7 @@ static long media_device_get_topology(struct media_device *mdev,
>  		uintf++;
>  	}
>  	topo->num_interfaces = i;
> +	topo->reserved2 = 0;
>  
>  	/* Get pads and number of pads */
>  	i = 0;
> @@ -326,6 +328,7 @@ static long media_device_get_topology(struct media_device *mdev,
>  		upad++;
>  	}
>  	topo->num_pads = i;
> +	topo->reserved3 = 0;
>  
>  	/* Get links and number of links */
>  	i = 0;
> @@ -357,6 +360,7 @@ static long media_device_get_topology(struct media_device *mdev,
>  		ulink++;
>  	}
>  	topo->num_links = i;
> +	topo->reserved4 = 0;
>  
>  	return ret;
>  }
> -- 
> 2.15.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
