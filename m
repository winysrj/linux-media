Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50909
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754441AbdCaKGd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 06:06:33 -0400
Date: Fri, 31 Mar 2017 07:06:25 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yuval Mintz <Yuval.Mintz@cavium.com>,
        Ariel Elior <ariel.elior@cavium.com>,
        everest-linux-l2@cavium.com, Yishai Hadas <yishaih@mellanox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] treewide: Correct diffrent[iate] and banlance typos
Message-ID: <20170331070625.39294170@vento.lan>
In-Reply-To: <962aace119675e5fe87be2a88ddac1a5486f8e60.1490931810.git.joe@perches.com>
References: <962aace119675e5fe87be2a88ddac1a5486f8e60.1490931810.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 20:44:16 -0700
Joe Perches <joe@perches.com> escreveu:

> Add these misspellings to scripts/spelling.txt too
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h | 2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c      | 2 +-
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c       | 2 +-
>  drivers/net/ethernet/qlogic/qed/qed_int.c           | 2 +-
>  drivers/net/ethernet/qlogic/qed/qed_main.c          | 2 +-
>  drivers/net/ethernet/qlogic/qed/qed_sriov.c         | 2 +-
>  include/linux/mlx4/device.h                         | 2 +-
>  scripts/spelling.txt                                | 3 +++
>  8 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
> index 354ec07eae87..23ae72468025 100644
> --- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
> +++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
> @@ -70,7 +70,7 @@
>  * (3) both long and short but short preferred and long only when necesarry
>  *
>  * These modes must be selected compile time via compile switches.
> -* Compile switch settings for the diffrent modes:
> +* Compile switch settings for the different modes:
>  * (1) DRXDAPFASI_LONG_ADDR_ALLOWED=0, DRXDAPFASI_SHORT_ADDR_ALLOWED=1
>  * (2) DRXDAPFASI_LONG_ADDR_ALLOWED=1, DRXDAPFASI_SHORT_ADDR_ALLOWED=0
>  * (3) DRXDAPFASI_LONG_ADDR_ALLOWED=1, DRXDAPFASI_SHORT_ADDR_ALLOWED=1
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> index cea6bdcde33f..8baf9d3eb4b1 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> @@ -1591,7 +1591,7 @@ static int __bnx2x_vlan_mac_execute_step(struct bnx2x *bp,
>  	if (rc != 0) {
>  		__bnx2x_vlan_mac_h_pend(bp, o, *ramrod_flags);
>  
> -		/* Calling function should not diffrentiate between this case
> +		/* Calling function should not differentiate between this case
>  		 * and the case in which there is already a pending ramrod
>  		 */
>  		rc = 1;


Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
