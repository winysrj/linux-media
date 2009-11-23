Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:51766 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZKWUqz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 15:46:55 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jarod Wilson <jarod@wilsonet.com>
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
	<4B0AC65C.806@redhat.com>
	<BDC6A41E-67C0-4952-94E9-D405C7209394@wilsonet.com>
Date: Mon, 23 Nov 2009 21:46:58 +0100
In-Reply-To: <BDC6A41E-67C0-4952-94E9-D405C7209394@wilsonet.com> (Jarod
	Wilson's message of "Mon, 23 Nov 2009 14:17:29 -0500")
Message-ID: <m3vdh1q88t.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson <jarod@wilsonet.com> writes:

> There are quite a few available IR options that are NOT tied to a
> video capture device at all -- the mceusb and imon drivers submitted
> in my patch series are actually two such beasts.

Precisely. This also includes the parallel and serial port receivers,
I'm under impression that they are, or at least were, the most common,
due to their extreme simplicity.

> And particularly with the mceusb receivers, because they support damn
> near every IR protocol under the sun at any carrier frequency, using a
> remote other than the bundled one is quite common. Most people's set
> top boxes and/or televisions and/or AV receivers come with a remote
> capable of controlling multiple devices, and many bundled remotes are,
> quite frankly, utter garbage.

This is precisely also my experience.
-- 
Krzysztof Halasa
