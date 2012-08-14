Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58732 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2HNXvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 19:51:47 -0400
Received: by lbbgj3 with SMTP id gj3so565590lbb.19
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 16:51:46 -0700 (PDT)
Message-ID: <502AE483.6000001@iki.fi>
Date: Wed, 15 Aug 2012 02:51:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: linux-media@vger.kernel.org
Subject: Re: small regression in mediatree/for_v3.7-3 - media_build
References: <1344987576.21425.YahooMailClassic@web29406.mail.ird.yahoo.com>
In-Reply-To: <1344987576.21425.YahooMailClassic@web29406.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2012 02:39 AM, Hin-Tak Leung wrote:
> There seems to be a small regression on mediatree/for_v3.7-3
> - dmesg/klog get flooded with these:
>
> [201145.140260] dvb_frontend_poll: 15 callbacks suppressed
> [201145.586405] usb_urb_complete: 88 callbacks suppressed
> [201150.587308] usb_urb_complete: 3456 callbacks suppressed
>
> [201468.630197] usb_urb_complete: 3315 callbacks suppressed
> [201473.632978] usb_urb_complete: 3529 callbacks suppressed
> [201478.635400] usb_urb_complete: 3574 callbacks suppressed
>
> It seems to be every 5 seconds, but I think that's just klog skipping repeats and collapsing duplicate entries. This does not happen the last time I tried playing with the TV stick :-).

That's because you has dynamic debugs enabled!
modprobe dvb_core; echo -n 'module dvb_core +p' > 
/sys/kernel/debug/dynamic_debug/control
modprobe dvb_usbv2; echo -n 'module dvb_usbv2 +p' > 
/sys/kernel/debug/dynamic_debug/control

If you don't add dvb_core and dvb_usbv2 modules to 
/sys/kernel/debug/dynamic_debug/control you will not see those.

I have added ratelimited version for those few debugs that are flooded 
normally. This suppressed is coming from ratelimit - it does not print 
all those similar debugs.

regards
Antti

-- 
http://palosaari.fi/
