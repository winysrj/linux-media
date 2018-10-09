Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41640 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbeJIStf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 14:49:35 -0400
Subject: Re: [PATCH 1/1] media: docs: Document metadata format in struct
 v4l2_format
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20181009113106.14202-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <14bd1646-6b9d-1b14-5f21-ba39cd8a5391@xs4all.nl>
Date: Tue, 9 Oct 2018 13:32:57 +0200
MIME-Version: 1.0
In-Reply-To: <20181009113106.14202-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/18 13:31, Sakari Ailus wrote:
> The format fields in struct v4l2_format were otherwise reported but the
> meta field was missing. Document it.
> 
> Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  Documentation/media/uapi/v4l/dev-meta.rst     | 2 +-
>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
> index f7ac8d0d3af14..b65dc078abeb8 100644
> --- a/Documentation/media/uapi/v4l/dev-meta.rst
> +++ b/Documentation/media/uapi/v4l/dev-meta.rst
> @@ -40,7 +40,7 @@ To use the :ref:`format` ioctls applications set the ``type`` field of the
>  the desired operation. Both drivers and applications must set the remainder of
>  the :c:type:`v4l2_format` structure to 0.
>  
> -.. _v4l2-meta-format:
> +.. c:type:: v4l2_meta_format
>  
>  .. tabularcolumns:: |p{1.4cm}|p{2.2cm}|p{13.9cm}|
>  
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> index 3ead350e099f9..9ea494a8facab 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> @@ -133,6 +133,11 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
>        - Definition of a data format, see :ref:`pixfmt`, used by SDR
>  	capture and output devices.
>      * -
> +      - struct :c:type:`v4l2_meta_format`
> +      - ``meta``
> +      - Definition of a metadata format, see :ref:`meta-formats`, used by
> +	metadata capture devices.
> +    * -
>        - __u8
>        - ``raw_data``\ [200]
>        - Place holder for future extensions.
> 
