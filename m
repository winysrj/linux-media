Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37414 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbcKJBDx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 20:03:53 -0500
Received: by mail-it0-f45.google.com with SMTP id u205so2749665itc.0
        for <linux-media@vger.kernel.org>; Wed, 09 Nov 2016 17:03:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161109153521.232b0956@vento.lan>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
 <20161108155520.224229d5@vento.lan> <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
 <20161109073331.204b53c4@vento.lan> <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
 <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com> <20161109153521.232b0956@vento.lan>
From: VDR User <user.vdr@gmail.com>
Date: Wed, 9 Nov 2016 17:03:52 -0800
Message-ID: <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> (gdb) l *module_put+0x67
>> 0xc10a4b87 is in module_put (kernel/module.c:1108).
>> 1103            int ret;
>> 1104
>> 1105            if (module) {
>> 1106                    preempt_disable();
>> 1107                    ret = atomic_dec_if_positive(&module->refcnt);
>> 1108                    WARN_ON(ret < 0);       /* Failed to put refcount */
>> 1109                    trace_module_put(module, _RET_IP_);
>> 1110                    preempt_enable();
>> 1111            }
>> 1112    }
>
> OK, I guess we've made progress. Please try the enclosed patch.
>
> Regards,
> Mauro
>
> [media] gp8psk: Fix DVB frontend attach
>
> it should be calling module_get() at attach, as otherwise
> module_put() will crash.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I think you forgot the patch. :)
