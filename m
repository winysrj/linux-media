Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0ETTWW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 15:22:22 -0400
Date: Thu, 20 May 2010 15:22:13 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Ang Way Chuang <wcang79@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvb-core: Fix ULE decapsulation bug when less than 4 bytes of
 ULE SNDU is packed into the remaining bytes of a MPEG2-TS frame
Message-ID: <20100520192213.GA19133@redhat.com>
References: <4BE2D7A6.30201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE2D7A6.30201@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 06, 2010 at 02:52:22PM -0000, Ang Way Chuang wrote:
> ULE (Unidirectional Lightweight Encapsulation RFC 4326) decapsulation 
> code has a bug that incorrectly treats ULE SNDU packed into the 
> remaining 2 or 3 bytes of a MPEG2-TS frame as having invalid pointer 
> field on the subsequent MPEG2-TS frame.
> 
> This patch was generated and tested against v2.6.34-rc6. I suspect 
> that this bug was introduced in kernel version 2.6.15, but had not 
> verified it.
> 
> Care has been taken not to introduce more bug by fixing this bug, but
> please scrutinize the code because I always produces buggy code.
> 
> Signed-off-by: Ang Way Chuang <wcang@nav6.org>
> 
> ---
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
> index 441c064..35a4afb 100644
> --- a/drivers/media/dvb/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb/dvb-core/dvb_net.c
> @@ -458,8 +458,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 						       "field: %u.\n", priv->ts_count, *from_where);
> 
> 						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
> -						if (priv->ule_skb) {
> -							dev_kfree_skb( priv->ule_skb );
> +						if (priv->ule_skb || priv->ule_sndu_remain) {
> +							if (priv->ule_skb)
> +								dev_kfree_skb( priv->ule_skb );
> 							dev->stats.rx_errors++;
> 							dev->stats.rx_frame_errors++;
> 						}

That code block looks odd that way, but after staring at it for a minute,
it makes sense. Another way to do it that might read cleaner (and reduce
excessive tab indent levels) would be to add a 'bool errors', then:

	bool errors = false;
	...
	if (priv->ule_skb) {
		errors = true;
		dev_kfree_skb(priv->ule_skb);
	}

	if (errors || priv->ule_sndu_remain) {
		dev->stats.rx_errors++;
		dev->stats.rx_frame_errors++;
	}


> @@ -534,6 +535,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 				from_where += 2;
> 			}
> 
> +			priv->ule_sndu_remain = priv->ule_sndu_len + 2;
> 			/*
> 			 * State of current TS:
> 			 *   ts_remain (remaining bytes in the current TS cell)

Is this *always* true? Your description says "...the remaining 2 or 3
bytes", indicating this could sometimes need to be +3. Is +0 also a
possibility?


> @@ -543,6 +545,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 			 */
> 			switch (ts_remain) {
> 				case 1:
> +					priv->ule_sndu_remain--;
> 					priv->ule_sndu_type = from_where[0] << 8;
> 					priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
> 					ts_remain -= 1; from_where += 1;
> @@ -556,6 +559,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 				default: /* complete ULE header is present in current TS. */
> 					/* Extract ULE type field. */
> 					if (priv->ule_sndu_type_1) {
> +						priv->ule_sndu_type_1 = 0;
> 						priv->ule_sndu_type |= from_where[0];
> 						from_where += 1; /* points to payload start. */
> 						ts_remain -= 1;

-- 
Jarod Wilson
jarod@redhat.com

