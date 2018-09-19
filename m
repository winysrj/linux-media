Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42276 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731029AbeISQ4S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 12:56:18 -0400
Date: Wed, 19 Sep 2018 14:18:40 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 3/5] media: v4l2-common: add v4l2_find_closest_fract()
Message-ID: <20180919111840.7pxd2lnxcnlm3t63@paasikivi.fi.intel.com>
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
 <1537200191-17956-4-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537200191-17956-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mita-san,

On Tue, Sep 18, 2018 at 01:03:09AM +0900, Akinobu Mita wrote:
> Add a function to locate the closest element in a sorted v4l2_fract array.
> 
> The implementation is based on find_closest() macro in linux/util_macros.h
> and the way to compare two v4l2_fract in vivid_vid_cap_s_parm in
> drivers/media/platform/vivid/vivid-vid-cap.c.
> 
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-common.c | 26 ++++++++++++++++++++++++++
>  include/media/v4l2-common.h           | 12 ++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index b518b92..91bd460 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -387,6 +387,32 @@ __v4l2_find_nearest_size(const void *array, size_t array_size,
>  }
>  EXPORT_SYMBOL_GPL(__v4l2_find_nearest_size);
>  
> +#define FRACT_CMP(a, OP, b)				\
> +	((u64)(a).numerator * (b).denominator OP	\
> +	 (u64)(b).numerator * (a).denominator)
> +
> +int v4l2_find_closest_fract(struct v4l2_fract x, const struct v4l2_fract *array,

unsigned int ?

> +			    size_t num)
> +{
> +	int i;
> +
> +	for (i = 0; i < num - 1; i++) {
> +		struct v4l2_fract a = array[i];
> +		struct v4l2_fract b = array[i + 1];
> +		struct v4l2_fract midpoint = {
> +			.numerator = a.numerator * b.denominator +
> +				     b.numerator * a.denominator,

Assuming the entire range could be in use, this may lead to an overflow.
Same on the line below.

I also wonder if e.g. a binary search would be more effective than going
through the entire list.

> +			.denominator = 2 * a.denominator * b.denominator,
> +		};
> +
> +		if (FRACT_CMP(x, <=, midpoint))
> +			break;
> +	}
> +
> +	return i;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_find_closest_fract);
> +
>  void v4l2_get_timestamp(struct timeval *tv)
>  {
>  	struct timespec ts;
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index cdc87ec..e388f4e 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -350,6 +350,18 @@ __v4l2_find_nearest_size(const void *array, size_t array_size,
>  			 size_t height_offset, s32 width, s32 height);
>  
>  /**
> + * v4l2_find_closest_fract - locate the closest element in a sorted array
> + * @x: The reference value.
> + * @array: The array in which to look for the closest element. Must be sorted
> + *  in ascending order.
> + * @num: number of elements in 'array'.
> + *
> + * Returns the index of the element closest to 'x'.
> + */
> +int v4l2_find_closest_fract(struct v4l2_fract x, const struct v4l2_fract *array,
> +			    size_t num);
> +
> +/**
>   * v4l2_get_timestamp - helper routine to get a timestamp to be used when
>   *	filling streaming metadata. Internally, it uses ktime_get_ts(),
>   *	which is the recommended way to get it.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
