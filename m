Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34990 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754490AbeGINMY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 09:12:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv5 12/12] media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name usage
Date: Mon, 09 Jul 2018 16:12:57 +0300
Message-ID: <1910449.xYJzjsU7bm@avalon>
In-Reply-To: <20180629114331.7617-13-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-13-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday, 29 June 2018 14:43:31 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> Mention that IDs should not be hardcoded in applications and that the
> entity name must be unique within the media topology.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  .../uapi/mediactl/media-ioc-enum-entities.rst |  9 +++++---
>  .../uapi/mediactl/media-ioc-g-topology.rst    | 22 ++++++++++++++-----
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
> b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst index
> 961466ae821d..a4aa7deef690 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
> @@ -62,15 +62,18 @@ id's until they get an error.
>         -  ``id``
>         -
>         -
> -       -  Entity id, set by the application. When the id is or'ed with
> +       -  Entity id, set by the application. When the ID is or'ed with

Should you also s/Entity id/Entity ID/ for consistency ?

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	  ``MEDIA_ENT_ID_FLAG_NEXT``, the driver clears the flag and returns
> -	  the first entity with a larger id.
> +	  the first entity with a larger ID. Do not expect that the ID will
> +	  always be the same for each instance of the device. In other words,
> +	  do not hardcode entity IDs in an application.
> 
>      *  -  char
>         -  ``name``\ [32]
>         -
>         -
> -       -  Entity name as an UTF-8 NULL-terminated string.
> +       -  Entity name as an UTF-8 NULL-terminated string. This name must be
> unique
> +          within the media topology.
> 
>      *  -  __u32
>         -  ``type``
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst index
> e572dd0d806d..3a5f165d9811 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> @@ -131,11 +131,14 @@ desired arrays with the media graph elements.
> 
>      *  -  __u32
>         -  ``id``
> -       -  Unique ID for the entity.
> +       -  Unique ID for the entity. Do not expect that the ID will
> +	  always be the same for each instance of the device. In other words,
> +	  do not hardcode entity IDs in an application.
> 
>      *  -  char
>         -  ``name``\ [64]
> -       -  Entity name as an UTF-8 NULL-terminated string.
> +       -  Entity name as an UTF-8 NULL-terminated string. This name must be
> unique
> +          within the media topology.
> 
>      *  -  __u32
>         -  ``function``
> @@ -166,7 +169,9 @@ desired arrays with the media graph elements.
> 
>      *  -  __u32
>         -  ``id``
> -       -  Unique ID for the interface.
> +       -  Unique ID for the interface. Do not expect that the ID will
> +	  always be the same for each instance of the device. In other words,
> +	  do not hardcode interface IDs in an application.
> 
>      *  -  __u32
>         -  ``intf_type``
> @@ -215,7 +220,9 @@ desired arrays with the media graph elements.
> 
>      *  -  __u32
>         -  ``id``
> -       -  Unique ID for the pad.
> +       -  Unique ID for the pad. Do not expect that the ID will
> +	  always be the same for each instance of the device. In other words,
> +	  do not hardcode pad IDs in an application.
> 
>      *  -  __u32
>         -  ``entity_id``
> @@ -231,7 +238,8 @@ desired arrays with the media graph elements.
>  	  returns true. The ``media_version`` is defined in struct
> 
>  	  :c:type:`media_device_info` and can be retrieved using
>  	  :ref:`MEDIA_IOC_DEVICE_INFO`. Pad indices are stable. If new pads are
>  	  :added
> 
> -	  for an entity in the future, then those will be added at the end.
> +	  for an entity in the future, then those will be added at the end of the
> +	  entity's pad array.
> 
>      *  -  __u32
>         -  ``reserved``\ [4]
> @@ -250,7 +258,9 @@ desired arrays with the media graph elements.
> 
>      *  -  __u32
>         -  ``id``
> -       -  Unique ID for the link.
> +       -  Unique ID for the link. Do not expect that the ID will
> +	  always be the same for each instance of the device. In other words,
> +	  do not hardcode link IDs in an application.
> 
>      *  -  __u32
>         -  ``source_id``


-- 
Regards,

Laurent Pinchart
