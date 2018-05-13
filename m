Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:40269 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbeEMJNP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 05:13:15 -0400
Subject: Re: [PATCH 1/5] media: docs: selection: fix typos
To: Luca Ceresoli <luca@lucaceresoli.net>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e96a3e14-ccdb-a18b-816b-c4023853a4cb@xs4all.nl>
Date: Sun, 13 May 2018 11:13:10 +0200
MIME-Version: 1.0
In-Reply-To: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/2018 11:15 PM, Luca Ceresoli wrote:

Please add a commit message here. Yes, it can be as simple as 'Fixed typos in the
selection documentation.'

Regards,

	Hans

> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> ---
>  Documentation/media/uapi/v4l/selection-api-004.rst | 2 +-
>  Documentation/media/uapi/v4l/selection.svg         | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/selection-api-004.rst b/Documentation/media/uapi/v4l/selection-api-004.rst
> index d782cd5b2117..0a4ddc2d71db 100644
> --- a/Documentation/media/uapi/v4l/selection-api-004.rst
> +++ b/Documentation/media/uapi/v4l/selection-api-004.rst
> @@ -41,7 +41,7 @@ The driver may further adjust the requested size and/or position
>  according to hardware limitations.
>  
>  Each capture device has a default source rectangle, given by the
> -``V4L2_SEL_TGT_CROP_DEFAULT`` target. This rectangle shall over what the
> +``V4L2_SEL_TGT_CROP_DEFAULT`` target. This rectangle shall cover what the
>  driver writer considers the complete picture. Drivers shall set the
>  active crop rectangle to the default when the driver is first loaded,
>  but not later.
> diff --git a/Documentation/media/uapi/v4l/selection.svg b/Documentation/media/uapi/v4l/selection.svg
> index a93e3b59786d..911062bd2844 100644
> --- a/Documentation/media/uapi/v4l/selection.svg
> +++ b/Documentation/media/uapi/v4l/selection.svg
> @@ -1128,11 +1128,11 @@
>     </text>
>    </g>
>    <text transform="matrix(.96106 0 0 1.0405 48.571 195.53)" x="2438.062" y="1368.429" enable-background="new" font-size="50" style="line-height:125%">
> -   <tspan x="2438.062" y="1368.429">COMPOSE_BONDS</tspan>
> +   <tspan x="2438.062" y="1368.429">COMPOSE_BOUNDS</tspan>
>    </text>
>    <g font-size="40">
>     <text transform="translate(48.571 195.53)" x="8.082" y="1438.896" enable-background="new" style="line-height:125%">
> -    <tspan x="8.082" y="1438.896" font-size="50">CROP_BONDS</tspan>
> +    <tspan x="8.082" y="1438.896" font-size="50">CROP_BOUNDS</tspan>
>     </text>
>     <text transform="translate(48.571 195.53)" x="1455.443" y="-26.808" enable-background="new" style="line-height:125%">
>      <tspan x="1455.443" y="-26.808" font-size="50">overscan area</tspan>
> 
