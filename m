Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0GGN7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 09:59:40 -0400
Date: Wed, 7 Jul 2010 09:52:59 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: Some issues with imon input driver
Message-ID: <20100707135259.GA29996@redhat.com>
References: <201007070536.45900.anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007070536.45900.anssi.hannula@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 07, 2010 at 05:36:45AM +0300, Anssi Hannula wrote:
> Hi!
> 
> I tried to set up my imon remote, but run into the issue of buttons getting 
> easily stuck. And while looking at the code, I noticed some more issues :)

I'm not entirely surprised, I knew there were a few quirks left I'd not
yet fully sorted out. Generally, it works quite well, but I didn't abuse
the receiver quite as thoroughly as you. ;)

Can I talk you into filing a bug to track this? I can probably work up
fixes for a number of these sooner or later, if you don't beat me to them,
but it'd be easy for one or more of the specific problems to slip through
the cracks if not logged somewhere. My From: address here matches my
b.k.o. account, if you want to assign said bug to me.

Ah, and because we're actually handing remote controls via
drivers/media/IR/, you should cc linux-media as well (if not instead of
linux-input) on anything regarding this driver.

Thanks much,

--jarod


> So here they all are (on 2.6.35-rc4):
> 
> - There is no fallback timer if a release code is missed (i.e. remote pointed 
> away from receiver or some other anomaly), causing a key stuck on autorepeat. 
> The driver should inject a release code itself if there is no release/repeat 
> code in 500ms after initial press or in 120ms after a repeat code.
> 
> - No release code is sent for 0x02XXXXXX keys if pressing any other button 
> before release, examples:
> 
> example 1:
> hold '5', then press 'Play' once, then release '5'
> The 'Play' codes are relayed properly, but the release code for '5' (the 'all 
> 0x02XXXXXX keys released' (i.e. empty HID input report) which the hardware 
> does send properly) is wrongly interpreted as a release code for 'Play'.
> The driver should either release '5' when the empty report is received, or, as 
> this is just a remote control, just inject a release code for '5' when 'Play' 
> is pressed.
> 
> example 2:
> hold '5', then hold '4', then release '5', then release '4'
> As the 0x02XXXXXX range is not completely released until after '4' is 
> released, the zeroed bitfield is not sent until after '4', and the driver 
> doesn't release '5' at this point anymore. The driver should've injected a 
> release code for '5' when '4' was pressed.
> 
> - imon_mce_timeout() timer function seems to access ictx->last_keycode without 
> locking
> 
> - imon_parse_press_type() tests for ictx->release_code which is in an 
> undefined state if ktype isn't IMON_KEY_IMON
> 
> - when the dpad is in keyboard mode and you hold it down to one direction, 
> instead of autorepeat there is a constant stream of release/press events
> 
> 
> I may get around to fix these (if I find time and an MCE remote for testing), 
> but that won't probably happen soon, thus I'm reporting these here if someone 
> else wants to fix them.

-- 
Jarod Wilson
jarod@redhat.com

