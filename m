Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752049AbeENX1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 19:27:23 -0400
Subject: Re: [PATCH v1 1/4] media: rc: introduce BPF_PROG_IR_DECODER
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
References: <cover.1526331777.git.sean@mess.org>
 <32a944171d5c48abf126259595b0088ce3122c91.1526331777.git.sean@mess.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <089862eb-8d37-6479-3c2a-ba6199ae7d3c@infradead.org>
Date: Mon, 14 May 2018 16:27:19 -0700
MIME-Version: 1.0
In-Reply-To: <32a944171d5c48abf126259595b0088ce3122c91.1526331777.git.sean@mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2018 02:10 PM, Sean Young wrote:
> Add support for BPF_PROG_IR_DECODER. This type of BPF program can call

Kconfig file below uses IR_BPF_DECODER instead of the symbol name above.

and then patch 3 says a third choice:
The context provided to a BPF_PROG_RAWIR_DECODER is a struct ir_raw_event;

> rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
> that the last key should be repeated.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/Kconfig          |  8 +++
>  drivers/media/rc/Makefile         |  1 +
>  drivers/media/rc/ir-bpf-decoder.c | 93 +++++++++++++++++++++++++++++++
>  include/linux/bpf_types.h         |  3 +
>  include/uapi/linux/bpf.h          | 16 +++++-
>  5 files changed, 120 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/rc/ir-bpf-decoder.c
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index eb2c3b6eca7f..10ad6167d87c 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -120,6 +120,14 @@ config IR_IMON_DECODER
>  	   remote control and you would like to use it with a raw IR
>  	   receiver, or if you wish to use an encoder to transmit this IR.
>  
> +config IR_BPF_DECODER
> +	bool "Enable IR raw decoder using BPF"
> +	depends on BPF_SYSCALL
> +	depends on RC_CORE=y
> +	help
> +	   Enable this option to make it possible to load custom IR
> +	   decoders written in BPF.
> +
>  endif #RC_DECODERS
>  
>  menuconfig RC_DEVICES
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 2e1c87066f6c..12e1118430d0 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -5,6 +5,7 @@ obj-y += keymaps/
>  obj-$(CONFIG_RC_CORE) += rc-core.o
>  rc-core-y := rc-main.o rc-ir-raw.o
>  rc-core-$(CONFIG_LIRC) += lirc_dev.o
> +rc-core-$(CONFIG_IR_BPF_DECODER) += ir-bpf-decoder.o


-- 
~Randy
