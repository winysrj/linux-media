Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JUK67-0002Px-Gb
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 12:05:15 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id 5C4B2D88124
	for <linux-dvb@linuxtv.org>; Wed, 27 Feb 2008 12:04:18 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1203434275.6870.25.camel@tux>
References: <1203434275.6870.25.camel@tux>
Date: Wed, 27 Feb 2008 11:04:27 +0000
Message-Id: <1204110267.6712.17.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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


On Tue, 2008-02-19 at 16:17 +0100, Filippo Argiolas wrote:
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

Hi all,

I believe that we could we agree that this patch
      * does not break anything,
      * does what it says it should do,
      * works fine,
      * is coded properly wrt the v4l-dvb guideline,
      * got enough feedback.

Could the powers that be merge it?

Many thanks.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
