Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46110 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbeKGVb4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 16:31:56 -0500
Subject: Re: [PATCH] media: staging: tegra-vde: Change from __attribute to
 __packed.
To: rafaelgoncalves@riseup.net, mchehab@kernel.org,
        gregkh@linuxfoundation.org, thierry.reding@gmail.com,
        jonathanh@nvidia.com, linux-media@vger.kernel.org,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, lkcamp@lists.libreplanetbr.org
References: <20181107022324.11994-1-rafaelgoncalves@riseup.net>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <bc0d606c-c2e7-c23d-e1a5-cb9e0a30a937@gmail.com>
Date: Wed, 7 Nov 2018 15:01:08 +0300
MIME-Version: 1.0
In-Reply-To: <20181107022324.11994-1-rafaelgoncalves@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.11.2018 5:23, rafaelgoncalves@riseup.net wrote:
> From: Rafael Goncalves <rafaelgoncalves@riseup.net>
> 
> Correct the following warnings from checkpatch.pl:
> 
> WARNING: __packed is preferred over __attribute__((packed))
> +} __attribute__((packed));
> 
> WARNING: __packed is preferred over __attribute__((packed))
> +} __attribute__((packed));
> 
> Signed-off-by: Rafael Goncalves <rafaelgoncalves@riseup.net>
> 
> ---
> 
> Hi.
> It's my first patch submission, please let me know if there is something
> that I can improve.
> ---
>  drivers/staging/media/tegra-vde/uapi.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/tegra-vde/uapi.h b/drivers/staging/media/tegra-vde/uapi.h
> index a50c7bcae057..5ffa4afa4047 100644
> --- a/drivers/staging/media/tegra-vde/uapi.h
> +++ b/drivers/staging/media/tegra-vde/uapi.h
> @@ -29,7 +29,7 @@ struct tegra_vde_h264_frame {
>  	__u32 flags;
>  
>  	__u32 reserved;
> -} __attribute__((packed));
> +} __packed;
>  
>  struct tegra_vde_h264_decoder_ctx {
>  	__s32 bitstream_data_fd;
> @@ -61,7 +61,7 @@ struct tegra_vde_h264_decoder_ctx {
>  	__u8  num_ref_idx_l1_active_minus1;
>  
>  	__u32 reserved;
> -} __attribute__((packed));
> +} __packed;
>  
>  #define VDE_IOCTL_BASE			('v' + 0x20)
>  
> 

Hello Rafael,

Thank you very much for the patch, but looks like it is not correct. The Userspace API header is supposed to be used by kernel and userspace, the __packed macro is available in kernel only.

Interestingly there few places in include/uapi/ that use __packed macro, I'm wondering if they are correct. Note that GCC just won't complain about undefined qualifier, at least by default.
