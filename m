Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60337 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbeEQNoa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 09:44:30 -0400
Date: Thu, 17 May 2018 14:44:28 +0100
From: Sean Young <sean@mess.org>
To: Quentin Monnet <quentin.monnet@netronome.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>
Subject: Re: [PATCH v3 1/2] media: rc: introduce BPF_PROG_RAWIR_EVENT
Message-ID: <20180517134427.bjvt2t3jfabpvbcy@gofer.mess.org>
References: <cover.1526504511.git.sean@mess.org>
 <92785c791057185fa5691f78cecfa4beae7fc336.1526504511.git.sean@mess.org>
 <592262ad-e92f-2b53-f6bb-086257c21db0@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592262ad-e92f-2b53-f6bb-086257c21db0@netronome.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Quentin,

On Thu, May 17, 2018 at 01:10:56PM +0100, Quentin Monnet wrote:
> 2018-05-16 22:04 UTC+0100 ~ Sean Young <sean@mess.org>
> > Add support for BPF_PROG_RAWIR_EVENT. This type of BPF program can call
> > rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
> > that the last key should be repeated.
> > 
> > The bpf program can be attached to using the bpf(BPF_PROG_ATTACH) syscall;
> > the target_fd must be the /dev/lircN device.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/Kconfig           |  13 ++
> >  drivers/media/rc/Makefile          |   1 +
> >  drivers/media/rc/bpf-rawir-event.c | 363 +++++++++++++++++++++++++++++
> >  drivers/media/rc/lirc_dev.c        |  24 ++
> >  drivers/media/rc/rc-core-priv.h    |  24 ++
> >  drivers/media/rc/rc-ir-raw.c       |  14 +-
> >  include/linux/bpf_rcdev.h          |  30 +++
> >  include/linux/bpf_types.h          |   3 +
> >  include/uapi/linux/bpf.h           |  55 ++++-
> >  kernel/bpf/syscall.c               |   7 +
> >  10 files changed, 531 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/media/rc/bpf-rawir-event.c
> >  create mode 100644 include/linux/bpf_rcdev.h
> > 
> 
> [...]
> 
> Hi Sean,
> 
> Please find below some nitpicks on the documentation for the two helpers.

I agree with all your points. I will reword and fix this for v4.

Thanks,

Sean
> 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index d94d333a8225..243e141e8a5b 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> 
> [...]
> 
> > @@ -1902,6 +1904,35 @@ union bpf_attr {
> >   *		egress otherwise). This is the only flag supported for now.
> >   *	Return
> >   *		**SK_PASS** on success, or **SK_DROP** on error.
> > + *
> > + * int bpf_rc_keydown(void *ctx, u32 protocol, u32 scancode, u32 toggle)
> > + *	Description
> > + *		Report decoded scancode with toggle value. For use in
> > + *		BPF_PROG_TYPE_RAWIR_EVENT, to report a successfully
> 
> Could you please use bold RST markup for constants and function names?
> Typically for BPF_PROG_TYPE_RAWIR_EVENT here and the enum below.
> 
> > + *		decoded scancode. This is will generate a keydown event,
> 
> s/This is will/This will/?
> 
> > + *		and a keyup event once the scancode is no longer repeated.
> > + *
> > + *		*ctx* pointer to bpf_rawir_event, *protocol* is decoded
> > + *		protocol (see RC_PROTO_* enum).
> 
> This documentation is intended to be compiled as a man page. Could you
> please use a complete sentence here?
> Also, this could do with additional markup as well: **struct
> bpf_rawir_event**.
> 
> > + *
> > + *		Some protocols include a toggle bit, in case the button
> > + *		was released and pressed again between consecutive scancodes,
> > + *		copy this bit into *toggle* if it exists, else set to 0.
> > + *
> > + *     Return
> 
> The "Return" lines here and in the second helper use space indent
> instead as tabs (as all other lines do). Would you mind fixing it for
> consistency?
> 
> > + *		Always return 0 (for now)
> 
> Other helpers use just "0" in that case, but I do not really mind.
> Out of curiosity, do you have anything specific in mind for changing the
> return value here in the future?

I don't expect this is to change, so I should just "0".

> 
> > + *
> > + * int bpf_rc_repeat(void *ctx)
> > + *	Description
> > + *		Repeat the last decoded scancode; some IR protocols like
> > + *		NEC have a special IR message for repeat last button,
> 
> s/repeat/repeating/?
> 
> > + *		in case user is holding a button down; the scancode is
> > + *		not repeated.
> > + *
> > + *		*ctx* pointer to bpf_rawir_event.
> 
> Please use a complete sentence here as well, if you do not mind.
> 
> > + *
> > + *     Return
> > + *		Always return 0 (for now)
> >   */
> Thanks,
> Quentin
