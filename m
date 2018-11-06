Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40689 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729241AbeKFUDc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 15:03:32 -0500
Date: Tue, 6 Nov 2018 10:38:56 +0000
From: Sean Young <sean@mess.org>
To: Peter Seiderer <ps.report@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4l-utils] Add missing linux/bpf_common.h
Message-ID: <20181106103856.66uhadykgsw2dqs3@gofer.mess.org>
References: <20181105203047.15258-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105203047.15258-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 05, 2018 at 09:30:47PM +0100, Peter Seiderer wrote:
> Copy from [1], needed by bpf.h.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/uapi/linux/bpf_common.h?h=v4.19

So bpf.h does include this file, but we don't use anything from it in
v4l-utils.

This include file is for the original BPF, which has been around for a
long time. So why is this include file missing, i.e. what problem are you
trying to solve?

Lastely, the file should be included in the sync-with-kernel target so
it does not get out of sync -- should it really be necessary to add the
file.


Sean

> 
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
>  include/linux/bpf_common.h | 57 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>  create mode 100644 include/linux/bpf_common.h
> 
> diff --git a/include/linux/bpf_common.h b/include/linux/bpf_common.h
> new file mode 100644
> index 00000000..ee97668b
> --- /dev/null
> +++ b/include/linux/bpf_common.h
> @@ -0,0 +1,57 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI__LINUX_BPF_COMMON_H__
> +#define _UAPI__LINUX_BPF_COMMON_H__
> +
> +/* Instruction classes */
> +#define BPF_CLASS(code) ((code) & 0x07)
> +#define		BPF_LD		0x00
> +#define		BPF_LDX		0x01
> +#define		BPF_ST		0x02
> +#define		BPF_STX		0x03
> +#define		BPF_ALU		0x04
> +#define		BPF_JMP		0x05
> +#define		BPF_RET		0x06
> +#define		BPF_MISC        0x07
> +
> +/* ld/ldx fields */
> +#define BPF_SIZE(code)  ((code) & 0x18)
> +#define		BPF_W		0x00 /* 32-bit */
> +#define		BPF_H		0x08 /* 16-bit */
> +#define		BPF_B		0x10 /*  8-bit */
> +/* eBPF		BPF_DW		0x18    64-bit */
> +#define BPF_MODE(code)  ((code) & 0xe0)
> +#define		BPF_IMM		0x00
> +#define		BPF_ABS		0x20
> +#define		BPF_IND		0x40
> +#define		BPF_MEM		0x60
> +#define		BPF_LEN		0x80
> +#define		BPF_MSH		0xa0
> +
> +/* alu/jmp fields */
> +#define BPF_OP(code)    ((code) & 0xf0)
> +#define		BPF_ADD		0x00
> +#define		BPF_SUB		0x10
> +#define		BPF_MUL		0x20
> +#define		BPF_DIV		0x30
> +#define		BPF_OR		0x40
> +#define		BPF_AND		0x50
> +#define		BPF_LSH		0x60
> +#define		BPF_RSH		0x70
> +#define		BPF_NEG		0x80
> +#define		BPF_MOD		0x90
> +#define		BPF_XOR		0xa0
> +
> +#define		BPF_JA		0x00
> +#define		BPF_JEQ		0x10
> +#define		BPF_JGT		0x20
> +#define		BPF_JGE		0x30
> +#define		BPF_JSET        0x40
> +#define BPF_SRC(code)   ((code) & 0x08)
> +#define		BPF_K		0x00
> +#define		BPF_X		0x08
> +
> +#ifndef BPF_MAXINSNS
> +#define BPF_MAXINSNS 4096
> +#endif
> +
> +#endif /* _UAPI__LINUX_BPF_COMMON_H__ */
> -- 
> 2.19.1
