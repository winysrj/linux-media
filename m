Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:45760 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753422AbdGNKJB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 06:09:01 -0400
Message-ID: <1500026936.4457.68.camel@perches.com>
Subject: Re: [PATCH 05/14] isdn: isdnloop: suppress a gcc-7 warning
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org
Date: Fri, 14 Jul 2017 03:08:56 -0700
In-Reply-To: <20170714092540.1217397-6-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
         <20170714092540.1217397-6-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-07-14 at 11:25 +0200, Arnd Bergmann wrote:
> We test whether a bit is set in a mask here, which is correct
> but gcc warns about it as it thinks it might be confusing:
> 
> drivers/isdn/isdnloop/isdnloop.c:412:37: error: ?: using integer constants in boolean context, the expression will always evaluate to 'true' [-Werror=int-in-bool-context]
> 
> This replaces the negation of an integer with an equivalent
> comparison to zero, which gets rid of the warning.
[]
> diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
[]
> @@ -409,7 +409,7 @@ isdnloop_sendbuf(int channel, struct sk_buff *skb, isdnloop_card *card)
>  		return -EINVAL;
>  	}
>  	if (len) {
> -		if (!(card->flags & (channel) ? ISDNLOOP_FLAGS_B2ACTIVE : ISDNLOOP_FLAGS_B1ACTIVE))
> +		if ((card->flags & (channel) ? ISDNLOOP_FLAGS_B2ACTIVE : ISDNLOOP_FLAGS_B1ACTIVE) == 0)
>  			return 0;
>  		if (card->sndcount[channel] > ISDNLOOP_MAX_SQUEUE)
>  			return 0;

The if as written can not be zero.

drivers/isdn/isdnloop/isdnloop.h:#define ISDNLOOP_FLAGS_B1ACTIVE 1      /* B-Channel-1 is open           */
drivers/isdn/isdnloop/isdnloop.h:#define ISDNLOOP_FLAGS_B2ACTIVE 2      /* B-Channel-2 is open           */

Perhaps this is a logic defect and should be:

		if (!(card->flags & ((channel) ? ISDNLOOP_FLAGS_B2ACTIVE : ISDNLOOP_FLAGS_B1ACTIVE)))
