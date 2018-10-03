Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36632 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbeJCSCY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 14:02:24 -0400
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
To: Keiichi Watanabe <keiichiw@chromium.org>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        jcliang@chromium.org, shik@chromium.org
References: <20181003070656.193854-1-keiichiw@chromium.org>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <b2dc51d7-fc92-2e7b-3a07-55a076b95d8b@ideasonboard.com>
Date: Wed, 3 Oct 2018 12:14:22 +0100
MIME-Version: 1.0
In-Reply-To: <20181003070656.193854-1-keiichiw@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Keiichi,

On 03/10/18 08:06, Keiichi Watanabe wrote:
> Support 640x480 as a frame size for video input devices of vivid.
> 
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> ---
>  drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index 58e14dd1dcd3..da80bf4bc365 100644
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

I agree this is a useful frame size to add...
(having got local patches which also update these tables)

>  	{ 1280, 720 },
>  	{ 1920, 1080 },
>  	{ 3840, 2160 },
> @@ -75,6 +76,8 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>  	{  1, 5 },
>  	{  1, 10 },
>  	{  1, 15 },
> +	{  1, 15 },
> +	{  1, 25 },

But won't this add duplicates of 25 and 15 FPS to all the frame sizes
smaller than 1280,720 ? Or are they filtered out?


Now the difficulty is adding smaller frame rates (like 1,1, 1,2) would
effect/reduce the output rates of the larger frame sizes, so how about
adding some high rate support (any two from 1/{60,75,90,100,120}) instead?


Regards

Kieran Bingham

>  	{  1, 25 },
>  	{  1, 30 },
>  	{  1, 50 },
> 
