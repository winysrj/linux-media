Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40138 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3CUNYg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:24:36 -0400
Date: Thu, 21 Mar 2013 14:24:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Simon Horman <horms@verge.net.au>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Jesse Gross <jesse@nicira.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	dev@openvswitch.org
Subject: Re: [PATCH] net: add ETH_P_802_3_MIN
Message-ID: <20130321142403.3c0bfac8@stein>
In-Reply-To: <1363854568-32228-1-git-send-email-horms@verge.net.au>
References: <1363854568-32228-1-git-send-email-horms@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mar 21 Simon Horman wrote:
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
> ---
>  drivers/firewire/net.c           |    2 +-

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

>  drivers/isdn/i4l/isdn_net.c      |    2 +-
>  drivers/media/dvb-core/dvb_net.c |    6 +++---
>  drivers/net/ethernet/sun/niu.c   |    2 +-
>  drivers/net/plip/plip.c          |    2 +-
>  include/uapi/linux/if_ether.h    |    3 +++
>  net/ethernet/eth.c               |    2 +-
>  net/openvswitch/datapath.c       |    2 +-
>  8 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
> index 2b27bff..bd34ca1 100644
> --- a/drivers/firewire/net.c
> +++ b/drivers/firewire/net.c
> @@ -630,7 +630,7 @@ static int fwnet_finish_incoming_packet(struct net_device *net,
>  			if (memcmp(eth->h_dest, net->dev_addr, net->addr_len))
>  				skb->pkt_type = PACKET_OTHERHOST;
>  		}
> -		if (ntohs(eth->h_proto) >= 1536) {
> +		if (ntohs(eth->h_proto) >= ETH_P_802_3_MIN) {
>  			protocol = eth->h_proto;
>  		} else {
>  			rawp = (u16 *)skb->data;
[...]

-- 
Stefan Richter
-=====-===-= --== =-=-=
http://arcgraph.de/sr/
