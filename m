Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:38154 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3C1Fbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 01:31:32 -0400
Date: Thu, 28 Mar 2013 14:31:29 +0900
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: jesse@nicira.com, isdn@linux-pingi.de, linville@tuxdriver.com,
	johannes@sipsolutions.net, bart.de.schuymer@pandora.be,
	stephen@networkplumber.org, kaber@trash.net, marcel@holtmann.org,
	gustavo@padovan.org, johan.hedberg@gmail.com,
	linux-bluetooth@vger.kernel.org, netfilter-devel@vger.kernel.org,
	bridge@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH v2] net: add ETH_P_802_3_MIN
Message-ID: <20130328053128.GA23630@verge.net.au>
References: <1364445505-9745-1-git-send-email-horms@verge.net.au>
 <20130328.012108.961738246524996742.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328.012108.961738246524996742.davem@davemloft.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 28, 2013 at 01:21:08AM -0400, David Miller wrote:
> From: Simon Horman <horms@verge.net.au>
> Date: Thu, 28 Mar 2013 13:38:25 +0900
> 
> > Add a new constant ETH_P_802_3_MIN, the minimum ethernet type for
> > an 802.3 frame. Frames with a lower value in the ethernet type field
> > are Ethernet II.
> > 
> > Also update all the users of this value that David Miller and
> > I could find to use the new constant.
> > 
> > Also correct a bug in util.c. The comparison with ETH_P_802_3_MIN
> > should be >= not >.
> > 
> > As suggested by Jesse Gross.
> > 
> > Compile tested only.
> > 
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Looks great, applied, thanks Simon.

Thanks!
