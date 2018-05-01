Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0064.outbound.protection.outlook.com ([104.47.40.64]:36693
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751126AbeEAVWu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 17:22:50 -0400
Date: Tue, 1 May 2018 14:22:37 -0700
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Rohit Athavale <RATHAVAL@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v4 07/10] media: Add new dt-bindings/vf_codes for
 supported formats
Message-ID: <20180501212236.GC9872@smtp.xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
 <17a5f753d3a580971e6802775a237e501597ddbc.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <17a5f753d3a580971e6802775a237e501597ddbc.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-04-30 at 18:35:10 -0700, Satish Kumar Nagireddy wrote:
> From: Rohit Athavale <rathaval@xilinx.com>
> 
> This commit adds new entries to the exisiting vf_codes that are used
> to describe the media bus formats in the DT bindings. The newly added
> 8-bit and 10-bit color depth related formats will need these updates.
> 
> Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
> Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
> ---
>  include/dt-bindings/media/xilinx-vip.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/dt-bindings/media/xilinx-vip.h b/include/dt-bindings/media/xilinx-vip.h
> index 6298fec..fcd34d7 100644
> --- a/include/dt-bindings/media/xilinx-vip.h
> +++ b/include/dt-bindings/media/xilinx-vip.h
> @@ -35,5 +35,7 @@
>  #define XVIP_VF_CUSTOM2			13
>  #define XVIP_VF_CUSTOM3			14
>  #define XVIP_VF_CUSTOM4			15
> +#define XVIP_VF_VUY_422			16
> +#define XVIP_VF_XBGR			17

The existing ones are from UG934, while new ones are not. We need to organize
this a little differently, and this should come with more details.

Thanks,
-hyun

>  
>  #endif /* __DT_BINDINGS_MEDIA_XILINX_VIP_H__ */
> -- 
> 2.1.1
> 
