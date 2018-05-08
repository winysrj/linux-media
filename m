Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64380 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753419AbeEHHWF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 03:22:05 -0400
Date: Tue, 8 May 2018 15:18:51 +0800
From: Yunliang Ding <yunliang.ding@intel.com>
To: Colin King <colin.king@canonical.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: atomisp: fix spelling mistake: "diregard" ->
 "disregard"
Message-ID: <20180508071850.GA17320@intel.com>
References: <20180429120647.10194-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180429120647.10194-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-04-29 at 13:06:47 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in ia_css_print message text

Hi Colin,

The atomisp drivers will soon EOL accorinding to the ML discussion.

> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  .../css2400/css_2401_csi2p_system/host/csi_rx_private.h         | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
> index 9c0cb4a63862..4fa74e7a96e6 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
> @@ -202,7 +202,7 @@ static inline void csi_rx_be_ctrl_dump_state(
>  		ia_css_print("CSI RX BE STATE Controller %d PEC ID %d custom pec 0x%x \n", ID, i, state->pec[i]);
>  	}
>  #endif
> -	ia_css_print("CSI RX BE STATE Controller %d Global LUT diregard reg 0x%x \n", ID, state->global_lut_disregard_reg);
> +	ia_css_print("CSI RX BE STATE Controller %d Global LUT disregard reg 0x%x \n", ID, state->global_lut_disregard_reg);
>  	ia_css_print("CSI RX BE STATE Controller %d packet stall reg 0x%x \n", ID, state->packet_status_stall);
>  	/*
>  	 * Get the values of the register-set per
> -- 
> 2.17.0
> 
