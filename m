Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:64784 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZHTNDC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 09:03:02 -0400
Received: from mbpwifi.kernelscience.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KOO00C0PEX1IM10@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 20 Aug 2009 09:03:02 -0400 (EDT)
Date: Thu, 20 Aug 2009 09:03:00 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx23885: fix support for TBS 6920 card
In-reply-to: <20090819232002.a941c388.kosio.dimitrov@gmail.com>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: linux-media@vger.kernel.org, bob@turbosight.com
Message-id: <4A8D4984.4000309@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090819232002.a941c388.kosio.dimitrov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/19/09 7:20 PM, Konstantin Dimitrov wrote:
>
> fix: GPIO initialization for TBS 6920
> fix: wrong I2C address for demod on TBS 6920
> fix: wrong I2C bus number for demod on TBS 6920
> fix: wrong "gen_ctrl_val" value for TS1 port on TBS 6920 (and some other cards)
> add: module_param "lnb_pwr_ctrl" as option to choose between "type 0" and "type 1" of LNB power control (two TBS 6920 boards no matter that they are marked as the same hardware revision may have different types of LNB power control)
> fix: LNB power control function for type 0 doesn't preserve the previous GPIO state, which is critical
> add: LNB power control function for type 1
>
> Signed-off-by: Bob Liu<bob@turbosight.com>
> Signed-off-by: Konstantin Dimitrov<kosio.dimitrov@gmail.com>

I got a weird HTML related email bounce from vger when I responded originally to 
this via gmail. Maybe this time via thunderbird will bring success.

...

Hmm. A custom hanging off of a gpio to something that looks like an i2c power 
control device. I want to review some of these generic (and no-so-generic) 
changes before we merge this patch.

Is the datasheet for the LNB power control device available to the public? I'd 
like to understand some of the register details.

Thanks,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
