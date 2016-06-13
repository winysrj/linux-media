Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33233 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161119AbcFMTvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 15:51:41 -0400
Date: Mon, 13 Jun 2016 21:51:36 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@vger.kernel.org, netdev@vger.kernel.org,
	henrk@austad.us, Arnd Bergmann <arnd@linaro.org>
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
Message-ID: <20160613195136.GC2441@netboy>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
 <20160613114713.GA9544@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160613114713.GA9544@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 13, 2016 at 01:47:13PM +0200, Richard Cochran wrote:
> 3. ALSA support for tunable AD/DA clocks.  The rate of the Listener's
>    DA clock must match that of the Talker and the other Listeners.
>    Either you adjust it in HW using a VCO or similar, or you do
>    adaptive sample rate conversion in the application. (And that is
>    another reason for *not* having a shared kernel buffer.)  For the
>    Talker, either you adjust the AD clock to match the PTP time, or
>    you measure the frequency offset.

Actually, we already have support for tunable clock-like HW elements,
namely the dynamic posix clock API.  It is trivial to write a driver
for VCO or the like.  I am just not too familiar with the latest high
end audio devices.

I have seen audio PLL/multiplier chips that will take, for example, a
10 kHz input and produce your 48 kHz media clock.  With the right HW
design, you can tell your PTP Hardware Clock to produce a 10000 PPS,
and you will have a synchronized AVB endpoint.  The software is all
there already.  Somebody should tell the ALSA guys about it.

I don't know if ALSA has anything for sample rate conversion or not,
but haven't seen anything that addresses distributed synchronized
audio applications.

Thanks,
Richard
