Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:48176 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751289AbdJGQOq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Oct 2017 12:14:46 -0400
Date: Sat, 7 Oct 2017 18:14:44 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Srishti Sharma <srishtishar@gmail.com>
cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH] Staging: media: atomisp: pci: Eliminate
 use of typedefs for struct
In-Reply-To: <1507384322-16584-1-git-send-email-srishtishar@gmail.com>
Message-ID: <alpine.DEB.2.20.1710071814230.2134@hadrien>
References: <1507384322-16584-1-git-send-email-srishtishar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sat, 7 Oct 2017, Srishti Sharma wrote:

> The use of typedefs for struct is discouraged, and hence can be
> eliminated. Done using the following semantic patch by coccinelle.
>
> @r1@
> type T;
> @@
>
> typedef struct {...} T;
>
> @script: python p@
> T << r1.T;
> T1;
> @@
>
> if T[-2:] == "_t" or T[-2:] == "_T":
>         coccinelle.T1 = T[:-2]
> else:
>         coccinelle.T1 = T
>
> print T, T1
> @r2@
> type r1.T;
> identifier p.T1;
> @@
>
> - typedef
> struct
> + T1
> {
> ...
> }
> - T
> ;
>
> @r3@
> type r1.T;
> identifier p.T1;
> @@
>
> - T
> + struct T1
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
>  .../media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c  | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
> index d9178e8..6d9bceb 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
> @@ -37,7 +37,7 @@ more details.
>  #include "ia_css_spctrl.h"
>  #include "ia_css_debug.h"
>
> -typedef struct {
> +struct spctrl_context_info {
>  	struct ia_css_sp_init_dmem_cfg dmem_config;
>  	uint32_t        spctrl_config_dmem_addr; /** location of dmem_cfg  in SP dmem */
>  	uint32_t        spctrl_state_dmem_addr;
> @@ -45,9 +45,9 @@ typedef struct {
>  	hrt_vaddress    code_addr;          /* sp firmware location in host mem-DDR*/
>  	uint32_t        code_size;
>  	char           *program_name;       /* used in case of PLATFORM_SIM */
> -} spctrl_context_info;
> +};
>
> -static spctrl_context_info spctrl_cofig_info[N_SP_ID];
> +static struct spctrl_context_info spctrl_cofig_info[N_SP_ID];
>  static bool spctrl_loaded[N_SP_ID] = {0};
>
>  /* Load firmware */
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1507384322-16584-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
