Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34731 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab0HNPDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Aug 2010 11:03:21 -0400
Subject: Re: [PATCH v2] V4L2: avoid name conflicts in macros
From: Andy Walls <awalls@md.metrocast.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1008122026450.17224@axis700.grange>
References: <Pine.LNX.4.64.1008122026450.17224@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 11:03:51 -0400
Message-ID: <1281798231.2474.37.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 2010-08-12 at 22:16 +0200, Guennadi Liakhovetski wrote:
> "sd" and "err" are too common names to be used in macros for local variables.
> Prefix them with an underscore to avoid name clashing.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

I've reviewed these but not tetsed them.  The functionally look OK.

I share Lawrence's concern about "__err" being considered a reserved
library symbol somewhere in the kernel sometime in the future, and still
having a good probability for name clashing  

However

"git grep __err" reveals that "__err" is used in a few places as a local
variable with block scope in a macro: the same manner as it is used in
this patch.  I didn't find a global declaration of "__err" in the
kernel.

"git grep '[^_a-zA-Z0-9]_err[^_a-z:]' | grep -v goto"  also shows that
"_err" is popular in macros, but also with no apparent global
declaration in the kernel.

"git grep '[^_a-zA-Z0-9]_err_[^a-z]' | grep -v goto" shows that "_err_"
is not used anywhere in the kernel.


Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> ---
> 
> v2:
> 
> as suggested by Mauro, also patched v4l2_device_call_all and 
> v4l2_device_call_until_err, as well as ivtv and cx18 specific macros
> 
>  drivers/media/video/cx18/cx18-driver.h |   19 +++++++---
>  drivers/media/video/ivtv/ivtv-driver.h |   14 ++++++--
>  include/media/v4l2-device.h            |   57 ++++++++++++++++++++++----------
>  3 files changed, 63 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
> index 9bc51a9..7e43c7b 100644
> --- a/drivers/media/video/cx18/cx18-driver.h
> +++ b/drivers/media/video/cx18/cx18-driver.h
> @@ -674,18 +674,25 @@ static inline int cx18_raw_vbi(const struct cx18 *cx)
>  
>  /* Call the specified callback for all subdevs with a grp_id bit matching the
>   * mask in hw (if 0, then match them all). Ignore any errors. */
> -#define cx18_call_hw(cx, hw, o, f, args...) \
> -	__v4l2_device_call_subdevs(&(cx)->v4l2_dev, \
> -				   !(hw) || (sd->grp_id & (hw)), o, f , ##args)
> +#define cx18_call_hw(cx, hw, o, f, args...)				\
> +	do {								\
> +		struct v4l2_subdev *__sd; 				\
> +		__v4l2_device_call_subdevs_p(&(cx)->v4l2_dev, __sd,	\
> +			!(hw) || (__sd->grp_id & (hw)), o, f , ##args);	\
> +	} while (0)
>  
>  #define cx18_call_all(cx, o, f, args...) cx18_call_hw(cx, 0, o, f , ##args)
>  
>  /* Call the specified callback for all subdevs with a grp_id bit matching the
>   * mask in hw (if 0, then match them all). If the callback returns an error
>   * other than 0 or -ENOIOCTLCMD, then return with that error code. */
> -#define cx18_call_hw_err(cx, hw, o, f, args...) \
> -	__v4l2_device_call_subdevs_until_err( \
> -		   &(cx)->v4l2_dev, !(hw) || (sd->grp_id & (hw)), o, f , ##args)
> +#define cx18_call_hw_err(cx, hw, o, f, args...)				\
> +({									\
> +	struct v4l2_subdev *__sd;					\
> +	__v4l2_device_call_subdevs_until_err_p(&(cx)->v4l2_dev,		\
> +			__sd, !(hw) || (__sd->grp_id & (hw)), o, f,	\
> +			##args);					\
> +})
>  
>  #define cx18_call_all_err(cx, o, f, args...) \
>  	cx18_call_hw_err(cx, 0, o, f , ##args)
> diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
> index 7580314..e61252c 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.h
> +++ b/drivers/media/video/ivtv/ivtv-driver.h
> @@ -811,15 +811,23 @@ static inline int ivtv_raw_vbi(const struct ivtv *itv)
>  /* Call the specified callback for all subdevs matching hw (if 0, then
>     match them all). Ignore any errors. */
>  #define ivtv_call_hw(itv, hw, o, f, args...) 				\
> -	__v4l2_device_call_subdevs(&(itv)->v4l2_dev, !(hw) || (sd->grp_id & (hw)), o, f , ##args)
> +	do {								\
> +		struct v4l2_subdev *__sd; 				\
> +		__v4l2_device_call_subdevs_p(&(itv)->v4l2_dev, __sd,	\
> +			!(hw) || (__sd->grp_id & (hw)), o, f , ##args);	\
> +	} while (0)
>  
>  #define ivtv_call_all(itv, o, f, args...) ivtv_call_hw(itv, 0, o, f , ##args)
>  
>  /* Call the specified callback for all subdevs matching hw (if 0, then
>     match them all). If the callback returns an error other than 0 or
>     -ENOIOCTLCMD, then return with that error code. */
> -#define ivtv_call_hw_err(itv, hw, o, f, args...)  		\
> -	__v4l2_device_call_subdevs_until_err(&(itv)->v4l2_dev, !(hw) || (sd->grp_id & (hw)), o, f , ##args)
> +#define ivtv_call_hw_err(itv, hw, o, f, args...)			\
> +({									\
> +	struct v4l2_subdev *__sd;					\
> +	__v4l2_device_call_subdevs_until_err_p(&(itv)->v4l2_dev, __sd,	\
> +		!(hw) || (__sd->grp_id & (hw)), o, f , ##args);		\
> +})
>  
>  #define ivtv_call_all_err(itv, o, f, args...) ivtv_call_hw_err(itv, 0, o, f , ##args)
>  
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 8bcbd7a..fe10464 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -101,46 +101,67 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
>  /* Call the specified callback for all subdevs matching the condition.
>     Ignore any errors. Note that you cannot add or delete a subdev
>     while walking the subdevs list. */
> -#define __v4l2_device_call_subdevs(v4l2_dev, cond, o, f, args...) 	\
> +#define __v4l2_device_call_subdevs_p(v4l2_dev, sd, cond, o, f, args...)	\
>  	do { 								\
> -		struct v4l2_subdev *sd; 				\
> +		list_for_each_entry((sd), &(v4l2_dev)->subdevs, list)	\
> +			if ((cond) && (sd)->ops->o && (sd)->ops->o->f)	\
> +				(sd)->ops->o->f((sd) , ##args);		\
> +	} while (0)
> +
> +#define __v4l2_device_call_subdevs(v4l2_dev, cond, o, f, args...)	\
> +	do {								\
> +		struct v4l2_subdev *__sd; 				\
>  									\
> -		list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)   	\
> -			if ((cond) && sd->ops->o && sd->ops->o->f) 	\
> -				sd->ops->o->f(sd , ##args); 		\
> +		__v4l2_device_call_subdevs_p(v4l2_dev, __sd, cond, o,	\
> +						f , ##args);		\
>  	} while (0)
>  
>  /* Call the specified callback for all subdevs matching the condition.
>     If the callback returns an error other than 0 or -ENOIOCTLCMD, then
>     return with that error code. Note that you cannot add or delete a
>     subdev while walking the subdevs list. */
> -#define __v4l2_device_call_subdevs_until_err(v4l2_dev, cond, o, f, args...) \
> +#define __v4l2_device_call_subdevs_until_err_p(v4l2_dev, sd, cond, o, f, args...) \
>  ({ 									\
> -	struct v4l2_subdev *sd; 					\
> -	long err = 0; 							\
> +	long __err = 0;							\
>  									\
> -	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list) { 		\
> -		if ((cond) && sd->ops->o && sd->ops->o->f) 		\
> -			err = sd->ops->o->f(sd , ##args); 		\
> -		if (err && err != -ENOIOCTLCMD)				\
> +	list_for_each_entry((sd), &(v4l2_dev)->subdevs, list) {		\
> +		if ((cond) && (sd)->ops->o && (sd)->ops->o->f) 		\
> +			__err = (sd)->ops->o->f((sd) , ##args);		\
> +		if (__err && __err != -ENOIOCTLCMD)			\
>  			break; 						\
>  	} 								\
> -	(err == -ENOIOCTLCMD) ? 0 : err; 				\
> +	(__err == -ENOIOCTLCMD) ? 0 : __err; 				\
> +})
> +
> +#define __v4l2_device_call_subdevs_until_err(v4l2_dev, cond, o, f, args...) \
> +({ 									\
> +	struct v4l2_subdev *__sd; 					\
> +	__v4l2_device_call_subdevs_until_err_p(v4l2_dev, __sd, cond, o,	\
> +						f, args...);		\
>  })
>  
>  /* Call the specified callback for all subdevs matching grp_id (if 0, then
>     match them all). Ignore any errors. Note that you cannot add or delete
>     a subdev while walking the subdevs list. */
> -#define v4l2_device_call_all(v4l2_dev, grpid, o, f, args...) 		\
> -	__v4l2_device_call_subdevs(v4l2_dev, 				\
> -			!(grpid) || sd->grp_id == (grpid), o, f , ##args)
> +#define v4l2_device_call_all(v4l2_dev, grpid, o, f, args...)		\
> +	do {								\
> +		struct v4l2_subdev *__sd; 				\
> +									\
> +		__v4l2_device_call_subdevs_p(v4l2_dev, __sd,		\
> +			!(grpid) || __sd->grp_id == (grpid), o, f ,	\
> +			##args);					\
> +	} while (0)
>  
>  /* Call the specified callback for all subdevs matching grp_id (if 0, then
>     match them all). If the callback returns an error other than 0 or
>     -ENOIOCTLCMD, then return with that error code. Note that you cannot
>     add or delete a subdev while walking the subdevs list. */
>  #define v4l2_device_call_until_err(v4l2_dev, grpid, o, f, args...) 	\
> -	__v4l2_device_call_subdevs_until_err(v4l2_dev,			\
> -		       !(grpid) || sd->grp_id == (grpid), o, f , ##args)
> +({ 									\
> +	struct v4l2_subdev *__sd; 					\
> +	__v4l2_device_call_subdevs_until_err_p(v4l2_dev, __sd,		\
> +			!(grpid) || __sd->grp_id == (grpid), o, f ,	\
> +			##args);					\
> +})
>  
>  #endif


