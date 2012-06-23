Return-path: <linux-media-owner@vger.kernel.org>
Received: from sw-systems.de ([188.246.4.200]:59256 "EHLO mail.sw-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2FWJrf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 05:47:35 -0400
Subject: Re: Skystar HD2 / mantis status?
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
From: Bernhard Stegmaier <stegmaier@sw-systems.de>
In-Reply-To: <CABKuU7p+-db0dEJR+n1WRxOdKO-7frkuCbfSCPfGWkULNBAcdg@mail.gmail.com>
Date: Sat, 23 Jun 2012 11:39:15 +0200
Cc: linux-media <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <CC78EA1D-60D6-4262-8691-1E7153633ACF@sw-systems.de>
References: <CABKuU7p+-db0dEJR+n1WRxOdKO-7frkuCbfSCPfGWkULNBAcdg@mail.gmail.com>
To: Andrew Hakman <andrew.hakman@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm also running a stock 3.2 kernel with mythtv and a SkyStar HD2.
It is fine for both DVB-S and DVB-S2 (on Astra).

Only thing I had to do is to increase lock timeouts quite a bit.
Default mythtv values were too small so I got no locks.


Regards,
Bernhard
 
On 23.06.2012, at 01:54, Andrew Hakman wrote:

> What is the status of the Skystar HD2 / Mantis driver? I am running
> kernel 3.2-4, and the card tunes DVB-S fine, but gives a transport
> stream with a ton of errors when tuning DVB-S2. Is there a driver that
> actually works with this card properly, or is the card just useless
> for DVB-S2 in linux?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

