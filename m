Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37647 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbcFSJqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 05:46:34 -0400
Date: Sun, 19 Jun 2016 11:46:29 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
Message-ID: <20160619094629.GC5853@netboy>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
 <20160613114713.GA9544@localhost.localdomain>
 <20160613195136.GC2441@netboy>
 <20160614121844.54a125a5@lxorguk.ukuu.org.uk>
 <5760C84C.40408@sakamocchi.jp>
 <20160615080602.GA13555@localhost.localdomain>
 <5764DA85.3050801@sakamocchi.jp>
 <20160618224549.GF32724@icarus.home.austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160618224549.GF32724@icarus.home.austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 19, 2016 at 12:45:50AM +0200, Henrik Austad wrote:
> edit: this turned out to be a somewhat lengthy answer. I have tried to 
> shorten it down somewhere. it is getting late and I'm getting increasingly 
> incoherent (Richard probably knows what I'm talking about ;) so I'll stop 
> for now.

Thanks for your responses, Henrik.  I think your explanations are on spot.

> note that an adjustable sample-clock is not a *requirement* but in general 
> you'd want to avoid resampling in software.

Yes, but..

Adjusting the local clock rate to match the AVB network rate is
essential.  You must be able to *continuously* adjust the rate in
order to compensate drift.  Again, there are exactly two ways to do
it, namely in hardware (think VCO) or in software (dynamic
resampling).

What you cannot do is simply buffer the AV data and play it out
blindly at the local clock rate.

Regarding the media clock, if I understand correctly, there the talker
has two possibilities.  Either the talker samples the stream at the
gPTP rate, or the talker must tell the listeners the relationship
(phase offset and frequency ratio) between the media clock and the
gPTP time.  Please correct me if I got the wrong impression...

Thanks,
Richard
