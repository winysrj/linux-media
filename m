Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:45588 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbbFAIov (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 04:44:51 -0400
Date: Mon, 1 Jun 2015 10:44:47 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Jemma Denson <jdenson@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v2 1/4] b2c2: Add option to skip the first 6 pid filters
Message-ID: <20150601104447.0454d255@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <556C12E3.3020404@gmail.com>
References: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
	<1433009409-5622-2-git-send-email-jdenson@gmail.com>
	<556BF852.80202@iki.fi>
	<556C12E3.3020404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Mon, 01 Jun 2015 09:08:03 +0100 Jemma Denson <jdenson@gmail.com>
wrote:
> Yes, that might work, I hadn't though of just swapping them around - 
> thanks. It would however assume that the 0x0000 PAT feed is requested 
> early on enough that it always sits within the bank of 32 and nothing 
> else is too bothered by the odd out of order packet.
> 
> The only concern I have got is if there is any other oddness in the 
> first 6 - this card is the only flexcop based card with dvb-s2 and there 
> is a lack of stream with high bitrate transponders (>approx. 45Mbps), 
> which we think might due to the hardware pid filter. The card apparently 
> works fine under the windows driver so it's a case of trying to work out 
> what that might be doing differently. It's quite speculative at the 
> moment but I'm hoping this patch might help with that and I'm waiting 
> for some feedback on that - I'm stuck with 28.2E which doesn't hold 
> anything interesting.
> 
> At the moment it doesn't really matter too much having only 32 filters 
> rather than the full 38 - it does switch to full-TS once it runs out of 
> hardware filters, and the only issue with full-TS is that the flexcop 
> can't pass a TS with more than 45Mbps (but they aren't working at the 
> moment anyway)

I agree, if the 6 PID-filters are not working they should be used. The
worth is receiving PSI of a transponder/channel which is in fact from
the one previously tuned.

I think it is better to leave it as you suggested.

--
Patrick.
