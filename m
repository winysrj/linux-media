Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59864 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726529AbeJIVSE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 17:18:04 -0400
Subject: Re: [PATCH v2] media: vivid: Support 480p for webcam capture
To: Keiichi Watanabe <keiichiw@chromium.org>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, kieran.bingham@ideasonboard.com,
        tfiga@chromium.org, jcliang@chromium.org, shik@chromium.org
References: <20181009134339.233238-1-keiichiw@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b40366d-1358-93a0-a411-1237d7d0cad8@xs4all.nl>
Date: Tue, 9 Oct 2018 16:00:51 +0200
MIME-Version: 1.0
In-Reply-To: <20181009134339.233238-1-keiichiw@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/18 15:43, Keiichi Watanabe wrote:
> Support 640x480 as a frame size for video input devices of vivid.
> 
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index 58e14dd1dcd3..6cf910a60ecf 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -51,7 +51,7 @@ static const struct vivid_fmt formats_ovl[] = {
>  };
>  
>  /* The number of discrete webcam framesizes */
> -#define VIVID_WEBCAM_SIZES 5
> +#define VIVID_WEBCAM_SIZES 6
>  /* The number of discrete webcam frameintervals */
>  #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
>  
> @@ -59,6 +59,7 @@ static const struct vivid_fmt formats_ovl[] = {
>  static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
>  	{  320, 180 },
>  	{  640, 360 },
> +	{  640, 480 },
>  	{ 1280, 720 },
>  	{ 1920, 1080 },
>  	{ 3840, 2160 },
> @@ -74,9 +75,11 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>  	{  1, 4 },
>  	{  1, 5 },
>  	{  1, 10 },
> +	{  2, 25 },
>  	{  1, 15 },
>  	{  1, 25 },
>  	{  1, 30 },
> +	{  1, 40 },
>  	{  1, 50 },
>  	{  1, 60 },
>  };
> 
