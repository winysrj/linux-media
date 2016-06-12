Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:45816 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751823AbcFLHmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 03:42:39 -0400
Message-ID: <1465716910.25087.88.camel@perches.com>
Subject: Re: [very-RFC 5/8] Add TSN machinery to drive the traffic from a
 shim over the network
From: Joe Perches <joe@perches.com>
To: Henrik Austad <henrik@austad.us>, linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
	linux-netdev@vger.kernel.org, henrk@austad.us,
	Henrik Austad <haustad@cisco.com>,
	"David S. Miller" <davem@davemloft.net>
Date: Sun, 12 Jun 2016 00:35:10 -0700
In-Reply-To: <1465683741-20390-6-git-send-email-henrik@austad.us>
References: <1465683741-20390-1-git-send-email-henrik@austad.us>
	 <1465683741-20390-6-git-send-email-henrik@austad.us>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2016-06-12 at 00:22 +0200, Henrik Austad wrote:
> From: Henrik Austad <haustad@cisco.com>
> 
> In short summary:
> 
> * tsn_core.c is the main driver of tsn, all new links go through
>   here and all data to/form the shims are handled here
>   core also manages the shim-interface.
[]
> diff --git a/net/tsn/tsn_configfs.c b/net/tsn/tsn_configfs.c
[]
> +static inline struct tsn_link *to_tsn_link(struct config_item *item)
> +{
> +	/* this line causes checkpatch to WARN. making checkpatch happy,
> +	 * makes code messy..
> +	 */
> +	return item ? container_of(to_config_group(item), struct tsn_link, group) : NULL;
> +}

How about

static inline struct tsn_link *to_tsn_link(struct config_item *item)
{
	if (!item)
		return NULL;
	return container_of(to_config_group(item), struct tsn_link, group);
}
