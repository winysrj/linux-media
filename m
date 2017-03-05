Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33356 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdCESOs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 13:14:48 -0500
Date: Sun, 5 Mar 2017 10:14:45 -0800
From: Alison Schofield <amsfield22@gmail.com>
To: simran singhal <singhalsimran0@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH] staging: media: Remove unnecessary
 function and its call
Message-ID: <20170305181444.GA2094@d830.WORKGROUP>
References: <20170305064721.GA22548@singhal-Inspiron-5558>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170305064721.GA22548@singhal-Inspiron-5558>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 05, 2017 at 12:17:21PM +0530, simran singhal wrote:
> The function atomisp_set_stop_timeout on being called, simply returns
> back. The function hasn't been mentioned in the TODO and doesn't have
> FIXME code around. Hence, atomisp_set_stop_timeout and its calls have been
> removed.
> 
> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
> ---

Hi Simran,

It's helpful to state right in the subject line what you removed.
ie.  remove unused function atomisp_set_stop_timeout()

If you do that, scan's or grep'ing the git log pretty oneline's can 
easily see this without having to dig into the log.

(gitpretty='git log --pretty=oneline --abbrev-commit')

Can you share to Outreachy group how you found this?  By inspection
or otherwise??

Thanks,
alisons


alisons


>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c          | 1 -
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h       | 1 -
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c | 5 -----
>  3 files changed, 7 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> index e99f7b8..66299dd 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> @@ -1700,7 +1700,6 @@ void atomisp_wdt_work(struct work_struct *work)
>  		}
>  	}
>  #endif
> -	atomisp_set_stop_timeout(ATOMISP_CSS_STOP_TIMEOUT_US);
>  	dev_err(isp->dev, "timeout recovery handling done\n");
>  	atomic_set(&isp->wdt_work_queued, 0);
>  
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
> index 5a404e4..0b9ced5 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
> @@ -660,7 +660,6 @@ int atomisp_css_set_acc_parameters(struct atomisp_acc_fw *acc_fw);
>  int atomisp_css_isr_thread(struct atomisp_device *isp,
>  			   bool *frame_done_found,
>  			   bool *css_pipe_done);
> -void atomisp_set_stop_timeout(unsigned int timeout);
>  
>  bool atomisp_css_valid_sof(struct atomisp_device *isp);
>  
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
> index 6697d72..cfa0ad4 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
> @@ -4699,11 +4699,6 @@ int atomisp_css_isr_thread(struct atomisp_device *isp,
>  	return 0;
>  }
>  
> -void atomisp_set_stop_timeout(unsigned int timeout)
> -{
> -	return;
> -}
> -
>  bool atomisp_css_valid_sof(struct atomisp_device *isp)
>  {
>  	unsigned int i, j;
> -- 
> 2.7.4
> 
> -- 
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20170305064721.GA22548%40singhal-Inspiron-5558.
> For more options, visit https://groups.google.com/d/optout.
