Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39198 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753394AbdJMN1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 09:27:34 -0400
Subject: Re: [PATCH v2 03/17] media: v4l2-common: get rid of struct
 v4l2_discrete_probe
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <2c6deebfb792a95fb5a0b60ed715671c6398e20f.1506548682.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fb2ddcfa-12d8-0c00-08b9-bde6ba1d5cdb@xs4all.nl>
Date: Fri, 13 Oct 2017 15:27:29 +0200
MIME-Version: 1.0
In-Reply-To: <2c6deebfb792a95fb5a0b60ed715671c6398e20f.1506548682.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/17 23:46, Mauro Carvalho Chehab wrote:
> This struct is there just two store two arguments of
> v4l2_find_nearest_format(). The other two arguments are passed
> as parameter.
> 
> IMHO, there isn't much sense on doing that, and that will just
> add one more struct to document ;)
> 
> So, let's get rid of the struct, passing the parameters directly.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/vivid/vivid-vid-cap.c |  9 +++------
>  drivers/media/v4l2-core/v4l2-common.c        | 13 +++++++------
>  include/media/v4l2-common.h                  | 12 ++++--------
>  3 files changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index 01419455e545..0fbbcde19f0d 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -93,11 +93,6 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>  	{  1, 60 },
>  };
>  
> -static const struct v4l2_discrete_probe webcam_probe = {
> -	webcam_sizes,
> -	VIVID_WEBCAM_SIZES
> -};
> -
>  static int vid_cap_queue_setup(struct vb2_queue *vq,
>  		       unsigned *nbuffers, unsigned *nplanes,
>  		       unsigned sizes[], struct device *alloc_devs[])
> @@ -578,7 +573,9 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
>  	mp->field = vivid_field_cap(dev, mp->field);
>  	if (vivid_is_webcam(dev)) {
>  		const struct v4l2_frmsize_discrete *sz =
> -			v4l2_find_nearest_format(&webcam_probe, mp->width, mp->height);
> +			v4l2_find_nearest_format(webcam_sizes,
> +						 VIVID_WEBCAM_SIZES,
> +						 mp->width, mp->height);
>  
>  		w = sz->width;
>  		h = sz->height;
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index a5ea1f517291..fb9a2a3c1072 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -371,18 +371,19 @@ void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
>  }
>  EXPORT_SYMBOL_GPL(v4l_bound_align_image);
>  
> -const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
> -		const struct v4l2_discrete_probe *probe,
> -		s32 width, s32 height)
> +const struct v4l2_frmsize_discrete
> +*v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,

Please move the initial '*' to the end of the first line. Otherwise it is very
hard to see that this function returns a pointer.

> +			  const size_t num_sizes,
> +			  s32 width, s32 height)
>  {
>  	int i;
>  	u32 error, min_error = UINT_MAX;
>  	const struct v4l2_frmsize_discrete *size, *best = NULL;
>  
> -	if (!probe)
> -		return best;
> +	if (!sizes)
> +		return NULL;
>  
> -	for (i = 0, size = probe->sizes; i < probe->num_sizes; i++, size++) {
> +	for (i = 0, size = sizes; i < num_sizes; i++, size++) {
>  		error = abs(size->width - width) + abs(size->height - height);
>  		if (error < min_error) {
>  			min_error = error;
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 7dbecbe3009c..7ae7840df068 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -249,14 +249,10 @@ void v4l_bound_align_image(unsigned int *w, unsigned int wmin,
>  			   unsigned int hmax, unsigned int halign,
>  			   unsigned int salign);
>  
> -struct v4l2_discrete_probe {
> -	const struct v4l2_frmsize_discrete	*sizes;
> -	int					num_sizes;
> -};
> -
> -const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
> -		const struct v4l2_discrete_probe *probe,
> -		s32 width, s32 height);
> +const struct v4l2_frmsize_discrete
> +*v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,

Same here.

> +			  const size_t num_sizes,
> +			  s32 width, s32 height);
>  
>  void v4l2_get_timestamp(struct timeval *tv);
>  
> 

After changing that you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
