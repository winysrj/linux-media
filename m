Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17058 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdIKVBQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 17:01:16 -0400
Date: Tue, 12 Sep 2017 00:00:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vincent Hervieux <vincent.hervieux@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@llwyncelyn.cymru, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, rvarsha016@gmail.com,
        fengguang.wu@intel.com, daeseok.youn@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: atomisp: fix compilation errors in case of
 ISP2401.
Message-ID: <20170911210041.7q5aorxnmixwvjym@mwanda>
References: <cover.1505142435.git.vincent.hervieux@gmail.com>
 <eb7714c464199ecb81d3a9bf9c57b5bf2689ac4b.1505142435.git.vincent.hervieux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb7714c464199ecb81d3a9bf9c57b5bf2689ac4b.1505142435.git.vincent.hervieux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We always need a changelog.  And actually this seems a bit involved so
there is stuff to explain.

On Mon, Sep 11, 2017 at 08:51:15PM +0200, Vincent Hervieux wrote:
> Signed-off-by: Vincent Hervieux <vincent.hervieux@gmail.com>
> ---
>  .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  5 ++---
>  .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  6 +++++-
>  .../pci/atomisp2/css2400/ia_css_acc_types.h        |  1 +
>  .../css2400/runtime/debug/src/ia_css_debug.c       |  3 ---
>  .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 24 ++++++++++------------
>  .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |  8 +-------
>  6 files changed, 20 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> index f48bf451c1f5..d79a3cfb834d 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> @@ -1045,9 +1045,8 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
>  				asd->re_trigger_capture = false;
>  				dev_dbg(isp->dev, "Trigger capture again for new buffer. err=%d\n",
>  						err);
> -			} else {
> -				asd->re_trigger_capture = true;
> -			}
> +		} else {
> +			asd->re_trigger_capture = true;
>  #endif
>  		}
>  		break;
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> index 663aa916e3ca..1e61f66437d2 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> @@ -1602,4 +1602,8 @@ module_exit(atomisp_exit);
>  MODULE_AUTHOR("Wen Wang <wen.w.wang@intel.com>");
>  MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
>  MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("Intel ATOM Platform ISP Driver");
> +#if defined(ISP2400) || defined(ISP2400B0)
> +MODULE_DESCRIPTION("Intel ATOM Platform ISP Driver 2400");
> +#elif defined(ISP2401)
> +MODULE_DESCRIPTION("Intel ATOM Platform ISP Driver 2401");
> +#endif
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h
> index a2a1873aca83..3bcbd0fa0637 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_acc_types.h
> @@ -222,6 +222,7 @@ struct ia_css_binary_info {
>  		uint8_t	luma_only;
>  		uint8_t	input_yuv;
>  		uint8_t	input_raw;
> +		uint8_t	lace_stats;
>  #endif
>  		uint8_t	reduced_pipe;
>  		uint8_t	vf_veceven;
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
> index 0fa7cb2423d8..6f6e30cb7550 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
> @@ -49,9 +49,6 @@
>  #include "assert_support.h"
>  #include "print_support.h"
>  #include "string_support.h"
> -#ifdef ISP2401
> -#include "ia_css_system_ctrl.h"
> -#endif
>  
>  #include "fifo_monitor.h"
>  
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> index e882b5596813..1d2e56e74e01 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> @@ -1496,7 +1496,7 @@ sh_css_invalidate_shading_tables(struct ia_css_stream *stream)
>  		"sh_css_invalidate_shading_tables() leave: return_void\n");
>  }
>  
> -#ifndef ISP2401
> +#if 1 /* was ndef ISP2401 but this function is used by ISP2401 on line 1758 */

Just delete the #if.  (I haven't looked at the code).  These comments
should probably be in the changelog.  You probably want to break this
patch up into several patches and add a little changelog for each
explaining what's going on.

Extra curly brace.  Bad indenting.  Add a missing struct member.
Delete references to header file that doesn't exist.  Delete defines.

regards,
dan carpenter
