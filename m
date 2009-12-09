Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757147AbZLISsM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 13:48:12 -0500
Message-ID: <4B1FF0ED.9080701@redhat.com>
Date: Wed, 09 Dec 2009 16:48:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 07/11] add video file for tlg2300
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com> <1258687493-4012-2-git-send-email-shijie8@gmail.com> <1258687493-4012-3-git-send-email-shijie8@gmail.com> <1258687493-4012-4-git-send-email-shijie8@gmail.com> <1258687493-4012-5-git-send-email-shijie8@gmail.com> <1258687493-4012-6-git-send-email-shijie8@gmail.com> <1258687493-4012-7-git-send-email-shijie8@gmail.com> <1258687493-4012-8-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-8-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> pd-video.c and pd-bufqueue.c contain the code for V4L2 implementation.
> The code support read,mmap and user pointer.
> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/media/video/tlg2300/pd-bufqueue.c |  185 ++++
>  drivers/media/video/tlg2300/pd-video.c    | 1636 +++++++++++++++++++++++++++++
>  2 files changed, 1821 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tlg2300/pd-bufqueue.c
>  create mode 100644 drivers/media/video/tlg2300/pd-video.c
> 
> diff --git a/drivers/media/video/tlg2300/pd-bufqueue.c b/drivers/media/video/tlg2300/pd-bufqueue.c
> new file mode 100644
> index 0000000..6106fbd
> --- /dev/null
> +++ b/drivers/media/video/tlg2300/pd-bufqueue.c
> @@ -0,0 +1,185 @@
> +#include "pd-common.h"
> +#include <linux/sched.h>
> +#include <linux/vmalloc.h>
> +#include <linux/uaccess.h>
> +#include <linux/poll.h>
> +#include <linux/mm.h>
> +
> +void pd_bufqueue_wakeup(struct pd_bufqueue *queue)
> +{
> +	if (waitqueue_active(&queue->queue_wq))
> +		wake_up_interruptible(&queue->queue_wq);
> +}
> +
> +int pd_bufqueue_qbuf(struct pd_bufqueue *q, int index)
> +{
> +	unsigned long lock_flags;
> +	struct pd_frame *f;
> +
> +	if (index < 0 || index >= q->buf_count)
> +		return -EINVAL;
> +	f = &q->frame_buffer[index];
> +
> +	spin_lock_irqsave(&q->queue_lock, lock_flags);
> +	if (list_empty(&f->frame))
> +		list_add_tail(&f->frame, &q->inqueue);
> +	spin_unlock_irqrestore(&q->queue_lock, lock_flags);
> +	return 0;
> +}
> +
> +int pd_bufqueue_dqbuf(struct pd_bufqueue *q, unsigned int f_flags,
> +			struct pd_frame **pd_frame)
> +{
> +	unsigned long lock_flags;
> +	int retval = -EAGAIN;
> +
> +	if (list_empty(&q->outqueue)) {
> +		if (f_flags & O_NONBLOCK)
> +			return -EAGAIN;
> +
> +		retval = wait_event_interruptible_timeout(q->queue_wq,
> +				!(list_empty(&q->outqueue)), HZ/2);
> +		if (retval < 0)
> +			return retval;
> +		else if (retval == 0)
> +			return -EAGAIN;
> +	}
> +
> +	spin_lock_irqsave(&q->queue_lock, lock_flags);
> +	if (!list_empty(&q->outqueue)) {
> +		*pd_frame = list_entry(q->outqueue.next,
> +					struct pd_frame, frame);
> +		list_del_init(&(*pd_frame)->frame);
> +		retval = 0;
> +	}
> +	spin_unlock_irqrestore(&q->queue_lock, lock_flags);
> +
> +	return retval;
> +}
> +
> +ssize_t pd_bufqueue_poll(struct pd_bufqueue *queue, struct file *file,
> +			poll_table *wait)
> +{
> +	if (list_empty(&queue->outqueue))
> +		poll_wait(file, &queue->queue_wq, wait);
> +
> +	if (!list_empty(&queue->outqueue))
> +		return POLLIN|POLLRDNORM;
> +	return 0;
> +}
> +
> +ssize_t pd_bufqueue_read(struct pd_bufqueue *queue, unsigned int f_flags,
> +			char __user *buf, size_t count)
> +{
> +	int rc, retval = 0, copy = 0;
> +	struct pd_frame *pd_frame = NULL;
> +	unsigned long retn ;
> +
> +	if (!queue->is_reading)
> +		queue->is_reading = 1;
> +
> +	while (count > 0) {
> +		if (!queue->read_frame) {
> +			retval = pd_bufqueue_dqbuf(queue,
> +					f_flags, &queue->read_frame);
> +			if (retval < 0)
> +				goto readout;
> +		}
> +		pd_frame = queue->read_frame;
> +
> +		rc = min(pd_frame->bytesused - queue->read_offset, count);
> +		retn = copy_to_user(buf + copy,
> +				pd_frame->data + queue->read_offset, rc);
> +		if (retn > 0)
> +			;
> +		count -= rc;
> +		queue->read_offset += rc;
> +		copy += rc;
> +
> +		if (queue->read_offset == pd_frame->bytesused) {
> +			pd_bufqueue_qbuf(queue, pd_frame->index);
> +			queue->read_frame = NULL;
> +			queue->read_offset = 0;
> +		}
> +	}
> +readout:
> +	return copy ? copy : retval;
> +}
> +
> +void pd_bufqueue_cleanup(struct pd_bufqueue *queue)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < queue->buf_count; i++) {
> +		if (queue->frame_buffer[i].data) {
> +			if (KERNEL_MEM == queue->mtype)
> +				kfree(queue->frame_buffer[i].data);
> +			else
> +				vfree(queue->frame_buffer[i].data);
> +
> +			queue->frame_buffer[i].data = NULL;
> +		}
> +	}
> +}
> +
> +void pd_bufqueue_init(struct pd_bufqueue *queue, unsigned int *buf_count,
> +			unsigned int buf_length, enum mem_type type)
> +{
> +	unsigned int i, count, alignedsize;
> +
> +	if (queue->frame_buffer[0].data) {
> +		if (buf_length > queue->buf_length) {
> +			pd_bufqueue_cleanup(queue);
> +		} else {
> +			*buf_count = queue->buf_count;
> +			goto init_out;
> +		}
> +	}
> +	memset(queue, 0, sizeof(*queue));
> +	queue->buf_length = buf_length;
> +
> +	count = (*buf_count > MAX_BUFFER_NUM) ? MAX_BUFFER_NUM : *buf_count;
> +	alignedsize = PAGE_ALIGN(buf_length);
> +
> +	for (i = 0; i < count; i++) {
> +		void *mem;
> +
> +		if (KERNEL_MEM == type)
> +			mem = kcalloc(1, alignedsize, GFP_KERNEL);
> +		else
> +			mem = vmalloc_user(alignedsize);
> +
> +		if (!mem)
> +			break;
> +		queue->frame_buffer[i].data = mem;
> +		queue->frame_buffer[i].index = i;
> +		INIT_LIST_HEAD(&queue->frame_buffer[i].frame);
> +	}
> +	queue->buf_count = *buf_count = i;
> +	queue->mtype	= type;
> +
> +init_out:
> +	spin_lock_init(&queue->queue_lock);
> +	INIT_LIST_HEAD(&queue->inqueue);
> +	INIT_LIST_HEAD(&queue->outqueue);
> +	init_waitqueue_head(&queue->queue_wq);
> +}
> +
> +void reset_queue_stat(struct pd_bufqueue *q)
> +{
> +	unsigned long flags;
> +	struct pd_frame *f = &q->frame_buffer[0];
> +
> +	spin_lock_irqsave(&(q->queue_lock), flags);
> +	for (; f < &q->frame_buffer[MAX_BUFFER_NUM]; f++) {
> +		INIT_LIST_HEAD(&f->frame);
> +		f->index = f - &q->frame_buffer[0];
> +	}
> +	INIT_LIST_HEAD(&q->inqueue);
> +	INIT_LIST_HEAD(&q->outqueue);
> +	q->read_frame = NULL;
> +	q->curr_frame = NULL;
> +	q->read_offset = 0;
> +
> +	spin_unlock_irqrestore(&(q->queue_lock), flags);
> +}


It would be much better if you use videobuf-vmalloc, expanding it if needed.


> diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
> new file mode 100644
> index 0000000..f9f6e19
> --- /dev/null
> +++ b/drivers/media/video/tlg2300/pd-video.c
> @@ -0,0 +1,1636 @@
> +#include "pd-common.h"
> +#include "vendorcmds.h"
> +#include <media/v4l2-dev.h>
> +#include <linux/fs.h>
> +#include <linux/vmalloc.h>
> +#include <linux/videodev2.h>
> +#include <linux/usb.h>
> +#include <linux/mm.h>
> +#include <media/v4l2-ioctl.h>
> +#include <linux/sched.h>
> +
> +static int pd_video_release(struct file *file);
> +static int pd_video_open(struct file *file);
> +static int pm_video_open(struct file *file);
> +static int __pd_video_release(struct file *file);
> +static int pm_video_suspend(struct poseidon *pd);
> +static int pm_video_resume(struct poseidon *pd);
> +static void iso_bubble_handler(struct work_struct *w);
> +
> +int country_code = 86;
> +module_param(country_code, int, 0644);
> +MODULE_PARM_DESC(country_code, "country code (e.g China is 86)");

Huh? You shouldn't be using a country code. The driver should decide the
proper encoding based on the video stanadard.

> +
> +int usb_transfer_mode;
> +module_param(usb_transfer_mode, int, 0644);
> +MODULE_PARM_DESC(usb_transfer_mode, "0 = bulk, 1 = iscchronous");
> +
> +/*
> + * Drop frames if the hardware is not power enough
> + * and the default is the normal mode.
> + */
> +int drop_frame;
> +module_param(drop_frame, int, 0644);
> +MODULE_PARM_DESC(drop_frame, "0 = normal, 1 = drop frame");
> +
> +#define DROP_MODE	(1)
> +#define FRAME_MAX_SIZE (720*576*2)
> +#define ISO_PKT_SIZE	(3072)
> +
> +static const struct poseidon_format poseidon_formats[] = {
> +	{ "YUV 422", V4L2_PIX_FMT_YUYV, 16, 0},
> +	{ "RGB565", V4L2_PIX_FMT_RGB565, 16, 0},
> +};
> +static const unsigned int POSEIDON_FORMATS = ARRAY_SIZE(poseidon_formats);
> +
> +#define tv(id, _name, w, h, cmd)	\
> +	{				\
> +		.v4l2_id	= id,	\
> +		.name 		= _name,	\
> +		.swidth 	= w,	\
> +		.sheight 	= h,	\
> +		.tlg_tvnorm 	= cmd,	\
> +	 }
> +
> +static const struct poseidon_tvnorm poseidon_tvnorms[] = {
> +	tv(V4L2_STD_PAL_D, "PAL-D", 720, 576, TLG_TUNE_VSTD_PAL_D),
> +	tv(V4L2_STD_PAL_B, "PAL-B", 720, 576, TLG_TUNE_VSTD_PAL_B),
> +	tv(V4L2_STD_PAL_G, "PAL-G", 720, 576, TLG_TUNE_VSTD_PAL_G),
> +	tv(V4L2_STD_PAL_H, "PAL-H", 720, 576, TLG_TUNE_VSTD_PAL_H),
> +	tv(V4L2_STD_PAL_I, "PAL-I", 720, 576, TLG_TUNE_VSTD_PAL_I),
> +	tv(V4L2_STD_PAL_M, "PAL-M", 720, 480, TLG_TUNE_VSTD_PAL_M),
> +	tv(V4L2_STD_PAL_N, "PAL-N", 720, 576, TLG_TUNE_VSTD_PAL_N_COMBO),
> +	tv(V4L2_STD_PAL_Nc, "PAL-Nc", 720, 576, TLG_TUNE_VSTD_PAL_N_COMBO),
> +	tv(V4L2_STD_NTSC_M, "NTSC-M", 720, 480, TLG_TUNE_VSTD_NTSC_M),
> +	tv(V4L2_STD_NTSC_M_JP, "NTSC-JP", 720, 480, TLG_TUNE_VSTD_NTSC_M_J),
> +	tv(V4L2_STD_SECAM_B, "SECAM-B", 720, 576, TLG_TUNE_VSTD_SECAM_B),
> +	tv(V4L2_STD_SECAM_D, "SECAM-D", 720, 576, TLG_TUNE_VSTD_SECAM_D),
> +	tv(V4L2_STD_SECAM_G, "SECAM-G", 720, 576, TLG_TUNE_VSTD_SECAM_G),
> +	tv(V4L2_STD_SECAM_H, "SECAM-H", 720, 576, TLG_TUNE_VSTD_SECAM_H),
> +	tv(V4L2_STD_SECAM_K, "SECAM-K", 720, 576, TLG_TUNE_VSTD_SECAM_K),
> +	tv(V4L2_STD_SECAM_K1, "SECAM-K1", 720, 576, TLG_TUNE_VSTD_SECAM_K1),
> +	tv(V4L2_STD_SECAM_L, "SECAM-L", 720, 576, TLG_TUNE_VSTD_SECAM_L),
> +	tv(V4L2_STD_SECAM_LC, "SECAM-LC", 720, 576, TLG_TUNE_VSTD_SECAM_L1),
> +};

This is also ugly and completely uneeded. Just use V4L2_STD on all places. If
you want to know how many lines, you just need to do something like:

	lines = (std && V4L2_STD_625_50) ? 576: 480;


> +static const unsigned int POSEIDON_TVNORMS = ARRAY_SIZE(poseidon_tvnorms);
> +
> +#define PD_TVNORMS_SUPPORT (V4L2_STD_PAL_D | V4L2_STD_PAL_B | V4L2_STD_PAL_G \
> +		| V4L2_STD_PAL_H | V4L2_STD_PAL_I |  V4L2_STD_PAL_M \
> +		| V4L2_STD_PAL_N | V4L2_STD_PAL_Nc | V4L2_STD_NTSC_M \
> +		| V4L2_STD_NTSC_M_JP | V4L2_STD_SECAM_B | V4L2_STD_SECAM_D \
> +		| V4L2_STD_SECAM_G | V4L2_STD_SECAM_H | V4L2_STD_SECAM_K \
> +		| V4L2_STD_SECAM_K1 | V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC)
> +
> +struct pd_audio_mode {
> +	u32 tlg_audio_mode;
> +	u32 v4l2_audio_sub;
> +	u32 v4l2_audio_mode;
> +};
> +
> +static const struct pd_audio_mode pd_audio_modes[] = {
> +	{ TLG_TUNE_TVAUDIO_MODE_MONO, V4L2_TUNER_SUB_MONO,
> +		V4L2_TUNER_MODE_MONO },
> +	{ TLG_TUNE_TVAUDIO_MODE_STEREO, V4L2_TUNER_SUB_STEREO,
> +		V4L2_TUNER_MODE_STEREO },
> +	{ TLG_TUNE_TVAUDIO_MODE_LANG_A, V4L2_TUNER_SUB_LANG1,
> +		V4L2_TUNER_MODE_LANG1 },
> +	{ TLG_TUNE_TVAUDIO_MODE_LANG_B, V4L2_TUNER_SUB_LANG2,
> +		V4L2_TUNER_MODE_LANG2 },
> +	{ TLG_TUNE_TVAUDIO_MODE_LANG_C, V4L2_TUNER_SUB_LANG1,
> +		V4L2_TUNER_MODE_LANG1_LANG2 }
> +};

Why don't you directly use V4L2_TUNER?

> +static const unsigned int POSEIDON_AUDIOMODS = ARRAY_SIZE(pd_audio_modes);
> +
> +struct pd_input {
> +	char *name;
> +	uint32_t tlg_src;
> +};
> +
> +static const struct pd_input pd_inputs[] = {
> +	{ "TV Antenna", TLG_SIG_SRC_ANTENNA },
> +	{ "TV Cable", TLG_SIG_SRC_CABLE },
> +	{ "TV SVideo", TLG_SIG_SRC_SVIDEO },
> +	{ "TV Composite", TLG_SIG_SRC_COMPOSITE }
> +};
> +static const unsigned int POSEIDON_INPUTS = ARRAY_SIZE(pd_inputs);
> +
> +struct poseidon_control {
> +	struct v4l2_queryctrl v4l2_ctrl;
> +	enum cmd_custom_param_id vc_id;
> +};
> +
> +static struct poseidon_control controls[] = {
> +	{
> +		{ V4L2_CID_BRIGHTNESS, V4L2_CTRL_TYPE_INTEGER,
> +			"brightness", 0, 10000, 1, 100, 0, },
> +		CUST_PARM_ID_BRIGHTNESS_CTRL
> +	},
> +
> +	{
> +		{ V4L2_CID_CONTRAST, V4L2_CTRL_TYPE_INTEGER,
> +			"contrast", 0, 10000, 1, 100, 0, },
> +		CUST_PARM_ID_CONTRAST_CTRL,
> +	},
> +
> +	{
> +		{ V4L2_CID_HUE, V4L2_CTRL_TYPE_INTEGER,
> +			"hue", 0, 10000, 1, 100, 0, },
> +		CUST_PARM_ID_HUE_CTRL,
> +	},
> +
> +	{
> +		{ V4L2_CID_SATURATION, V4L2_CTRL_TYPE_INTEGER,
> +			"saturation", 0, 10000, 1, 100, 0, },
> +		CUST_PARM_ID_SATURATION_CTRL,
> +	},
> +};
> +
> +static struct v4l2_format default_v4l2_format = {
> +	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +	.fmt.pix = {
> +		.width		= 720,
> +		.height		= 576,
> +		.pixelformat	= V4L2_PIX_FMT_YUYV,
> +		.field		= V4L2_FIELD_INTERLACED,
> +		.bytesperline	= 720 * 2,
> +		.sizeimage	= 720 * 576 * 2,
> +		.colorspace	= V4L2_COLORSPACE_SMPTE170M,
> +		.priv		= 0
> +	}
> +};

