Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.ird.yahoo.com ([77.238.189.193]:43431 "HELO
	nm14-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752843Ab2HOAor convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 20:44:47 -0400
Message-ID: <1344991485.62541.YahooMailClassic@web29404.mail.ird.yahoo.com>
Date: Wed, 15 Aug 2012 01:44:45 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: small regression in mediatree/for_v3.7-3 - media_build
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <502AE483.6000001@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Wed, 15/8/12, Antti Palosaari <crope@iki.fi> wrote:

> On 08/15/2012 02:39 AM, Hin-Tak Leung
> wrote:
> > There seems to be a small regression on
> mediatree/for_v3.7-3
> > - dmesg/klog get flooded with these:
> > 
> > [201145.140260] dvb_frontend_poll: 15 callbacks
> suppressed
> > [201145.586405] usb_urb_complete: 88 callbacks
> suppressed
> > [201150.587308] usb_urb_complete: 3456 callbacks
> suppressed
> > 
> > [201468.630197] usb_urb_complete: 3315 callbacks
> suppressed
> > [201473.632978] usb_urb_complete: 3529 callbacks
> suppressed
> > [201478.635400] usb_urb_complete: 3574 callbacks
> suppressed
> > 
> > It seems to be every 5 seconds, but I think that's just
> klog skipping repeats and collapsing duplicate entries. This
> does not happen the last time I tried playing with the TV
> stick :-).
> 
> That's because you has dynamic debugs enabled!
> modprobe dvb_core; echo -n 'module dvb_core +p' >
> /sys/kernel/debug/dynamic_debug/control
> modprobe dvb_usbv2; echo -n 'module dvb_usbv2 +p' >
> /sys/kernel/debug/dynamic_debug/control
> 
> If you don't add dvb_core and dvb_usbv2 modules to
> /sys/kernel/debug/dynamic_debug/control you will not see
> those.
> 
> I have added ratelimited version for those few debugs that
> are flooded normally. This suppressed is coming from
> ratelimit - it does not print all those similar debugs.

I did not enable it - it is as shipped :-).

# grep 'CONFIG_DYNAMIC' /boot/config*
/boot/config-3.4.6-2.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
/boot/config-3.4.6-2.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
/boot/config-3.5.0-2.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
/boot/config-3.5.0-2.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
/boot/config-3.5.1-1.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
/boot/config-3.5.1-1.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y

Now I wonder why I didn't have those usb_urb_complete messages before? The last time I played with mediatree was with 3.4.4-5.fc17.x86_64, and with the mediatree2/dvb_core branch - and I did not have these then.

