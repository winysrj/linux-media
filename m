Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55366 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbZLHOG2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 09:06:28 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>
	<4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>
	<A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
	<4B17AA6A.9060702@redhat.com>
	<20091203175531.GB776@core.coreip.homeip.net>
	<20091203163328.613699e5@pedra>
	<20091204100642.GD22570@core.coreip.homeip.net>
	<20091204121234.5144836b@pedra>
	<20091206070929.GB14651@core.coreip.homeip.net>
	<4B1B8F83.5080009@redhat.com> <m31vj77t51.fsf@intrepid.localdomain>
	<4B1D9714.5060000@redhat.com>
Date: Tue, 08 Dec 2009 15:06:31 +0100
In-Reply-To: <4B1D9714.5060000@redhat.com> (Mauro Carvalho Chehab's message of
	"Mon, 07 Dec 2009 22:00:20 -0200")
Message-ID: <m3zl5ttva0.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Yes, an opaque type for scancode at the userspace API can be better, but
> passing a pointer to kernel will require some compat32 logic (as pointer
> size is different on 32 and 64 bits).

Yes. I think we can't avoid that, but it's a single compat handler,
I wouldn't worry about it too much. We don't need it in every driver
fortunately.

> We may use something like an u8[] with an arbitrary large number of
> bytes.

Yes. All of this pointed to by the pointer.

> In this case, we need to take some care to avoid LSB/MSB troubles.

Sure.
-- 
Krzysztof Halasa
