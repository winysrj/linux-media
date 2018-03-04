Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:29119 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932084AbeCDPyO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Mar 2018 10:54:14 -0500
Date: Sun, 4 Mar 2018 16:54:13 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Arushi Singhal <arushisinghal19971997@gmail.com>
cc: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH 0/3] staging: media: cleanup
In-Reply-To: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
Message-ID: <alpine.DEB.2.20.1803041653350.2182@hadrien>
References: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 4 Mar 2018, Arushi Singhal wrote:

> Spellcheck the comments.
> Remove the repeated, consecutive words with single word.

For the series:
Acked-by: Julia Lawall <julia.lawall@lip6.fr>

But please look out for things to change in the code, not just in the
comments.

julia


>
> Arushi Singhal (3):
>   staging: media: Replace "be be" with "be"
>   staging: media: Replace "cant" with "can't"
>   staging: media: Replace "dont" with "don't"
>
>  drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h | 2 +-
>  drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c                | 2 +-
>  drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c                    | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1520178507-25141-1-git-send-email-arushisinghal19971997%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
