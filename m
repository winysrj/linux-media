Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33695 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZKZXpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 18:45:16 -0500
Date: Thu, 26 Nov 2009 15:45:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126234517.GF6936@core.coreip.homeip.net>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain> <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com> <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com> <4B0DA885.7010601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0DA885.7010601@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 25, 2009 at 10:58:29PM +0100, Gerd Hoffmann wrote:
>
> (1) ir code (say rc5) -> keycode conversion looses information.
>
> I think this can easily be addressed by adding a IR event type to the  
> input layer, which could look like this:
>
>   input_event->type  = EV_IR
>   input_event->code  = IR_RC5
>   input_event->value = <rc5 value>
>
> In case the 32bit value is too small we might want send two events  
> instead, with ->code being set to IR_<code>_1 and IR_<code>_2
>
> Advantages:
>   * Applications (including lircd) can get access to the unmodified
>     rc5/rc6/... codes.
>   * All the ir-code -> keycode mapping magic can be handled by the
>     core input layer then.  All the driver needs to do is to pass on
>     the information which keymap should be loaded by default (for the
>     bundled remote if any).  The configuration can happen in userspace
>     (sysfs attribute + udev + small utility in tools/ir/).
>   * lirc drivers which get ir codes from the hardware can be converted
>     to pure input layer drivers without regressions.  lircd is not
>     required any more.
>

I think we need to separate 2 kinds of applications since they have
different requirements as far as interface goes:

1. "Reguilar" user-space applications interested in receiving keystrokes
from user and reacting to them. Movie players, CD players, MythTV-like
applications and so on. Those, to my understanding, are not concerned
with the fine details of RC5, RC6, NEC and so forth protocol decoding
and just want to know when to start playing, when to stop and when to
revind. That class of applications is best served by current input layer
since it unifies data coming from IR, keyboards, button devices and so
forth.

2. "System" applications that are interested in protocol decoding. Those
need interface best suited for IR and nothing else. This protocol is
appears is better kept separate from the evdev input protocol. In case
where we rely solely on such userspace application(s) to perform protocol
decoding we should route input events back to kernel through uinput for
consumption by "class 1" applications.


We use this approach for PS/2 (serio allows binding either psmouse/atkbd
or serio_raw to provide alternate interfaces depending on the users
need), USB hid allows raw access as well, maybe we should follow the
suit here.

-- 
Dmitry
