Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40209 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab3APOhq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 09:37:46 -0500
Message-ID: <50F6BB14.40302@iki.fi>
Date: Wed, 16 Jan 2013 16:37:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Radoslaw Moszczynski <r.moszczynsk@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: PcTV Nanostick 290e -- DVB-C frontend only working after reconnecting
 the device
References: <016601cdf3f1$9e7925e0$db6b71a0$%moszczynsk@samsung.com>
In-Reply-To: <016601cdf3f1$9e7925e0$db6b71a0$%moszczynsk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/16/2013 03:58 PM, Radoslaw Moszczynski wrote:
> Hi,
>
> I'm not sure if this has been already reported, but I was playing around
> with Nanostick 290e today and I encountered some weird behavior with the
> DVB-C frontend.
>
> The DVB-C frontend only seems to work once after plugging in the device.
> During subsequent uses, it fails to lock on to signal. However, you can
> unplug the Nanostick, plug it back in, and it is able to lock on again. But
> only once -- then you have to replug it again.
>
> The exact actions that I took:
>
> 1. Plug in the Nanostick.
> 2. Run dvbstream to record a DVB-C stream -- works OK.
> 3. Run dvbstream to record a DVB-C stream again -- fail to lock on signal.
> 4. Unplug the Nanostick. Plug it back in.
> 5. Run dvbstream to record a DVB-C stream -- works OK.
> 6. Run dvbstream to record a DVB-C stream again -- fail to lock on signal.
>
> I'm using kernel 3.2.0 on Ubuntu x86. The DVB-T/T2 frontend doesn't display
> this behavior.
>
> If anyone's interested in debugging this, I'll be happy to provide more
> information.

Could you test first quite latest Kernel, 3.7 or even 3.8. If 3.7 
behaves similarly, then test older Kernel 3.0.

Working only on first tuning attempt sounds like it should not be common 
problem - otherwise there should be million bug reports like that.

regards
Antti

-- 
http://palosaari.fi/
