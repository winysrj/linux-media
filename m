Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:42446 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZLCRrn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 12:47:43 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, jonsmirl@gmail.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>
	<4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>
Date: Thu, 03 Dec 2009 18:47:46 +0100
In-Reply-To: <4B153617.8070608@redhat.com> (Gerd Hoffmann's message of "Tue,
	01 Dec 2009 16:28:23 +0100")
Message-ID: <m3fx7s2blp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann <kraxel@redhat.com> writes:

> I'd pick a more descriptive name like 'bundled_remote'.
> Maybe an additional attribute could say which protocol the bundled
> remote speaks (rc5, ...), so userspace could do something sensible by
> default even if it has no data about the bundled remote.

This is problematic since there can be more that one remote bundled.
If we export the sensor (tuner etc) name, userspace can make some
decision (or ask the user etc).

The protocol alone won't help - the user will have to teach the system
about the remote anyway. This should be made trivial at least for common
protocols, though.

> Name them by the hardware they are bundled with should work reasonable
> well.

I guess udev can look at parent PCI vendor/device and subsystem
vendor/device for most PCI cases. Ditto with USB. For generic stuff like
TSOP* coupled with a resistor and connected to RS232 port, we can't
guess anyway.

> We also could also provide a list of possible remotes directly via
> sysfs

The kernel has no way to _know_ this information. The policy is better
handled in userland.

>> Anyway, we shouldn't postpone lirc drivers addition due to that.

Actually merging lirc is a prerequisite for a number of changes.
-- 
Krzysztof Halasa
