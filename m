Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55001 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZK1Poi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 10:44:38 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 	system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	<4B104971.4020800@s5r6.in-berlin.de>
	<1259370501.11155.14.camel@maxim-laptop>
	<m37hta28w9.fsf@intrepid.localdomain>
	<1259419368.18747.0.camel@maxim-laptop>
	<m3zl66y8mo.fsf@intrepid.localdomain>
	<1259422559.18747.6.camel@maxim-laptop>
Date: Sat, 28 Nov 2009 16:44:41 +0100
In-Reply-To: <1259422559.18747.6.camel@maxim-laptop> (Maxim Levitsky's message
	of "Sat, 28 Nov 2009 17:35:59 +0200")
Message-ID: <m3r5riy7py.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxim Levitsky <maximlevitsky@gmail.com> writes:

> Generic decoder that lirc has is actually much better and more tolerant
> that protocol specific decoders that you propose,

Actually, it is not the case. Why do you think it's better (let alone
"much better")? Have you at least seen my RC5 decoder?

> You claim you 'fix' the decoder, right?

Sure.

> But what about all these lirc userspace drivers?

Nothing. They are not relevant and obviously have to use lircd.
If you can have userspace driver, you can have lircd as well.

> How they are supposed to use that 'fixed' decoder.

They are not.

Is it a problem for you?
How is your keyboard supposed to use scanner driver?
-- 
Krzysztof Halasa
