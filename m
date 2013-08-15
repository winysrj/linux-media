Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2563 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760418Ab3HOGff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 02:35:35 -0400
Message-ID: <520C7695.7020405@xs4all.nl>
Date: Thu, 15 Aug 2013 08:35:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 02/10] v4l2: add matrix support.
References: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl> <1376305113-17128-3-git-send-email-hverkuil@xs4all.nl> <20130814143313.GA19221@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130814143313.GA19221@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2013 04:33 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the set!
> 
> On Mon, Aug 12, 2013 at 12:58:25PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch adds core support for matrices: querying, getting and setting.
>>
>> Two initial matrix types are defined for motion detection (defining regions
>> and thresholds).
> 
> I requested in the past that no new IOCTLs would be added for an essential
> extension of V4L2 control-like functionality. I understand developing a more
> generic framework does not answer to the problems at hand right now, so I
> think it's certainly fine to continue with matrix IOCTLs, too. But we still
> should think a little about extensibility a little bit.
> 
> How about using the same ID space as the controls do for matrices, for
> instance, so we won't get one more? The selections and controls have no ID
> collisions at the moment.

Fair enough. That certainly doesn't hurt.

> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-dev.c   |  3 ++
>>  drivers/media/v4l2-core/v4l2-ioctl.c | 23 ++++++++++++-
>>  include/media/v4l2-ioctl.h           |  8 +++++
>>  include/uapi/linux/videodev2.h       | 64 ++++++++++++++++++++++++++++++++++++
>>  4 files changed, 97 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>> index c8859d6..5e58df6 100644
>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>> @@ -598,6 +598,9 @@ static void determine_valid_ioctls(struct video_device *vdev)
>>  	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
>>  	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
>>  		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
>> +	SET_VALID_IOCTL(ops, VIDIOC_QUERY_MATRIX, vidioc_query_matrix);
>> +	SET_VALID_IOCTL(ops, VIDIOC_G_MATRIX, vidioc_g_matrix);
>> +	SET_VALID_IOCTL(ops, VIDIOC_S_MATRIX, vidioc_s_matrix);
>>  
>>  	if (is_vid) {
>>  		/* video specific ioctls */
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index 68e6b5e..47debfc 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -549,7 +549,7 @@ static void v4l_print_cropcap(const void *arg, bool write_only)
>>  	const struct v4l2_cropcap *p = arg;
>>  
>>  	pr_cont("type=%s, bounds wxh=%dx%d, x,y=%d,%d, "
>> -		"defrect wxh=%dx%d, x,y=%d,%d\n, "
>> +		"defrect wxh=%dx%d, x,y=%d,%d, "
>>  		"pixelaspect %d/%d\n",
>>  		prt_names(p->type, v4l2_type_names),
>>  		p->bounds.width, p->bounds.height,
>> @@ -831,6 +831,24 @@ static void v4l_print_freq_band(const void *arg, bool write_only)
>>  			p->rangehigh, p->modulation);
>>  }
>>  
>> +static void v4l_print_query_matrix(const void *arg, bool write_only)
>> +{
>> +	const struct v4l2_query_matrix *p = arg;
>> +
>> +	pr_cont("type=0x%x, columns=%u, rows=%u, elem_min=%lld, elem_max=%lld, elem_size=%u\n",
>> +			p->type, p->columns, p->rows,
>> +			p->elem_min.val, p->elem_max.val, p->elem_size);
>> +}
>> +
>> +static void v4l_print_matrix(const void *arg, bool write_only)
>> +{
>> +	const struct v4l2_matrix *p = arg;
>> +
>> +	pr_cont("type=0x%x, wxh=%dx%d, x,y=%d,%d, matrix=%p\n",
>> +			p->type, p->rect.width, p->rect.height,
>> +			p->rect.top, p->rect.left, p->matrix);
>> +}
>> +
>>  static void v4l_print_u32(const void *arg, bool write_only)
>>  {
>>  	pr_cont("value=%u\n", *(const u32 *)arg);
>> @@ -2055,6 +2073,9 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>>  	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
>>  	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
>>  	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
>> +	IOCTL_INFO_STD(VIDIOC_QUERY_MATRIX, vidioc_query_matrix, v4l_print_query_matrix, INFO_FL_CLEAR(v4l2_query_matrix, ref)),
>> +	IOCTL_INFO_STD(VIDIOC_G_MATRIX, vidioc_g_matrix, v4l_print_matrix, INFO_FL_CLEAR(v4l2_matrix, matrix)),
>> +	IOCTL_INFO_STD(VIDIOC_S_MATRIX, vidioc_s_matrix, v4l_print_matrix, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_matrix, matrix)),
>>  };
>>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>>  
>> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
>> index e0b74a4..7e4538e 100644
>> --- a/include/media/v4l2-ioctl.h
>> +++ b/include/media/v4l2-ioctl.h
>> @@ -271,6 +271,14 @@ struct v4l2_ioctl_ops {
>>  	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
>>  					const struct v4l2_event_subscription *sub);
>>  
>> +	/* Matrix ioctls */
>> +	int (*vidioc_query_matrix) (struct file *file, void *fh,
>> +				    struct v4l2_query_matrix *qmatrix);
>> +	int (*vidioc_g_matrix) (struct file *file, void *fh,
>> +				    struct v4l2_matrix *matrix);
>> +	int (*vidioc_s_matrix) (struct file *file, void *fh,
>> +				    struct v4l2_matrix *matrix);
>> +
>>  	/* For other private ioctls */
>>  	long (*vidioc_default)	       (struct file *file, void *fh,
>>  					bool valid_prio, unsigned int cmd, void *arg);
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 95ef455..605d295 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -1838,6 +1838,64 @@ struct v4l2_create_buffers {
>>  	__u32			reserved[8];
>>  };
>>  
>> +/* Define to which motion detection region each element belongs.
>> + * Each element is a __u8. */
>> +#define V4L2_MATRIX_T_MD_REGION     (1)
>> +/* Define the motion detection threshold for each element.
>> + * Each element is a __u16. */
>> +#define V4L2_MATRIX_T_MD_THRESHOLD  (2)
>> +
>> +/**
>> + * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
>> + * @type:	matrix type
>> + * @ref:	reference to some object (if any) owning the matrix
> 
> Is this for future extensibility only? Four __u32s don't say much to me. If
> so, how about combining this with the reserved field below?

Yes, it's for future extensibility. It shows how a feature like that could be
implemented, but I think you are right and that it should be dropped and
reserved should be increased by 4 elements.

>> + * @columns:	number of columns in the matrix
>> + * @rows:	number of rows in the matrix
> 
> Two dimensions only? How about one or three? I could imagine use for one, at
> the very least.

For one you just set rows to 1. A vector is after all a matrix of one row.
Should we need a third dimension, then there are enough reserved fields to make
that possible. I can't think of a single use-case that would require a three
dimensional matrix.
 
>> + * @elem_min:	minimum matrix element value
>> + * @elem_max:	maximum matrix element value
>> + * @elem_size:	size in bytes each matrix element
>> + * @reserved:	future extensions, applications and drivers must zero this.
>> + */
>> +struct v4l2_query_matrix {
>> +	__u32 type;
>> +	union {
>> +		__u32 raw[4];
>> +	} ref;
>> +	__u32 columns;
>> +	__u32 rows;
>> +	union {
>> +		__s64 val;
>> +		__u64 uval;
>> +		__u32 raw[4];
>> +	} elem_min;
>> +	union {
>> +		__s64 val;
>> +		__u64 uval;
>> +		__u32 raw[4];
>> +	} elem_max;
> 
> How about step; do you think it'd make sense to specify that? I have to
> admit the step in controls hasn't been extemely useful to me: much of the
> time the value of the control should have just been divided by the step,
> with the exception of controls that have a standardised unit, but even then
> step won't do good on them since there's typically no 1:1 mapping between
> possible values and the actual values which leads the driver writer choosing
> step of one.

You just explained why I decided against adding a step :-)

