Return-path: <linux-media-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:58632 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbeE3K5M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 06:57:12 -0400
Subject: Re: [PATCH v5 0/3] IR decoding using BPF
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <cover.1527419762.git.sean@mess.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ddee9d3a-6464-1e41-d475-ede0918a17c3@iogearbox.net>
Date: Wed, 30 May 2018 12:57:09 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1527419762.git.sean@mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2018 01:24 PM, Sean Young wrote:
> The kernel IR decoders (drivers/media/rc/ir-*-decoder.c) support the most
> widely used IR protocols, but there are many protocols which are not
> supported[1]. For example, the lirc-remotes[2] repo has over 2700 remotes,
> many of which are not supported by rc-core. There is a "long tail" of
> unsupported IR protocols, for which lircd is need to decode the IR .
> 
> IR encoding is done in such a way that some simple circuit can decode it;
> therefore, bpf is ideal.
> 
> In order to support all these protocols, here we have bpf based IR decoding.
> The idea is that user-space can define a decoder in bpf, attach it to
> the rc device through the lirc chardev.
> 
> Separate work is underway to extend ir-keytable to have an extensive library
> of bpf-based decoders, and a much expanded library of rc keymaps.
> 
> Another future application would be to compile IRP[3] to a IR BPF program, and
> so support virtually every remote without having to write a decoder for each.
> It might also be possible to support non-button devices such as analog
> directional pads or air conditioning remote controls and decode the target
> temperature in bpf, and pass that to an input device.
> 
> Thanks,
> 
> Sean Young
> 
> [1] http://www.hifi-remote.com/wiki/index.php?title=DecodeIR
> [2] https://sourceforge.net/p/lirc-remotes/code/ci/master/tree/remotes/
> [3] http://www.hifi-remote.com/wiki/index.php?title=IRP_Notation
> 
> Changes since v4:
>  - Renamed rc_dev_bpf_{attach,detach,query} to lirc_bpf_{attach,detach,query}
>  - Fixed error path in lirc_bpf_query
>  - Rebased on bpf-next
> 
> Changes since v3:
>  - Implemented review comments from Quentin Monnet and Y Song (thanks!)
>  - More helpful and better formatted bpf helper documentation
>  - Changed back to bpf_prog_array rather than open-coded implementation
>  - scancodes can be 64 bit
>  - bpf gets passed values in microseconds, not nanoseconds.
>    microseconds is more than than enough (IR receivers support carriers upto
>    70kHz, at which point a single period is already 14 microseconds). Also,
>    this makes it much more consistent with lirc mode2.
>  - Since it looks much more like lirc mode2, rename the program type to
>    BPF_PROG_TYPE_LIRC_MODE2.
>  - Rebased on bpf-next
> 
> Changes since v2:
>  - Fixed locking issues
>  - Improved self-test to cover more cases
>  - Rebased on bpf-next again
> 
> Changes since v1:
>  - Code review comments from Y Song <ys114321@gmail.com> and
>    Randy Dunlap <rdunlap@infradead.org>
>  - Re-wrote sample bpf to be selftest
>  - Renamed RAWIR_DECODER -> RAWIR_EVENT (Kconfig, context, bpf prog type)
>  - Rebase on bpf-next
>  - Introduced bpf_rawir_event context structure with simpler access checking

Applied to bpf-next, thanks Sean!
