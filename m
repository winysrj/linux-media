Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46260 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754453AbdKMN00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 08:26:26 -0500
Date: Mon, 13 Nov 2017 15:26:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>
Subject: Re: [PATCH v4 10/12] intel-ipu3: css pipeline
Message-ID: <20171113132622.qpieoqxqkpwhxlbg@valkosipuli.retiisi.org.uk>
References: <1508298896-26096-1-git-send-email-yong.zhi@intel.com>
 <1508298896-26096-7-git-send-email-yong.zhi@intel.com>
 <20171101185723.66f7xfsem4npmhfp@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1AE34AC3@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AE34AC3@ORSMSX106.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Nov 10, 2017 at 10:35:43PM +0000, Zhi, Yong wrote:
> Hi, Sakari,
> 
> Thanks for the review.
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Sakari Ailus
> > Sent: Wednesday, November 1, 2017 11:57 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> > Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>
> > Subject: Re: [PATCH v4 10/12] intel-ipu3: css pipeline
> > 
> > Hi Yong,
> > 
> > Apologies for the late reply. Please find my (few) comments below.
> > 
> > On Tue, Oct 17, 2017 at 10:54:55PM -0500, Yong Zhi wrote:
> > > Add css pipeline and v4l code.
> > >
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > ---
> > >  drivers/media/pci/intel/ipu3/ipu3-css.c | 1761
> > ++++++++++++++++++++++++++++++-
> > >  drivers/media/pci/intel/ipu3/ipu3-css.h |   89 ++
> > >  2 files changed, 1849 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.c
> > b/drivers/media/pci/intel/ipu3/ipu3-css.c
> > > index 6e615bf9378a..11f7ad3514c3 100644
> > > --- a/drivers/media/pci/intel/ipu3/ipu3-css.c
> > > +++ b/drivers/media/pci/intel/ipu3/ipu3-css.c
> > > @@ -13,9 +13,16 @@
> 
> (snip)
> 
> > > +static bool ipu3_css_queue_enabled(struct ipu3_css_queue *q)
> > > +{
> > > +	return !!q->css_fmt;
> > 
> > No need for !!.
> > 
> 
> The original code "return q->css_fmt !=NULL;" is more explicit, I changed
> to the current form to silent checkpatch.pl CHECK for null comparison.

Ok. You're still basically checking whether it's non-NULL, and casting an
non-zero value to bool converts it as true. So you don't need !!.

> 
> > > +}
> > > +
> > >  /******************* css hw *******************/
> > >
> 
> (snip)
> 
> > > +	/* Configure SP group */
> > > +
> > > +	sp_group = css->xmem_sp_group_ptrs.vaddr;
> > > +	memset(sp_group, 0, sizeof(*sp_group));
> > > +
> > > +	sp_group->pipe[thread].num_stages = 1;
> > > +	sp_group->pipe[thread].pipe_id = PIPE_ID;
> > > +	sp_group->pipe[thread].thread_id = thread;
> > > +	sp_group->pipe[thread].pipe_num = pipe;
> > > +	sp_group->pipe[thread].num_execs = -1;
> > > +	sp_group->pipe[thread].pipe_qos_config = -1;
> > > +	sp_group->pipe[thread].required_bds_factor = 0;
> > > +	sp_group->pipe[thread].dvs_frame_delay = IPU3_CSS_AUX_FRAMES
> > - 1;
> > > +	sp_group->pipe[thread].inout_port_config =
> > > +	    IMGU_ABI_PORT_CONFIG_TYPE_INPUT_HOST |
> > > +	    IMGU_ABI_PORT_CONFIG_TYPE_OUTPUT_HOST;
> > 
> > Indentation. Most of this seems to have been fixed but some remains in this
> > patch at least. Could you address that for the next version, please?
> 
> Yes, will fix all indentation in next version.
> 
> > 
> > > +	sp_group->pipe[thread].scaler_pp_lut = 0;
> > > +	sp_group-
> > >pipe[thread].shading.internal_frame_origin_x_bqs_on_sctbl = 0;
> > > +	sp_group-
> > >pipe[thread].shading.internal_frame_origin_y_bqs_on_sctbl = 0;
> > > +	sp_group->pipe[thread].sp_stage_addr[stage] =
> > > +	    css->xmem_sp_stage_ptrs[pipe][stage].daddr;
> > > +	sp_group->pipe[thread].pipe_config =
> > > +	    bi->info.isp.sp.enable.params ? (1 << thread) : 0;
> 
> (snip)
> 
> > > +int ipu3_css_set_parameters(struct ipu3_css *css,
> > > +			    struct ipu3_uapi_params *set_params,
> > > +			    struct ipu3_uapi_gdc_warp_param *set_gdc,
> > > +			    unsigned int gdc_bytes,
> > > +			    struct ipu3_uapi_obgrid_param *set_obgrid,
> > > +			    unsigned int obgrid_bytes)
> > > +{
> > > +	static const unsigned int queue_id = IMGU_ABI_QUEUE_A_ID;
> > > +	const int stage = 0, thread = 0;
> > > +	const struct imgu_fw_info *bi;
> > > +	int obgrid_size;
> > > +	unsigned int stripes;
> > > +	struct ipu3_uapi_flags *use = set_params ? &set_params->use : NULL;
> > > +
> > > +	/* Destination buffers which are filled here */
> > > +	struct imgu_abi_parameter_set_info *param_set;
> > > +	struct ipu3_uapi_acc_param *acc = NULL;
> > > +	struct ipu3_uapi_gdc_warp_param *gdc = NULL;
> > > +	struct ipu3_uapi_obgrid_param *obgrid = NULL;
> > > +	const struct ipu3_css_map *map;
> > > +	void *vmem0 = NULL;
> > > +	void *dmem0 = NULL;
> > > +
> > > +	enum imgu_abi_memories m;
> > > +	int r = -EBUSY;
> > > +	int s;
> > > +
> > > +	if (!css->streaming)
> > > +		return -EPROTO;
> > > +
> > > +	bi = &css->fwp->binary_header[css->current_binary];
> > > +	obgrid_size = ipu3_css_fw_obgrid_size(bi);
> > > +	stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
> > > +
> > > +	/*
> > > +	 * Check that we can get a new parameter_set_info from the pool.
> > > +	 * If this succeeds, then all of the other pool_get() calls below
> > > +	 * should also succeed.
> > > +	 */
> > > +	if (ipu3_css_pool_get(&css->pool.parameter_set_info, css->frame) <
> > 0)
> > > +		goto fail_no_put;
> > 
> > The size of the pool is always four. If there were four parameter buffers
> > queued, this would fails, wouldn't it? And that would lead to a failure in
> > queueing the buffer, too, right?
> > 
> > How about associating a kernel-only buffer with each parameter buffer?
> > 
> 
> I learned from the engineer who knows the use pattern of above API
> between user space and kernel, that the size of the pool is rather safe,
> Queuing parameter failure should not happen under normal condition.

>From the API point of view the limit is still arbitrary. You could address
this at least by either limit the number of buffers to four, or increasing
the number of pool buffers. The internal logic could be changed, too, so
that the parameters are copied just before sending the buffers to the
device for processing. That's same some memory, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
