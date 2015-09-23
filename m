Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:34948 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbbIWO0Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 10:26:24 -0400
Date: Wed, 23 Sep 2015 15:26:19 +0100
From: Sean Young <sean@mess.org>
To: Eric Nelson <eric@nelint.com>
Cc: linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mchehab@osg.samsung.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	patrice.chotard@st.com, fabf@skynet.be, wsa@the-dreams.de,
	heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br
Subject: Re: [PATCH V3 2/2] rc: gpio-ir-recv: add timeout on idle
Message-ID: <20150923142619.GA10653@gofer.mess.org>
References: <5602AE95.9000505@nelint.com>
 <1443017228-16499-1-git-send-email-eric@nelint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1443017228-16499-1-git-send-email-eric@nelint.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 23, 2015 at 07:07:08AM -0700, Eric Nelson wrote:
> Many decoders require a trailing space (period without IR illumination)
> to be delivered before completing a decode.
> 
> Since the gpio-ir-recv driver only delivers events on gpio transitions,
> a single IR symbol (caused by a quick touch on an IR remote) will not
> be properly decoded without the use of a timer to flush the tail end
> state of the IR receiver.
> 
> This patch initializes and uses a timer and the timeout field of rcdev
> to complete the stream and allow decode.
> 
> The timeout can be overridden through the use of the LIRC_SET_REC_TIMEOUT
> ioctl.
> 
> Signed-off-by: Eric Nelson <eric@nelint.com>

Acked-by: Sean Young <sean@mess.org>

