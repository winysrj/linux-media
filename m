Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:33185 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZKZW7p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 17:59:45 -0500
Date: Thu, 26 Nov 2009 14:59:50 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
In-Reply-To: <4B0ED238.6060306@redhat.com>
Message-ID: <Pine.LNX.4.58.0911261450590.30284@shell2.speakeasy.net>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com>
 <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com>
 <m36391tjj3.fsf@intrepid.localdomain> <4B0AC65C.806@redhat.com>
 <m3zl6dq8ig.fsf@intrepid.localdomain> <4B0E765C.2080806@redhat.com>
 <m3iqcxuotd.fsf@intrepid.localdomain> <4B0ED238.6060306@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Nov 2009, Mauro Carvalho Chehab wrote:
> >> See above. Also, several protocols have a way to check if a keystroke were
> >> properly received. When handling just one protocol, we can use this to double
> >> check the key. However, on a multiprotocol mode, we'll need to disable this
> >> feature.
> >
> > I don't think so. We can pass the space/mark data to all (configured,
> > i.e. with active mapping) protocol handlers at once. Should a check
> > fail, we ignore the data. Perhaps another protocol will make some sense
> > out of it.
>
> What happens if it succeeds on two protocol handlers?

Then you use the protocol that fits best.  For instance decoding with one
protocol might produce a scancode that isn't assigned to any key, while
another protocol produces an assigned scancode.  Clearly then the latter is
most likely to be correct.  It also possible to have a space/mark length
that is within the allowable tolerances for one remote, but is even closer
another remote.  You don't want to just find *a* match, you want to find
the *best* match.

The in kernel code in v4l is very simple in that it is only designed to
work with one procotol and one remote.  Once you have multiple remotes of
any type things become much more complicted.  Keep in mind that remotes
that aren't even intended to be used with the computer but are used in the
same room will still be received by the receiver.  It's not enough to
decode the signals you expect to receive, you must also not get confused by
random signals destined for somewhere else.