> +
> +static int vidioc_querycap(struct file *file, void *fh,
> +			struct v4l2_capability *cap)
> +{
> +	strcpy(cap->driver, "Telegent Driver");
> +	strcpy(cap->card, "Telegent Poseidon");
> +	strcpy(cap->bus_info, "USB Bus");

Bus info is wrong. It should be generated by something like:

        usb_make_path(dev, cap->bus_info, sizeof(cap->bus_info));

> +	cap->version = 0;

You should use:
	cap->version = KERNEL_VERSION(0, 0, 1)


> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
> +				V4L2_CAP_AUDIO | V4L2_CAP_STREAMING |
> +				V4L2_CAP_READWRITE;

As you have VBI support, you need also V4L2_CAP_VBI_CAPTURE



> +	return 0;
> +}
> +
> +/*====================================================================*/
> +static void init_copy(struct video_data *video, bool index)
> +{
> +	video->field_count	= index;
> +	video->lines_copied	= 0;
> +	video->prev_left	= 0 ;
> +	video->dst 		= (char *)video->video_queue.curr_frame->data
> +					+ index * video->lines_size;
> +	video->vbi->copied 	= 0; /* set it here */
> +}
> +
> +static bool get_frame(struct pd_bufqueue *q, int *need_init)
> +{
> +	if (q->curr_frame)
> +		return true;
> +
> +	spin_lock(&q->queue_lock);
> +	if (!list_empty(&q->inqueue)) {
> +		q->curr_frame = list_entry(q->inqueue.next,
> +						struct pd_frame, frame);
> +		list_del_init(&q->curr_frame->frame);
> +		if (need_init)
> +			*need_init = 1;
> +	}
> +	spin_unlock(&q->queue_lock);
> +
> +	return !!q->curr_frame;
> +
> +}
> +
> +/* check if the video's buffer is ready */
> +static bool get_video_frame(struct video_data *video)
> +{
> +	struct pd_bufqueue *q = &video->video_queue;
> +	int need_init = 0;
> +	bool ret = true;
> +
> +	ret = get_frame(q, &need_init);
> +	if (need_init)
> +		init_copy(video, 0);
> +	return ret;
> +}
> +
> +static void put_back_frame(struct pd_bufqueue *q)
> +{
> +
> +	if (q->curr_frame == NULL)
> +		return;
> +
> +	spin_lock(&q->queue_lock);
> +	list_add_tail(&q->curr_frame->frame, &q->outqueue);
> +	q->curr_frame = NULL;
> +	spin_unlock(&q->queue_lock);
> +
> +	if (waitqueue_active(&q->queue_wq))
> +		wake_up_interruptible(&q->queue_wq);
> +}
> +
> +static void end_field(struct video_data *video)
> +{
> +	if (DROP_MODE == drop_frame) {
> +		int i = 0;
> +		char *buf = (char *)video->video_queue.curr_frame->data;
> +		int size = video->lines_size;
> +
> +		for (; i < video->lines_per_field; i++, buf += size * 2)
> +			memcpy(buf + size, buf, size);
> +
> +		put_back_frame(&video->video_queue);
> +		return;
> +	}
> +
> +	if (1 == video->field_count)
> +		put_back_frame(&video->video_queue);
> +	else
> +		init_copy(video, 1);
> +}
> +
> +static void copy_video_data(struct video_data *video, char *src,
> +				unsigned int count)
> +{
> +#define copy_data(len)  \
> +	do { \
> +		if (++video->lines_copied > video->lines_per_field) \
> +			goto overflow; \
> +		memcpy(video->dst, src, len);\
> +		video->dst += len + video->lines_size; \
> +		src += len; \
> +		count -= len; \
> +	 } while (0)
> +
> +	while (count && count >= video->lines_size) {
> +		if (video->prev_left) {
> +			copy_data(video->prev_left);
> +			video->prev_left = 0;
> +			continue;
> +		}
> +		copy_data(video->lines_size);
> +	}
> +	if (count && count < video->lines_size) {
> +		memcpy(video->dst, src, count);
> +
> +		video->prev_left = video->lines_size - count;
> +		video->dst += count;
> +	}
> +	return;
> +
> +overflow:
> +	end_field(video);
> +}
> +
> +static void check_trailer(struct video_data *video, char *src, int count)
> +{
> +	struct vbi_data *vbi = video->vbi;
> +	int offset; /* trailer's offset */
> +	char *buf;
> +
> +	offset = (video->cur_format.fmt.pix.sizeimage / 2 + video->vbi_size)
> +		- (vbi->copied + video->lines_size * video->lines_copied);
> +	if (video->prev_left)
> +		offset -= (video->lines_size - video->prev_left);
> +
> +	if (offset > count || offset <= 0)
> +		goto short_package;
> +
> +	buf = src + offset;
> +
> +	/* trailer : (VFHS) + U32 + U32 + field_num */
> +	if (!strncmp(buf, "VFHS", 4)) {
> +		int field_num = *((u32 *)(buf + 12));
> +
> +		if ((field_num & 1) ^ video->field_count) {
> +			init_copy(video, video->field_count);
> +			return;
> +		}
> +		copy_video_data(video, src, offset);
> +	}
> +short_package:
> +	end_field(video);
> +}
> +
> +static inline void copy_vbi_data(struct vbi_data *vbi,
> +				char *src, unsigned int count)
> +{
> +	if (get_frame(&vbi->vbi_queue, NULL)) {
> +		char *buf = vbi->vbi_queue.curr_frame->data;
> +
> +		if (vbi->video->field_count)
> +			buf += vbi->video->vbi_size;
> +		memcpy(buf + vbi->copied, src, count);
> +	}
> +	vbi->copied += count;
> +}
> +
> +/*
> + * Copy the normal data (VBI or VIDEO) without the trailer.
> + * VBI is not interlaced, while VIDEO is interlaced.
> + */
> +static inline void copy_vbi_video_data(struct video_data *video,
> +				char *src, unsigned int count)
> +{
> +	struct vbi_data *vbi = video->vbi;
> +	unsigned int vbi_delta = video->vbi_size - vbi->copied;
> +
> +	if (vbi_delta >= count) {
> +		copy_vbi_data(vbi, src, count);
> +	} else {
> +		if (vbi_delta) {
> +			copy_vbi_data(vbi, src, vbi_delta);
> +			put_back_frame(&vbi->vbi_queue);
> +		}
> +		copy_video_data(video, src + vbi_delta, count - vbi_delta);
> +	}
> +}
> +
> +static void urb_complete_bulk(struct urb *urb)
> +{
> +	struct video_data *video = urb->context;
> +	char *src = (char *)urb->transfer_buffer;
> +	int count = urb->actual_length;
> +	int ret = 0;
> +
> +	if (!video->is_streaming || urb->status) {
> +		if (urb->status == -EPROTO)
> +			goto resend_it;
> +		return;
> +	}
> +
> +	if (!get_video_frame(video))
> +		goto resend_it;
> +
> +	if (count == urb->transfer_buffer_length)
> +		copy_vbi_video_data(video, src, count);
> +	else
> +		check_trailer(video, src, count);
> +
> +resend_it:
> +	ret = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (ret)
> +		log(" submit failed: error %d", ret);
> +}
> +
> +/************************* for ISO *********************/
> +#define GET_SUCCESS		(0)
> +#define GET_TRAILER		(1)
> +#define GET_TOO_MUCH_BUBBLE	(2)
> +#define GET_NONE		(3)
> +static int get_chunk(int start, struct urb *urb,
> +			int *head, int *tail, int *bubble_err)
> +{
> +	struct usb_iso_packet_descriptor *pkt = NULL;
> +	int ret = GET_SUCCESS;
> +
> +	for (*head = *tail = -1; start < urb->number_of_packets; start++) {
> +		pkt = &urb->iso_frame_desc[start];
> +
> +		/* handle the bubble of the Hub */
> +		if (-EOVERFLOW == pkt->status) {
> +			if (++*bubble_err > urb->number_of_packets / 3)
> +				return GET_TOO_MUCH_BUBBLE;
> +			continue;
> +		}
> +
> +		/* This is the gap */
> +		if (pkt->status || pkt->actual_length <= 0
> +				|| pkt->actual_length > ISO_PKT_SIZE) {
> +			if (*head != -1)
> +				break;
> +			continue;
> +		}
> +
> +		/* a good isochronous packet */
> +		if (pkt->actual_length == ISO_PKT_SIZE) {
> +			if (*head == -1)
> +				*head = start;
> +			*tail = start;
> +			continue;
> +		}
> +
> +		/* trailer is here */
> +		if (pkt->actual_length < ISO_PKT_SIZE) {
> +			if (*head == -1) {
> +				*head = start;
> +				*tail = start;
> +				return GET_TRAILER;
> +			}
> +			break;
> +		}
> +	}
> +
> +	if (*head == -1 && *tail == -1)
> +		ret = GET_NONE;
> +	return ret;
> +}
> +
> +/*
> + * |__|------|___|-----|_______|
> + *       ^          ^
> + *       |          |
> + *      gap        gap
> + */
> +static void urb_complete_iso(struct urb *urb)
> +{
> +	struct video_data *video = urb->context;
> +	int bubble_err = 0, head = 0, tail = 0;
> +	char *src = (char *)urb->transfer_buffer;
> +	int ret = 0;
> +
> +	if (!video->is_streaming)
> +		return;
> +
> +	do {
> +		if (!get_video_frame(video))
> +			goto out;
> +
> +		switch (get_chunk(head, urb, &head, &tail, &bubble_err)) {
> +		case GET_SUCCESS:
> +			copy_vbi_video_data(video, src + (head * ISO_PKT_SIZE),
> +					(tail - head + 1) * ISO_PKT_SIZE);
> +			break;
> +		case GET_TRAILER:
> +			check_trailer(video, src + (head * ISO_PKT_SIZE),
> +					ISO_PKT_SIZE);
> +			break;
> +		case GET_NONE:
> +			goto out;
> +		case GET_TOO_MUCH_BUBBLE:
> +			log("\t We got too much bubble");
> +			goto out;
> +		}
> +	} while (head = tail + 1, head < urb->number_of_packets);
> +
> +out:
> +	ret = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (ret)
> +		log("usb_submit_urb err : %d", ret);
> +}
> +/*============================= [  end  ] =====================*/


