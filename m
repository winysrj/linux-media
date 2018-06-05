Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47537 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751765AbeFEKQc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Jun 2018 06:16:32 -0400
Date: Tue, 5 Jun 2018 11:16:29 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v5 2/3] media: rc: introduce BPF_PROG_LIRC_MODE2
Message-ID: <20180605101629.yffyp64o7adg6hu5@gofer.mess.org>
References: <cover.1527419762.git.sean@mess.org>
 <9f2c54d4956f962f44fcda739a824397ddea132c.1527419762.git.sean@mess.org>
 <20180604174730.sctfoklq7klswebp@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180604174730.sctfoklq7klswebp@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 04, 2018 at 07:47:30PM +0200, Matthias Reichl wrote:
> Hi Sean,
> 
> I finally found the time to test your patch series and noticed
> 2 issues - comments are inline
> 
> On Sun, May 27, 2018 at 12:24:09PM +0100, Sean Young wrote:
> > diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> > index eb2c3b6eca7f..d5b35a6ba899 100644
> > --- a/drivers/media/rc/Kconfig
> > +++ b/drivers/media/rc/Kconfig
> > @@ -25,6 +25,19 @@ config LIRC
> >  	   passes raw IR to and from userspace, which is needed for
> >  	   IR transmitting (aka "blasting") and for the lirc daemon.
> >  
> > +config BPF_LIRC_MODE2
> > +	bool "Support for eBPF programs attached to lirc devices"
> > +	depends on BPF_SYSCALL
> > +	depends on RC_CORE=y
> 
> Requiring rc-core to be built into the kernel could become
> problematic in the future for people using media_build.
> 
> Currently the whole media tree (including rc-core) can be built
> as modules so DVB and IR drivers can be replaced by newer versions.
> But with rc-core in the kernel things could easily break if internal
> data structures are changed.
> 
> Maybe we should add a small layer with a stable API/ABI between
> bpf-lirc and rc-core to decouple them? Or would it be possible
> to build rc-core with bpf support as a module?

Unfortunately bpf cannot be built as a module.

> > +	depends on LIRC
> > +	help
> > +	   Allow attaching eBPF programs to a lirc device using the bpf(2)
> > +	   syscall command BPF_PROG_ATTACH. This is supported for raw IR
> > +	   receivers.
> > +
> > +	   These eBPF programs can be used to decode IR into scancodes, for
> > +	   IR protocols not supported by the kernel decoders.
> > +
> >  menuconfig RC_DECODERS
> >  	bool "Remote controller decoders"
> >  	depends on RC_CORE
> > [...]
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 388d4feda348..3c104113d040 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -11,6 +11,7 @@
> >   */
> >  #include <linux/bpf.h>
> >  #include <linux/bpf_trace.h>
> > +#include <linux/bpf_lirc.h>
> >  #include <linux/btf.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/slab.h>
> > @@ -1578,6 +1579,8 @@ static int bpf_prog_attach(const union bpf_attr *attr)
> >  	case BPF_SK_SKB_STREAM_PARSER:
> >  	case BPF_SK_SKB_STREAM_VERDICT:
> >  		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, true);
> > +	case BPF_LIRC_MODE2:
> > +		return lirc_prog_attach(attr);
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -1648,6 +1651,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> >  	case BPF_SK_SKB_STREAM_PARSER:
> >  	case BPF_SK_SKB_STREAM_VERDICT:
> >  		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, false);
> > +	case BPF_LIRC_MODE2:
> > +		return lirc_prog_detach(attr);
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -1695,6 +1700,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
> >  	case BPF_CGROUP_SOCK_OPS:
> >  	case BPF_CGROUP_DEVICE:
> >  		break;
> > +	case BPF_LIRC_MODE2:
> > +		return lirc_prog_query(attr, uattr);
> 
> When testing this patch series I was wondering why I always got
> -EINVAL when trying to query the registered programs.
> 
> Closer inspection revealed that bpf_prog_attach/detach/query and
> calls to them in the bpf syscall are in "#ifdef CONFIG_CGROUP_BPF"
> blocks - and as I built the kernel without CONFIG_CGROUP_BPF
> BPF_PROG_ATTACH/DETACH/QUERY weren't handled in the syscall switch
> and I got -EINVAL from the bpf syscall function.
> 
> I haven't checked in detail yet, but it looks to me like
> bpf_prog_attach/detach/query could always be built (or when
> either cgroup bpf or lirc bpf are enabled) and the #ifdefs moved
> inside the switch(). So lirc bpf could be used without cgroup bpf.
> Or am I missing something?

You are right, this features depends on CONFIG_CGROUP_BPF right now. This
also affects the BPF_SK_MSG_VERDICT, BPF_SK_SKB_STREAM_VERDICT and
BPF_SK_SKB_STREAM_PARSER type bpf attachments, and as far as I know
these shouldn't depend on CONFIG_CGROUP_BPF either.


Sean
