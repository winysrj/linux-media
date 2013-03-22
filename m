Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:39232 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVNtm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 09:49:42 -0400
Date: Fri, 22 Mar 2013 22:49:38 +0900
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, jesse@nicira.com,
	stefanr@s5r6.in-berlin.de, isdn@linux-pingi.de, mchehab@redhat.com,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	dev@openvswitch.org
Subject: Re: [PATCH] net: add ETH_P_802_3_MIN
Message-ID: <20130322134938.GA4220@verge.net.au>
References: <1363854568-32228-1-git-send-email-horms@verge.net.au>
 <20130321.115608.570355867509300023.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321.115608.570355867509300023.davem@davemloft.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 21, 2013 at 11:56:08AM -0400, David Miller wrote:
> From: Simon Horman <horms@verge.net.au>
> Date: Thu, 21 Mar 2013 17:29:28 +0900
> 
> > Add a new constant ETH_P_802_3_MIN, the minimum ethernet type for
> > an 802.3 frame. Frames with a lower value in the ethernet type field
> > are Ethernet II.
> > 
> > Also update all the users of this value that I could find to use the
> > new constant.
> > 
> > I anticipate adding some more users of this constant when
> > adding MPLS support to Open vSwtich.
> > 
> > As suggested by Jesse Gross.
> > 
> > Compile tested only.
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> You missed a few cases:
> 
> drivers/media/dvb-core/dvb_net.c:       } while (p->ule_sndu_type < 1536);
> drivers/media/dvb-core/dvb_net.c:                               if (priv->ule_sndu_type < 1536) {
> net/atm/lec.h: *    is less than 1536(0x0600) MUST be encoded by placing that length
> drivers/net/wireless/ray_cs.c:  if (ntohs(proto) >= 1536) { /* DIX II ethernet frame */
> net/bridge/netfilter/ebtables.c:                if (FWINV2(ntohs(ethproto) >= 1536, EBT_IPROTO))
> include/linux/if_vlan.h:        if (ntohs(proto) >= 1536) {
> net/bluetooth/bnep/netdev.c:    if (proto >= 1536)
> net/openvswitch/flow.c: if (ntohs(proto) >= 1536)
> net/mac80211/tx.c:      } else if (ethertype >= 0x600) {
> net/wireless/util.c:    } else if (ethertype > 0x600) {
> 
> In fact, the last line looks like a bug, it should be >= not >.

Thanks for finding those.

> Could you take care of these bits and respin your patch?

Sure.