Same comment here: use videobuf instead.


> +
> +static int prepare_iso_urb(struct video_data *video)
> +{
> +	int i;
> +
> +	if (video->pd_sbuf[0].urb)
> +		return 0;
> +
> +	for (i = 0; i < SBUF_NUM; i++) {
> +		int j;
> +		struct urb *urb;
> +
> +		urb = usb_alloc_urb(PK_PER_URB, GFP_KERNEL);
> +		if (urb == NULL)
> +			goto out;
> +
> +		video->pd_sbuf[i].urb = urb;
> +		video->pd_sbuf[i].data = usb_buffer_alloc(video->udev,
> +						ISO_PKT_SIZE * PK_PER_URB,
> +						GFP_KERNEL,
> +						&urb->transfer_dma);
> +
> +		urb->complete	= urb_complete_iso;	/* handler */
> +		urb->dev	= video->udev;
> +		urb->context	= video;
> +		urb->pipe	= usb_rcvisocpipe(video->udev,
> +						video->endpoint_addr);
> +		urb->interval	= 1;
> +		urb->number_of_packets	= PK_PER_URB;
> +		urb->transfer_flags	= URB_ISO_ASAP;
> +		urb->transfer_buffer	= video->pd_sbuf[i].data;
> +		urb->transfer_buffer_length = PK_PER_URB * ISO_PKT_SIZE;
> +
> +		for (j = 0; j < PK_PER_URB; j++) {
> +			urb->iso_frame_desc[j].offset = ISO_PKT_SIZE * j;
> +			urb->iso_frame_desc[j].length = ISO_PKT_SIZE;
> +		}
> +	}
> +	return 0;
> +out:
> +	for (; i > 0; i--)
> +		;
> +	return -ENOMEM;
> +}
> +
> +static int prepare_bulk_urb(struct video_data *video)
> +{
> +	int i;
> +	int sb_size = 0x2000 ;
> +
> +	if (video->pd_sbuf[0].urb)
> +		return 0;
> +
> +	for (i = 0; i < SBUF_NUM; i++) {
> +		struct urb *urb = usb_alloc_urb(0, GFP_KERNEL);
> +
> +		if (urb == NULL)
> +			return -ENOMEM;
> +		video->pd_sbuf[i].urb = urb;
> +		video->pd_sbuf[i].data = usb_buffer_alloc(video->udev,
> +							sb_size,
> +							GFP_KERNEL,
> +							&urb->transfer_dma);
> +		usb_fill_bulk_urb(urb, video->udev,
> +			usb_rcvbulkpipe(video->udev, video->endpoint_addr),
> +			video->pd_sbuf[i].data,
> +			sb_size,
> +			urb_complete_bulk,
> +			video);
> +		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +	}
> +	return 0;
> +}
> +
> +int usb_transfer_start(struct video_data *video)
> +{
> +	int i, ret;
> +
> +	video->is_streaming = 1;
> +	for (i = 0; i < SBUF_NUM; i++) {
> +		ret = usb_submit_urb(video->pd_sbuf[i].urb, GFP_KERNEL);
> +		if (ret)
> +			log("(%d) failed: error %d", i, ret);
> +	}
> +	return ret;
> +}
> +
> +void usb_transfer_cleanup(struct video_data *video)
> +{
> +	struct pd_sbuf *sbuf = &video->pd_sbuf[0];
> +
> +	for (; sbuf < &video->pd_sbuf[SBUF_NUM]; sbuf++) {
> +		if (sbuf->urb) {
> +			usb_buffer_free(video->udev,
> +					sbuf->urb->transfer_buffer_length,
> +					sbuf->data,
> +					sbuf->urb->transfer_dma);
> +			usb_free_urb(sbuf->urb);
> +			sbuf->urb = NULL;
> +			sbuf->data = NULL;
> +		}
> +	}
> +}
> +
> +int usb_transfer_stop(struct video_data *video)
> +{
> +	if (video->is_streaming) {
> +		int i;
> +
> +		video->is_streaming = 0;
> +		for (i = 0; i < SBUF_NUM; ++i) {
> +			if (video->pd_sbuf[i].urb)
> +				usb_kill_urb(video->pd_sbuf[i].urb);
> +		}
> +		usb_transfer_cleanup(video);
> +	}
> +	return 0;
> +}
> +
> +static void usb_transfer_init(struct poseidon *pd, u8 addr,
> +				struct usb_device *udev)
> +{
> +	struct video_data *video = &pd->video_data;
> +
> +	video->endpoint_addr = addr;
> +	video->udev	= udev;
> +	video->vbi	= &pd->vbi_data;
> +	video->vbi->video = video;
> +}
> +
> +static int vidioc_enum_fmt_cap(struct file *file, void *fh,
> +				struct v4l2_fmtdesc *f)
> +{
> +	if (POSEIDON_FORMATS <= f->index)
> +		return -EINVAL;
> +	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	f->flags = 0;	/* not compressed image */
> +	strcpy(f->description, poseidon_formats[f->index].name);
> +	f->pixelformat = poseidon_formats[f->index].fourcc;
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct poseidon *pd = fh;
> +
> +	*f = pd->video_data.cur_format;
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_cap(struct file *file, void *fh,
> +		struct v4l2_format *f)
> +{
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct poseidon *pd = fh;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	s32 ret = 0, cmd_status = 0, vid_resol;
> +
> +	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != f->type)
> +		return -EINVAL;
> +	if (file != pd->file_for_stream
> +		&& (pd->state & POSEIDON_STATE_STREAM_CAP))
> +		return -EBUSY;
> +
> +	mutex_lock(&pd->lock);
> +	if (!(pd->state & POSEIDON_STATE_STREAM_CAP)) {
> +		pd->state |= POSEIDON_STATE_STREAM_CAP;
> +		pd->file_for_stream = file;
> +	}
> +
> +	if (file == pd->file_for_stream) {
> +		if (pix->pixelformat == V4L2_PIX_FMT_RGB565) {
> +			vid_resol = TLG_TUNER_VID_FORMAT_RGB_565;
> +		} else {
> +			pix->pixelformat = V4L2_PIX_FMT_YUYV;
> +			vid_resol = TLG_TUNER_VID_FORMAT_YUV;
> +		}
> +		ret = send_set_req(pd, VIDEO_STREAM_FMT_SEL,
> +					vid_resol, &cmd_status);
> +
> +		vid_resol = TLG_TUNE_VID_RES_720;
> +		switch (pix->width) {
> +		case 704:
> +			vid_resol = TLG_TUNE_VID_RES_704;
> +			break;
> +		default:
> +			pix->width = 720;
> +		case 720:
> +			break;
> +		}
> +		ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
> +					vid_resol, &cmd_status);
> +		if (ret || cmd_status) {
> +			mutex_unlock(&pd->lock);
> +			return -ENXIO;
> +		}
> +	}
> +	mutex_unlock(&pd->lock);
> +
> +	pix->height = (pd->video_data.tvnormid & V4L2_STD_525_60) ? 480 : 576;
> +	pix->bytesperline	= pix->width * 2;
> +	pix->sizeimage 		= pix->width * pix->height * 2;

