Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:41836 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZKWUJd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 15:09:33 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: James Mastros <james@mastros.biz>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:  Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<829197380911230720k233c3c86t659180d1413aa0dd@mail.gmail.com>
	<abc933c50911230853o1caab007te9ac07dbbbd6e191@mail.gmail.com>
Date: Mon, 23 Nov 2009 21:09:36 +0100
In-Reply-To: <abc933c50911230853o1caab007te9ac07dbbbd6e191@mail.gmail.com>
	(James Mastros's message of "Mon, 23 Nov 2009 16:53:00 +0000")
Message-ID: <m3d439rojj.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James Mastros <james@mastros.biz> writes:

> (This is the
> difference with a ps2 keyboard -- a ps2 keyboard gets a map assigned
> to it at boottime, so it works out-of-box.  This isn't really possible
> with an IR remote -- though perhaps rc5 is standarized enough, I don't
> think other protocols neccessarly are.)

Even with RC5 this isn't really possible. RC5 specifies several classes
of remotes, and with a typical HTPC scenario the sensor will pick up
more than one remote codeset - e.g. one for the display, one for TV
card, and maybe others (all those codes may be coming from a single
remote). We have no way to know in advance which one code set is for the
PC.

The only thing which we can "preconfigure" is the remote bundled with
the sensor (card etc). And even this can be incorrect. Several sensors
don't came with a remote controller.

I think the default sensor->remote assignment may only make sense in
userspace, while configuring the mapping.


Of course all the above changes when the sensors can't present the
"raw" data (IR on/off) but does all the decoding internally (and for
example can't decode all RC5 but only keys used on its remote). In such
unfortunate cases it has to go to the input layer directly.

> Userspace would have to load a keymap; those don't really belong in
> kernel code.  Of course, userspace could look at the device
> identifiers to pick a reasonable default keymap if it's not configured
> to load another, solving the out-of-box experince.

Precisely.
-- 
Krzysztof Halasa
