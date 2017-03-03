Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:62935 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752019AbdCCRdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 12:33:16 -0500
Date: Fri, 3 Mar 2017 18:06:11 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: simran singhal <singhalsimran0@gmail.com>
cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH] staging: media: Remove parentheses
 from return arguments
In-Reply-To: <20170303170139.GA9887@singhal-Inspiron-5558>
Message-ID: <alpine.DEB.2.20.1703031805570.3490@hadrien>
References: <20170303170139.GA9887@singhal-Inspiron-5558>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 3 Mar 2017, simran singhal wrote:

> The sematic patch used for this is:
> @@
> identifier i;
> constant c;
> @@
> return
> - (
>     \(i\|-i\|i(...)\|c\)
> - )
>   ;
>
> Signed-off-by: simran singhal <singhalsimran0@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>


> ---
>  .../media/atomisp/pci/atomisp2/css2400/sh_css.c      | 20 ++++++++++----------
>  .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c   |  2 +-
>  2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> index f39d6f5..1216efb 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> @@ -2009,7 +2009,7 @@ enum ia_css_err ia_css_suspend(void)
>  	for(i=0;i<MAX_ACTIVE_STREAMS;i++)
>  		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "==*> after 1: seed %d (%p)\n", i, my_css_save.stream_seeds[i].stream);
>  	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_suspend() leave\n");
> -	return(IA_CSS_SUCCESS);
> +	return IA_CSS_SUCCESS;
>  }
>
>  enum ia_css_err
> @@ -2021,10 +2021,10 @@ ia_css_resume(void)
>
>  	err = ia_css_init(&(my_css_save.driver_env), my_css_save.loaded_fw, my_css_save.mmu_base, my_css_save.irq_type);
>  	if (err != IA_CSS_SUCCESS)
> -		return(err);
> +		return err;
>  	err = ia_css_start_sp();
>  	if (err != IA_CSS_SUCCESS)
> -		return(err);
> +		return err;
>  	my_css_save.mode = sh_css_mode_resume;
>  	for(i=0;i<MAX_ACTIVE_STREAMS;i++)
>  	{
> @@ -2038,7 +2038,7 @@ ia_css_resume(void)
>  				if (i)
>  					for(j=0;j<i;j++)
>  						ia_css_stream_unload(my_css_save.stream_seeds[j].stream);
> -				return(err);
> +				return err;
>  			}
>  			err = ia_css_stream_start(my_css_save.stream_seeds[i].stream);
>  			if (err != IA_CSS_SUCCESS)
> @@ -2048,7 +2048,7 @@ ia_css_resume(void)
>  					ia_css_stream_stop(my_css_save.stream_seeds[j].stream);
>  					ia_css_stream_unload(my_css_save.stream_seeds[j].stream);
>  				}
> -				return(err);
> +				return err;
>  			}
>  			*my_css_save.stream_seeds[i].orig_stream = my_css_save.stream_seeds[i].stream;
>  			for(j=0;j<my_css_save.stream_seeds[i].num_pipes;j++)
> @@ -2057,7 +2057,7 @@ ia_css_resume(void)
>  	}
>  	my_css_save.mode = sh_css_mode_working;
>  	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_resume() leave: return_void\n");
> -	return(IA_CSS_SUCCESS);
> +	return IA_CSS_SUCCESS;
>  }
>
>  enum ia_css_err
> @@ -10261,7 +10261,7 @@ ia_css_stream_load(struct ia_css_stream *stream)
>  						for(k=0;k<j;k++)
>  							ia_css_pipe_destroy(my_css_save.stream_seeds[i].pipes[k]);
>  					}
> -					return(err);
> +					return err;
>  				}
>  			err = ia_css_stream_create(&(my_css_save.stream_seeds[i].stream_config), my_css_save.stream_seeds[i].num_pipes,
>  						    my_css_save.stream_seeds[i].pipes, &(my_css_save.stream_seeds[i].stream));
> @@ -10270,12 +10270,12 @@ ia_css_stream_load(struct ia_css_stream *stream)
>  				ia_css_stream_destroy(stream);
>  				for(j=0;j<my_css_save.stream_seeds[i].num_pipes;j++)
>  					ia_css_pipe_destroy(my_css_save.stream_seeds[i].pipes[j]);
> -				return(err);
> +				return err;
>  			}
>  			break;
>  		}
>  	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,	"ia_css_stream_load() exit, \n");
> -	return(IA_CSS_SUCCESS);
> +	return IA_CSS_SUCCESS;
>  #else
>  	/* TODO remove function - DEPRECATED */
>  	(void)stream;
> @@ -10416,7 +10416,7 @@ ia_css_stream_unload(struct ia_css_stream *stream)
>  			break;
>  		}
>  	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,	"ia_css_stream_unload() exit, \n");
> -	return(IA_CSS_SUCCESS);
> +	return IA_CSS_SUCCESS;
>  }
>
>  #endif
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> index b7db3de..d3567ac 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> @@ -74,7 +74,7 @@ static struct fw_param *fw_minibuffer;
>
>  char *sh_css_get_fw_version(void)
>  {
> -	return(FW_rel_ver_name);
> +	return FW_rel_ver_name;
>  }
>
>
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20170303170139.GA9887%40singhal-Inspiron-5558.
> For more options, visit https://groups.google.com/d/optout.
>
