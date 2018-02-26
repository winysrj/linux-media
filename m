Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:50270 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752493AbeBZNv1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 08:51:27 -0500
Subject: Re: [PATCH v2] Staging: bcm2048: Fix function argument alignment in
 radio-bcm2048.c.
To: Quytelda Kahja <quytelda@tamalin.org>, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20180219072550.hz4vpomsaz2ajrnm@mwanda>
 <20180220065304.8943-1-quytelda@tamalin.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cb62e915-eb9c-9252-1f0a-cc85c8ea3530@xs4all.nl>
Date: Mon, 26 Feb 2018 14:51:20 +0100
MIME-Version: 1.0
In-Reply-To: <20180220065304.8943-1-quytelda@tamalin.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2018 07:53 AM, Quytelda Kahja wrote:
> Fix a coding style problem.

What coding style problem? You should give a short description of
what you are fixing.

> 
> Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
> ---
> This is the patch without the unnecessary fixes for line length.
> 
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 06d1920150da..f38a4f2acdde 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -1864,7 +1864,7 @@ static int bcm2048_probe(struct bcm2048_device *bdev)
>  		goto unlock;
>  
>  	err = bcm2048_set_fm_search_rssi_threshold(bdev,
> -					BCM2048_DEFAULT_RSSI_THRESHOLD);
> +						   BCM2048_DEFAULT_RSSI_THRESHOLD);
>  	if (err < 0)
>  		goto unlock;
>  

Just drop this change: it will replace one warning (non-aligned) with
another (> 80 cols).

This code is fine as it is.

Regards,

	Hans

> @@ -1942,9 +1942,9 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
>   */
>  #define property_write(prop, type, mask, check)				\
>  static ssize_t bcm2048_##prop##_write(struct device *dev,		\
> -					struct device_attribute *attr,	\
> -					const char *buf,		\
> -					size_t count)			\
> +				      struct device_attribute *attr,	\
> +				      const char *buf,			\
> +				      size_t count)			\
>  {									\
>  	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
>  	type value;							\
> @@ -1966,8 +1966,8 @@ static ssize_t bcm2048_##prop##_write(struct device *dev,		\
>  
>  #define property_read(prop, mask)					\
>  static ssize_t bcm2048_##prop##_read(struct device *dev,		\
> -					struct device_attribute *attr,	\
> -					char *buf)			\
> +				     struct device_attribute *attr,	\
> +				     char *buf)				\
>  {									\
>  	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
>  	int value;							\
> @@ -1985,8 +1985,8 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
>  
>  #define property_signed_read(prop, size, mask)				\
>  static ssize_t bcm2048_##prop##_read(struct device *dev,		\
> -					struct device_attribute *attr,	\
> -					char *buf)			\
> +				     struct device_attribute *attr,	\
> +				     char *buf)				\
>  {									\
>  	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
>  	size value;							\
> @@ -2005,8 +2005,8 @@ property_read(prop, mask)						\
>  
>  #define property_str_read(prop, size)					\
>  static ssize_t bcm2048_##prop##_read(struct device *dev,		\
> -					struct device_attribute *attr,	\
> -					char *buf)			\
> +				     struct device_attribute *attr,	\
> +				     char *buf)				\
>  {									\
>  	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
>  	int count;							\
> @@ -2175,7 +2175,7 @@ static int bcm2048_fops_release(struct file *file)
>  }
>  
>  static __poll_t bcm2048_fops_poll(struct file *file,
> -				      struct poll_table_struct *pts)
> +				  struct poll_table_struct *pts)
>  {
>  	struct bcm2048_device *bdev = video_drvdata(file);
>  	__poll_t retval = 0;
> 
