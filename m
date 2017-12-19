Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932910AbdLSHIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 02:08:50 -0500
Date: Tue, 19 Dec 2017 08:08:46 +0100
Message-ID: <s5hh8sn5h4x.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-rtc@vger.kernel.org, alsa-devel@alsa-project.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-audit@redhat.com,
        amd-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com, ocfs2-devel@oss.oracle.com,
        linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [trivial PATCH] treewide: Align function definition open/close braces
In-Reply-To: <1513556924.31581.51.camel@perches.com>
References: <1513556924.31581.51.camel@perches.com>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Dec 2017 01:28:44 +0100,
Joe Perches wrote:
> 
> Some functions definitions have either the initial open brace and/or
> the closing brace outside of column 1.
> 
> Move those braces to column 1.
> 
> This allows various function analyzers like gnu complexity to work
> properly for these modified functions.
> 
> Miscellanea:
> 
> o Remove extra trailing ; and blank line from xfs_agf_verify
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> git diff -w shows no difference other than the above 'Miscellanea'
> 
> (this is against -next, but it applies against Linus' tree
>  with a couple offsets)
> 
>  arch/x86/include/asm/atomic64_32.h                   |  2 +-
>  drivers/acpi/custom_method.c                         |  2 +-
>  drivers/acpi/fan.c                                   |  2 +-
>  drivers/gpu/drm/amd/display/dc/core/dc.c             |  2 +-
>  drivers/media/i2c/msp3400-kthreads.c                 |  2 +-
>  drivers/message/fusion/mptsas.c                      |  2 +-
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |  2 +-
>  drivers/net/wireless/ath/ath9k/xmit.c                |  2 +-
>  drivers/platform/x86/eeepc-laptop.c                  |  2 +-
>  drivers/rtc/rtc-ab-b5ze-s3.c                         |  2 +-
>  drivers/scsi/dpt_i2o.c                               |  2 +-
>  drivers/scsi/sym53c8xx_2/sym_glue.c                  |  2 +-
>  fs/locks.c                                           |  2 +-
>  fs/ocfs2/stack_user.c                                |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c                            |  5 ++---
>  fs/xfs/xfs_export.c                                  |  2 +-
>  kernel/audit.c                                       |  6 +++---
>  kernel/trace/trace_printk.c                          |  4 ++--
>  lib/raid6/sse2.c                                     | 14 +++++++-------
>  sound/soc/fsl/fsl_dma.c                              |  2 +-

For sound bits,
  Acked-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi
