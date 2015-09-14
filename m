Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:34160 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbbINKLR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 06:11:17 -0400
Date: Mon, 14 Sep 2015 11:00:44 +0100
From: Sean Young <sean@mess.org>
To: Eric Nelson <eric@nelint.com>
Cc: linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mchehab@osg.samsung.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	patrice.chotard@st.com, fabf@skynet.be, wsa@the-dreams.de,
	heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br
Subject: Re: [PATCH][resend] rc: gpio-ir-recv: allow flush space on idle
Message-ID: <20150914100044.GA21149@gofer.mess.org>
References: <1441980024-1944-1-git-send-email-eric@nelint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1441980024-1944-1-git-send-email-eric@nelint.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 11, 2015 at 07:00:24AM -0700, Eric Nelson wrote:
> Many decoders require a trailing space (period without IR illumination)
> to be delivered before completing a decode.
> 
> Since the gpio-ir-recv driver only delivers events on gpio transitions,
> a single IR symbol (caused by a quick touch on an IR remote) will not
> be properly decoded without the use of a timer to flush the tail end
> state of the IR receiver.

This is a problem other IR drivers suffer from too. It might be better
to send a IR timeout event like st_rc_send_lirc_timeout() in st_rc.c,
with the duration set to what the timeout was. That is what irraw 
timeouts are for; much better than fake transitions.

> This patch adds an optional device tree node "flush-ms" which, if
> present, will use a jiffie-based timer to complete the last pulse
> stream and allow decode.

A common value for this is 100ms, I'm not sure what use it has to have
it configurable. It's nice to have it exposed in rc_dev->timeout.


Sean
