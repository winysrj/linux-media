Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:34672 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761AbZKYRSe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 12:18:34 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: IR raw input is not sutable for input system
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<20091123173726.GE17813@core.coreip.homeip.net>
	<4B0B6321.3050001@wilsonet.com>
	<1259105571.28219.20.camel@maxim-laptop>
	<Pine.LNX.4.58.0911241918390.30284@shell2.speakeasy.net>
Date: Wed, 25 Nov 2009 18:18:38 +0100
In-Reply-To: <Pine.LNX.4.58.0911241918390.30284@shell2.speakeasy.net> (Trent
	Piepho's message of "Tue, 24 Nov 2009 19:32:42 -0800 (PST)")
Message-ID: <m34ooi7cb5.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho <xyzzy@speakeasy.org> writes:

> The signal recevied by the ir receiver contains glitches.  Depending on the
> receiver there can be quite a few.  It is also not trivial to turn the raw
> signal sent by the remote into a digital value, even if you know what to
> expect.  It takes digital signal processing techniques to turn the messy
> sequence of inaccurate mark and space lengths into a best guess at what
> digital code the remote sent.

This is of course true. Except that most receivers do that in hardware,
the receiver/demodular chip such as TSOP1838 does it.
If you receive with a phototransistor or a photodiode feeding some sort
of ADC device (not a very smart design), sure - you have to do this
yourself.

I have never heard of such receiver, though.

> One thing that could be done, unless it has changed much since I wrote it
> 10+ years ago, is to take the mark/space protocol the ir device uses and sent
> that data to lircd via the input layer.  It would be less efficient, but
> would avoid another kernel interface.  Of course the input layer to lircd
> interface would be somewhat different than other input devices, so
> it's not entirely correct to say another interface is avoided.

IOW, it would be worse, wouldn't it?
-- 
Krzysztof Halasa
