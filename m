Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ukl.yahoo.com ([217.146.183.200]:40820 "HELO
	nm2.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751351Ab1HPA6n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 20:58:43 -0400
Message-ID: <4E49C0BF.5040905@yahoo.com>
Date: Tue, 16 Aug 2011 01:58:39 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: steve@stevekerrison.com, linux-media@vger.kernel.org
Subject: Possible cause of replug lockup in em28xx-dvb
References: <1313397551.2818.5.camel@ares>
In-Reply-To: <1313397551.2818.5.camel@ares>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been "plugging away" at the locking issue in the em28xx / em28xx-dvb 
modules, and I think I've found the reason. Basically, we're trying to acquire 
the dev->lock mutex again in dvb_init() when we've already acquired it in 
em28xx_init_dev().

The exact sequence is:
	em28xx_init_dev()
	- em28xx_init_extension()
	-- ops->init(dev) function for each extension

where ops->init = dvb_init() for the em28xx-dvb extension. However, if you 
remove the em28xx-dvb module first then the em28xx_extension_devlist is empty
and you avoid calling dvb_init().

As to the fix, I'm thinking of moving the mutex_lock() / mutex_unlock() calls
from dvb_init() to em28xx_register_extension() instead. This way, we ensure that 
dvb_init() is still always called with the dvb->lock mutex held.

I'll submit a patch for review in the morning. (Or should I say, "later this 
morning"...)

Cheers,
Chris
