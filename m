Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:38373 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752911AbeDURlZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 13:41:25 -0400
Date: Sat, 21 Apr 2018 19:41:21 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v2 7/7] media: rc: mceusb: allow the timeout to be
 configurable
Message-ID: <20180421174121.xcztgoaw2pspj3zv@camel2.lan>
References: <cover.1523221902.git.sean@mess.org>
 <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
 <20180417191457.fhgsdega2kjqw3t2@camel2.lan>
 <20180418112428.zk3lmdxoqv46weph@gofer.mess.org>
 <20180418174229.jurjnyqbtkyctjvb@camel2.lan>
 <20180419221723.s6kx7nip6ue2d43o@camel2.lan>
 <20180421131852.2zrn7qp3ir4kyqvf@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180421131852.2zrn7qp3ir4kyqvf@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 21, 2018 at 03:18:52PM +0200, Matthias Reichl wrote:
> Hi Sean,
> 
> On Fri, Apr 20, 2018 at 12:17:23AM +0200, Matthias Reichl wrote:
> > One of the affected users reported back that the fix worked fine!
> > 
> > I'm keeping an eye on further reports but so far I'd say everything's
> > working really well.
> 
> Another bug report came in, button press results in multiple
> key down/up events
> https://forum.kodi.tv/showthread.php?tid=298461&pid=2727837#pid2727837
> (and following posts).
> 
> ir-ctl -r output looks fine to me, but ir-keytable -t output suggests
> we'll need a margin between raw timeout and key up timeout:
> 
> https://pastebin.com/6RTSGXvp
> 2199.824106: event type EV_MSC(0x04): scancode = 0x800f0419
> 2199.824106: event type EV_KEY(0x01) key_down: KEY_STOP(0x0080)
> 2199.824106: event type EV_SYN(0x00).
> 2199.887081: event type EV_KEY(0x01) key_up: KEY_STOP(0x0080)
> 2199.887081: event type EV_MSC(0x04): scancode = 0x800f0422
> 2199.887081: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
> 2199.887081: event type EV_SYN(0x00).
> 2200.029804: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
> 2200.029804: event type EV_SYN(0x00).

Sorry, just noticed I snipped off the interesting part, here
is the rest:

2200.036070: event type EV_MSC(0x04): scancode = 0x800f0422
2200.036070: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
2200.036070: event type EV_SYN(0x00).
2200.143067: event type EV_MSC(0x04): scancode = 0x800f0422
2200.143067: event type EV_SYN(0x00).
2200.206061: event type EV_MSC(0x04): scancode = 0x800f0422
2200.206061: event type EV_SYN(0x00).
2200.346472: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
2200.346472: event type EV_SYN(0x00).

I looked at the log again, and now it doesn't make much sense
to me.

I'm not exactly sure what happened with the first KEY_OK
scancode, that seems to have been decoded ~60ms after the
KEY_STOP scancode (.887 vs .824).

The second KEY_OK scancode was decoded ~ 150ms after the first,
(and caused the problem), delay to third is 107ms, to fourth 63ms.

I'll ask the user to change batteries on the remote and check
if the reception is OK, could be that this was a false alarm.

Adding some margin (maybe 20-50ms) for keyup could still make
sense though, as currently we have basically just the timeout
as margin, which can be quite low and round to 1-2 jiffies.

so long,

Hias
