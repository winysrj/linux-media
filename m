Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47175 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbbJCOZV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2015 10:25:21 -0400
Date: Sat, 3 Oct 2015 11:25:10 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Eric Nelson <eric@nelint.com>
Cc: linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	patrice.chotard@st.com, fabf@skynet.be, wsa@the-dreams.de,
	heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br
Subject: Re: [PATCH V2 1/2] rc-core: define a default timeout for drivers
Message-ID: <20151003112510.54fe2a25@recife.lan>
In-Reply-To: <1442862524-3694-2-git-send-email-eric@nelint.com>
References: <1441980024-1944-1-git-send-email-eric@nelint.com>
	<1442862524-3694-1-git-send-email-eric@nelint.com>
	<1442862524-3694-2-git-send-email-eric@nelint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Sep 2015 12:08:43 -0700
Eric Nelson <eric@nelint.com> escreveu:

> A default timeout value of 100ms is workable for most decoders.
> Declare a constant to help standardize its' use.

I guess the worse case scenario is the NEC protocol:
	http://www.sbprojects.com/knowledge/ir/nec.php

with allows a repeat message to be sent on every 110ms. As the
repeat message is 11.25 ms, that would mean a maximum time without
data for 98.75 ms. So, in thesis, 100 ms would be ok. However, IR
timings are not always precise and may affected by the battery charge.

So, I think that a timeout of 100ms is too close to 98.75 and may
cause troubles.

S, IMHO, it is safer to define the default timeout as 125ms.

Regards,
Mauro


> 
> Signed-off-by: Eric Nelson <eric@nelint.com>
> ---
>  include/media/rc-core.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index ec921f6..62c64bd 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -239,6 +239,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
>  	memset(ev, 0, sizeof(*ev));
>  }
>  
> +#define IR_DEFAULT_TIMEOUT	MS_TO_NS(100)
>  #define IR_MAX_DURATION         500000000	/* 500 ms */
>  #define US_TO_NS(usec)		((usec) * 1000)
>  #define MS_TO_US(msec)		((msec) * 1000)
