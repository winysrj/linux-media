Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64160 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3LYK5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Dec 2013 05:57:38 -0500
Received: by mail-lb0-f179.google.com with SMTP id w7so3295470lbi.10
        for <linux-media@vger.kernel.org>; Wed, 25 Dec 2013 02:57:37 -0800 (PST)
Message-ID: <52BABA23.2040709@cogentembedded.com>
Date: Wed, 25 Dec 2013 14:57:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 13/19] media: dvb_core: slight optimization of addr
 compare
References: <52BA5113.7070908@huawei.com>
In-Reply-To: <52BA5113.7070908@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 25-12-2013 7:29, Ding Tianhong wrote:

> Use possibly more efficient ether_addr_equal
> instead of memcmp.

> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>   drivers/media/dvb-core/dvb_net.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index f91c80c..3dfc33b 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -179,7 +179,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
>   	eth = eth_hdr(skb);
>
>   	if (*eth->h_dest & 1) {
> -		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
> +		if(ether_addr_equal(eth->h_dest,dev->broadcast))

    There should be space after comma.

> @@ -674,11 +674,11 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
>   					if (priv->rx_mode != RX_MODE_PROMISC) {
>   						if (priv->ule_skb->data[0] & 0x01) {
>   							/* multicast or broadcast */
> -							if (memcmp(priv->ule_skb->data, bc_addr, ETH_ALEN)) {
> +							if (!ether_addr_equal(priv->ule_skb->data, bc_addr)) {
>   								/* multicast */
>   								if (priv->rx_mode == RX_MODE_MULTI) {
>   									int i;
> -									for(i = 0; i < priv->multi_num && memcmp(priv->ule_skb->data, priv->multi_macs[i], ETH_ALEN); i++)
> +									for(i = 0; i < priv->multi_num && !ether_addr_equal(priv->ule_skb->data, priv->multi_macs[i]); i++)

    Shouldn't this line be broken?

>   										;
>   									if (i == priv->multi_num)
>   										drop = 1;

WBR, Sergei


