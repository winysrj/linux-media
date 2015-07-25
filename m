Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38859 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754972AbbGYWml (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2015 18:42:41 -0400
Date: Sun, 26 Jul 2015 01:42:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/7] v4l2-fh: add v4l2_fh_open_is_first and
 v4l2_fh_release_is_last
Message-ID: <20150725224239.GA15270@valkosipuli.retiisi.org.uk>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
 <1437733296-38198-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1437733296-38198-4-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jul 24, 2015 at 12:21:32PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add new helper functions that report back if this was the first open
> or last close.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

...

> @@ -65,11 +65,23 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
>   */
>  bool v4l2_fh_add(struct v4l2_fh *fh);
>  /*
> + * It allocates a v4l2_fh and inits and adds it to the video_device associated
> + * with the file pointer. In addition it returns true if this was the first
> + * open and false otherwise. The error code is returned in *err.
> + */
> +bool v4l2_fh_open_is_first(struct file *filp, int *err);

The new interface functions look a tad clumsy to me.

What would you think of returning the singularity value from v4l2_fh_open()
straight away? Negative integers are errors, so zero and positive values are
free.

A few drivers just check if the value is non-zero and then return that
value, but there are just a handful of those.

> +/*
>   * Can be used as the open() op of v4l2_file_operations.
>   * It allocates a v4l2_fh and inits and adds it to the video_device associated
>   * with the file pointer.
>   */
> -int v4l2_fh_open(struct file *filp);
> +static inline int v4l2_fh_open(struct file *filp)
> +{
> +	int err;
> +
> +	v4l2_fh_open_is_first(filp, &err);
> +	return err;
> +}
>  /*
>   * Remove file handle from the list of file handles. Must be called in
>   * v4l2_file_operations->release() handler if the driver uses v4l2_fh.
> @@ -86,12 +98,23 @@ bool v4l2_fh_del(struct v4l2_fh *fh);
>   */
>  void v4l2_fh_exit(struct v4l2_fh *fh);
>  /*
> + * It deletes and exits the v4l2_fh associated with the file pointer and
> + * frees it. It will do nothing if filp->private_data (the pointer to the
> + * v4l2_fh struct) is NULL. This function returns true if this was the
> + * last open file handle and false otherwise.
> + */
> +bool v4l2_fh_release_is_last(struct file *filp);
> +/*
>   * Can be used as the release() op of v4l2_file_operations.
>   * It deletes and exits the v4l2_fh associated with the file pointer and
>   * frees it. It will do nothing if filp->private_data (the pointer to the
>   * v4l2_fh struct) is NULL. This function always returns 0.
>   */
> -int v4l2_fh_release(struct file *filp);
> +static inline int v4l2_fh_release(struct file *filp)
> +{
> +	v4l2_fh_release_is_last(filp);
> +	return 0;
> +}
>  /*
>   * Returns true if this filehandle is the only filehandle opened for the

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