I also can't really see a use-case for a step in a matrix.

>> +	__u32 elem_size;
>> +	__u32 reserved[12];
>> +} __attribute__ ((packed));
>> +
>> +/**
>> + * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
>> + * @type:	matrix type
>> + * @ref:	reference to some object (if any) owning the matrix
>> + * @rect:	which part of the matrix to get/set
> 
> In some cases it might be possible to choose the size of the matrix. If this
> isn't supported now, do you have ideas how to add it? Perhaps using rect
> woulnd't be possible. A new IOCTL could be one possibility as well; that'd
> make it quite clear and drivers not supporting it wouldn't implement it. I
> think it might quite well make it together with S_MATRIX, though, e.g. a
> flags field with a flag telling that the dimension fields are valid.

Would it be an idea to add a flags field to both v4l2_matrix and v4l2_query_matrix?
We don't have flags yet, but that makes it easy to add. For a feature such as you
describe it would be easy enough to implement that by setting an e.g.
V4L2_MATRIX_FL_NEW_SIZE flag. In query_matrix you would than have a
V4L2_QMATRIX_FL_HAS_NEW_SIZE (or perhaps in query_matrix it should be called
'capabilities' instead).

I can also just leave it out and use one of the reserved fields when such a feature
is needed.

>> + * @matrix:	pointer to the matrix of size (in bytes):
>> + *		elem_size * rect.width * rect.height
>> + * @reserved:	future extensions, applications and drivers must zero this.
>> + */
>> +struct v4l2_matrix {
>> +	__u32 type;
>> +	union {
>> +		__u32 raw[4];
>> +	} ref;
>> +	struct v4l2_rect rect;
>> +	void __user *matrix;
>> +	__u32 reserved[12];
>> +} __attribute__ ((packed));
>> +
>>  /*
>>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>>   *
>> @@ -1946,6 +2004,12 @@ struct v4l2_create_buffers {
>>     Never use these in applications! */
>>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
>>  
>> +/* Experimental, these three ioctls may change over the next couple of kernel
>> +   versions. */
>> +#define VIDIOC_QUERY_MATRIX	_IOWR('V', 103, struct v4l2_query_matrix)
>> +#define VIDIOC_G_MATRIX		_IOWR('V', 104, struct v4l2_matrix)
>> +#define VIDIOC_S_MATRIX		_IOWR('V', 105, struct v4l2_matrix)
>> +
>>  /* Reminder: when adding new ioctls please add support for them to
>>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>>  
> 

Thanks for the review!

I'll prepare a new version this weekend dropping the ref fields and integrating the ID
space into that of the controls.

Regards,

	Hans
