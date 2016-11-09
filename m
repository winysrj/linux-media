Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41865
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751670AbcKIRfc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 12:35:32 -0500
Date: Wed, 9 Nov 2016 15:35:21 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: VDR User <user.vdr@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
Message-ID: <20161109153521.232b0956@vento.lan>
In-Reply-To: <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
        <20161108155520.224229d5@vento.lan>
        <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
        <20161109073331.204b53c4@vento.lan>
        <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
        <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Nov 2016 07:49:43 -0800
VDR User <user.vdr@gmail.com> escreveu:

> $ gdb /usr/src/linux/vmlinux
> GNU gdb (Debian 7.11.1-2) 7.11.1
> ...
> Reading symbols from /usr/src/linux/vmlinux...done.
> (gdb) l *module_put+0x67
> 0xc10a4b87 is in module_put (kernel/module.c:1108).
> 1103            int ret;
> 1104
> 1105            if (module) {
> 1106                    preempt_disable();
> 1107                    ret = atomic_dec_if_positive(&module->refcnt);
> 1108                    WARN_ON(ret < 0);       /* Failed to put refcount */
> 1109                    trace_module_put(module, _RET_IP_);
> 1110                    preempt_enable();
> 1111            }
> 1112    }

OK, I guess we've made progress. Please try the enclosed patch.

Regards,
Mauro

[media] gp8psk: Fix DVB frontend attach

it should be calling module_get() at attach, as otherwise
module_put() will crash.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


Thanks,
Mauro
