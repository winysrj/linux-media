Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37468 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbcKIPtp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 10:49:45 -0500
Received: by mail-it0-f43.google.com with SMTP id u205so279631414itc.0
        for <linux-media@vger.kernel.org>; Wed, 09 Nov 2016 07:49:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
 <20161108155520.224229d5@vento.lan> <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
 <20161109073331.204b53c4@vento.lan> <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
From: VDR User <user.vdr@gmail.com>
Date: Wed, 9 Nov 2016 07:49:43 -0800
Message-ID: <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

$ gdb /usr/src/linux/vmlinux
GNU gdb (Debian 7.11.1-2) 7.11.1
...
Reading symbols from /usr/src/linux/vmlinux...done.
(gdb) l *module_put+0x67
0xc10a4b87 is in module_put (kernel/module.c:1108).
1103            int ret;
1104
1105            if (module) {
1106                    preempt_disable();
1107                    ret = atomic_dec_if_positive(&module->refcnt);
1108                    WARN_ON(ret < 0);       /* Failed to put refcount */
1109                    trace_module_put(module, _RET_IP_);
1110                    preempt_enable();
1111            }
1112    }
