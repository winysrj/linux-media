Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51427 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbeKZTxh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 14:53:37 -0500
Date: Mon, 26 Nov 2018 09:00:09 +0000
From: Sean Young <sean@mess.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>, Roman Gushchin <guro@fb.com>,
        Martin KaFai Lau <kafai@fb.com>, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] media: bpf: add bpf function to report mouse movement
Message-ID: <20181126090009.rhhp5hisimuo3xvt@gofer.mess.org>
References: <20181123115040.13725-1-sean@mess.org>
 <4d72a8da-75c5-5050-6f85-c06694ad1b64@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d72a8da-75c5-5050-6f85-c06694ad1b64@iogearbox.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Mon, Nov 26, 2018 at 01:55:36AM +0100, Daniel Borkmann wrote:
> Hi Sean,
> 
> On 11/23/2018 12:50 PM, Sean Young wrote:
> > Some IR remotes have a directional pad or other pointer-like thing that
> > can be used as a mouse. Make it possible to decode these types of IR
> > protocols in BPF.
> > 
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Sean Young <sean@mess.org>
> 
> Is this patch targeted at bpf-next tree?

You're right, I missed the bpf-next tag.

> > ---
> >  drivers/media/rc/bpf-lirc.c               | 24 +++++++++++++++++++++++
> >  include/uapi/linux/bpf.h                  | 17 +++++++++++++++-
> >  tools/testing/selftests/bpf/bpf_helpers.h |  2 ++
> >  3 files changed, 42 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
> > index 8b97fd1f0cea..390a722e6211 100644
> > --- a/drivers/media/rc/bpf-lirc.c
> > +++ b/drivers/media/rc/bpf-lirc.c
> > @@ -59,6 +59,28 @@ static const struct bpf_func_proto rc_keydown_proto = {
> >  	.arg4_type = ARG_ANYTHING,
> >  };
> >  
> > +BPF_CALL_3(bpf_rc_pointer_rel, u32*, sample, s32, rel_x, s32, rel_y)
> > +{
> > +	struct ir_raw_event_ctrl *ctrl;
> > +
> > +	ctrl = container_of(sample, struct ir_raw_event_ctrl, bpf_sample);
> > +
> > +	input_report_rel(ctrl->dev->input_dev, REL_X, rel_x);
> > +	input_report_rel(ctrl->dev->input_dev, REL_Y, rel_y);
> > +	input_sync(ctrl->dev->input_dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct bpf_func_proto rc_pointer_rel_proto = {
> > +	.func	   = bpf_rc_pointer_rel,
> > +	.gpl_only  = true,
> > +	.ret_type  = RET_INTEGER,
> > +	.arg1_type = ARG_PTR_TO_CTX,
> > +	.arg2_type = ARG_ANYTHING,
> > +	.arg3_type = ARG_ANYTHING,
> > +};
> > +
> >  static const struct bpf_func_proto *
> >  lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >  {
> > @@ -67,6 +89,8 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >  		return &rc_repeat_proto;
> >  	case BPF_FUNC_rc_keydown:
> >  		return &rc_keydown_proto;
> > +	case BPF_FUNC_rc_pointer_rel:
> > +		return &rc_pointer_rel_proto;
> >  	case BPF_FUNC_map_lookup_elem:
> >  		return &bpf_map_lookup_elem_proto;
> >  	case BPF_FUNC_map_update_elem:
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 23e2031a43d4..3499a1555bbf 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2268,6 +2268,20 @@ union bpf_attr {
> >   *
> >   *	Return
> >   *		0 on success, or a negative error in case of failure.
> > + *
> > + * int bpf_rc_pointer_rel(void *ctx, s32 rel_x, s32 rel_y)
> > + *	Description
> > + *		This helper is used in programs implementing IR decoding, to
> > + *		report a successfully decoded pointer movement.
> > + *
> > + *		The *ctx* should point to the lirc sample as passed into
> > + *		the program.
> > + *
> > + *		This helper is only available is the kernel was compiled with
> > + *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
> > + *		"**y**".
> > + *	Return
> > + *		0
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)		\
> >  	FN(unspec),			\
> > @@ -2360,7 +2374,8 @@ union bpf_attr {
> >  	FN(map_push_elem),		\
> >  	FN(map_pop_elem),		\
> >  	FN(map_peek_elem),		\
> > -	FN(msg_push_data),
> > +	FN(msg_push_data),		\
> > +	FN(rc_pointer_rel),
> >  
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >   * function eBPF program intends to call
> > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > index 686e57ce40f4..5c900a917fa4 100644
> > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > @@ -168,6 +168,8 @@ static int (*bpf_skb_vlan_push)(void *ctx, __be16 vlan_proto, __u16 vlan_tci) =
> >  	(void *) BPF_FUNC_skb_vlan_push;
> >  static int (*bpf_skb_vlan_pop)(void *ctx) =
> >  	(void *) BPF_FUNC_skb_vlan_pop;
> > +static int (*bpf_rc_pointer_rel)(void *ctx, int rel_x, int rel_y) =
> > +	(void *) BPF_FUNC_rc_pointer_rel;
> >  
> >  /* llvm builtin functions that eBPF C program may use to
> >   * emit BPF_LD_ABS and BPF_LD_IND instructions
> > 
> 
> tools/include/uapi/linux/bpf.h would have to be synced as well here.

That's true.

> Probably would be good to extend the lirc2 BPF kselftest as well?

Again, good point.

Thank you for review! I'll post a new version when it is ready.


Sean