Hmm.. if you're calculating bytesperline/sizeimage here, why had them
initialized at the struct?

> +
> +	pd->video_data.cur_format = *f;
> +
> +	pd->video_data.lines_per_field = pix->height / 2;
> +	pd->video_data.lines_size = pix->width * 2;
> +	return 0;
> +}
> +
> +static int set_std(struct poseidon *pd, v4l2_std_id *norm)
> +{
> +	s32 i, ret = 0, cmd_status, param;
> +
> +	for (i = 0; i < POSEIDON_TVNORMS; i++) {
> +		if (*norm & poseidon_tvnorms[i].v4l2_id) {
> +			param = poseidon_tvnorms[i].tlg_tvnorm;
> +			goto found;
> +		}
> +	}
> +	return -EINVAL;
> +found:
> +	mutex_lock(&pd->lock);
> +	ret = send_set_req(pd, VIDEO_STD_SEL, param, &cmd_status);
> +	if (ret || cmd_status)
> +		goto out;
> +
> +	pd->video_data.tvnormid = poseidon_tvnorms[i].v4l2_id;
> +	if (pd->video_data.tvnormid & V4L2_STD_525_60)
> +		pd->video_data.vbi_size = V4L_NTSC_VBI_FRAMESIZE / 2;
> +	else
> +		pd->video_data.vbi_size = V4L_PAL_VBI_FRAMESIZE / 2;
> +out:
> +	mutex_unlock(&pd->lock);
> +	return ret;
> +}
> +
> +int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *norm)
> +{
> +	return set_std((struct poseidon *)fh, norm);
> +}
> +
> +static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
> +{
> +	if (in->index < 0 || in->index >= POSEIDON_INPUTS)
> +		return -EINVAL;
> +	strcpy(in->name, pd_inputs[in->index].name);
> +	in->type  = V4L2_INPUT_TYPE_TUNER;
> +
> +	/*
> +	 * the audio input index mixed with this video input,
> +	 * Poseidon only have one audio/video, set to "0"
> +	 */
> +	in->audioset	= 0;
> +	in->tuner	= 0;
> +	in->std		= PD_TVNORMS_SUPPORT;
> +	in->status	= 0;
> +	return 0;
> +}
> +
> +static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
> +{
> +	struct poseidon *pd = fh;
> +	*i = pd->video_data.sig_index;
> +	return 0;
> +}
> +
> +static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
> +{
> +	s32 ret, cmd_status;
> +	struct poseidon *pd = fh;
> +
> +	if (i < 0 || i >= POSEIDON_INPUTS)
> +		return -EINVAL;
> +	ret = send_set_req(pd, SGNL_SRC_SEL,
> +				pd_inputs[i].tlg_src, &cmd_status);
> +	if (ret)
> +		return ret;
> +
> +	pd->video_data.sig_index = i;
> +	return 0;
> +}
> +
> +static struct poseidon_control *check_control_id(__u32 id)
> +{
> +	struct poseidon_control *control = &controls[0];
> +	int array_size = ARRAY_SIZE(controls);
> +
> +	for (; control < &controls[array_size]; control++)
> +		if (control->v4l2_ctrl.id  == id)
> +			return control;
> +	return NULL;
> +}
> +
> +static int vidioc_queryctrl(struct file *file, void *fh,
> +			struct v4l2_queryctrl *a)
> +{
> +	struct poseidon_control *control = NULL;
> +
> +	control = check_control_id(a->id);
> +	if (!control)
> +		return -EINVAL;
> +
> +	*a = control->v4l2_ctrl;
> +	return 0;
> +}
> +
> +static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *ctrl)
> +{
> +	struct poseidon *pd = fh;
> +	struct poseidon_control *control = NULL;
> +	s32 ret = 0, cmd_status;
> +	struct tuner_custom_parameter_s tuner_param;
> +
> +	control = check_control_id(ctrl->id);
> +	if (!control)
> +		return -EINVAL;
> +
> +	mutex_lock(&pd->lock);
> +	ret = send_get_req(pd, TUNER_CUSTOM_PARAMETER, control->vc_id,
> +			&tuner_param, &cmd_status, sizeof(tuner_param));
> +	mutex_unlock(&pd->lock);
> +
> +	if (ret || cmd_status)
> +		return -1;
> +
> +	ctrl->value = tuner_param.param_value;
> +	return 0;
> +}
> +
> +static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
> +{
> +	struct tuner_custom_parameter_s param = {};
> +	struct poseidon_control *control = NULL;
> +	s32 ret = 0, cmd_status, params;
> +	struct poseidon *pd = fh;
> +
> +	control = check_control_id(a->id);
> +	if (!control)
> +		return -EINVAL;
> +
> +	param.param_value = a->value;
> +	param.param_id	= control->vc_id;
> +	params = *(s32 *)&param; /* temp code */
> +
> +	mutex_lock(&pd->lock);
> +	ret = send_set_req(pd, TUNER_CUSTOM_PARAMETER, params, &cmd_status);
> +	ret = send_set_req(pd, TAKE_REQUEST, 0, &cmd_status);
> +	mutex_unlock(&pd->lock);
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(HZ/4);
> +	return ret;
> +}
> +
> +/* Audio ioctls */
> +static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
> +{
> +	if (0 != a->index)
> +		return -EINVAL;
> +	a->capability = V4L2_AUDCAP_STEREO;
> +	strcpy(a->name, "USB audio in");
> +	/*Poseidon have no AVL function.*/
> +	a->mode = 0;
> +	return 0;
> +}
> +
> +int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
> +{
> +	a->index = 0;
> +	a->capability = V4L2_AUDCAP_STEREO;
> +	strcpy(a->name, "USB audio in");
> +	a->mode = 0;
> +	return 0;
> +}
> +
> +int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
> +{
> +	return (0 == a->index) ? 0 : -EINVAL;
> +}
> +
> +/* Tuner ioctls */
> +static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *tuner)
> +{
> +	s32 count = 5, ret, cmd_status;
> +	int index;
> +	struct tuner_atv_sig_stat_s atv_stat;
> +	struct poseidon *pd = fh;
> +
> +	if (0 != tuner->index)
> +		return -EINVAL;
> +
> +	mutex_lock(&pd->lock);
> +	ret = send_get_req(pd, TUNER_STATUS, TLG_MODE_ANALOG_TV,
> +				&atv_stat, &cmd_status, sizeof(atv_stat));
> +
> +	while (atv_stat.sig_lock_busy && count-- && !ret) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(HZ);
> +
> +		ret = send_get_req(pd, TUNER_STATUS, TLG_MODE_ANALOG_TV,
> +				&atv_stat, &cmd_status, sizeof(atv_stat));
> +	}
> +	mutex_unlock(&pd->lock);
> +
> +	if (debug_mode)
> +		log("P:%d,S:%d", atv_stat.sig_present, atv_stat.sig_strength);
> +
> +	if (ret || cmd_status)
> +		tuner->signal = 0;
> +	else if (atv_stat.sig_present && !atv_stat.sig_strength)
> +		tuner->signal = 0xFFFF;
> +	else
> +		tuner->signal = (atv_stat.sig_strength * 255 / 10) << 8;
> +
> +	strcpy(tuner->name, "Telegent Systems");
> +	tuner->type = V4L2_TUNER_ANALOG_TV;
> +	tuner->rangelow = TUNER_FREQ_MIN / 62500;
> +	tuner->rangehigh = TUNER_FREQ_MAX / 62500;
> +	tuner->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO |
> +				V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
> +	index = pd->video_data.audio_index;
> +	tuner->rxsubchans = pd_audio_modes[index].v4l2_audio_sub;
> +	tuner->audmode = pd_audio_modes[index].v4l2_audio_mode;
> +	tuner->afc = 0;
> +	return 0;
> +}
> +
> +static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *a)
> +{
> +	s32 index, ret = 0, cmd_status, param, audiomode;
> +	struct poseidon *pd = fh;
> +
> +	if (0 != a->index)
> +		return -EINVAL;
> +
> +	for (index = 0; index < POSEIDON_AUDIOMODS; index++)
> +		if (a->audmode == pd_audio_modes[index].v4l2_audio_mode)
> +			goto found;
> +	return -EINVAL;
> +found:
> +	mutex_lock(&pd->lock);
> +	param = pd_audio_modes[index].tlg_audio_mode;
> +	ret = send_set_req(pd, TUNER_AUD_MODE, param, &cmd_status);
> +	audiomode = get_audio_std(TLG_MODE_ANALOG_TV_UNCOMP, pd->country_code);
> +	ret |= send_set_req(pd, TUNER_AUD_ANA_STD, audiomode,
> +				&cmd_status);
> +	if (!ret)
> +		pd->video_data.audio_index = index;
> +	mutex_unlock(&pd->lock);
> +	return ret;
> +}
> +
> +static int vidioc_g_frequency(struct file *file, void *fh,
> +			struct v4l2_frequency *freq)
> +{
> +	struct poseidon *pd = fh;
> +
> +	if (0 != freq->tuner)
> +		return -EINVAL;
> +	freq->frequency = pd->video_data.freq;
> +	freq->type = V4L2_TUNER_ANALOG_TV;
> +	return 0;
> +}
> +
> +static void userptr_queue_init(struct pd_bufqueue *q, int n)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < n; i++) {
> +		INIT_LIST_HEAD(&q->frame_buffer[i].frame);
> +		q->user_pages[i] = NULL;
> +	}
> +
> +	spin_lock_init(&q->queue_lock);
> +	q->buf_count	= n;
> +	q->userptr_init	= 0;
> +	INIT_LIST_HEAD(&q->inqueue);
> +	INIT_LIST_HEAD(&q->outqueue);
> +	init_waitqueue_head(&q->queue_wq);
> +}
> +
> +static int pm_video_open(struct file *file)
> +{
> +	pd_video_open(file);
> +	return 0;
> +}
> +
> +static int set_frequency(struct poseidon *pd, __u32 frequency)
> +{
> +	s32 ret = 0, param, cmd_status;
> +
> +	param = frequency * 62500 / 1000;
> +	if (param < TUNER_FREQ_MIN/1000 || param > TUNER_FREQ_MAX / 1000)
> +		return -EINVAL;
> +
> +	mutex_lock(&pd->lock);
> +	ret = send_set_req(pd, TUNE_FREQ_SELECT, param, &cmd_status);
> +	ret = send_set_req(pd, TAKE_REQUEST, 0, &cmd_status);
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(HZ / 4);
> +	pd->video_data.freq = frequency;
> +	mutex_unlock(&pd->lock);
> +	return ret;
> +}
> +
> +static int vidioc_s_frequency(struct file *file, void *fh,
> +				struct v4l2_frequency *freq)
> +{
> +	struct poseidon *pd = fh;
> +
> +	pd->file_for_stream = file;
> +#ifdef CONFIG_PM
> +	pd->inode = file->f_dentry->d_inode;
> +	pd->pm_suspend = pm_video_suspend;
> +	pd->pm_resume = pm_video_resume;
> +	pd->pm_open = pm_video_open;
> +#endif
> +	return set_frequency(pd, freq->frequency);
> +}
> +
> +static int sanity_check(struct poseidon *pd, struct file *file,
> +			struct v4l2_buffer *b)
> +{
> +	if (pd->file_for_stream != file)
> +		return -EBUSY;
> +
> +	if (b->index > pd->video_data.video_queue.buf_count
> +		|| b->index < 0
> +		|| b->index >= MAX_BUFFER_NUM
> +		|| V4L2_BUF_TYPE_VIDEO_CAPTURE != b->type)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int vidioc_reqbufs(struct file *file, void *fh,
> +				struct v4l2_requestbuffers *b)
> +{
> +	u32 count = 0;
> +	struct poseidon *pd = fh;
> +
> +	if (file != pd->file_for_stream)
> +		return -EBUSY;
> +	if (pd->video_data.stream_method)
> +		return -EBUSY;
> +
> +	if (V4L2_MEMORY_USERPTR == b->memory) {
> +		pd->video_data.buf_count = b->count;
> +		pd->video_data.stream_method = STREAM_USER;
> +		userptr_queue_init(&pd->video_data.video_queue, b->count);
> +	} else /* if (V4L2_MEMORY_MMAP == b->memory) */ {
> +		pd->video_data.stream_method = STREAM_MMAP;
> +
> +		count = b->count;
> +		pd_bufqueue_init(&pd->video_data.video_queue, &count,
> +				pd->video_data.frame_size, USER_MEM);
> +		b->count = count;
> +		pd->video_data.buf_count = count;
> +	}
> +	return 0;
> +}
> +
> +static int vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
> +{
> +	struct poseidon *pd = fh;
> +
> +	if (pd->video_data.buf_count <= b->index)
> +		return -EINVAL;
> +
> +	b->flags = V4L2_BUF_FLAG_MAPPED;
> +	b->field  = V4L2_FIELD_INTERLACED;
> +	b->m.offset = b->index * pd->video_data.frame_size;
> +	b->length = pd->video_data.frame_size;
> +	return 0;
> +}
> +
> +static void clear_user_pointer(struct pd_bufqueue *q)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < q->buf_count; i++) {
> +		if (!test_bit(i, (void *)&q->userptr_init))
> +			continue;
> +
> +		vunmap(q->frame_buffer[i].data);
> +		q->frame_buffer[i].data = NULL;
> +
> +		j = q->buf_length >> PAGE_SHIFT;
> +		while (j)
> +			put_page(q->user_pages[i][--j]);
> +
> +		kfree(q->user_pages[i]);
> +		q->user_pages[i] = NULL;
> +	}
> +	q->userptr_init = 0;
> +}
> +
> +static int setup_user_pointer(struct pd_bufqueue *q, struct v4l2_buffer *b)
> +{
> +	unsigned int nr_pages	= b->length >> PAGE_SHIFT;
> +	struct pd_frame *f	= &q->frame_buffer[b->index];
> +	int  i;
> +	int ret = -ENOMEM;
> +	struct page **pagesp;
> +
> +	pagesp = kcalloc(1, sizeof(struct page *) * nr_pages, GFP_KERNEL);
> +	if (!pagesp)
> +		return -ENOMEM;
> +
> +	/* <1> The function get_user_pages_fast() will
> +	 *	 1.) increase the page->count, and
> +	 *	 2.) makes the Anonymous page Active.
> +	 *	 3.) makes the pages pinned in memory.
> +	 *	 4.) prevent the pages from migrating to other node in numa.
> +	 */
> +	get_user_pages_fast((unsigned long)b->m.userptr, nr_pages, 1, pagesp);
> +	if (ret < nr_pages)
> +		goto free_part_pages;
> +
> +	/* <2> map the pages to VMALLOC space. */
> +	f->data = vmap(pagesp, nr_pages, VM_MAP, PAGE_KERNEL);
> +	if (!f->data)
> +		goto free_all_pages;
> +
> +	/* <3> setup the driver's buffers */
> +	f->userptr		= b->m.userptr;
> +	f->length		= b->length;
> +	f->index		= b->index;
> +
> +	q->buf_length		= b->length;
> +	q->user_pages[b->index] = pagesp;
> +	set_bit(b->index, (void *)&q->userptr_init);
> +	return 0;
> +
> +free_all_pages:
> +	ret = nr_pages;
> +free_part_pages:
> +	for (i = 0; i < ret; i++)
> +		put_page(pagesp[i]);
> +
> +	kfree(pagesp);
> +	return -EAGAIN;
> +}
> +
> +static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> +{
> +	struct poseidon *pd = fh;
> +	struct pd_bufqueue *q;
> +	int ret = 0;
> +
> +	ret = sanity_check(pd, file, b);
> +	if (ret)
> +		return ret;
> +
> +	q = &pd->video_data.video_queue;
> +
> +	if (V4L2_MEMORY_USERPTR == b->memory) {
> +		if (!test_bit(b->index, (void *)&q->userptr_init))
> +			setup_user_pointer(q, b);
> +		pd_bufqueue_qbuf(q, b->index);
> +
> +		b->flags	|= V4L2_BUF_FLAG_QUEUED;
> +		b->flags	&= ~(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE);
> +		ret		= 0;
> +	} else /*if (V4L2_MEMORY_MMAP == b->memory) */ {
> +		ret = pd_bufqueue_qbuf(q, b->index);
> +		if (!ret) {
> +			b->flags |= V4L2_BUF_FLAG_QUEUED;
> +			b->flags &= ~V4L2_BUF_FLAG_DONE;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> +{
> +	struct pd_frame *pd_frame = NULL;
> +	struct poseidon *pd = fh;
> +	struct video_data *video;
> +	int ret;
> +
> +	ret = sanity_check(pd, file, b);
> +	if (ret)
> +		return ret;
> +
> +	video = &pd->video_data;
> +	pd_bufqueue_dqbuf(&video->video_queue, file->f_flags, &pd_frame);
> +	if (!pd_frame)
> +		return -EAGAIN;
> +
> +	b->index	= pd_frame->index;
> +	b->sequence	= pd_frame->frame_seq;
> +	b->flags	&= ~(V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE);
> +	b->field	= V4L2_FIELD_INTERLACED;
> +	do_gettimeofday(&b->timestamp);
> +
> +	if (V4L2_MEMORY_USERPTR == b->memory) {
> +		b->length	= pd_frame->length;
> +		b->m.userptr	= pd_frame->userptr;
> +	}
> +	b->bytesused = video->cur_format.fmt.pix.sizeimage;
> +
> +	/* bgr to rgb */
> +	if (video->cur_format.fmt.pix.pixelformat == V4L2_PIX_FMT_RGB565) {
> +		u16 *buf = (u16 *)pd_frame->data;
> +		for (; buf < (u16 *)(pd_frame->data + b->bytesused); buf++)
> +			*buf = ((*buf) & 0x7E0)
> +				| (((*buf) << 11) & 0xF800)
> +				| (((*buf) >> 11) & 0x1F);
> +	}
> +	return 0;
> +}
> +
> +static int start_video_stream(struct poseidon *pd)
> +{
> +	s32 cmd_status;
> +	struct video_data *video = &pd->video_data;
> +
> +	vbi_request_buf(&pd->vbi_data, pd->video_data.vbi_size * 2);
> +	send_set_req(pd, TAKE_REQUEST, 0, &cmd_status);
> +	send_set_req(pd, PLAY_SERVICE, TLG_TUNE_PLAY_SVC_START, &cmd_status);
> +
> +	if (video->cur_transfer_mode) {
> +		prepare_iso_urb(video);
> +		INIT_WORK(&pd->work, iso_bubble_handler);
> +	} else {
> +		prepare_bulk_urb(video);
> +	}
> +	printk(KERN_DEBUG "\t\t The USB transfer mode is %s now.\n\n",
> +		video->cur_transfer_mode ? "isochronous" : "bulk");
> +
> +	usb_transfer_start(&pd->video_data);
> +	pd->video_data.is_streaming = 1;
> +	return 0;
> +}
> +
> +int stop_video_stream(struct poseidon *pd)
> +{
> +	if (pd->video_data.is_streaming) {
> +		s32 cmd_status;
> +
> +		pd->video_data.is_streaming = 0;
> +		pd_bufqueue_wakeup(&pd->video_data.video_queue);
> +		usb_transfer_stop(&pd->video_data);
> +
> +		send_set_req(pd, PLAY_SERVICE, TLG_TUNE_PLAY_SVC_STOP,
> +			       &cmd_status);
> +
> +		reset_queue_stat(&pd->video_data.video_queue);
> +		reset_queue_stat(&pd->vbi_data.vbi_queue);
> +	}
> +	return 0;
> +}
> +
> +int pd_video_stop_stream(struct poseidon *pd)
> +{
> +	mutex_lock(&pd->lock);
> +	stop_video_stream(pd);
> +	mutex_unlock(&pd->lock);
> +	return 0;
> +}
> +
> +static void iso_bubble_handler(struct work_struct *w)
> +{
> +	struct poseidon *pd = container_of(w, struct poseidon, work);
> +	unsigned int i;
> +
> +	mutex_lock(&pd->lock);
> +	start_video_stream(pd);
> +
> +	/* refill the queue */
> +	for (i = 0; i < pd->video_data.buf_count; i++)
> +		pd_bufqueue_qbuf(&pd->video_data.video_queue, i);
> +
> +	stop_video_stream(pd);
> +	mutex_unlock(&pd->lock);
> +}
> +
> +static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
> +{
> +	int ret = 0;
> +	struct poseidon *pd = fh;
> +
> +	if (file != pd->file_for_stream)
> +		return -EBUSY;
> +
> +	mutex_lock(&pd->lock);
> +	ret = start_video_stream(pd);
> +	mutex_unlock(&pd->lock);
> +	return ret;
> +}
> +
> +static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
> +{
> +	struct poseidon *pd = fh;
> +
> +	if (file != pd->file_for_stream)
> +		return -EBUSY;
> +
> +	mutex_lock(&pd->lock);
> +	stop_video_stream(pd);
> +	mutex_unlock(&pd->lock);
> +	return 0;
> +}
> +
> +static int pd_video_checkmode(struct poseidon *pd)
> +{
> +	s32 ret = 0, cmd_status, audiomode;
> +	int alternate;
> +	struct video_data *video = &pd->video_data;
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(HZ/2);
> +
> +	if (video->cur_transfer_mode)
> +		alternate = ISO_3K_BULK_ALTERNATE_IFACE;
> +	else
> +		alternate = BULK_ALTERNATE_IFACE;
> +	ret = usb_set_interface(pd->udev, 0, alternate);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = set_tuner_mode(pd, TLG_MODE_ANALOG_TV);
> +	ret |= send_set_req(pd, SGNL_SRC_SEL,
> +				TLG_SIG_SRC_ANTENNA, &cmd_status);
> +	ret |= send_set_req(pd, VIDEO_STD_SEL,
> +				TLG_TUNE_VSTD_PAL_D, &cmd_status);
> +	ret |= send_set_req(pd, VIDEO_STREAM_FMT_SEL,
> +				TLG_TUNER_VID_FORMAT_YUV, &cmd_status);
> +	ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
> +				TLG_TUNE_VID_RES_720, &cmd_status);
> +
> +	/* drop-field mode */
> +	if (DROP_MODE == drop_frame)
> +		send_set_req(pd, 0x76, 0x100, &cmd_status);
> +
> +	ret |= send_set_req(pd, TUNE_FREQ_SELECT, TUNER_FREQ_MIN, &cmd_status);
> +	ret |= send_set_req(pd, VBI_DATA_SEL, 1, &cmd_status);/* enable vbi */
> +
> +	audiomode = get_audio_std(TLG_MODE_ANALOG_TV_UNCOMP, pd->country_code);
> +	ret |= send_set_req(pd, TUNER_AUD_ANA_STD, audiomode, &cmd_status);
> +	ret |= send_set_req(pd, TUNER_AUD_MODE,
> +				TLG_TUNE_TVAUDIO_MODE_STEREO, &cmd_status);
> +	ret |= send_set_req(pd, AUDIO_SAMPLE_RATE_SEL,
> +				ATV_AUDIO_RATE_48K, &cmd_status);
> +
> +	video->tvnormid		= V4L2_STD_PAL_D;
> +	video->cur_format	= default_v4l2_format;
> +	video->vbi_size		= V4L_PAL_VBI_FRAMESIZE / 2;
> +	video->audio_index	= 1; /* STEREO */
> +	video->sig_index	= 0; /* Antenna */
> +error:
> +	return ret;
> +}
> +
> +static int pm_video_suspend(struct poseidon *pd)
> +{
> +	pm_alsa_suspend(pd);
> +
> +	stop_video_stream(pd);
> +	usb_transfer_cleanup(&pd->video_data);
> +	usb_set_interface(pd->udev, 0, 0);
> +	mdelay(2000);
> +	return 0;
> +}
> +
> +static int pm_video_resume(struct poseidon *pd)
> +{
> +	int i;
> +	v4l2_std_id	tvnorm_id;
> +
> +	if (in_hibernation(pd)) {
> +		__pd_video_release(pd->file_for_stream);
> +		return 0;
> +	}
> +
> +	tvnorm_id = pd->video_data.tvnormid;
> +	pd_video_checkmode(pd);
> +	if (tvnorm_id != pd->video_data.tvnormid)
> +		set_std(pd, &tvnorm_id);
> +	vidioc_s_fmt_cap(pd->file_for_stream, pd, &pd->video_data.cur_format);
> +	set_frequency(pd, pd->video_data.freq);
> +
> +	for (i = 0; i < pd->video_data.buf_count; i++)
> +		pd_bufqueue_qbuf(&pd->video_data.video_queue, i);
> +
> +	start_video_stream(pd);
> +	pm_alsa_resume(pd);
> +	return 0;
> +}
> +
> +void set_debug_mode(struct video_device *vfd, int debug_mode)
> +{
> +	vfd->debug = 0;
> +	if (debug_mode == 1)
> +		vfd->debug = V4L2_DEBUG_IOCTL;
> +	if (debug_mode == 2)
> +		vfd->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
> +}
> +
> +static int pd_video_open(struct file *file)
> +{
> +	s32 ret = 0;
> +	struct video_device *vfd = video_devdata(file);
> +	struct poseidon *pd = video_get_drvdata(vfd);
> +
> +	mutex_lock(&pd->lock);
> +	if (pd->state & POSEIDON_STATE_DISCONNECT) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +	if (pd->state && !(pd->state & POSEIDON_STATE_ANALOG)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	usb_autopm_get_interface(pd->interface);
> +	if (!pd->state) {
> +		/* handle custom parameter first */
> +		pd->video_data.cur_transfer_mode = usb_transfer_mode;
> +		pd->country_code = country_code;
> +		set_debug_mode(vfd, debug_mode);
> +
> +		ret = pd_video_checkmode(pd);
> +		if (ret < 0)
> +			goto out;
> +		pd->state |= POSEIDON_STATE_ANALOG;
> +		pd->file_for_stream = file;
> +		usb_transfer_init(pd, 0x82, pd->udev);
> +	}
> +	kref_get(&pd->kref);
> +	file->private_data = pd;
> +	pd->video_data.users++;
> +out:
> +	mutex_unlock(&pd->lock);
> +	return ret;
> +}
> +
> +static int __pd_video_release(struct file *file)
> +{
> +	struct poseidon *pd = file->private_data;
> +
> +	mutex_lock(&pd->lock);
> +	if (file == pd->file_for_stream
> +		&& (pd->state & POSEIDON_STATE_STREAM_CAP)
> +		&& !in_hibernation(pd)) {
> +		stop_video_stream(pd);
> +		if (STREAM_USER == pd->video_data.stream_method)
> +			clear_user_pointer(&pd->video_data.video_queue);
> +		else
> +			pd_bufqueue_cleanup(&pd->video_data.video_queue);
> +
> +		vbi_release_buf(&pd->vbi_data);
> +		usb_transfer_cleanup(&pd->video_data);
> +
> +		pd->state &= ~POSEIDON_STATE_STREAM_CAP;
> +		pd->video_data.stream_method = 0;
> +	}
> +
> +	pd->video_data.users--;
> +	if (0 == pd->video_data.users)
> +		pd->state = 0;
> +	mutex_unlock(&pd->lock);
> +
> +	kref_put(&pd->kref, poseidon_delete);
> +	file->private_data = NULL;
> +	return 0;
> +}
> +
> +static int pd_video_release(struct file *file)
> +{
> +	struct poseidon *pd = file->private_data;
> +
> +	__pd_video_release(file);
> +	usb_autopm_put_interface(pd->interface);
> +	return 0;
> +}
> +
> +static long pd_video_ioctl(struct file *file,
> +		unsigned int cmd, unsigned long arg)
> +{
> +	int country_code;
> +	struct poseidon *pd = file->private_data;
> +	unsigned long ret;
> +
> +	if (!pd || pd->state & POSEIDON_STATE_DISCONNECT)
> +		return -ENODEV;
> +
> +	switch (cmd) {
> +	case PD_COUNTRY_CODE:
> +		ret = copy_from_user(&country_code, (char __user *)arg,
> +				sizeof(country_code));
> +		if (0 == ret)
> +			pd->country_code = country_code;
> +		return ret ? -EAGAIN : 0;

Why are you creating an ioctl for country_code? You don't need it.

> +
> +	default:
> +		return video_ioctl2(file, cmd, arg);
> +	}
> +}
> +
> +static int pd_video_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct poseidon *pd = file->private_data;
> +	struct pd_frame *frame;
> +	int index;
> +	int ret;
> +
> +	if ((vma->vm_flags & VM_WRITE) && !(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +
> +	index = (vma->vm_pgoff << PAGE_SHIFT) / pd->video_data.frame_size;
> +	frame = &pd->video_data.video_queue.frame_buffer[index];
> +
> +	if (!frame->data)
> +		return -EINVAL;
> +
> +	ret = remap_vmalloc_range(vma, frame->data, 0);
> +	if (ret)
> +		return ret;
> +	vma->vm_flags |= VM_DONTEXPAND;
> +	return 0;
> +}
> +
> +unsigned int pd_video_poll(struct file *file, poll_table *table)
> +{
> +	struct poseidon *pd = file->private_data;
> +	return pd_bufqueue_poll(&pd->video_data.video_queue, file, table);
> +}
> +
> +ssize_t pd_video_read(struct file *file, char __user *buffer,
> +		size_t count, loff_t *ppos)
> +{
> +	int ret = -EINVAL;
> +	struct poseidon *pd = file->private_data;
> +	struct video_data *video = &pd->video_data;
> +
> +	if (video->stream_method == 0 && !video->is_streaming) {
> +		int buf_count = 4, i;
> +
> +		pd_bufqueue_init(&video->video_queue, &buf_count,
> +				video->frame_size, USER_MEM);
> +		video->buf_count = buf_count;
> +		for (i = 0; i < buf_count; i++)
> +			pd_bufqueue_qbuf(&video->video_queue, i);
> +
> +		mutex_lock(&pd->lock);
> +		start_video_stream(pd);
> +		mutex_unlock(&pd->lock);
> +
> +		video->stream_method = STREAM_RW;
> +	}
> +	if (video->stream_method == STREAM_RW)
> +		ret = pd_bufqueue_read(&video->video_queue, file->f_flags,
> +					buffer, count);
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations pd_video_fops = {
> +	.owner = THIS_MODULE,
> +	.open  = pd_video_open,
> +	.release = pd_video_release,
> +	.ioctl = pd_video_ioctl,
> +	.mmap  = pd_video_mmap,
> +	.poll  = pd_video_poll,
> +	.read  = pd_video_read,
> +};
> +
> +static const struct v4l2_ioctl_ops pd_video_ioctl_ops = {
> +	.vidioc_querycap = vidioc_querycap,
> +	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_cap,
> +
> +	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_cap,
> +	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_cap,
> +	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_cap,
> +	/* Buffer handlers */
> +	.vidioc_reqbufs = vidioc_reqbufs,
> +	.vidioc_querybuf = vidioc_querybuf,
> +	.vidioc_qbuf = vidioc_qbuf,
> +	.vidioc_dqbuf = vidioc_dqbuf,
> +	/* Stream on/off */
> +	.vidioc_streamon = vidioc_streamon,
> +	.vidioc_streamoff = vidioc_streamoff,
> +
> +	.vidioc_s_std = vidioc_s_std,
> +
> +	.vidioc_enum_input = vidioc_enum_input,
> +	.vidioc_g_input = vidioc_g_input,
> +	.vidioc_s_input = vidioc_s_input,
> +
> +	/* Control handling */
> +	.vidioc_queryctrl = vidioc_queryctrl,
> +	.vidioc_g_ctrl = vidioc_g_ctrl,
> +	.vidioc_s_ctrl = vidioc_s_ctrl,
> +
> +	/* Audio ioctls */
> +	.vidioc_enumaudio = vidioc_enumaudio,
> +	.vidioc_g_audio = vidioc_g_audio,
> +	.vidioc_s_audio = vidioc_s_audio,
> +
> +	/* Tuner ioctls */
> +	.vidioc_g_tuner = vidioc_g_tuner,
> +	.vidioc_s_tuner = vidioc_s_tuner,
> +	.vidioc_g_frequency = vidioc_g_frequency,
> +	.vidioc_s_frequency = vidioc_s_frequency,
> +};
> +
> +static struct video_device pd_video_template = {
> +	.name = "poseidon_video",
> +	.fops = &pd_video_fops,
> +	.minor = -1,
> +	.release = video_device_release,
> +	.tvnorms = PD_TVNORMS_SUPPORT,
> +	.ioctl_ops = &pd_video_ioctl_ops,
> +};
> +
> +struct video_device *vdev_init(struct poseidon *pd, struct video_device *tmp)
> +{
> +	struct video_device *vfd;
> +
> +	vfd = video_device_alloc();
> +	if (vfd == NULL)
> +		return NULL;
> +	*vfd = *tmp;
> +	vfd->minor   = -1;
> +	vfd->parent = &(pd->udev->dev);
> +	vfd->release = video_device_release;
> +	video_set_drvdata(vfd, pd);
> +	return vfd;
> +}
> +
> +int pd_video_init(struct poseidon *pd)
> +{
> +	struct video_data *video = &pd->video_data;
> +	int ret;
> +
> +	video->frame_size = PAGE_ALIGN(FRAME_MAX_SIZE);
> +	video->video_dev = vdev_init(pd, &pd_video_template);
> +	if (video->video_dev == NULL)
> +		return -ENOMEM;
> +
> +	ret = video_register_device(video->video_dev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		video_device_release(video->video_dev);
> +		video->video_dev = NULL;
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +void pd_video_exit(struct poseidon *pd)
> +{
> +	struct video_data *video = &pd->video_data;
> +
> +	if (video->video_dev && (-1 != video->video_dev->minor)) {
> +		video_unregister_device(video->video_dev);
> +		video->video_dev = NULL;
> +	}
> +}

Cheers,
Mauro
