Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3689 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbaJ2JBd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 05:01:33 -0400
Message-ID: <5450AC8C.4090603@xs4all.nl>
Date: Wed, 29 Oct 2014 09:59:56 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Divneil Wadhawan <divneil.wadhawan@st.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] vb2: replace VIDEO_MAX_FRAME with VB2_MAX_FRAME
References: <5437932A.7000706@xs4all.nl>	<20141028162647.43c1946a@recife.lan>	<54509744.7090005@xs4all.nl> <20141029062952.05e47989@recife.lan>
In-Reply-To: <20141029062952.05e47989@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/14 09:29, Mauro Carvalho Chehab wrote:
> Em Wed, 29 Oct 2014 08:29:08 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 10/28/2014 07:26 PM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 10 Oct 2014 10:04:58 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> (This patch is from Divneil except for the vivid changes which I added. He had
>>>> difficulties posting the patch without the mailer mangling it, so I'm reposting
>>>> it for him)
>>>>
>>>> - vb2 drivers to rely on VB2_MAX_FRAME.
>>>>
>>>> - VB2_MAX_FRAME bumps the value to 64 from current 32
>>>
>>> Hmm... what's the point of announcing a maximum of 32 buffers to userspace,
>>> but using internally 64?
>>
>> Where do we announce 32 buffers?
> 
> VIDEO_MAX_FRAME is defined at videodev2.h:
> 
> include/uapi/linux/videodev2.h:#define VIDEO_MAX_FRAME               32
> 
> So, it is part of userspace API. Yeah, I know, it sucks, but apps
> may be using it to limit the max number of buffers.

So? Userspace is free to ask for 32 buffers, and it will get 32 buffers if
memory allows. vb2 won't be returning more than 32, so I don't see how things
can break.

Regards,

	Hans

