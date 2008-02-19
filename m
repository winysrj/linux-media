Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JRZo7-00073V-47
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 22:15:19 +0100
Date: Tue, 19 Feb 2008 22:14:34 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Filippo Argiolas <filippo.argiolas@gmail.com>
In-Reply-To: <1203434275.6870.25.camel@tux>
Message-ID: <Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
 receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

That indeed looks OK to my eyes. I have to admit that I never took a look 
into the IR-code from DiBcom...

In any case, especially to that problem with "unknown key code" I think it 
is time to change the IR-behavior of the DVB-USB.

My problem is, I don't know how.

My naive idea would be, that the IR-code is reporting each key (as raw as 
possible) without mapping it to an event to the event interface and then 
someone, somewhere is interpreting it. Also forward any repeat-attribute.

Those endless tables in a lot of dvb-usb drivers are annoying me, firstly 
because they are endless and huge, and secondly, they are never complete. 
If there is an adequate replacement from userspace (somehow loading 
key-lists to the event-layer or in the worst case, to the 
dvb-usb-framework) would be a good solution.

Filippo, it seems you understand quite some thing around that. Do you know 
if what I'm saying is somehow possible?

Thanks,
Patrick.



On Tue, 19 Feb 2008, Filippo Argiolas wrote:

> Hi, my last messages have been almost ignored.. so I'm opening a new
> thread. Please refer to the other thread [wintv nova-t stick, dib0700
> and remote controllers] for more info.
>
> Here is a brief summary of the problem as far as I can understand:
> - when a keypress event is received the device stores its data somewhere
> - every 150ms dib0700_rc_query reads this data
> - since there is nothing that resets device memory if no key is being
> pressed anymore device still stores the data from the last keypress
> event
> - to prevent having false keypresses the driver reads rc5 toggle bit
> that changes from 0 to 1 and viceversa when a new key is pressed or when
> the same key is released and pressed again. So it ignores everything
> until the toggle bit changes. The right behavior should be "repeat last
> key until toggle bit changes", but cannot be done since last data still
> stored would be considered as a repeat even if nothing is pressed.
> - this way it ignores even repeated key events (when a key is holded
> down)
> - this approach is wrong because it works just for rc5 (losing repeat
> feature..) but doesn't work for example with nec remotes that don't set
> the toggle bit and use a different system.
>
> The patch solves it calling dib0700_rc_setup after each poll resetting
> last key data from the device. I've also implemented repeated key
> feature (with repeat delay to avoid unwanted double hits) for rc-5 and
> nec protocols. It also contains some keymap for the remotes I've used
> for testing (a philipps compatible rc5 remote and a teac nec remote).
> They are far from being complete since I've used them just for testing.
>
> Thanks for reading this,
> Let me know what do you think about it,
> Greets,
>
> Filippo
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
