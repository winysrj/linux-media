Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463Ab3CUOEe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 10:04:34 -0400
Date: Thu, 21 Mar 2013 11:02:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Jesse Gross <jesse@nicira.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Karsten Keil <isdn@linux-pingi.de>,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	dev@openvswitch.org
Subject: Re: [PATCH] net: add ETH_P_802_3_MIN
Message-ID: <20130321110255.4c06b2b7@redhat.com>
In-Reply-To: <1363854568-32228-1-git-send-email-horms@verge.net.au>
References: <1363854568-32228-1-git-send-email-horms@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Mar 2013 17:29:28 +0900
Simon Horman <horms@verge.net.au> escreveu:

> Add a new constant ETH_P_802_3_MIN, the minimum ethernet type for
> an 802.3 frame. Frames with a lower value in the ethernet type field
> are Ethernet II.
> 
> Also update all the users of this value that I could find to use the
> new constant.
> 
> I anticipate adding some more users of this constant when
> adding MPLS support to Open vSwtich.
> 
> As suggested by Jesse Gross.
> 
> Compile tested only.
> 
> Cc: Jesse Gross <jesse@nicira.com>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux1394-devel@lists.sourceforge.net
> Cc: linux-media@vger.kernel.org
> Cc: dev@openvswitch.org
> Signed-off-by: Simon Horman <horms@verge.net.au>

...

> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index 44225b1..9fc82a1 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -185,7 +185,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
>  			skb->pkt_type=PACKET_MULTICAST;
>  	}
>  
> -	if (ntohs(eth->h_proto) >= 1536)
> +	if (ntohs(eth->h_proto) >= ETH_P_802_3_MIN)
>  		return eth->h_proto;

...

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro
