Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43053 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752421AbeEOMTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 08:19:36 -0400
Date: Tue, 15 May 2018 13:19:33 +0100
From: Sean Young <sean@mess.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v1 1/4] media: rc: introduce BPF_PROG_IR_DECODER
Message-ID: <20180515121933.ogyvf4fi6sezzryy@gofer.mess.org>
References: <cover.1526331777.git.sean@mess.org>
 <32a944171d5c48abf126259595b0088ce3122c91.1526331777.git.sean@mess.org>
 <089862eb-8d37-6479-3c2a-ba6199ae7d3c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <089862eb-8d37-6479-3c2a-ba6199ae7d3c@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 14, 2018 at 04:27:19PM -0700, Randy Dunlap wrote:
> On 05/14/2018 02:10 PM, Sean Young wrote:
> > Add support for BPF_PROG_IR_DECODER. This type of BPF program can call
> 
> Kconfig file below uses IR_BPF_DECODER instead of the symbol name above.
> 
> and then patch 3 says a third choice:
> The context provided to a BPF_PROG_RAWIR_DECODER is a struct ir_raw_event;


Yes, you're right. I guess the source/trigger is raw IR events; decoding
is something you're likely to do, but not necessarily. So:

bpf type: BPF_PROG_TYPE_RAWIR_EVENT, has context struct bpf_rawir_event. 

Then we can call the Kconfig option CONFIG_BPF_RAW_IR_EVENT


Sean
> 
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
> >  	   remote control and you would like to use it with a raw IR
> >  	   receiver, or if you wish to use an encoder to transmit this IR.
> >  
> > +config IR_BPF_DECODER
> > +	bool "Enable IR raw decoder using BPF"
> > +	depends on BPF_SYSCALL
> > +	depends on RC_CORE=y
> > +	help
> > +	   Enable this option to make it possible to load custom IR
> > +	   decoders written in BPF.
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
> 
> 
> -- 
> ~Randy
