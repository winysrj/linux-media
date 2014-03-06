Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2734 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCFH0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 02:26:22 -0500
Message-ID: <53182313.8090200@xs4all.nl>
Date: Thu, 06 Mar 2014 08:26:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 2/4] v4l2: add VIDIOC_G/S_EDID support to the v4l2
 core.
References: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl> <a108c13f6c3ae6c224a0fceadd1ba83e92d6f074.1393932339.git.hans.verkuil@cisco.com> <1798397.6pcHtiyYvU@avalon>
In-Reply-To: <1798397.6pcHtiyYvU@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for your comments!

On 03/06/2014 02:41 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Tuesday 04 March 2014 12:30:57 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Support this ioctl as part of the v4l2 core. Use the new ioctl
>> name and struct v4l2_edid type in the existing core code.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 32 ++++++++++++------------
>>  drivers/media/v4l2-core/v4l2-dev.c            |  2 ++
>>  drivers/media/v4l2-core/v4l2-ioctl.c          | 16 +++++++++++---
>>  drivers/media/v4l2-core/v4l2-subdev.c         |  4 ++--
>>  include/media/v4l2-ioctl.h                    |  2 ++
>>  include/media/v4l2-subdev.h                   |  4 ++--
>>  6 files changed, 37 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index 1b18616..6463c87
>> 100644
>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> @@ -740,7 +740,7 @@ static int put_v4l2_event32(struct v4l2_event *kp,
>> struct v4l2_event32 __user *u return 0;
>>  }
>>
>> -struct v4l2_subdev_edid32 {
>> +struct v4l2_edid32 {
>>  	__u32 pad;
>>  	__u32 start_block;
>>  	__u32 blocks;
>> @@ -748,11 +748,11 @@ struct v4l2_subdev_edid32 {
>>  	compat_caddr_t edid;
>>  };
>>
>> -static int get_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct
>> v4l2_subdev_edid32 __user *up) +static int get_v4l2_edid32(struct v4l2_edid
>> *kp, struct v4l2_edid32 __user *up) {
>>  	u32 tmp;
>>
>> -	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_subdev_edid32)) ||
>> +	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_edid32)) ||
>>  		get_user(kp->pad, &up->pad) ||
>>  		get_user(kp->start_block, &up->start_block) ||
>>  		get_user(kp->blocks, &up->blocks) ||
>> @@ -763,11 +763,11 @@ static int get_v4l2_subdev_edid32(struct
>> v4l2_subdev_edid *kp, struct v4l2_subde return 0;
>>  }
>>
>> -static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct
>> v4l2_subdev_edid32 __user *up) +static int put_v4l2_edid32(struct v4l2_edid
>> *kp, struct v4l2_edid32 __user *up) {
>>  	u32 tmp = (u32)((unsigned long)kp->edid);
>>
>> -	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_subdev_edid32)) ||
>> +	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_edid32)) ||
>>  		put_user(kp->pad, &up->pad) ||
>>  		put_user(kp->start_block, &up->start_block) ||
>>  		put_user(kp->blocks, &up->blocks) ||
>> @@ -787,8 +787,8 @@ static int put_v4l2_subdev_edid32(struct
>> v4l2_subdev_edid *kp, struct v4l2_subde #define VIDIOC_DQBUF32		
> _IOWR('V',
>> 17, struct v4l2_buffer32)
>>  #define VIDIOC_ENUMSTD32	_IOWR('V', 25, struct v4l2_standard32)
>>  #define VIDIOC_ENUMINPUT32	_IOWR('V', 26, struct v4l2_input32)
>> -#define VIDIOC_SUBDEV_G_EDID32	_IOWR('V', 63, struct v4l2_subdev_edid32)
>> -#define VIDIOC_SUBDEV_S_EDID32	_IOWR('V', 64, struct v4l2_subdev_edid32)
>> +#define VIDIOC_G_EDID32		_IOWR('V', 63, struct v4l2_edid32)
>> +#define VIDIOC_S_EDID32		_IOWR('V', 64, struct v4l2_edid32)
> 
> Shouldn't the ioctl numbers be 40 and 41 ?

Oh, for crying out loud. That's been wrong since these ioctls were first added
in 3.7. I'll split this off as a patch for 3.14 with a CC to stable.

Well spotted!

> 
>>  #define VIDIOC_TRY_FMT32      	_IOWR('V', 64, struct v4l2_format32)
>>  #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
>>  #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
>> @@ -816,7 +816,7 @@ static long do_video_ioctl(struct file *file, unsigned
>> int cmd, unsigned long ar struct v4l2_ext_controls v2ecs;
>>  		struct v4l2_event v2ev;
>>  		struct v4l2_create_buffers v2crt;
>> -		struct v4l2_subdev_edid v2edid;
>> +		struct v4l2_edid v2edid;
>>  		unsigned long vx;
>>  		int vi;
>>  	} karg;
>> @@ -849,8 +849,8 @@ static long do_video_ioctl(struct file *file, unsigned
>> int cmd, unsigned long ar case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT;
>> break;
>>  	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
>>  	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
>> -	case VIDIOC_SUBDEV_G_EDID32: cmd = VIDIOC_SUBDEV_G_EDID; break;
>> -	case VIDIOC_SUBDEV_S_EDID32: cmd = VIDIOC_SUBDEV_S_EDID; break;
>> +	case VIDIOC_G_EDID32: cmd = VIDIOC_G_EDID; break;
>> +	case VIDIOC_S_EDID32: cmd = VIDIOC_S_EDID; break;
>>  	}
>>
>>  	switch (cmd) {
>> @@ -868,9 +868,9 @@ static long do_video_ioctl(struct file *file, unsigned
>> int cmd, unsigned long ar compatible_arg = 0;
>>  		break;
>>
>> -	case VIDIOC_SUBDEV_G_EDID:
>> -	case VIDIOC_SUBDEV_S_EDID:
>> -		err = get_v4l2_subdev_edid32(&karg.v2edid, up);
>> +	case VIDIOC_G_EDID:
>> +	case VIDIOC_S_EDID:
>> +		err = get_v4l2_edid32(&karg.v2edid, up);
>>  		compatible_arg = 0;
>>  		break;
>>
>> @@ -966,9 +966,9 @@ static long do_video_ioctl(struct file *file, unsigned
>> int cmd, unsigned long ar err = put_v4l2_event32(&karg.v2ev, up);
>>  		break;
>>
>> -	case VIDIOC_SUBDEV_G_EDID:
>> -	case VIDIOC_SUBDEV_S_EDID:
>> -		err = put_v4l2_subdev_edid32(&karg.v2edid, up);
>> +	case VIDIOC_G_EDID:
>> +	case VIDIOC_S_EDID:
>> +		err = put_v4l2_edid32(&karg.v2edid, up);
>>  		break;
>>
>>  	case VIDIOC_G_FMT:
>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c
>> b/drivers/media/v4l2-core/v4l2-dev.c index 0a30dbf..b61bc68 100644
>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>> @@ -693,6 +693,7 @@ static void determine_valid_ioctls(struct video_device
>> *vdev) SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDOUT, vidioc_enumaudout);
>>  			SET_VALID_IOCTL(ops, VIDIOC_G_AUDOUT, vidioc_g_audout);
>>  			SET_VALID_IOCTL(ops, VIDIOC_S_AUDOUT, vidioc_s_audout);
>> +			SET_VALID_IOCTL(ops, VIDIOC_S_EDID, vidioc_s_edid);
> 
> Shouldn't VIDIOC_S_EDID be enabled for rx devices, not tx devices ?

Yes indeed. That's embarrassing...

> 
>>  		}
>>  		if (ops->vidioc_g_crop || ops->vidioc_g_selection)
>>  			set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
>> @@ -710,6 +711,7 @@ static void determine_valid_ioctls(struct video_device
>> *vdev) SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
>> SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
>> SET_VALID_IOCTL(ops, VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap);
>> +		SET_VALID_IOCTL(ops, VIDIOC_G_EDID, vidioc_g_edid);
>>  	}
>>  	if (is_tx) {
>>  		/* transmitter only ioctls */
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
>> b/drivers/media/v4l2-core/v4l2-ioctl.c index 707aef7..26b4c5b 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -834,6 +834,14 @@ static void v4l_print_freq_band(const void *arg, bool
>> write_only) p->rangehigh, p->modulation);
>>  }
>>
>> +static void v4l_print_edid(const void *arg, bool write_only)
>> +{
>> +	const struct v4l2_edid *p = arg;
>> +
>> +	pr_cont("pad=%u, start_block=%u, blocks=%u\n",
>> +			p->pad, p->start_block, p->blocks);
> 
> Extra tab ?

I'll remove it.

> 
>> +}
>> +
>>  static void v4l_print_u32(const void *arg, bool write_only)
>>  {
>>  	pr_cont("value=%u\n", *(const u32 *)arg);
>> @@ -2009,6 +2017,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>>  	IOCTL_INFO_FNC(VIDIOC_QUERYMENU, v4l_querymenu, v4l_print_querymenu,
>> INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
>> IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
>> IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
>> +	IOCTL_INFO_STD(VIDIOC_G_EDID, vidioc_g_edid, v4l_print_edid,
>> INFO_FL_CLEAR(v4l2_edid, edid)),
>> +	IOCTL_INFO_STD(VIDIOC_S_EDID, vidioc_s_edid, v4l_print_edid, INFO_FL_PRIO
>> | INFO_FL_CLEAR(v4l2_edid, edid)),
>> IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
>> IOCTL_INFO_FNC(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32, INFO_FL_PRIO),
>> IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput,
>> INFO_FL_CLEAR(v4l2_output, index)),
>> @@ -2221,9 +2231,9 @@ static int
>> check_array_args(unsigned int cmd, void *parg, size_t *array_size, break;
>>  	}
>>
>> -	case VIDIOC_SUBDEV_G_EDID:
>> -	case VIDIOC_SUBDEV_S_EDID: {
>> -		struct v4l2_subdev_edid *edid = parg;
>> +	case VIDIOC_G_EDID:
>> +	case VIDIOC_S_EDID: {
>> +		struct v4l2_edid *edid = parg;
>>
>>  		if (edid->blocks) {
>>  			if (edid->blocks > 256) {
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
>> b/drivers/media/v4l2-core/v4l2-subdev.c index 60d2550..aea84ac 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -349,10 +349,10 @@ static long subdev_do_ioctl(struct file *file,
>> unsigned int cmd, void *arg) sd, pad, set_selection, subdev_fh, sel);
>>  	}
>>
>> -	case VIDIOC_SUBDEV_G_EDID:
>> +	case VIDIOC_G_EDID:
>>  		return v4l2_subdev_call(sd, pad, get_edid, arg);
>>
>> -	case VIDIOC_SUBDEV_S_EDID:
>> +	case VIDIOC_S_EDID:
>>  		return v4l2_subdev_call(sd, pad, set_edid, arg);
>>  #endif
>>  	default:
>> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
>> index e0b74a4..c362756 100644
>> --- a/include/media/v4l2-ioctl.h
>> +++ b/include/media/v4l2-ioctl.h
>> @@ -265,6 +265,8 @@ struct v4l2_ioctl_ops {
>>  				    struct v4l2_enum_dv_timings *timings);
>>  	int (*vidioc_dv_timings_cap) (struct file *file, void *fh,
>>  				    struct v4l2_dv_timings_cap *cap);
>> +	int (*vidioc_g_edid) (struct file *file, void *fh, struct v4l2_edid
>> *edid);
>> +	int (*vidioc_s_edid) (struct file *file, void *fh, struct v4l2_edid
>> *edid);
>>
>>  	int (*vidioc_subscribe_event)  (struct v4l2_fh *fh,
>>  					const struct v4l2_event_subscription *sub);
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 1752530..855c928 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -507,8 +507,8 @@ struct v4l2_subdev_pad_ops {
>>  			     struct v4l2_subdev_selection *sel);
>>  	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>>  			     struct v4l2_subdev_selection *sel);
>> -	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
>> -	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
>> +	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_edid *edid);
>> +	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_edid *edid);
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>  	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
>>  			     struct v4l2_subdev_format *source_fmt,
> 

Thanks!

	Hans
