Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:50102 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab1LWNjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 08:39:02 -0500
Message-ID: <4EF48473.3020207@linuxtv.org>
Date: Fri, 23 Dec 2011 14:38:59 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [RFCv1] add DTMB support for DVB API
References: <4EF3A171.3030906@iki.fi>
In-Reply-To: <4EF3A171.3030906@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.12.2011 22:30, Antti Palosaari wrote:
> @@ -201,6 +205,9 @@ typedef enum fe_guard_interval {
>      GUARD_INTERVAL_1_128,
>      GUARD_INTERVAL_19_128,
>      GUARD_INTERVAL_19_256,
> +    GUARD_INTERVAL_PN420,
> +    GUARD_INTERVAL_PN595,
> +    GUARD_INTERVAL_PN945,
>  } fe_guard_interval_t;

What does PN mean in this context?

Regards,
Andreas
