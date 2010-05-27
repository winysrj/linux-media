Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab0E0MbO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 08:31:14 -0400
Date: Thu, 27 May 2010 08:30:38 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Ang Way Chuang <wcang79@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-core: Fix ULE decapsulation bug when less than 4
 bytes of ULE SNDU is packed into the remaining bytes of a MPEG2-TS frame
Message-ID: <20100527123038.GA15893@redhat.com>
References: <4BFDFCD1.6020208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFDFCD1.6020208@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 27, 2010 at 01:02:09PM +0800, Ang Way Chuang wrote:
> ULE (Unidirectional Lightweight Encapsulation RFC 4326)
> decapsulation code has a bug that incorrectly treats ULE SNDU packed
> into the remaining 2 or 3 bytes of a MPEG2-TS frame as having
> invalid pointer field on the subsequent MPEG2-TS frame.
> 
> This patch was generated and tested against the latest Linus's pre
> 2.6.35-rc1 tree.
> 
> Signed-off-by: Ang Way Chuang <wcang@nav6.org>

Looks good to me, thanks for the updated version. Good catch noting that
error needed to be reset to false after it was handled, I'd missed that.

Acked-by: Jarod Wilson <jarod@redhat.com>

> ---
> diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
> index f6dac2b..6c3a8a0 100644
> --- a/drivers/media/dvb/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb/dvb-core/dvb_net.c
> @@ -351,6 +351,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 	const u8 *ts, *ts_end, *from_where = NULL;
> 	u8 ts_remain = 0, how_much = 0, new_ts = 1;
> 	struct ethhdr *ethh = NULL;
> +	bool error = false;
> 
> #ifdef ULE_DEBUG
> 	/* The code inside ULE_DEBUG keeps a history of the last 100 TS cells processed. */
> @@ -460,10 +461,16 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 
> 						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
> 						if (priv->ule_skb) {
> -							dev_kfree_skb( priv->ule_skb );
> +							error = true;
> +							dev_kfree_skb(priv->ule_skb);
> +						}
> +
> +						if (error || priv->ule_sndu_remain) {
> 							dev->stats.rx_errors++;
> 							dev->stats.rx_frame_errors++;
> +							error = false;
> 						}
> +
> 						reset_ule(priv);
> 						priv->need_pusi = 1;
> 						continue;
> @@ -535,6 +542,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 				from_where += 2;
> 			}
> 
> +			priv->ule_sndu_remain = priv->ule_sndu_len + 2;
> 			/*
> 			 * State of current TS:
> 			 *   ts_remain (remaining bytes in the current TS cell)
> @@ -544,6 +552,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> 			 */
> 			switch (ts_remain) {
> 				case 1:
> +					priv->ule_sndu_remain--;
> 					priv->ule_sndu_type = from_where[0] << 8;
> 					priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
> 					ts_remain -= 1; from_where += 1;
> @@ -557,6 +566,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
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

