Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40479 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbeEOKaP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 06:30:15 -0400
Date: Tue, 15 May 2018 11:30:12 +0100
From: Sean Young <sean@mess.org>
To: Y Song <ys114321@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v1 1/4] media: rc: introduce BPF_PROG_IR_DECODER
Message-ID: <20180515103012.egptnp5qci2ugp5k@gofer.mess.org>
References: <cover.1526331777.git.sean@mess.org>
 <32a944171d5c48abf126259595b0088ce3122c91.1526331777.git.sean@mess.org>
 <CAH3MdRXkzpJZ=VLwJWpuwiNhcjJwjNqpaZXwk+1-HfL_7hjJew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3MdRXkzpJZ=VLwJWpuwiNhcjJwjNqpaZXwk+1-HfL_7hjJew@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 14, 2018 at 09:48:05PM -0700, Y Song wrote:
> On Mon, May 14, 2018 at 2:10 PM, Sean Young <sean@mess.org> wrote:
> > Add support for BPF_PROG_IR_DECODER. This type of BPF program can call
> > rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
> > that the last key should be repeated.
> >
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/Kconfig          |  8 +++
> >  drivers/media/rc/Makefile         |  1 +
> >  drivers/media/rc/ir-bpf-decoder.c | 93 +++++++++++++++++++++++++++++++
> >  include/linux/bpf_types.h         |  3 +
> >  include/uapi/linux/bpf.h          | 16 +++++-
> >  5 files changed, 120 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/media/rc/ir-bpf-decoder.c
> >
> > diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> > index eb2c3b6eca7f..10ad6167d87c 100644
> > --- a/drivers/media/rc/Kconfig
> > +++ b/drivers/media/rc/Kconfig
> > @@ -120,6 +120,14 @@ config IR_IMON_DECODER
> >            remote control and you would like to use it with a raw IR
> >            receiver, or if you wish to use an encoder to transmit this IR.
> >
> > +config IR_BPF_DECODER
> > +       bool "Enable IR raw decoder using BPF"
> > +       depends on BPF_SYSCALL
> > +       depends on RC_CORE=y
> > +       help
> > +          Enable this option to make it possible to load custom IR
> > +          decoders written in BPF.
> > +
> >  endif #RC_DECODERS
> >
> >  menuconfig RC_DEVICES
> > diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> > index 2e1c87066f6c..12e1118430d0 100644
> > --- a/drivers/media/rc/Makefile
> > +++ b/drivers/media/rc/Makefile
> > @@ -5,6 +5,7 @@ obj-y += keymaps/
> >  obj-$(CONFIG_RC_CORE) += rc-core.o
> >  rc-core-y := rc-main.o rc-ir-raw.o
> >  rc-core-$(CONFIG_LIRC) += lirc_dev.o
> > +rc-core-$(CONFIG_IR_BPF_DECODER) += ir-bpf-decoder.o
> >  obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
> >  obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
> >  obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
> > diff --git a/drivers/media/rc/ir-bpf-decoder.c b/drivers/media/rc/ir-bpf-decoder.c
> > new file mode 100644
> > index 000000000000..aaa5e208b1a5
> > --- /dev/null
> > +++ b/drivers/media/rc/ir-bpf-decoder.c
> > @@ -0,0 +1,93 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// ir-bpf-decoder.c - handles bpf decoders
> > +//
> > +// Copyright (C) 2018 Sean Young <sean@mess.org>
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/filter.h>
> > +#include "rc-core-priv.h"
> > +
> > +/*
> > + * BPF interface for raw IR decoder
> > + */
> > +const struct bpf_prog_ops ir_decoder_prog_ops = {
> > +};
> > +
> > +BPF_CALL_1(bpf_rc_repeat, struct ir_raw_event*, event)
> > +{
> > +       struct ir_raw_event_ctrl *ctrl;
> > +
> > +       ctrl = container_of(event, struct ir_raw_event_ctrl, prev_ev);
> > +
> > +       rc_repeat(ctrl->dev);
> > +       return 0;
> > +}
> > +
> > +static const struct bpf_func_proto rc_repeat_proto = {
> > +       .func      = bpf_rc_repeat,
> > +       .gpl_only  = true, // rc_repeat is EXPORT_SYMBOL_GPL
> > +       .ret_type  = RET_VOID,
> 
> I suggest using RET_INTEGER here since we do return an integer 0.
> RET_INTEGER will also make it easy to extend if you want to return
> a non-zero value for error code or other reasons.

Ok.

> > +       .arg1_type = ARG_PTR_TO_CTX,
> > +};
> > +
> > +BPF_CALL_4(bpf_rc_keydown, struct ir_raw_event*, event, u32, protocol,
> > +          u32, scancode, u32, toggle)
> > +{
> > +       struct ir_raw_event_ctrl *ctrl;
> > +
> > +       ctrl = container_of(event, struct ir_raw_event_ctrl, prev_ev);
> > +       rc_keydown(ctrl->dev, protocol, scancode, toggle != 0);
> > +       return 0;
> > +}
> > +
> > +static const struct bpf_func_proto rc_keydown_proto = {
> > +       .func      = bpf_rc_keydown,
> > +       .gpl_only  = true, // rc_keydown is EXPORT_SYMBOL_GPL
> > +       .ret_type  = RET_VOID,
> 
> ditto. RET_INTEGER is preferable.

Ok.

> > +       .arg1_type = ARG_PTR_TO_CTX,
> > +       .arg2_type = ARG_ANYTHING,
> > +       .arg3_type = ARG_ANYTHING,
> > +       .arg4_type = ARG_ANYTHING,
> > +};
> > +
> > +static const struct bpf_func_proto *ir_decoder_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > +{
> > +       switch (func_id) {
> > +       case BPF_FUNC_rc_repeat:
> > +               return &rc_repeat_proto;
> > +       case BPF_FUNC_rc_keydown:
> > +               return &rc_keydown_proto;
> > +       case BPF_FUNC_map_lookup_elem:
> > +               return &bpf_map_lookup_elem_proto;
> > +       case BPF_FUNC_map_update_elem:
> > +               return &bpf_map_update_elem_proto;
> > +       case BPF_FUNC_map_delete_elem:
> > +               return &bpf_map_delete_elem_proto;
> > +       case BPF_FUNC_ktime_get_ns:
> > +               return &bpf_ktime_get_ns_proto;
> > +       case BPF_FUNC_tail_call:
> > +               return &bpf_tail_call_proto;
> > +       case BPF_FUNC_get_prandom_u32:
> > +               return &bpf_get_prandom_u32_proto;
> > +       default:
> > +               return NULL;
> > +       }
> > +}
> > +
> > +static bool ir_decoder_is_valid_access(int off, int size,
> > +                                      enum bpf_access_type type,
> > +                                      const struct bpf_prog *prog,
> > +                                      struct bpf_insn_access_aux *info)
> > +{
> > +       if (type == BPF_WRITE)
> > +               return false;
> > +       if (off < 0 || off + size > sizeof(struct ir_raw_event))
> > +               return false;
> 
> You probably need more than just checking the boundary.
> >From patch #3, the structure is:
>  struct ir_raw_event {
>         union {
>                 __u32           duration;
>                 __u32           carrier;
>         };
>         __u8                    duty_cycle;
> 
>         unsigned                pulse:1;
>         unsigned                reset:1;
>         unsigned                timeout:1;
>        unsigned                carrier_report:1;
> };
> 
> You would like the memory access to be aligned,
> so accessing duration/carrier with 4-byte alignment, and
> pulse/reset/timeout/carrier_report 4-byte alignment as well.
> 
> You could only allow __u32 access to duration/carrier.
> But if you want bpf program to access duration/carrier with
> code like (__u16)(ctx->duration), then the compiler may
> translate the load to a 2-byte load. You may need to handle
> endianness here. You can check net/core/filter.c function
> bpf_skb_is_valid_access for some examples.

Thanks, yes that makes sense. Actually exposing a struct with bit fields
isn't great. I think I can rework into something simpler (two u32 fields).

> > +
> > +       return true;
> > +}
> > +
> > +const struct bpf_verifier_ops ir_decoder_verifier_ops = {
> > +       .get_func_proto  = ir_decoder_func_proto,
> > +       .is_valid_access = ir_decoder_is_valid_access
> > +};
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index 2b28fcf6f6ae..ee5355715ee0 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -25,6 +25,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> >  #ifdef CONFIG_CGROUP_BPF
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
> >  #endif
> > +#ifdef CONFIG_IR_BPF_DECODER
> > +BPF_PROG_TYPE(BPF_PROG_TYPE_RAWIR_DECODER, ir_decoder)
> > +#endif
> >
> >  BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
> >  BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index c5ec89732a8d..6ad053e831c0 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -137,6 +137,7 @@ enum bpf_prog_type {
> >         BPF_PROG_TYPE_SK_MSG,
> >         BPF_PROG_TYPE_RAW_TRACEPOINT,
> >         BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
> > +       BPF_PROG_TYPE_RAWIR_DECODER,
> >  };
> >
> >  enum bpf_attach_type {
> > @@ -755,6 +756,17 @@ union bpf_attr {
> >   *     @addr: pointer to struct sockaddr to bind socket to
> >   *     @addr_len: length of sockaddr structure
> >   *     Return: 0 on success or negative error code
> > + *
> > + * int bpf_rc_keydown(ctx, protocol, scancode, toggle)
> > + *     Report decoded scancode with toggle value
> > + *     @ctx: pointer to ctx
> > + *     @protocol: decoded protocol
> > + *     @scancode: decoded scancode
> > + *     @toggle: set to 1 if button was toggled, else 0
> > + *
> > + * int bpf_rc_repeat(ctx)
> > + *     Repeat the last decoded scancode
> > + *     @ctx: pointer to ctx
> 
> The comment format has changed dramatically for
> documentation reason. Could you rebase your change
> on top of bpf-next tree? You will need to rewrite the above
> helper description so tools can generate proper documentation
> for them.

Ah, I need to rebase on top of bpf-next.

Thanks!

> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -821,7 +833,9 @@ union bpf_attr {
> >         FN(msg_apply_bytes),            \
> >         FN(msg_cork_bytes),             \
> >         FN(msg_pull_data),              \
> > -       FN(bind),
> > +       FN(bind),                       \
> > +       FN(rc_repeat),                  \
> > +       FN(rc_keydown),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >   * function eBPF program intends to call
> > --
> > 2.17.0
> >
