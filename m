Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39110 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750850AbeEMJMS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 05:12:18 -0400
Subject: Re: [PATCH 2/5] media: docs: clarify relationship between crop and
 selection APIs
To: Luca Ceresoli <luca@lucaceresoli.net>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
 <1522790146-16061-2-git-send-email-luca@lucaceresoli.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fca47fb0-a299-af1d-4485-268907bb1007@xs4all.nl>
Date: Sun, 13 May 2018 11:12:09 +0200
MIME-Version: 1.0
In-Reply-To: <1522790146-16061-2-git-send-email-luca@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/2018 11:15 PM, Luca Ceresoli wrote:
> Having two somewhat similar and largely overlapping APIs is confusing,
> especially since the older one appears in the docs before the newer
> and most featureful counterpart.
> 
> Clarify all of this in several ways:
>  - swap the two sections
>  - give a name to the two APIs in the section names
>  - add a note at the beginning of the CROP API section
> 
> Also remove a note that is incorrect (correct wording is in
> vidioc-cropcap.rst).
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Based on info from: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  Documentation/media/uapi/v4l/common.rst            |  2 +-
>  Documentation/media/uapi/v4l/crop.rst              | 21 ++++++++++++---------
>  Documentation/media/uapi/v4l/selection-api-005.rst |  2 ++
>  Documentation/media/uapi/v4l/selection-api.rst     |  4 ++--
>  4 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/common.rst b/Documentation/media/uapi/v4l/common.rst
> index 13f2ed3fc5a6..5f93e71122ef 100644
> --- a/Documentation/media/uapi/v4l/common.rst
> +++ b/Documentation/media/uapi/v4l/common.rst
> @@ -41,6 +41,6 @@ applicable to all devices.
>      extended-controls
>      format
>      planar-apis
> -    crop
>      selection-api
> +    crop
>      streaming-par
> diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
> index 182565b9ace4..83fa16eb347e 100644
> --- a/Documentation/media/uapi/v4l/crop.rst
> +++ b/Documentation/media/uapi/v4l/crop.rst
> @@ -2,9 +2,18 @@
>  
>  .. _crop:
>  
> -*************************************
> -Image Cropping, Insertion and Scaling
> -*************************************
> +*****************************************************
> +Image Cropping, Insertion and Scaling -- the CROP API
> +*****************************************************
> +
> +.. note::
> +
> +   The CROP API is mostly superseded by the newer :ref:`SELECTION API
> +   <selection-api>`. The new API should be preferred in most cases,
> +   with the exception of pixel aspect ratio detection, which is
> +   implemented by :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` and has no
> +   equivalent in the SELECTION API. See :ref:`selection-vs-crop` for a
> +   comparison of the two APIs.
>  
>  Some video capture devices can sample a subsection of the picture and
>  shrink or enlarge it to an image of arbitrary size. We call these
> @@ -40,12 +49,6 @@ support scaling or the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
>  :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls. Their size (and position
>  where applicable) will be fixed in this case.
>  
> -.. note::
> -
> -   All capture and output devices must support the
> -   :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl such that applications
> -   can determine if scaling takes place.

This note should be rewritten, not deleted:

	All capture and output devices that support the CROP or SELECTION API
	will also support the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl.

Regards,

	Hans

> -
>  
>  Cropping Structures
>  ===================
> diff --git a/Documentation/media/uapi/v4l/selection-api-005.rst b/Documentation/media/uapi/v4l/selection-api-005.rst
> index 5b47a28ac6d7..2ad30a49184f 100644
> --- a/Documentation/media/uapi/v4l/selection-api-005.rst
> +++ b/Documentation/media/uapi/v4l/selection-api-005.rst
> @@ -1,5 +1,7 @@
>  .. -*- coding: utf-8; mode: rst -*-
>  
> +.. _selection-vs-crop:
> +
>  ********************************
>  Comparison with old cropping API
>  ********************************
> diff --git a/Documentation/media/uapi/v4l/selection-api.rst b/Documentation/media/uapi/v4l/selection-api.rst
> index 81ea52d785b9..e4e623824b30 100644
> --- a/Documentation/media/uapi/v4l/selection-api.rst
> +++ b/Documentation/media/uapi/v4l/selection-api.rst
> @@ -2,8 +2,8 @@
>  
>  .. _selection-api:
>  
> -API for cropping, composing and scaling
> -=======================================
> +Cropping, composing and scaling -- the SELECTION API
> +====================================================
>  
>  
>  .. toctree::
> 
