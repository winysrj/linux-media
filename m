Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:48774 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754276AbdKJWfp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 17:35:45 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>
Subject: RE: [PATCH v4 10/12] intel-ipu3: css pipeline
Date: Fri, 10 Nov 2017 22:35:43 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE34AC3@ORSMSX106.amr.corp.intel.com>
References: <1508298896-26096-1-git-send-email-yong.zhi@intel.com>
 <1508298896-26096-7-git-send-email-yong.zhi@intel.com>
 <20171101185723.66f7xfsem4npmhfp@valkosipuli.retiisi.org.uk>
In-Reply-To: <20171101185723.66f7xfsem4npmhfp@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

Thanks for the review.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Wednesday, November 1, 2017 11:57 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>
> Subject: Re: [PATCH v4 10/12] intel-ipu3: css pipeline
> 
> Hi Yong,
> 
> Apologies for the late reply. Please find my (few) comments below.
> 
> On Tue, Oct 17, 2017 at 10:54:55PM -0500, Yong Zhi wrote:
> > Add css pipeline and v4l code.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-css.c | 1761
> ++++++++++++++++++++++++++++++-
> >  drivers/media/pci/intel/ipu3/ipu3-css.h |   89 ++
> >  2 files changed, 1849 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.c
> b/drivers/media/pci/intel/ipu3/ipu3-css.c
> > index 6e615bf9378a..11f7ad3514c3 100644
> > --- a/drivers/media/pci/intel/ipu3/ipu3-css.c
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-css.c
> > @@ -13,9 +13,16 @@

(snip)

> > +static bool ipu3_css_queue_enabled(struct ipu3_css_queue *q)
> > +{
> > +	return !!q->css_fmt;
> 
> No need for !!.
> 

The original code "return q->css_fmt !=NULL;" is more explicit, I changed to the current form to silent checkpatch.pl CHECK for null comparison.

> > +}
> > +
> >  /******************* css hw *******************/
> >

(snip)

> > +	/* Configure SP group */
> > +
> > +	sp_group = css->xmem_sp_group_ptrs.vaddr;
> > +	memset(sp_group, 0, sizeof(*sp_group));
> > +
> > +	sp_group->pipe[thread].num_stages = 1;
> > +	sp_group->pipe[thread].pipe_id = PIPE_ID;
> > +	sp_group->pipe[thread].thread_id = thread;
> > +	sp_group->pipe[thread].pipe_num = pipe;
> > +	sp_group->pipe[thread].num_execs = -1;
> > +	sp_group->pipe[thread].pipe_qos_config = -1;
> > +	sp_group->pipe[thread].required_bds_factor = 0;
> > +	sp_group->pipe[thread].dvs_frame_delay = IPU3_CSS_AUX_FRAMES
> - 1;
> > +	sp_group->pipe[thread].inout_port_config =
> > +	    IMGU_ABI_PORT_CONFIG_TYPE_INPUT_HOST |
> > +	    IMGU_ABI_PORT_CONFIG_TYPE_OUTPUT_HOST;
> 
> Indentation. Most of this seems to have been fixed but some remains in this
> patch at least. Could you address that for the next version, please?

Yes, will fix all indentation in next version.

> 
> > +	sp_group->pipe[thread].scaler_pp_lut = 0;
> > +	sp_group-
> >pipe[thread].shading.internal_frame_origin_x_bqs_on_sctbl = 0;
> > +	sp_group-
> >pipe[thread].shading.internal_frame_origin_y_bqs_on_sctbl = 0;
> > +	sp_group->pipe[thread].sp_stage_addr[stage] =
> > +	    css->xmem_sp_stage_ptrs[pipe][stage].daddr;
> > +	sp_group->pipe[thread].pipe_config =
> > +	    bi->info.isp.sp.enable.params ? (1 << thread) : 0;

(snip)

