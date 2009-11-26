Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56635 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701AbZKZQl0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 11:41:26 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dheitmueller@kernellabs.com, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDZbPXRZjFB@christoph> <4B0DBC2D.1010603@redhat.com>
Date: Thu, 26 Nov 2009 17:41:28 +0100
In-Reply-To: <4B0DBC2D.1010603@redhat.com> (Gerd Hoffmann's message of "Thu,
	26 Nov 2009 00:22:21 +0100")
Message-ID: <m38wdtw85j.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann <kraxel@redhat.com> writes:

> Why not?  With RC5 remotes applications can get the device address
> bits for example, which right now are simply get lost in the ir code
> -> 
> keycode conversion step.

Right, this in fact makes the input layer interface unusable for many
remotes at this time.
I think the address (aka group) should be just a part of the key
("command") code, IIRC this is what lirc RC5 does (I'm presently using
a custom "media" version of RC5).

> I know that lircd does matching instead of decoding, which allows to
> handle unknown encodings.  Thats why I think there will always be
> cases which only lircd will be able to handle (using raw samples).
>
> That doesn't make attempts to actually decode the IR samples a useless
> exercise though ;)

Sure. Especially RC5-like protos are simple to decode, and it's very
reliable, even with a very unstable remote clock source (such as
RC-based = resistor + capacitor).
-- 
Krzysztof Halasa
