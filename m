Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45698 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbcEDNgV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 09:36:21 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 0E08F20A1F
	for <linux-media@vger.kernel.org>; Wed,  4 May 2016 09:36:20 -0400 (EDT)
Date: Wed, 4 May 2016 16:34:08 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Ismael Luceno <ismael@iodev.co.uk>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	chall@corp.bluecherry.net, maintainers@bluecherrydvr.com
Subject: Re: [PATCH 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
Message-ID: <20160504133408.GA18570@acer>
References: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 30, 2016 at 12:17:08AM -0300, Ismael Luceno wrote:
> Such frame size is met in practice. Also report oversized frames.
> 
> Based on patches by Andrey Utkin <andrey.utkin@corp.bluecherry.net>.

If it is based on my patches([1] [2]), then why you claim authorship and
why you don't let me know (at last CCing me)?

Do you know that 200 KiB is not the limit, just as previous value? I
haven't researched subj deep enough to figure out proven good value for
new buffer size.

It's both laughable and infuriating for me to spectate your behaviour of
"stealth driver developer".
You have added yourself back to driver maintainers in MAINTAINERS file
after your quit without letting us know.
You are not affiliated with Bluecherry for two years, and you are not
informed about how the driver is working in production on customers
setups. So you are not aware what are real issues with it. BTW do you
still have a sample of actual hardware? Yeah, I agree that this can be
argument against Bluecherry and lack of openness in its bug tracking.
But you are also not open and not collaborating.

The point of my accusation to you is that you seem to be just gaining
"kernel developer" score for nobody's (except your CV's) benefit.
Development and maintenance is what Hans Verkuil, Krzysztof Halasa and
others do to this driver, but not this.

Sorry to be harsh.

[1] https://github.com/bluecherrydvr/solo6x10/commit/5cd985087362e2e524b3e44504eea791ae7cda7e
[2] https://github.com/bluecherrydvr/solo6x10/commit/3b437f79c40438eb09bb2d5dbcfe67dbc94648ed
