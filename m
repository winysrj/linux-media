Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33731 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752308AbeDPSEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 14:04:39 -0400
Date: Mon, 16 Apr 2018 15:04:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 7/9] media-ioc-g-topology.rst: document new 'index'
 field
Message-ID: <20180416150434.55792f37@vento.lan>
In-Reply-To: <20180416132121.46205-8-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
        <20180416132121.46205-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Apr 2018 15:21:19 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the new struct media_v2_pad 'index' field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> index c4055ddf070a..459818c3490c 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> @@ -334,7 +334,17 @@ desired arrays with the media graph elements.
>  
>         -  __u32
>  
> -       -  ``reserved``\ [5]
> +       -  ``index``
> +
> +       -  0-based pad index. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
> +          returns true. The ``media_version`` is defined in struct
> +	  :c:type:`media_device_info`.
> +
> +    -  .. row 5

Same comment as before: let's have just one patch removing those
script-generated comments from the doc files we touch.

> +
> +       -  __u32
> +
> +       -  ``reserved``\ [4]
>  
>         -  Reserved for future extensions. Drivers and applications must set
>  	  this array to zero.



Thanks,
Mauro
