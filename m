Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:41892 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZKWRM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:12:26 -0500
MIME-Version: 1.0
In-Reply-To: <abc933c50911230905g60e2071bpbee9318817d56fb5@mail.gmail.com>
References: <200910200956.33391.jarod@redhat.com>
	 <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	 <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	 <829197380911230720k233c3c86t659180d1413aa0dd@mail.gmail.com>
	 <abc933c50911230905g60e2071bpbee9318817d56fb5@mail.gmail.com>
Date: Mon, 23 Nov 2009 12:12:30 -0500
Message-ID: <829197380911230912i53d57dc2h10a5c31c79c9f1c@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James Mastros <james@mastros.biz>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 12:05 PM, James Mastros <james@mastros.biz> wrote:
> 2009/11/23 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> Just bear in mind that with the current in-kernel code, users do *not
>> * have to manually select the RC code to use if they are using the
>> default remote that shipped with the product.
> This could still happen, if LIRC checks the identifiers of the
> reciving device, and has a database that tells it mappings between
> those devices and the remote controls that shipped with them.
> However, it occours to me that the IR circumstances map pretty well to
> what happens with ps/2 and serial devices now:
>
> 1: There are a variety of drivers for serio computer-side hardware,
> each of which speaks the serio interface to the next-higher level.
> These corrospond to the drivers for IR recievers.
> 2: There's a raw serio interface, for those wishing to do strange things.
> 3: There's also a variety of things that take data, using the kernel
> serio API, and decode it into input events -- the ps2 keyboard driver,
> the basic mouse driver, the advanced mice drivers.  This is where the
> interface falls down a little bit -- the ps2 keyboard driver is the
> closest analogue to what I'm suggesting.  The ps2 keyboard driver
> creates scancode events, which map nicely to what the keyboard is
> sending -- these are, for ex, rc5 codes.  It will also produce
> key-up/key-down events, if it has a keymap loaded.  (This is the
> difference with a ps2 keyboard -- a ps2 keyboard gets a map assigned
> to it at boottime, so it works out-of-box.  This isn't really possible
> with an IR remote -- though perhaps rc5 is standarized enough, I don't
> think other protocols neccessarly are.)
>
> Userspace would have to load a keymap; those don't really belong in
> kernel code.  Of course, userspace could look at the device
> identifiers to pick a reasonable default keymap if it's not configured
> to load another, solving the out-of-box experince.

I think perhaps before we go much further into this, we may wish to
come up with a set of use cases and expected behavior.  I worry that
part of the problem here is people are thinking of how their
particular cards behave, and few people have a holistic picture of all
the possible scenarios.  Whatever implementation we come up, we should
be confident that it meets the requirements of *all* the various
hardware implementations.

I will try to draft up some requirements/use cases if people think
this would be worthwhile.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
