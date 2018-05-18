Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36562 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbeERFcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 01:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20180517214534.2ipc4q3ru7ykdklf@gofer.mess.org>
References: <cover.1526504511.git.sean@mess.org> <92785c791057185fa5691f78cecfa4beae7fc336.1526504511.git.sean@mess.org>
 <CAH3MdRUqpenhK0hCzMfRyJU5Dz=k83Vxw0HFtyL1qa7aO5vDBA@mail.gmail.com> <20180517214534.2ipc4q3ru7ykdklf@gofer.mess.org>
From: Y Song <ys114321@gmail.com>
Date: Thu, 17 May 2018 22:31:41 -0700
Message-ID: <CAH3MdRX4amQdbYOWo84sTQyBhZrNbE5ChgOgq_-pjKW5z5h8aA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] media: rc: introduce BPF_PROG_RAWIR_EVENT
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 17, 2018 at 2:45 PM, Sean Young <sean@mess.org> wrote:
> Hi,
>
> Again thanks for a thoughtful review. This will definitely will improve
> the code.
>
> On Thu, May 17, 2018 at 10:02:52AM -0700, Y Song wrote:
>> On Wed, May 16, 2018 at 2:04 PM, Sean Young <sean@mess.org> wrote:
>> > Add support for BPF_PROG_RAWIR_EVENT. This type of BPF program can call
>> > rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
>> > that the last key should be repeated.
>> >
>> > The bpf program can be attached to using the bpf(BPF_PROG_ATTACH) syscall;
>> > the target_fd must be the /dev/lircN device.
>> >
>> > Signed-off-by: Sean Young <sean@mess.org>
>> > ---
>> >  drivers/media/rc/Kconfig           |  13 ++
>> >  drivers/media/rc/Makefile          |   1 +
>> >  drivers/media/rc/bpf-rawir-event.c | 363 +++++++++++++++++++++++++++++
>> >  drivers/media/rc/lirc_dev.c        |  24 ++
>> >  drivers/media/rc/rc-core-priv.h    |  24 ++
>> >  drivers/media/rc/rc-ir-raw.c       |  14 +-
>> >  include/linux/bpf_rcdev.h          |  30 +++
>> >  include/linux/bpf_types.h          |   3 +
>> >  include/uapi/linux/bpf.h           |  55 ++++-
>> >  kernel/bpf/syscall.c               |   7 +
>> >  10 files changed, 531 insertions(+), 3 deletions(-)
>> >  create mode 100644 drivers/media/rc/bpf-rawir-event.c
>> >  create mode 100644 include/linux/bpf_rcdev.h
>> >
>> > diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>> > index eb2c3b6eca7f..2172d65b0213 100644
>> > --- a/drivers/media/rc/Kconfig
>> > +++ b/drivers/media/rc/Kconfig
>> > @@ -25,6 +25,19 @@ config LIRC
>> >            passes raw IR to and from userspace, which is needed for
>> >            IR transmitting (aka "blasting") and for the lirc daemon.
>> >
>> > +config BPF_RAWIR_EVENT
>> > +       bool "Support for eBPF programs attached to lirc devices"
>> > +       depends on BPF_SYSCALL
>> > +       depends on RC_CORE=y
>> > +       depends on LIRC
>> > +       help
>> > +          Allow attaching eBPF programs to a lirc device using the bpf(2)
>> > +          syscall command BPF_PROG_ATTACH. This is supported for raw IR
>> > +          receivers.
>> > +
>> > +          These eBPF programs can be used to decode IR into scancodes, for
>> > +          IR protocols not supported by the kernel decoders.
>> > +
>> >  menuconfig RC_DECODERS
>> >         bool "Remote controller decoders"
>> >         depends on RC_CORE
>> > diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
>> > index 2e1c87066f6c..74907823bef8 100644
>> > --- a/drivers/media/rc/Makefile
>> > +++ b/drivers/media/rc/Makefile
>> > @@ -5,6 +5,7 @@ obj-y += keymaps/
>> >  obj-$(CONFIG_RC_CORE) += rc-core.o
>> >  rc-core-y := rc-main.o rc-ir-raw.o
>> >  rc-core-$(CONFIG_LIRC) += lirc_dev.o
>> > +rc-core-$(CONFIG_BPF_RAWIR_EVENT) += bpf-rawir-event.o
>> >  obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
>> >  obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
>> >  obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
>> > diff --git a/drivers/media/rc/bpf-rawir-event.c b/drivers/media/rc/bpf-rawir-event.c
>> > new file mode 100644
>> > index 000000000000..7cb48b8d87b5
>> > --- /dev/null
>> > +++ b/drivers/media/rc/bpf-rawir-event.c
>> > @@ -0,0 +1,363 @@
>> > +// SPDX-License-Identifier: GPL-2.0
>> > +// bpf-rawir-event.c - handles bpf
>> > +//
>> > +// Copyright (C) 2018 Sean Young <sean@mess.org>
>> > +
>> > +#include <linux/bpf.h>
>> > +#include <linux/filter.h>
>> > +#include <linux/bpf_rcdev.h>
>> > +#include "rc-core-priv.h"
>> > +
>> > +/*
>> > + * BPF interface for raw IR
>> > + */
>> > +const struct bpf_prog_ops rawir_event_prog_ops = {
>> > +};
>> > +
>> > +BPF_CALL_1(bpf_rc_repeat, struct bpf_rawir_event*, event)
>> > +{
>> > +       struct ir_raw_event_ctrl *ctrl;
>> > +
>> > +       ctrl = container_of(event, struct ir_raw_event_ctrl, bpf_rawir_event);
>> > +
>> > +       rc_repeat(ctrl->dev);
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static const struct bpf_func_proto rc_repeat_proto = {
>> > +       .func      = bpf_rc_repeat,
>> > +       .gpl_only  = true, /* rc_repeat is EXPORT_SYMBOL_GPL */
>> > +       .ret_type  = RET_INTEGER,
>> > +       .arg1_type = ARG_PTR_TO_CTX,
>> > +};
>> > +
>> > +BPF_CALL_4(bpf_rc_keydown, struct bpf_rawir_event*, event, u32, protocol,
>> > +          u32, scancode, u32, toggle)
>> > +{
>> > +       struct ir_raw_event_ctrl *ctrl;
>> > +
>> > +       ctrl = container_of(event, struct ir_raw_event_ctrl, bpf_rawir_event);
>> > +
>> > +       rc_keydown(ctrl->dev, protocol, scancode, toggle != 0);
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static const struct bpf_func_proto rc_keydown_proto = {
>> > +       .func      = bpf_rc_keydown,
>> > +       .gpl_only  = true, /* rc_keydown is EXPORT_SYMBOL_GPL */
>> > +       .ret_type  = RET_INTEGER,
>> > +       .arg1_type = ARG_PTR_TO_CTX,
>> > +       .arg2_type = ARG_ANYTHING,
>> > +       .arg3_type = ARG_ANYTHING,
>> > +       .arg4_type = ARG_ANYTHING,
>> > +};
>> > +
>> > +static const struct bpf_func_proto *
>> > +rawir_event_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>> > +{
>> > +       switch (func_id) {
>> > +       case BPF_FUNC_rc_repeat:
>> > +               return &rc_repeat_proto;
>> > +       case BPF_FUNC_rc_keydown:
>> > +               return &rc_keydown_proto;
>> > +       case BPF_FUNC_map_lookup_elem:
>> > +               return &bpf_map_lookup_elem_proto;
>> > +       case BPF_FUNC_map_update_elem:
>> > +               return &bpf_map_update_elem_proto;
>> > +       case BPF_FUNC_map_delete_elem:
>> > +               return &bpf_map_delete_elem_proto;
>> > +       case BPF_FUNC_ktime_get_ns:
>> > +               return &bpf_ktime_get_ns_proto;
>> > +       case BPF_FUNC_tail_call:
>> > +               return &bpf_tail_call_proto;
>> > +       case BPF_FUNC_get_prandom_u32:
>> > +               return &bpf_get_prandom_u32_proto;
>> > +       case BPF_FUNC_trace_printk:
>> > +               if (capable(CAP_SYS_ADMIN))
>> > +                       return bpf_get_trace_printk_proto();
>> > +               /* fall through */
>> > +       default:
>> > +               return NULL;
>> > +       }
>> > +}
>> > +
>> > +static bool rawir_event_is_valid_access(int off, int size,
>> > +                                       enum bpf_access_type type,
>> > +                                       const struct bpf_prog *prog,
>> > +                                       struct bpf_insn_access_aux *info)
>> > +{
>> > +       /* struct bpf_rawir_event has two u32 fields */
>> > +       if (type == BPF_WRITE)
>> > +               return false;
>> > +
>> > +       if (size != sizeof(__u32))
>> > +               return false;
>> > +
>> > +       if (!(off == offsetof(struct bpf_rawir_event, duration) ||
>> > +             off == offsetof(struct bpf_rawir_event, type)))
>> > +               return false;
>> > +
>> > +       return true;
>> > +}
>> > +
>> > +const struct bpf_verifier_ops rawir_event_verifier_ops = {
>> > +       .get_func_proto  = rawir_event_func_proto,
>> > +       .is_valid_access = rawir_event_is_valid_access
>> > +};
>> > +
>> > +#define BPF_MAX_PROGS 64
>> > +
>> > +static int rc_dev_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
>> > +{
>> > +       struct ir_raw_event_ctrl *raw;
>> > +       struct bpf_prog_list *pl;
>> > +       int ret, size;
>> > +
>> > +       if (rcdev->driver_type != RC_DRIVER_IR_RAW)
>> > +               return -EINVAL;
>> > +
>> > +       ret = mutex_lock_interruptible(&ir_raw_handler_lock);
>> > +       if (ret)
>> > +               return ret;
>> > +
>> > +       raw = rcdev->raw;
>> > +       if (!raw) {
>> > +               ret = -ENODEV;
>> > +               goto out;
>> > +       }
>> > +
>> > +       size = 0;
>> > +       list_for_each_entry(pl, &raw->progs, node) {
>> > +               if (pl->prog == prog) {
>> > +                       ret = -EEXIST;
>> > +                       goto out;
>> > +               }
>> > +
>> > +               size++;
>> > +       }
>> > +
>> > +       if (size >= BPF_MAX_PROGS) {
>> > +               ret = -E2BIG;
>> > +               goto out;
>> > +       }
>> > +
>> > +       pl = kmalloc(sizeof(*pl), GFP_KERNEL);
>> > +       if (!pl) {
>> > +               ret = -ENOMEM;
>> > +               goto out;
>> > +       }
>> > +
>> > +       pl->prog = prog;
>> > +       list_add(&pl->node, &raw->progs);
>> > +out:
>> > +       mutex_unlock(&ir_raw_handler_lock);
>> > +       return ret;
>> > +}
>> > +
>> > +static int rc_dev_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
>> > +{
>> > +       struct ir_raw_event_ctrl *raw;
>> > +       struct bpf_prog_list *pl, *tmp;
>> > +       int ret;
>> > +
>> > +       if (rcdev->driver_type != RC_DRIVER_IR_RAW)
>> > +               return -EINVAL;
>> > +
>> > +       ret = mutex_lock_interruptible(&ir_raw_handler_lock);
>> > +       if (ret)
>> > +               return ret;
>> > +
>> > +       raw = rcdev->raw;
>> > +       if (!raw) {
>> > +               ret = -ENODEV;
>> > +               goto out;
>> > +       }
>> > +
>> > +       ret = -ENOENT;
>> > +
>> > +       list_for_each_entry_safe(pl, tmp, &raw->progs, node) {
>> > +               if (pl->prog == prog) {
>> > +                       list_del(&pl->node);
>> > +                       kfree(pl);
>> > +                       bpf_prog_put(prog);
>> > +                       ret = 0;
>> > +                       goto out;
>> > +               }
>> > +       }
>> > +out:
>> > +       mutex_unlock(&ir_raw_handler_lock);
>> > +       return ret;
>> > +}
>> > +
>> > +void rc_dev_bpf_init(struct rc_dev *rcdev)
>> > +{
>> > +       INIT_LIST_HEAD(&rcdev->raw->progs);
>> > +}
>> > +
>> > +void rc_dev_bpf_run(struct rc_dev *rcdev, struct ir_raw_event ev)
>> > +{
>> > +       struct ir_raw_event_ctrl *raw = rcdev->raw;
>> > +       struct bpf_prog_list *pl;
>> > +
>> > +       if (list_empty(&raw->progs))
>> > +               return;
>> > +
>> > +       if (unlikely(ev.carrier_report)) {
>> > +               raw->bpf_rawir_event.carrier = ev.carrier;
>> > +               raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_CARRIER;
>> > +       } else {
>> > +               raw->bpf_rawir_event.duration = ev.duration;
>> > +
>> > +               if (ev.pulse)
>> > +                       raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_PULSE;
>> > +               else if (ev.timeout)
>> > +                       raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_TIMEOUT;
>> > +               else if (ev.reset)
>> > +                       raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_RESET;
>> > +               else
>> > +                       raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_SPACE;
>> > +       }
>> > +
>> > +       list_for_each_entry(pl, &raw->progs, node)
>> > +               BPF_PROG_RUN(pl->prog, &raw->bpf_rawir_event);
>>
>> Is the raw->progs protected by locks? It is possible that attaching/detaching
>> could manipulate raw->progs at the same time? In perf/cgroup prog array
>> case, the prog array run is protected by rcu and the dummy prog idea is
>> to avoid the prog is skipped by reshuffling.
>
> Yes, it is. The caller takes the appropriate lock. These functions could do
> with some comments.
>
>> Also, the original idea about using prog array is the least overhead since you
>> want to BPF programs to execute as soon as possible.
>
> Now, for our purposes the we're not bothered by a few milliseconds delay,
> so I would pick whatever uses less cpu/memory overall. There is some overhead
> in using rcu but the array is nice since it uses less memory than the
> double-linked list, and less cache misses.
>
> So I wanted bpf_prog_detach() to return -ENOENT if the prog was not in the list,
> however bpf_prog_array_copy() and bpf_prog_array_delete_safe() do not return
> anything useful for that.
>
> Maybe I should look at adding a count-delta return to bpf_prog_array_copy(),
> and a bool return to bpf_prog_array_delete_safe(). Or I could scan the array
> an extra time to see if it is present. Any other ideas?

The detaching is not performance critical. Either of these methods is fine.
A bool return to bpf_prog_array_delete_safe() seems easy to make a change.

>
> Also, BPF_F_OVERRIDE is not relevant for this but possibly BPF_F_ALLOW_MULTI
> could invoke the same behaviour as for cgroups. What do you think?

Looks like you already allow multiple programs attaching to the same device?
So by default you already implied supporting BPF_F_ALLOW_MULTI, but you
just did not specify it. I think this is fine. perf event also
supports program array
by default and users do not need to specify flags.
Or I misunderstood your question?
