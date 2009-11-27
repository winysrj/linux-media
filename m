Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:44686 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZK0ApO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 19:45:14 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>
	<4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain>
	<4B0ED238.6060306@redhat.com>
	<Pine.LNX.4.58.0911261450590.30284@shell2.speakeasy.net>
Date: Fri, 27 Nov 2009 01:45:14 +0100
In-Reply-To: <Pine.LNX.4.58.0911261450590.30284@shell2.speakeasy.net> (Trent
	Piepho's message of "Thu, 26 Nov 2009 14:59:50 -0800 (PST)")
Message-ID: <m3vdgwre1x.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho <xyzzy@speakeasy.org> writes:

> Then you use the protocol that fits best.  For instance decoding with one
> protocol might produce a scancode that isn't assigned to any key, while
> another protocol produces an assigned scancode.  Clearly then the latter is
> most likely to be correct.

Right.

> It also possible to have a space/mark length
> that is within the allowable tolerances for one remote, but is even closer
> another remote.  You don't want to just find *a* match, you want to find
> the *best* match.

That won't work, the decoders don't calculate quality. And even if they
did, if you have two remotes generating the same e.g. RC5 code, you
won't be able to differentiate between them. Your TV etc. won't do that
either.

> The in kernel code in v4l is very simple in that it is only designed to
> work with one procotol and one remote.  Once you have multiple remotes of
> any type things become much more complicted.

If you're using them at once, sure :-)

> Keep in mind that remotes
> that aren't even intended to be used with the computer but are used in the
> same room will still be received by the receiver.  It's not enough to
> decode the signals you expect to receive, you must also not get confused by
> random signals destined for somewhere else.

This is usually not a problem. My experience is the decoding is very
reliable.
-- 
Krzysztof Halasa
