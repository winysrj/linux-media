Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34723 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbIPVWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 17:22:50 -0400
Date: Wed, 16 Sep 2015 16:22:47 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture
 driver
Message-ID: <20150916212247.GB15997@ti.com>
References: <1434475763-20294-1-git-send-email-bparrot@ti.com>
 <1434475763-20294-2-git-send-email-bparrot@ti.com>
 <5587C29C.20506@xs4all.nl>
 <20150623193647.GG31636@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150623193647.GG31636@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I am almost done with my review comment but I am stuck here.

Benoit Parrot <bparrot@ti.com> wrote on Tue [2015-Jun-23 14:36:47 -0500]:
> > > +
> > > +static int cal_get_external_info(struct cal_ctx *ctx)
> > > +{
> > > +	struct v4l2_ext_control ctrl_ext;
> > > +	struct v4l2_ext_controls ctrls_ext;
> > > +	int ret;
> > > +
> > > +	ctx_dbg(3, ctx, "%s\n", __func__);
> > > +
> > > +	memset(&ctrls_ext, 0, sizeof(ctrls_ext));
> > > +	memset(&ctrl_ext, 0, sizeof(ctrl_ext));
> > > +
> > > +	ctrl_ext.id = V4L2_CID_PIXEL_RATE;
> > > +
> > > +	ctrls_ext.count = 1;
> > > +	ctrls_ext.controls = &ctrl_ext;
> > > +
> > > +	ret = v4l2_g_ext_ctrls(&ctx->ctrl_handler, &ctrls_ext);
> > 
> > Use v4l2_ctrl_g_ctrl_int64() instead: much simpler. You do need to store the
> > v4l2_ctrl pointer for the pixel rate control when you create it, but that's no
> > problem. (or use v4l2_ctrl_find, but I prefer to just cache the pointer).
> 
> Hmm, that's how I had it in our local 3.14 branch originally but I kept
> getting 0 instead of the actual pixel rate.
> I'll revert it back and test again against linux-media/master.
> 
> > 
> > > +	if (ret < 0) {
> > > +		ctx_err(ctx, "no pixel rate control in subdev: %s\n",
> > > +			ctx->sensor->name);
> > > +		return -EPIPE;
> > > +	}
> > > +
> > > +	ctx->external_rate = ctrl_ext.value64;
> > > +	ctx_dbg(3, ctx, "sensor Pixel Rate: %d\n", ctx->external_rate);
> > > +
> > > +	return 0;
> > > +}

Alright, in order to comply with this comment I rewrote the above function
as follows:

static int cal_get_external_info(struct cal_ctx *ctx)
{
	struct v4l2_ctrl *ctrl;
	s64 val;
	ctx_dbg(3, ctx, "%s\n", __func__);

	ctrl = v4l2_ctrl_find(&ctx->ctrl_handler, V4L2_CID_PIXEL_RATE);
//	ctrl = v4l2_ctrl_find(ctx->sensor->ctrl_handler, V4L2_CID_PIXEL_RATE);
	if (ctrl == NULL) {
		ctx_err(ctx, "no pixel rate control in subdev: %s\n",
			ctx->sensor->name);
		return -EPIPE;
	}

//	ctx->external_rate = v4l2_ctrl_g_ctrl_int64(ctrl);
	val = v4l2_ctrl_g_ctrl_int64(ctrl);
	ctx_dbg(3, ctx, "sensor Pixel Rate: s64 %lld\n", val);
	ctx->external_rate = (unsigned int)val;
	ctx_dbg(3, ctx, "sensor Pixel Rate: %d\n", ctx->external_rate);

       return 0;
}

But in all cases the value I get from v4l2_ctrl_g_ctrl_int64 is always zero!
Now I have tripple check with debug code that the subdev is in fact setting
the p_cur and p_new value to something useful (i.e. not 0).

I have traced it down to the get_ctrl() call inside of v4l2_ctrl_g_ctrl_int64.

static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
  {
          struct v4l2_ctrl *master = ctrl->cluster[0];
          int ret = 0;
          int i;
  
	printk("BENOIT: ==> get_ctrl: ctrl name:%s cur: %lld new: %lld\n",
        ctrl->name, *ctrl->p_cur.p_s64, *ctrl->p_new.p_s64);
          /* Compound controls are not supported. The new_to_user() and
           * cur_to_user() calls below would need to be modified not to access
           * userspace memory when called from get_ctrl().
           */
	printk("BENOIT: ==> get_ctrl: ctrl name:%s is_int: %d\n", ctrl->name, ctrl->is_int);
          if (!ctrl->is_int)
                  return -EINVAL;

**** It always exits here, because for int64_integer the is_int is not set!
**** which means on the way back out the value reported will always be 0!
  
	printk("BENOIT: ==> get_ctrl: ctrl name:%s flags: 0x%08lx\n", ctrl->name, ctrl->flags);
          if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
                  return -EACCES;
  
	printk("BENOIT: ==> get_ctrl: ctrl name:%s before ctrl_lock:\n", ctrl->name);
          v4l2_ctrl_lock(master);
          /* g_volatile_ctrl will update the current control values */
          if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
                  for (i = 0; i < master->ncontrols; i++)
                          cur_to_new(master->cluster[i]);
                  ret = call_op(master, g_volatile_ctrl);
                  new_to_user(c, ctrl);
          } else {
                  cur_to_user(c, ctrl);
          }
	printk("BENOIT: <== get_ctrl: ctrl name:%s cur: %lld new: %lld\n",
        	ctrl->name, *ctrl->p_cur.p_s64, *ctrl->p_new.p_s64);
          v4l2_ctrl_unlock(master);
          return ret;
  }

As anyone ever used this successfully to read a V4L2_CID_PIXEL_RATE control value?

Regards,
Benoit

