Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34954 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932595AbeGINJe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 09:09:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv5 11/12] media-ioc-enum-links.rst: improve pad index description
Date: Mon, 09 Jul 2018 16:10:06 +0300
Message-ID: <3247616.pqdvV2kJkN@avalon>
In-Reply-To: <20180629114331.7617-12-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-12-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday, 29 June 2018 14:43:30 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> Make it clearer that the index starts at 0, and that it won't change
> since future new pads will be added at the end.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  Documentation/media/uapi/mediactl/media-ioc-enum-links.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
> b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst index
> 17abdeed1a9c..4cceeb8a6f73 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
> @@ -92,7 +92,9 @@ returned during the enumeration process.
> 
>      *  -  __u16
>         -  ``index``
> -       -  0-based pad index.
> +       -  Pad index, starts at 0. Pad indices are stable. If new pads are
> added
> +	  for an entity in the future, then those will be added at the end of the
> +	  entity's pad array.

Is that true strictly speaking ? We do mandate pad indices to be stable, but 
couldn't new pads still be inserted in the array ? The array wouldn't be 
sorted by pad index anymore, but I don't think we require that. If we want to 
I don't have any objection, but it should then be documented.

>      *  -  __u32
>         -  ``flags``

-- 
Regards,

Laurent Pinchart
