Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:51369 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbZKWUOF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 15:14:05 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: James Mastros <james@mastros.biz>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
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
	<829197380911230720k233c3c86t659180d1413aa0dd@mail.gmail.com>
	<abc933c50911230905g60e2071bpbee9318817d56fb5@mail.gmail.com>
	<4B0ACB70.9090707@redhat.com>
Date: Mon, 23 Nov 2009 21:14:08 +0100
In-Reply-To: <4B0ACB70.9090707@redhat.com> (Mauro Carvalho Chehab's message of
	"Mon, 23 Nov 2009 15:50:40 -0200")
Message-ID: <m38wdxrobz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> True, but this means that everyone with an IR will need to use lirc.

I think that if the input layer (instead of raw code) is used, a utility
which only sets the mapping(s) would suffice. I.e. no daemon.

> /me thinks that, whatever decided with those lirc drivers, this should
> be applied also to the existing V4L/DVB drivers.

Certainly.

> IMO, it would be better to load the tables at the boot time (or at the
> corresponding hotplug event, for USB devices).

Sure (unless the "raw code" interface is in use).

Though maybe the raw code interface should be done in a simple library
instead of requiring the daemon.
-- 
Krzysztof Halasa
