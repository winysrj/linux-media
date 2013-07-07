Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:43824 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3GGVuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 17:50:55 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so1593866bkc.14
        for <linux-media@vger.kernel.org>; Sun, 07 Jul 2013 14:50:54 -0700 (PDT)
Message-ID: <51D9E2BB.2080308@gmail.com>
Date: Sun, 07 Jul 2013 23:50:51 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/5] v4l2: add matrix support.
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl> <1372422454-13752-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1372422454-13752-2-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2013 02:27 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> This patch adds core support for matrices: querying, getting and setting.
>
> Two initial matrix types are defined for motion detection (defining regions
> and thresholds).
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/v4l2-core/v4l2-dev.c   |  3 ++
>   drivers/media/v4l2-core/v4l2-ioctl.c | 23 ++++++++++++-
>   include/media/v4l2-ioctl.h           |  8 +++++
>   include/uapi/linux/videodev2.h       | 64 ++++++++++++++++++++++++++++++++++++
>   4 files changed, 97 insertions(+), 1 deletion(-)

[...]

> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index e0b74a4..7e4538e 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -271,6 +271,14 @@ struct v4l2_ioctl_ops {
>   	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
>   					const struct v4l2_event_subscription *sub);
>
> +	/* Matrix ioctls */
> +	int (*vidioc_query_matrix) (struct file *file, void *fh,
> +				    struct v4l2_query_matrix *qmatrix);
> +	int (*vidioc_g_matrix) (struct file *file, void *fh,
> +				    struct v4l2_matrix *matrix);
> +	int (*vidioc_s_matrix) (struct file *file, void *fh,
> +				    struct v4l2_matrix *matrix);
> +
>   	/* For other private ioctls */
>   	long (*vidioc_default)	       (struct file *file, void *fh,
>   					bool valid_prio, unsigned int cmd, void *arg);
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 95ef455..5cbe815 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1838,6 +1838,64 @@ struct v4l2_create_buffers {
>   	__u32			reserved[8];
>   };
>
> +/* Define to which motion detection region each element belongs.
> + * Each element is a __u8. */
> +#define V4L2_MATRIX_TYPE_MD_REGION     (1)
> +/* Define the motion detection threshold for each element.
> + * Each element is a __u16. */
> +#define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)
> +
> +/**
> + * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
> + * @type:	matrix type
> + * @ref:	reference to some object (if any) owning the matrix
> + * @columns:	number of columns in the matrix
> + * @rows:	number of rows in the matrix
> + * @elem_min:	minimum matrix element value
> + * @elem_max:	maximum matrix element value
> + * @elem_size:	size in bytes each matrix element
> + * @reserved:	future extensions, applications and drivers must zero this.
> + */
> +struct v4l2_query_matrix {
> +	__u32 type;
> +	union {
> +		__u32 reserved[4];
> +	} ref;
> +	__u32 columns;
> +	__u32 rows;
> +	union {
> +		__s64 val;
> +		__u64 uval;
> +		__u32 reserved[4];
> +	} elem_min;
> +	union {
> +		__s64 val;
> +		__u64 uval;
> +		__u32 reserved[4];
> +	} elem_max;
> +	__u32 elem_size;

How about reordering it to something like:

	struct {
		union {
			__s64 val;
			__u64 uval;
			__u32 reserved[4];
		} min;
		union {
			__s64 val;
			__u64 uval;
			__u32 reserved[4];
		} max;
		__u32 size;
	} element;

?

--
Regards,
Sylwester