> > +int ipu3_css_set_parameters(struct ipu3_css *css,
> > +			    struct ipu3_uapi_params *set_params,
> > +			    struct ipu3_uapi_gdc_warp_param *set_gdc,
> > +			    unsigned int gdc_bytes,
> > +			    struct ipu3_uapi_obgrid_param *set_obgrid,
> > +			    unsigned int obgrid_bytes)
> > +{
> > +	static const unsigned int queue_id = IMGU_ABI_QUEUE_A_ID;
> > +	const int stage = 0, thread = 0;
> > +	const struct imgu_fw_info *bi;
> > +	int obgrid_size;
> > +	unsigned int stripes;
> > +	struct ipu3_uapi_flags *use = set_params ? &set_params->use : NULL;
> > +
> > +	/* Destination buffers which are filled here */
> > +	struct imgu_abi_parameter_set_info *param_set;
> > +	struct ipu3_uapi_acc_param *acc = NULL;
> > +	struct ipu3_uapi_gdc_warp_param *gdc = NULL;
> > +	struct ipu3_uapi_obgrid_param *obgrid = NULL;
> > +	const struct ipu3_css_map *map;
> > +	void *vmem0 = NULL;
> > +	void *dmem0 = NULL;
> > +
> > +	enum imgu_abi_memories m;
> > +	int r = -EBUSY;
> > +	int s;
> > +
> > +	if (!css->streaming)
> > +		return -EPROTO;
> > +
> > +	bi = &css->fwp->binary_header[css->current_binary];
> > +	obgrid_size = ipu3_css_fw_obgrid_size(bi);
> > +	stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
> > +
> > +	/*
> > +	 * Check that we can get a new parameter_set_info from the pool.
> > +	 * If this succeeds, then all of the other pool_get() calls below
> > +	 * should also succeed.
> > +	 */
> > +	if (ipu3_css_pool_get(&css->pool.parameter_set_info, css->frame) <
> 0)
> > +		goto fail_no_put;
> 
> The size of the pool is always four. If there were four parameter buffers
> queued, this would fails, wouldn't it? And that would lead to a failure in
> queueing the buffer, too, right?
> 
> How about associating a kernel-only buffer with each parameter buffer?
> 

I learned from the engineer who knows the use pattern of above API between user space and kernel, that the size of the pool is rather safe, 
Queuing parameter failure should not happen under normal condition. 

> > +	param_set = ipu3_css_pool_last(&css->pool.parameter_set_info, 0)-
> >vaddr;
> > +
> > +	/* Get a new acc only if new parameters given, or none yet */
> > +	if (set_params || !ipu3_css_pool_last(&css->pool.acc, 0)->vaddr) {
> > +		if (ipu3_css_pool_get(&css->pool.acc, css->frame) < 0)
> > +			goto fail;
> > +		acc = ipu3_css_pool_last(&css->pool.acc, 0)->vaddr;
> > +	}
> > +
> > +	/* Get new VMEM0 only if needed, or none yet */
> > +	m = IMGU_ABI_MEM_ISP_VMEM0;
> > +	if (!ipu3_css_pool_last(&css->pool.binary_params_p[m], 0)->vaddr
> ||
> > +	    (set_params && (set_params->use.lin_vmem_params ||
> > +			    set_params->use.tnr3_vmem_params ||
> > +			    set_params->use.xnr3_vmem_params))) {
> > +		if (ipu3_css_pool_get(&css->pool.binary_params_p[m],
> > +				      css->frame) < 0)
> > +			goto fail;
> > +		vmem0 = ipu3_css_pool_last(&css-
> >pool.binary_params_p[m], 0)
> > +		    ->vaddr;
> > +	}
> > +
> > +	/* Get new DMEM0 only if needed, or none yet */
> > +	m = IMGU_ABI_MEM_ISP_DMEM0;
> > +	if (!ipu3_css_pool_last(&css->pool.binary_params_p[m], 0)->vaddr
> ||
> > +	    (set_params && (set_params->use.tnr3_dmem_params ||
> > +			    set_params->use.xnr3_dmem_params))) {
> > +		if (ipu3_css_pool_get(&css->pool.binary_params_p[m],
> > +				      css->frame) < 0)
> > +			goto fail;
> > +		dmem0 = ipu3_css_pool_last(&css-
> >pool.binary_params_p[m], 0)
> > +		    ->vaddr;
> > +	}
> > +
> > +	/* Configure acc parameter cluster */
> > +	if (acc) {
> > +		map = ipu3_css_pool_last(&css->pool.acc, 1);
> > +		r = ipu3_css_cfg_acc(css, use, acc, map->vaddr, set_params ?
> > +				     &set_params->acc_param : NULL);
> > +		if (r < 0)
> > +			goto fail;
> > +	}
> > +
> > +	/* Configure late binding parameters */
> > +	if (vmem0) {
> > +		m = IMGU_ABI_MEM_ISP_VMEM0;
> > +		map = ipu3_css_pool_last(&css->pool.binary_params_p[m],
> 1);
> > +		r = ipu3_css_cfg_vmem0(css, use, vmem0, map->vaddr,
> set_params);
> > +		if (r < 0)
> > +			goto fail;
> > +	}
> > +
> > +	if (dmem0) {
> > +		m = IMGU_ABI_MEM_ISP_DMEM0;
> > +		map = ipu3_css_pool_last(&css->pool.binary_params_p[m],
> 1);
> > +		r = ipu3_css_cfg_dmem0(css, use, dmem0, map->vaddr,
> set_params);
> > +		if (r < 0)
> > +			goto fail;
> > +	}
> > +
> > +	/* Get a new gdc only if a new gdc is given, or none yet */
> > +	if (bi->info.isp.sp.enable.dvs_6axis) {
> > +		unsigned int a = IPU3_CSS_AUX_FRAME_REF;
> > +		unsigned int g = IPU3_CSS_RECT_GDC;
> > +
> > +		map = ipu3_css_pool_last(&css->pool.gdc, 0);
> > +
> > +		if (set_params && !set_params->use.gdc)
> > +			set_gdc = NULL;
> > +		if (set_gdc || !map->vaddr) {
> > +			if (ipu3_css_pool_get(&css->pool.gdc, css->frame) < 0)
> > +
> > +				goto fail;
> > +			map = ipu3_css_pool_last(&css->pool.gdc, 0);
> > +			gdc =  map->vaddr;
> > +			ipu3_css_cfg_gdc_table(gdc,
> > +					       css->aux_frames[a].bytesperline
> /
> > +					       css->aux_frames[a].bytesperpixel,
> > +					       css->aux_frames[a].height,
> > +					       css->rect[g].width,
> > +					       css->rect[g].height);
> > +		}
> > +	}
> > +
> > +	/* Get a new obgrid only if a new obgrid is given, or none yet */
> > +	if (set_params && !set_params->use.obgrid)
> > +		set_obgrid = NULL;
> > +	if (set_obgrid && obgrid_bytes < obgrid_size / stripes)
> > +		goto fail;
> > +	if (set_obgrid || (set_params && set_params->use.obgrid_param) ||
> > +	    !ipu3_css_pool_last(&css->pool.obgrid, 0)->vaddr) {
> > +		if (ipu3_css_pool_get(&css->pool.obgrid, css->frame) < 0)
> > +			goto fail;
> > +		map = ipu3_css_pool_last(&css->pool.obgrid, 0);
> > +		obgrid = map->vaddr;
> > +
> > +		/* Configure optical black level grid (obgrid) */
> > +		if (set_obgrid) {
> > +			for (s = 0; s < stripes; s++)
> > +				memcpy((void *)obgrid +
> > +					(obgrid_size / stripes) * s, set_obgrid,
> > +					obgrid_size / stripes);
> > +
> > +		} else if (set_params && set_params->use.obgrid_param) {
> > +			for (s = 0; s < obgrid_size / sizeof(*obgrid); s++)
> > +				obgrid[s] = set_params->obgrid_param;
> > +		} else {
> > +			memset(obgrid, 0, obgrid_size);
> > +		}
> > +	}
> > +
> > +	/* Configure parameter set info, queued to `queue_id' */
> > +
> > +	memset(param_set, 0, sizeof(*param_set));
> > +
> > +	param_set->mem_map.acc_cluster_params_for_sp =
> > +	    ipu3_css_pool_last(&css->pool.acc, 0)->daddr;
> > +
> > +	param_set->mem_map.dvs_6axis_params_y =
> > +	    ipu3_css_pool_last(&css->pool.gdc, 0)->daddr;
> > +
> > +	for (s = 0; s < stripes; s++)
> > +		param_set->mem_map.obgrid_tbl[s] =
> > +		    ipu3_css_pool_last(&css->pool.obgrid, 0)->daddr +
> > +		    (obgrid_size / stripes) * s;
> > +
> > +	for (m = 0; m < IMGU_ABI_NUM_MEMORIES; m++)
> > +		param_set->mem_map.isp_mem_param[stage][m] =
> > +		    ipu3_css_pool_last(&css->pool.binary_params_p[m], 0)
> > +		    ->daddr;
> > +
> > +	/* Then queue the new parameter buffer */
> > +	map = ipu3_css_pool_last(&css->pool.parameter_set_info, 0);
> > +	r = ipu3_css_queue_data(css, queue_id, thread, map->daddr);
> > +	if (r < 0)
> > +		goto fail;
> > +
> > +	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, 0,
> > +
> 	IMGU_ABI_EVENT_BUFFER_ENQUEUED(thread,
> > +							       queue_id));
> > +	if (r < 0)
> > +		goto fail_no_put;
> > +
> > +	/* Finally dequeue all old parameter buffers */
> > +
> > +	do {
> > +		u32 daddr;
> > +
> > +		r = ipu3_css_dequeue_data(css, queue_id, &daddr);
> > +		if (r == -EBUSY)
> > +			break;
> > +		if (r)
> > +			goto fail_no_put;
> > +		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID,
> thread,
> > +
> 	IMGU_ABI_EVENT_BUFFER_DEQUEUED
> > +					(queue_id));
> > +		if (r < 0) {
> > +			dev_err(css->dev, "failed to queue parameter
> event\n");
> > +			goto fail_no_put;
> > +		}
> > +	} while (1);
> > +
> > +	return 0;
> > +
> > +fail:
> > +	/*
> > +	 * A failure, most likely the parameter queue was full.
> > +	 * Return error but continue streaming. User can try submitting new
> > +	 * parameters again later.
> > +	 */
> > +
> > +	ipu3_css_pool_put(&css->pool.parameter_set_info);
> > +	if (acc)
> > +		ipu3_css_pool_put(&css->pool.acc);
> > +	if (gdc)
> > +		ipu3_css_pool_put(&css->pool.gdc);
> > +	if (obgrid)
> > +		ipu3_css_pool_put(&css->pool.obgrid);
> > +	if (vmem0)
> > +		ipu3_css_pool_put(
> > +			&css-
> >pool.binary_params_p[IMGU_ABI_MEM_ISP_VMEM0]);
> > +	if (dmem0)
> > +		ipu3_css_pool_put(
> > +			&css-
> >pool.binary_params_p[IMGU_ABI_MEM_ISP_DMEM0]);
> > +
> > +fail_no_put:
> > +	return r;
> > +}
> >
> >  void ipu3_css_irq_ack(struct ipu3_css *css)
> >  {
> > @@ -501,7 +2260,7 @@ void ipu3_css_irq_ack(struct ipu3_css *css)
> >  					bi->info.sp.output + 4 + 4 * i);
> >
> >  			dev_dbg(css->dev, "%s: swirq %i cnt %i val 0x%x\n",
> > -				 __func__, i, cnt, val);
> > +				__func__, i, cnt, val);
> >  		}
> >  	}
> >
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.h
> b/drivers/media/pci/intel/ipu3/ipu3-css.h
> > index 5b8e92d47f5d..43627df9910d 100644
> > --- a/drivers/media/pci/intel/ipu3/ipu3-css.h
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-css.h
> > @@ -16,6 +16,8 @@
> >
> >  #include <linux/videodev2.h>
> >  #include <linux/types.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/videobuf2-core.h>
> >  #include "ipu3-abi.h"
> >  #include "ipu3-css-pool.h"
> >
> > @@ -39,6 +41,12 @@
> >  #define IPU3_CSS_QUEUE_STAT_LACE	6
> >  #define IPU3_CSS_QUEUES			7
> >
> > +#define IPU3_CSS_RECT_EFFECTIVE		0       /* Effective resolution */
> > +#define IPU3_CSS_RECT_BDS		1       /* Resolution after BDS
> */
> > +#define IPU3_CSS_RECT_ENVELOPE		2       /* DVS envelope size */
> > +#define IPU3_CSS_RECT_GDC		3       /* gdc output res */
> > +#define IPU3_CSS_RECTS			4       /* number of rects */
> > +
> >  #define IA_CSS_BINARY_MODE_PRIMARY	2
> >  #define IA_CSS_BINARY_MODE_VIDEO	3
> >
> > @@ -56,6 +64,33 @@ enum ipu3_css_pipe_id {
> >  	IPU3_CSS_PIPE_ID_NUM
> >  };
> >
> > +struct ipu3_css_resolution {
> > +	u32 w;
> > +	u32 h;
> > +};
> > +
> > +enum ipu3_css_vf_status {
> > +	IPU3_NODE_VF_ENABLED,
> > +	IPU3_NODE_PV_ENABLED,
> > +	IPU3_NODE_VF_DISABLED
> > +};
> > +
> > +enum ipu3_css_buffer_state {
> > +	IPU3_CSS_BUFFER_NEW,	/* Not yet queued */
> > +	IPU3_CSS_BUFFER_QUEUED,	/* Queued, waiting to be filled */
> > +	IPU3_CSS_BUFFER_DONE,	/* Finished processing, removed
> from queue */
> > +	IPU3_CSS_BUFFER_FAILED,	/* Was not processed, removed from
> queue */
> > +};
> > +
> > +struct ipu3_css_buffer {
> > +	/* Private fields: user doesn't touch */
> > +	dma_addr_t daddr;
> > +	unsigned int queue;
> > +	enum ipu3_css_buffer_state state;
> > +	struct list_head list;
> > +	u8 queue_pos;
> > +};
> > +
> >  struct ipu3_css_format {
> >  	u32 pixelformat;
> >  	enum v4l2_colorspace colorspace;
> > @@ -126,11 +161,65 @@ struct ipu3_css {
> >
> >  	struct ipu3_css_queue queue[IPU3_CSS_QUEUES];
> >  	struct v4l2_rect rect[IPU3_CSS_RECTS];
> > +	struct ipu3_css_map abi_buffers[IPU3_CSS_QUEUES]
> > +				    [IMGU_ABI_HOST2SP_BUFQ_SIZE];
> > +
> > +	struct {
> > +		struct ipu3_css_pool parameter_set_info;
> > +		struct ipu3_css_pool acc;
> > +		struct ipu3_css_pool gdc;
> > +		struct ipu3_css_pool obgrid;
> > +		/* PARAM_CLASS_PARAM parameters for binding while
> streaming */
> > +		struct ipu3_css_pool
> binary_params_p[IMGU_ABI_NUM_MEMORIES];
> > +	} pool;
> > +
> > +	enum ipu3_css_vf_status vf_output_en;
> >  };
> >
> > +/******************* css v4l *******************/
> > +int ipu3_css_init(struct device *dev, struct ipu3_css *css,
> > +		  void __iomem *base, int length);
> > +void ipu3_css_cleanup(struct ipu3_css *css);
> > +int ipu3_css_fmt_try(struct ipu3_css *css,
> > +		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
> > +		     struct v4l2_rect *rects[IPU3_CSS_RECTS]);
> > +int ipu3_css_fmt_set(struct ipu3_css *css,
> > +		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
> > +		     struct v4l2_rect *rects[IPU3_CSS_RECTS]);
> > +int ipu3_css_meta_fmt_set(struct v4l2_meta_format *fmt);
> > +int ipu3_css_buf_queue(struct ipu3_css *css, struct ipu3_css_buffer *b);
> > +struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css);
> > +int ipu3_css_start_streaming(struct ipu3_css *css);
> > +void ipu3_css_stop_streaming(struct ipu3_css *css);
> > +bool ipu3_css_queue_empty(struct ipu3_css *css);
> > +bool ipu3_css_is_streaming(struct ipu3_css *css);
> > +
> >  /******************* css hw *******************/
> >  int ipu3_css_set_powerup(struct device *dev, void __iomem *base);
> >  int ipu3_css_set_powerdown(struct device *dev, void __iomem *base);
> >  void ipu3_css_irq_ack(struct ipu3_css *css);
> >
> > +/******************* set parameters ************/
> > +int ipu3_css_set_parameters(struct ipu3_css *css,
> > +		struct ipu3_uapi_params *set_params,
> > +		struct ipu3_uapi_gdc_warp_param *set_gdc,
> > +		unsigned int gdc_bytes,
> > +		struct ipu3_uapi_obgrid_param *set_obgrid,
> > +		unsigned int obgrid_bytes);
> > +
> > +/******************* css misc *******************/
> > +static inline enum ipu3_css_buffer_state
> > +ipu3_css_buf_state(struct ipu3_css_buffer *b)
> > +{
> > +	return b->state;
> > +}
> > +
> > +/* Initialize given buffer. May be called several times. */
> > +static inline void ipu3_css_buf_init(struct ipu3_css_buffer *b,
> > +				     unsigned int queue, dma_addr_t daddr)
> > +{
> > +	b->state = IPU3_CSS_BUFFER_NEW;
> > +	b->queue = queue;
> > +	b->daddr = daddr;
> > +}
> >  #endif
> 
> --
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
