Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40532 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750781AbeECM4a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 08:56:30 -0400
Date: Thu, 3 May 2018 15:56:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] [media] omap3isp: support 64-bit version of
 omap3isp_stat_data
Message-ID: <20180503125627.6elsr4iiknnv227c@valkosipuli.retiisi.org.uk>
References: <20180425213044.1535393-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180425213044.1535393-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for the patch and apologies for the delays.

On Wed, Apr 25, 2018 at 11:30:10PM +0200, Arnd Bergmann wrote:
> C libraries with 64-bit time_t use an incompatible format for
> struct omap3isp_stat_data. This changes the kernel code to
> support either version, by moving over the normal handling
> to the 64-bit variant, and adding compatiblity code to handle
> the old binary format with the existing ioctl command code.
> 
> Fortunately, the command code includes the size of the structure,
> so the difference gets handled automatically. In the process of
> eliminating the references to 'struct timeval' from the kernel,
> I also change the way the timestamp is generated internally,
> basically by open-coding the v4l2_get_timestamp() call.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I submitted this one in November and asked again in January,
> still waiting for a review so it can be applied.
> ---
>  drivers/media/platform/omap3isp/isph3a_aewb.c |  2 ++
>  drivers/media/platform/omap3isp/isph3a_af.c   |  2 ++
>  drivers/media/platform/omap3isp/isphist.c     |  2 ++
>  drivers/media/platform/omap3isp/ispstat.c     | 21 +++++++++++++++++++--
>  drivers/media/platform/omap3isp/ispstat.h     |  4 +++-
>  include/uapi/linux/omap3isp.h                 | 22 ++++++++++++++++++++++
>  6 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
> index d44626f20ac6..3c82dea4d375 100644
> --- a/drivers/media/platform/omap3isp/isph3a_aewb.c
> +++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
> @@ -250,6 +250,8 @@ static long h3a_aewb_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>  		return omap3isp_stat_config(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_REQ:
>  		return omap3isp_stat_request_statistics(stat, arg);
> +	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
> +		return omap3isp_stat_request_statistics_time32(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_EN: {
>  		unsigned long *en = arg;
>  		return omap3isp_stat_enable(stat, !!*en);
> diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
> index 99bd6cc21d86..4da25c84f0c6 100644
> --- a/drivers/media/platform/omap3isp/isph3a_af.c
> +++ b/drivers/media/platform/omap3isp/isph3a_af.c
> @@ -314,6 +314,8 @@ static long h3a_af_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>  		return omap3isp_stat_config(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_REQ:
>  		return omap3isp_stat_request_statistics(stat, arg);
> +	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
> +		return omap3isp_stat_request_statistics_time32(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_EN: {
>  		int *en = arg;
>  		return omap3isp_stat_enable(stat, !!*en);
> diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
> index a4ed5d140d48..d4be3d0e06f9 100644
> --- a/drivers/media/platform/omap3isp/isphist.c
> +++ b/drivers/media/platform/omap3isp/isphist.c
> @@ -435,6 +435,8 @@ static long hist_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>  		return omap3isp_stat_config(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_REQ:
>  		return omap3isp_stat_request_statistics(stat, arg);
> +	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
> +		return omap3isp_stat_request_statistics_time32(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_EN: {
>  		int *en = arg;
>  		return omap3isp_stat_enable(stat, !!*en);
> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> index 47cbc7e3d825..5967dfd0a9f7 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -18,6 +18,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/timekeeping.h>
>  
>  #include "isp.h"
>  
> @@ -237,7 +238,7 @@ static int isp_stat_buf_queue(struct ispstat *stat)
>  	if (!stat->active_buf)
>  		return STAT_NO_BUF;
>  
> -	v4l2_get_timestamp(&stat->active_buf->ts);
> +	ktime_get_ts64(&stat->active_buf->ts);
>  
>  	stat->active_buf->buf_size = stat->buf_size;
>  	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
> @@ -500,7 +501,8 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
>  		return PTR_ERR(buf);
>  	}
>  
> -	data->ts = buf->ts;
> +	data->ts.tv_sec = buf->ts.tv_sec;
> +	data->ts.tv_usec = buf->ts.tv_nsec / NSEC_PER_USEC;
>  	data->config_counter = buf->config_counter;
>  	data->frame_number = buf->frame_number;
>  	data->buf_size = buf->buf_size;
> @@ -512,6 +514,21 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
>  	return 0;
>  }
>  
> +int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> +					struct omap3isp_stat_data_time32 *data)
> +{
> +	struct omap3isp_stat_data data64;
> +	int ret;
> +
> +	ret = omap3isp_stat_request_statistics(stat, &data64);
> +
> +	data->ts.tv_sec = data64.ts.tv_sec;
> +	data->ts.tv_usec = data64.ts.tv_usec;
> +	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
> +
> +	return ret;
> +}
> +
>  /*
>   * omap3isp_stat_config - Receives new statistic engine configuration.
>   * @new_conf: Pointer to config structure.
> diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
> index 6d9b0244f320..923b38cfc682 100644
> --- a/drivers/media/platform/omap3isp/ispstat.h
> +++ b/drivers/media/platform/omap3isp/ispstat.h
> @@ -39,7 +39,7 @@ struct ispstat_buffer {
>  	struct sg_table sgt;
>  	void *virt_addr;
>  	dma_addr_t dma_addr;
> -	struct timeval ts;
> +	struct timespec64 ts;
>  	u32 buf_size;
>  	u32 frame_number;
>  	u16 config_counter;
> @@ -130,6 +130,8 @@ struct ispstat_generic_config {
>  int omap3isp_stat_config(struct ispstat *stat, void *new_conf);
>  int omap3isp_stat_request_statistics(struct ispstat *stat,
>  				     struct omap3isp_stat_data *data);
> +int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> +				     struct omap3isp_stat_data_time32 *data);
>  int omap3isp_stat_init(struct ispstat *stat, const char *name,
>  		       const struct v4l2_subdev_ops *sd_ops);
>  void omap3isp_stat_cleanup(struct ispstat *stat);
> diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
> index 1a920145db04..87b55755f4ff 100644
> --- a/include/uapi/linux/omap3isp.h
> +++ b/include/uapi/linux/omap3isp.h
> @@ -55,6 +55,8 @@
>  	_IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct omap3isp_h3a_af_config)
>  #define VIDIOC_OMAP3ISP_STAT_REQ \
>  	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct omap3isp_stat_data)
> +#define VIDIOC_OMAP3ISP_STAT_REQ_TIME32 \
> +	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct omap3isp_stat_data_time32)
>  #define VIDIOC_OMAP3ISP_STAT_EN \
>  	_IOWR('V', BASE_VIDIOC_PRIVATE + 7, unsigned long)
>  
> @@ -165,7 +167,14 @@ struct omap3isp_h3a_aewb_config {
>   * @config_counter: Number of the configuration associated with the data.
>   */
>  struct omap3isp_stat_data {
> +#ifdef __KERNEL__
> +	struct {
> +		__s64	tv_sec;
> +		__s64	tv_usec;

Any particular reason for __s64 here instead of e.g. long or __s32? Kernel
appears to use long in the timespec64 definition.

> +	} ts;
> +#else
>  	struct timeval ts;
> +#endif
>  	void __user *buf;
>  	__u32 buf_size;
>  	__u16 frame_number;
> @@ -173,6 +182,19 @@ struct omap3isp_stat_data {
>  	__u16 config_counter;
>  };
>  
> +#ifdef __KERNEL__
> +struct omap3isp_stat_data_time32 {
> +	struct {
> +		__s32	tv_sec;
> +		__s32	tv_usec;
> +	} ts;
> +	__u32 buf;
> +	__u32 buf_size;
> +	__u16 frame_number;
> +	__u16 cur_frame;
> +	__u16 config_counter;
> +};
> +#endif
>  
>  /* Histogram related structs */
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
