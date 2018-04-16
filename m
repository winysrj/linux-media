Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63716 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752750AbeDPSCv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 14:02:51 -0400
Date: Mon, 16 Apr 2018 15:02:46 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 5/9] media-ioc-enum-entities.rst: document new
 'function' field
Message-ID: <20180416150246.271607d0@vento.lan>
In-Reply-To: <20180416132121.46205-6-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
        <20180416132121.46205-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Apr 2018 15:21:17 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the new struct media_entity_desc 'function' field.

See my comments to patch 4/9.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../uapi/mediactl/media-ioc-enum-entities.rst      | 31 +++++++++++++++++-----
>  1 file changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
> index 582fda488810..6b0ab65288c6 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
> @@ -90,6 +90,12 @@ id's until they get an error.
>         -
>         -
>         -  Entity type, see :ref:`media-entity-functions` for details.
> +          Deprecated. If possible, use the ``function`` field instead.
> +	  For backwards compatibility this ``type`` field will only
> +	  expose functions ``MEDIA_ENT_F_IO_V4L``, ``MEDIA_ENT_F_CAM_SENSOR``,
> +	  ``MEDIA_ENT_F_FLASH``, ``MEDIA_ENT_F_LENS``, ``MEDIA_ENT_F_ATV_DECODER``
> +	  and ``MEDIA_ENT_F_TUNER``. Other functions will be mapped to
> +	  ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN`` or ``MEDIA_ENT_T_DEVNODE_UNKNOWN``.
>  
>      -  .. row 4
>  
> @@ -146,18 +152,31 @@ id's until they get an error.
>  
>         -  __u32
>  
> -       -  ``reserved[4]``
> +       -  ``function``
> +
> +       -
> +       -
> +       -  Entity main function, see :ref:`media-entity-functions` for details.
> +          Only valid if ``MEDIA_ENTITY_DESC_HAS_FUNCTION(media_version)``
> +          returns true. The ``media_version`` is defined in struct
> +          :c:type:`media_device_info`.
> +
> +    -  .. row 10
> +
> +       -  __u32
> +
> +       -  ``reserved[3]``
>  
>         -
>         -
>         -  Reserved for future extensions. Drivers and applications must set
>            the array to zero.
>  
> -    -  .. row 10
> +    -  .. row 11

Instead of keep incrementing the ".. row \d+" comment, better to
just remove them all from this rst file on a previous patch.

>  
>         -  union
>  
> -    -  .. row 11
> +    -  .. row 12
>  
>         -
>         -  struct
> @@ -167,7 +186,7 @@ id's until they get an error.
>         -
>         -  Valid for (sub-)devices that create a single device node.
>  
> -    -  .. row 12
> +    -  .. row 13
>  
>         -
>         -
> @@ -177,7 +196,7 @@ id's until they get an error.
>  
>         -  Device node major number.
>  
> -    -  .. row 13
> +    -  .. row 14
>  
>         -
>         -
> @@ -187,7 +206,7 @@ id's until they get an error.
>  
>         -  Device node minor number.
>  
> -    -  .. row 14
> +    -  .. row 15
>  
>         -
>         -  __u8



Thanks,
Mauro
