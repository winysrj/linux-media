Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56706 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZKWRFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <829197380911230720k233c3c86t659180d1413aa0dd@mail.gmail.com>
References: <200910200956.33391.jarod@redhat.com>
	 <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	 <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	 <829197380911230720k233c3c86t659180d1413aa0dd@mail.gmail.com>
Date: Mon, 23 Nov 2009 17:05:53 +0000
Message-ID: <abc933c50911230905g60e2071bpbee9318817d56fb5@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: James Mastros <james@mastros.biz>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/23 Devin Heitmueller <dheitmueller@kernellabs.com>:
> Just bear in mind that with the current in-kernel code, users do *not
> * have to manually select the RC code to use if they are using the
> default remote that shipped with the product.
This could still happen, if LIRC checks the identifiers of the
reciving device, and has a database that tells it mappings between
those devices and the remote controls that shipped with them.
However, it occours to me that the IR circumstances map pretty well to
what happens with ps/2 and serial devices now:

1: There are a variety of drivers for serio computer-side hardware,
each of which speaks the serio interface to the next-higher level.
These corrospond to the drivers for IR recievers.
2: There's a raw serio interface, for those wishing to do strange things.
3: There's also a variety of things that take data, using the kernel
serio API, and decode it into input events -- the ps2 keyboard driver,
the basic mouse driver, the advanced mice drivers.  This is where the
interface falls down a little bit -- the ps2 keyboard driver is the
closest analogue to what I'm suggesting.  The ps2 keyboard driver
creates scancode events, which map nicely to what the keyboard is
sending -- these are, for ex, rc5 codes.  It will also produce
key-up/key-down events, if it has a keymap loaded.  (This is the
difference with a ps2 keyboard -- a ps2 keyboard gets a map assigned
to it at boottime, so it works out-of-box.  This isn't really possible
with an IR remote -- though perhaps rc5 is standarized enough, I don't
think other protocols neccessarly are.)

Userspace would have to load a keymap; those don't really belong in
kernel code.  Of course, userspace could look at the device
identifiers to pick a reasonable default keymap if it's not configured
to load another, solving the out-of-box experince.

    -=- James Mastros
