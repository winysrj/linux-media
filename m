Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:58579 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbZKWUlH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 15:41:07 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
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
	<4B0AC65C.806@redhat.com>
Date: Mon, 23 Nov 2009 21:41:11 +0100
In-Reply-To: <4B0AC65C.806@redhat.com> (Mauro Carvalho Chehab's message of
	"Mon, 23 Nov 2009 15:29:00 -0200")
Message-ID: <m3zl6dq8ig.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> If you see patch 3/3, of the lirc submission series, you'll notice a driver
> that has hardware decoding, but, due to lirc interface, the driver generates
> pseudo pulse/space code for it to work via lirc interface.

IOW the driver generates artificial pulse code for lircd?
I think - pure bloat. lircd can get events from input layer without
problems. Perhaps I misunderstood?

> It is very bad to have two interfaces for the same thing, because people
> may do things like that.

I think having a "raw" scan code interface + the key code "cooked" mode
is beneficial. For remotes lacking the raw interface only the latter
could be used.

> Also, there are some cases where the same V4L driver can receive IR scancodes
> directly for one board, while for others, it needs to get pulse/space
> decoding.

Sure.

> This is an interesting discussion. We currently have lots of such tables in
> kernel, but it can be a good idea to have it loaded by udev during
> boot time.

Sure.

> Are you meaning that we should do more than one RC per input event
> interface?

I think so. Why not?

For example, one of my remotes generates codes from at least two RC5
groups (in only one "mode"). Currently a remote is limited to only one
RC5 group.

I think the mapping should be: key = proto + group + raw code, while
key2 could be different_proto + different group (if any) + another code.

> If so, why do you think we need to handle more than one IR protocol at
> the same time?

Why not?
There are X-in-1 remotes on the market for years. They can "speak" many
protocols at once. One may want to have a protocol to handle DVD apps
while another for DVB etc.
And someone may want to use several different remotes, why not?
Personally I use two different remotes (both set to speak RC5 but what
if I couldn't set the protocol?). Sure, it requires a bit of hackery
(not with pulse code and lircd).

> I think this will just make the driver more complex without need.

Not much more, and there is a need.
-- 
Krzysztof Halasa
