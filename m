Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:28177 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGYXNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 19:13:25 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A00H9TJ6C9KA0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 19:13:24 -0400 (EDT)
Date: Fri, 25 Jul 2014 20:13:20 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 42/49] rc-ir-raw: atomic reads of protocols
Message-id: <20140725201320.662a2521.m.chehab@samsung.com>
In-reply-to: <20140403233448.27099.69654.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
 <20140403233448.27099.69654.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:34:48 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Use atomic reads to avoid having to take a mutex when getting
> the bitmask of supported protocols.

This also belongs to that RCU change series, and doesn't apply.

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-core-priv.h |    2 +-
>  drivers/media/rc/rc-ir-raw.c    |   12 ++++--------
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index c3de26b..04776e8 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -29,7 +29,7 @@ enum rc_driver_type {
>  struct ir_raw_handler {
>  	struct list_head list;
>  
> -	u64 protocols; /* which are handled by this handler */
> +	unsigned protocols; /* which are handled by this handler */
>  	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
>  
>  	/* These two should only be used by the lirc decoder */
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index 9631825..bf5215b 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -27,7 +27,7 @@ static LIST_HEAD(ir_raw_client_list);
>  static LIST_HEAD(ir_raw_handler_list);
>  
>  /* protocols supported by the currently loaded decoders */
> -static u64 available_protocols;
> +static atomic_t available_protocols = ATOMIC_INIT(0);
>  
>  static int ir_raw_event_thread(void *data)
>  {
> @@ -251,11 +251,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_handle);
>  /* used internally by the sysfs interface */
>  static u64 ir_raw_get_allowed_protocols(struct rc_dev *dev)
>  {
> -	u64 protocols;
> -	mutex_lock(&ir_raw_mutex);
> -	protocols = available_protocols;
> -	mutex_unlock(&ir_raw_mutex);
> -	return protocols;
> +	return atomic_read(&available_protocols);
>  }
>  
>  static int change_protocol(struct rc_dev *dev, u64 *rc_type) {
> @@ -353,7 +349,7 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
>  	if (ir_raw_handler->raw_register)
>  		list_for_each_entry_rcu(raw, &ir_raw_client_list, list)
>  			ir_raw_handler->raw_register(raw->dev);
> -	available_protocols |= ir_raw_handler->protocols;
> +	atomic_set_mask(ir_raw_handler->protocols, &available_protocols);
>  	mutex_unlock(&ir_raw_mutex);
>  	synchronize_rcu();
>  
> @@ -370,7 +366,7 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
>  	if (ir_raw_handler->raw_unregister)
>  		list_for_each_entry_rcu(raw, &ir_raw_client_list, list)
>  			ir_raw_handler->raw_unregister(raw->dev);
> -	available_protocols &= ~ir_raw_handler->protocols;
> +	atomic_clear_mask(ir_raw_handler->protocols, &available_protocols);
>  	mutex_unlock(&ir_raw_mutex);
>  	synchronize_rcu();
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
