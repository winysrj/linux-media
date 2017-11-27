Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:46406 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752128AbdK0POz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 10:14:55 -0500
Subject: Re: [PATCH 6/8] [media] vivid: use ktime_t for timestamp calculation
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: y2038@lists.linaro.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Vincent ABRIOU <vincent.abriou@st.com>,
        Ingo Molnar <mingo@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20171127132027.1734806-1-arnd@arndb.de>
 <20171127132027.1734806-6-arnd@arndb.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <712d80dc-d236-0e9f-e324-aa03ca16baff@xs4all.nl>
Date: Mon, 27 Nov 2017 16:14:48 +0100
MIME-Version: 1.0
In-Reply-To: <20171127132027.1734806-6-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 11/27/2017 02:19 PM, Arnd Bergmann wrote:
> timespec is generally deprecated because of the y2038 overflow.
> In vivid, the usage is fine, since we are dealing with monotonic
> timestamps, but we can also simplify the code by going to ktime_t.
> 
> Using ktime_divns() should be roughly as efficient as the old code,
> since the constant 64-bit division gets turned into a multiplication
> on modern platforms, and we save multiple 32-bit divisions that can be
> expensive e.g. on ARMv7.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I hope I understood the VIVID_RDS_GEN_BLOCKS calculation right,
> please review carefully.
> ---
>  drivers/media/platform/vivid/vivid-core.c     |  2 +-
>  drivers/media/platform/vivid/vivid-core.h     |  2 +-
>  drivers/media/platform/vivid/vivid-radio-rx.c | 11 +++++------
>  drivers/media/platform/vivid/vivid-radio-tx.c |  8 +++-----
>  drivers/media/platform/vivid/vivid-rds-gen.h  |  1 +
>  5 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 5f316a5e38db..a091cfd93164 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -995,7 +995,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  
>  	dev->edid_max_blocks = dev->edid_blocks = 2;
>  	memcpy(dev->edid, vivid_hdmi_edid, sizeof(vivid_hdmi_edid));
> -	ktime_get_ts(&dev->radio_rds_init_ts);
> +	dev->radio_rds_init_time = ktime_get();
>  
>  	/* create all controls */
>  	ret = vivid_create_controls(dev, ccs_cap == -1, ccs_out == -1, no_error_inj,
> diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
> index 5cdf95bdc4d1..d8bff4dcefb7 100644
> --- a/drivers/media/platform/vivid/vivid-core.h
> +++ b/drivers/media/platform/vivid/vivid-core.h
> @@ -510,7 +510,7 @@ struct vivid_dev {
>  
>  	/* Shared between radio receiver and transmitter */
>  	bool				radio_rds_loop;
> -	struct timespec			radio_rds_init_ts;
> +	ktime_t				radio_rds_init_time;
>  
>  	/* CEC */
>  	struct cec_adapter		*cec_rx_adap;
> diff --git a/drivers/media/platform/vivid/vivid-radio-rx.c b/drivers/media/platform/vivid/vivid-radio-rx.c
> index 47c36c26096b..1b96cbd7f2ea 100644
> --- a/drivers/media/platform/vivid/vivid-radio-rx.c
> +++ b/drivers/media/platform/vivid/vivid-radio-rx.c
> @@ -38,9 +38,9 @@ ssize_t vivid_radio_rx_read(struct file *file, char __user *buf,
>  			 size_t size, loff_t *offset)
>  {
>  	struct vivid_dev *dev = video_drvdata(file);
> -	struct timespec ts;
>  	struct v4l2_rds_data *data = dev->rds_gen.data;
>  	bool use_alternates;
> +	ktime_t timestamp;
>  	unsigned blk;
>  	int perc;
>  	int i;
> @@ -64,17 +64,16 @@ ssize_t vivid_radio_rx_read(struct file *file, char __user *buf,
>  	}
>  
>  retry:
> -	ktime_get_ts(&ts);
> -	use_alternates = ts.tv_sec % 10 >= 5;
> +	timestamp = ktime_sub(ktime_get(), dev->radio_rds_init_time);
> +	blk = ktime_divns(timestamp, VIVID_RDS_NSEC_PER_BLK);
> +	use_alternates = blk % VIVID_RDS_GEN_BLOCKS;
> +

Almost right. This last line should be:

	use_alternates = (blk / VIVID_RDS_GEN_BLOCKS) & 1;

With that in place it works and you can add my:

Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

to this patch.

Regards,

	Hans


>  	if (dev->radio_rx_rds_last_block == 0 ||
>  	    dev->radio_rx_rds_use_alternates != use_alternates) {
>  		dev->radio_rx_rds_use_alternates = use_alternates;
>  		/* Re-init the RDS generator */
>  		vivid_radio_rds_init(dev);
>  	}
> -	ts = timespec_sub(ts, dev->radio_rds_init_ts);
> -	blk = ts.tv_sec * 100 + ts.tv_nsec / 10000000;
> -	blk = (blk * VIVID_RDS_GEN_BLOCKS) / 500;
>  	if (blk >= dev->radio_rx_rds_last_block + VIVID_RDS_GEN_BLOCKS)
>  		dev->radio_rx_rds_last_block = blk - VIVID_RDS_GEN_BLOCKS + 1;
>  
> diff --git a/drivers/media/platform/vivid/vivid-radio-tx.c b/drivers/media/platform/vivid/vivid-radio-tx.c
> index 0e8025b7b4dd..897b56195ca7 100644
> --- a/drivers/media/platform/vivid/vivid-radio-tx.c
> +++ b/drivers/media/platform/vivid/vivid-radio-tx.c
> @@ -37,7 +37,7 @@ ssize_t vivid_radio_tx_write(struct file *file, const char __user *buf,
>  {
>  	struct vivid_dev *dev = video_drvdata(file);
>  	struct v4l2_rds_data *data = dev->rds_gen.data;
> -	struct timespec ts;
> +	ktime_t timestamp;
>  	unsigned blk;
>  	int i;
>  
> @@ -58,10 +58,8 @@ ssize_t vivid_radio_tx_write(struct file *file, const char __user *buf,
>  	dev->radio_tx_rds_owner = file->private_data;
>  
>  retry:
> -	ktime_get_ts(&ts);
> -	ts = timespec_sub(ts, dev->radio_rds_init_ts);
> -	blk = ts.tv_sec * 100 + ts.tv_nsec / 10000000;
> -	blk = (blk * VIVID_RDS_GEN_BLOCKS) / 500;
> +	timestamp = ktime_sub(ktime_get(), dev->radio_rds_init_time);
> +	blk = ktime_divns(timestamp, VIVID_RDS_NSEC_PER_BLK);
>  	if (blk - VIVID_RDS_GEN_BLOCKS >= dev->radio_tx_rds_last_block)
>  		dev->radio_tx_rds_last_block = blk - VIVID_RDS_GEN_BLOCKS + 1;
>  
> diff --git a/drivers/media/platform/vivid/vivid-rds-gen.h b/drivers/media/platform/vivid/vivid-rds-gen.h
> index eff4bf552ed3..e55e3b22b7ca 100644
> --- a/drivers/media/platform/vivid/vivid-rds-gen.h
> +++ b/drivers/media/platform/vivid/vivid-rds-gen.h
> @@ -29,6 +29,7 @@
>  #define VIVID_RDS_GEN_GROUPS 57
>  #define VIVID_RDS_GEN_BLKS_PER_GRP 4
>  #define VIVID_RDS_GEN_BLOCKS (VIVID_RDS_GEN_BLKS_PER_GRP * VIVID_RDS_GEN_GROUPS)
> +#define VIVID_RDS_NSEC_PER_BLK (u32)(5ull * NSEC_PER_SEC / VIVID_RDS_GEN_BLOCKS)
>  
>  struct vivid_rds_gen {
>  	struct v4l2_rds_data	data[VIVID_RDS_GEN_BLOCKS];
> 
