Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40782 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753070AbeDPSKx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 14:10:53 -0400
Date: Mon, 16 Apr 2018 15:10:48 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 9/9] media-ioc-g-topology.rst: document new 'flags'
 field
Message-ID: <20180416151048.7fbe7144@vento.lan>
In-Reply-To: <20180416132121.46205-10-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
        <20180416132121.46205-10-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Apr 2018 15:21:21 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the new struct media_v2_entity 'flags' field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> index 459818c3490c..6521ab7c9b58 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> @@ -211,7 +211,18 @@ desired arrays with the media graph elements.
>  
>         -  __u32
>  
> -       -  ``reserved``\ [6]
> +       -  ``flags``
> +
> +       -  Entity flags, see :ref:`media-entity-flag` for details.
> +          Only valid if ``MEDIA_V2_ENTITY_HAS_FLAGS(media_version)``
> +          returns true. The ``media_version`` is defined in struct
> +	  :c:type:`media_device_info`.
> +
> +    -  .. row 5

Same comment as before: let's not add new useless comments.

> +
> +       -  __u32
> +
> +       -  ``reserved``\ [5]
>  
>         -  Reserved for future extensions. Drivers and applications must set
>  	  this array to zero.



Thanks,
Mauro