> 
>> The only place where a maximum is enforced is
>> in REQBUFS/CREATE_BUFS. Most (all?) vb2 drivers leave enforcing the maximum to
>> vb2, they only care about the minimum, so they will automatically use the new
>> maximum.
>>
>>>
>>> Btw, wouldn't this change break for DaVinci:
>>> 	include/media/davinci/vpfe_capture.h:   u8 *fbuffers[VIDEO_MAX_FRAME];
>>
>> That driver still uses vb1, so this patch won't break it.
> 
> No, it doesn't. Check the DaVinci Kconfig/Makefile. I merged a patchset
> that converted it to VB2.
> 
> Regards,
> Mauro
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Regards,
>>> Mauro
>>>
>>>>
>>>> Signed-off-by: Divneil Wadhawan <divneil.wadhawan@st.com>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>   drivers/media/pci/saa7134/saa7134-ts.c       | 4 ++--
>>>>   drivers/media/pci/saa7134/saa7134-vbi.c      | 4 ++--
>>>>   drivers/media/pci/saa7134/saa7134-video.c    | 2 +-
>>>>   drivers/media/platform/mem2mem_testdev.c     | 2 +-
>>>>   drivers/media/platform/ti-vpe/vpe.c          | 2 +-
>>>>   drivers/media/platform/vivid/vivid-core.h    | 2 +-
>>>>   drivers/media/platform/vivid/vivid-ctrls.c   | 2 +-
>>>>   drivers/media/platform/vivid/vivid-vid-cap.c | 2 +-
>>>>   drivers/media/v4l2-core/videobuf2-core.c     | 8 ++++----
>>>>   include/media/videobuf2-core.h               | 4 +++-
>>>>   10 files changed, 17 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
>>>> index bd25323..0d04995 100644
>>>> --- a/drivers/media/pci/saa7134/saa7134-ts.c
>>>> +++ b/drivers/media/pci/saa7134/saa7134-ts.c
>>>> @@ -227,8 +227,8 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
>>>>   	/* sanitycheck insmod options */
>>>>   	if (tsbufs < 2)
>>>>   		tsbufs = 2;
>>>> -	if (tsbufs > VIDEO_MAX_FRAME)
>>>> -		tsbufs = VIDEO_MAX_FRAME;
>>>> +	if (tsbufs > VB2_MAX_FRAME)
>>>> +		tsbufs = VB2_MAX_FRAME;
>>>>   	if (ts_nr_packets < 4)
>>>>   		ts_nr_packets = 4;
>>>>   	if (ts_nr_packets > 312)
>>>> diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
>>>> index 4f0b101..2269837 100644
>>>> --- a/drivers/media/pci/saa7134/saa7134-vbi.c
>>>> +++ b/drivers/media/pci/saa7134/saa7134-vbi.c
>>>> @@ -203,8 +203,8 @@ int saa7134_vbi_init1(struct saa7134_dev *dev)
>>>>   
>>>>   	if (vbibufs < 2)
>>>>   		vbibufs = 2;
>>>> -	if (vbibufs > VIDEO_MAX_FRAME)
>>>> -		vbibufs = VIDEO_MAX_FRAME;
>>>> +	if (vbibufs > VB2_MAX_FRAME)
>>>> +		vbibufs = VB2_MAX_FRAME;
>>>>   	return 0;
>>>>   }
>>>>   
>>>> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
>>>> index fc4a427..c7f39be 100644
>>>> --- a/drivers/media/pci/saa7134/saa7134-video.c
>>>> +++ b/drivers/media/pci/saa7134/saa7134-video.c
>>>> @@ -2030,7 +2030,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
>>>>   	int ret;
>>>>   
>>>>   	/* sanitycheck insmod options */
>>>> -	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
>>>> +	if (gbuffers < 2 || gbuffers > VB2_MAX_FRAME)
>>>>   		gbuffers = 2;
>>>>   	if (gbufsize > gbufsize_max)
>>>>   		gbufsize = gbufsize_max;
>>>> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
>>>> index c1b03cf..e1ff7e0 100644
>>>> --- a/drivers/media/platform/mem2mem_testdev.c
>>>> +++ b/drivers/media/platform/mem2mem_testdev.c
>>>> @@ -55,7 +55,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
>>>>   #define MEM2MEM_NAME		"m2m-testdev"
>>>>   
>>>>   /* Per queue */
>>>> -#define MEM2MEM_DEF_NUM_BUFS	VIDEO_MAX_FRAME
>>>> +#define MEM2MEM_DEF_NUM_BUFS	VB2_MAX_FRAME
>>>>   /* In bytes, per queue */
>>>>   #define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)
>>>>   
>>>> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
>>>> index 9a081c2..04e37c0 100644
>>>> --- a/drivers/media/platform/ti-vpe/vpe.c
>>>> +++ b/drivers/media/platform/ti-vpe/vpe.c
>>>> @@ -1971,7 +1971,7 @@ static const struct v4l2_ctrl_config vpe_bufs_per_job = {
>>>>   	.type = V4L2_CTRL_TYPE_INTEGER,
>>>>   	.def = VPE_DEF_BUFS_PER_JOB,
>>>>   	.min = 1,
>>>> -	.max = VIDEO_MAX_FRAME,
>>>> +	.max = VB2_MAX_FRAME,
>>>>   	.step = 1,
>>>>   };
>>>>   
>>>> diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
>>>> index 811c286..c0375a1 100644
>>>> --- a/drivers/media/platform/vivid/vivid-core.h
>>>> +++ b/drivers/media/platform/vivid/vivid-core.h
>>>> @@ -346,7 +346,7 @@ struct vivid_dev {
>>>>   	/* video capture */
>>>>   	struct tpg_data			tpg;
>>>>   	unsigned			ms_vid_cap;
>>>> -	bool				must_blank[VIDEO_MAX_FRAME];
>>>> +	bool				must_blank[VB2_MAX_FRAME];
>>>>   
>>>>   	const struct vivid_fmt		*fmt_cap;
>>>>   	struct v4l2_fract		timeperframe_vid_cap;
>>>> diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
>>>> index d5cbf00..7162f97 100644
>>>> --- a/drivers/media/platform/vivid/vivid-ctrls.c
>>>> +++ b/drivers/media/platform/vivid/vivid-ctrls.c
>>>> @@ -332,7 +332,7 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
>>>>   		break;
>>>>   	case VIVID_CID_PERCENTAGE_FILL:
>>>>   		tpg_s_perc_fill(&dev->tpg, ctrl->val);
>>>> -		for (i = 0; i < VIDEO_MAX_FRAME; i++)
>>>> +		for (i = 0; i < VB2_MAX_FRAME; i++)
>>>>   			dev->must_blank[i] = ctrl->val < 100;
>>>>   		break;
>>>>   	case VIVID_CID_INSERT_SAV:
>>>> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
>>>> index 331c544..55e8158 100644
>>>> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
>>>> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
>>>> @@ -252,7 +252,7 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
>>>>   
>>>>   	dev->vid_cap_seq_count = 0;
>>>>   	dprintk(dev, 1, "%s\n", __func__);
>>>> -	for (i = 0; i < VIDEO_MAX_FRAME; i++)
>>>> +	for (i = 0; i < VB2_MAX_FRAME; i++)
>>>>   		dev->must_blank[i] = tpg_g_perc_fill(&dev->tpg) < 100;
>>>>   	if (dev->start_streaming_error) {
>>>>   		dev->start_streaming_error = false;
>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>>> index 15b02f9..60354b4 100644
>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>>> @@ -911,7 +911,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>>>>   	/*
>>>>   	 * Make sure the requested values and current defaults are sane.
>>>>   	 */
>>>> -	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
>>>> +	num_buffers = min_t(unsigned int, req->count, VB2_MAX_FRAME);
>>>>   	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
>>>>   	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>>>>   	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
>>>> @@ -1015,7 +1015,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>>>>   	unsigned int num_planes = 0, num_buffers, allocated_buffers;
>>>>   	int ret;
>>>>   
>>>> -	if (q->num_buffers == VIDEO_MAX_FRAME) {
>>>> +	if (q->num_buffers == VB2_MAX_FRAME) {
>>>>   		dprintk(1, "maximum number of buffers already allocated\n");
>>>>   		return -ENOBUFS;
>>>>   	}
>>>> @@ -1026,7 +1026,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>>>>   		q->memory = create->memory;
>>>>   	}
>>>>   
>>>> -	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
>>>> +	num_buffers = min(create->count, VB2_MAX_FRAME - q->num_buffers);
>>>>   
>>>>   	/*
>>>>   	 * Ask the driver, whether the requested number of buffers, planes per
>>>> @@ -2725,7 +2725,7 @@ struct vb2_fileio_data {
>>>>   	struct v4l2_requestbuffers req;
>>>>   	struct v4l2_plane p;
>>>>   	struct v4l2_buffer b;
>>>> -	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
>>>> +	struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
>>>>   	unsigned int cur_index;
>>>>   	unsigned int initial_index;
>>>>   	unsigned int q_count;
>>>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>>>> index a8608ce..66dcc40 100644
>>>> --- a/include/media/videobuf2-core.h
>>>> +++ b/include/media/videobuf2-core.h
>>>> @@ -18,6 +18,8 @@
>>>>   #include <linux/videodev2.h>
>>>>   #include <linux/dma-buf.h>
>>>>   
>>>> +#define VB2_MAX_FRAME		64
>>>> +
>>>>   struct vb2_alloc_ctx;
>>>>   struct vb2_fileio_data;
>>>>   struct vb2_threadio_data;
>>>> @@ -402,7 +404,7 @@ struct vb2_queue {
>>>>   /* private: internal use only */
>>>>   	struct mutex			mmap_lock;
>>>>   	enum v4l2_memory		memory;
>>>> -	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
>>>> +	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
>>>>   	unsigned int			num_buffers;
>>>>   
>>>>   	struct list_head		queued_list;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

