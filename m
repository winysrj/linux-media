Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44471 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752777AbdCFL4s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 06:56:48 -0500
Date: Mon, 6 Mar 2017 12:31:02 +0100
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] staging/atomisp:fix build issue verus 4.11-rc1
Message-ID: <20170306113102.GA25696@kroah.com>
References: <148879927534.10796.6582496815100213383.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148879927534.10796.6582496815100213383.stgit@acox1-desk1.ger.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 06, 2017 at 11:21:28AM +0000, Alan Cox wrote:
> From: xingzhen <zhengjun.xing@intel.com>
> 
> commit:2a1f062a4acf move sigpending method fatal_signal_pending from
> <linux/sched.h> into <linux/sched/signal.h> cause the build issue,fix it.
> 
> Signed-off-by: xingzhen <zhengjun.xing@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> index 05ff912..e2aa949 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> @@ -39,7 +39,7 @@
>  #include <asm/cacheflush.h>
>  #include <linux/io.h>
>  #include <asm/current.h>
> -#include <linux/sched.h>
> +#include <linux/sched/signal.h>
>  #include <linux/file.h>

Ah, I already did this myself in my branch, thanks though!

greg k-h
