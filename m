Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47032 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbcGAOfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 10:35:15 -0400
Subject: Re: [PATCH] [media] cec: add missing inline stubs
To: Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20160701112027.102024-1-arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <51b68698-eced-a659-016f-cf9566851fd2@xs4all.nl>
Date: Fri, 1 Jul 2016 16:35:09 +0200
MIME-Version: 1.0
In-Reply-To: <20160701112027.102024-1-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2016 01:19 PM, Arnd Bergmann wrote:
> The linux/cec.h header file contains empty inline definitions for
> a subset of the API for the case in which CEC is not enabled,
> however we have driver that call other functions as well:
> 
> drivers/media/i2c/adv7604.c: In function 'adv76xx_cec_tx_raw_status':
> drivers/media/i2c/adv7604.c:1956:3: error: implicit declaration of function 'cec_transmit_done' [-Werror=implicit-function-declaration]
> drivers/media/i2c/adv7604.c: In function 'adv76xx_cec_isr':
> drivers/media/i2c/adv7604.c:2012:4: error: implicit declaration of function 'cec_received_msg' [-Werror=implicit-function-declaration]
> drivers/media/i2c/adv7604.c: In function 'adv76xx_probe':
> drivers/media/i2c/adv7604.c:3482:20: error: implicit declaration of function 'cec_allocate_adapter' [-Werror=implicit-function-declaration]

I don't understand this. These calls are under #if IS_ENABLED(CONFIG_VIDEO_ADV7842_CEC),
and that should be 0 if MEDIA_CEC is not selected.

Am I missing some weird config combination?

Regards,

	Hans


> 
> This adds stubs for the remaining interfaces as well.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/media/cec.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/media/cec.h b/include/media/cec.h
> index 9a791c08a789..c462f9b44074 100644
> --- a/include/media/cec.h
> +++ b/include/media/cec.h
> @@ -208,6 +208,12 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
>  void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
>  
>  #else
> +static inline struct cec_adapter *cec_allocate_adapter(
> +		const struct cec_adap_ops *ops, void *priv, const char *name,
> +		u32 caps, u8 available_las, struct device *parent)
> +{
> +	return NULL;
> +}
>  
>  static inline int cec_register_adapter(struct cec_adapter *adap)
>  {
> @@ -227,6 +233,25 @@ static inline void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
>  {
>  }
>  
> +static inline int cec_transmit_msg(struct cec_adapter *adap,
> +				   struct cec_msg *msg, bool block)
> +{
> +	return 0;
> +}
> +
> +/* Called by the adapter */
> +static inline void cec_transmit_done(struct cec_adapter *adap, u8 status,
> +				     u8 arb_lost_cnt, u8 nack_cnt,
> +				     u8 low_drive_cnt, u8 error_cnt)
> +{
> +}
> +
> +static inline void cec_received_msg(struct cec_adapter *adap,
> +				    struct cec_msg *msg)
> +{
> +}
> +
> +
>  #endif
>  
>  #endif /* _MEDIA_CEC_H */
> 
