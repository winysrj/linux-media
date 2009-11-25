Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:52066 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459AbZKYUtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 15:49:23 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ?
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	<E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
	<829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
	<E88E119C-BB86-4F01-8C2C-E514AC6BA5E2@wilsonet.com>
Date: Wed, 25 Nov 2009 21:49:28 +0100
In-Reply-To: <E88E119C-BB86-4F01-8C2C-E514AC6BA5E2@wilsonet.com> (Jarod
	Wilson's message of "Wed, 25 Nov 2009 13:43:24 -0500")
Message-ID: <m3skc249ev.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson <jarod@wilsonet.com> writes:

> Well, we've got a number of IOCTLs already, could extend those.
> (Although its been suggested elsewhere that we replace the IOCTLs with
> sysfs knobs).

Not sure if sysfs would be fast enough.

> A simple sysfs attr that contains the name of the default config file
> for the bundled remote of a given receiver would seem simple enough to
> implement.

A model name maybe. Though there is this mapping thing which I think
need ioctl().
-- 
Krzysztof Halasa
