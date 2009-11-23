Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:38182 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZKWVqk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 16:46:40 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: lirc@bartelmus.de (Christoph Bartelmus)
Cc: dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>
Date: Mon, 23 Nov 2009 22:46:43 +0100
In-Reply-To: <BDRae8rZjFB@christoph> (Christoph Bartelmus's message of "23 Nov
	2009 22:11:00 +0100")
Message-ID: <m3einork1o.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc@bartelmus.de (Christoph Bartelmus) writes:

>> I think we shouldn't at this time worry about IR transmitters.
>
> Sorry, but I have to disagree strongly.
> Any interface without transmitter support would be absolutely unacceptable
> for many LIRC users, including myself.

I don't say don't use a transmitter.
I say the transmitter is not an input device, they are completely
independent functions. I can't see any reason to try and fit both in the
same interface - can you?
-- 
Krzysztof Halasa
