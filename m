Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:57801 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZK1LUT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 06:20:19 -0500
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
Date: Sat, 28 Nov 2009 12:20:22 +0100
In-Reply-To: <1259370501.11155.14.camel@maxim-laptop> (Maxim Levitsky's
	message of "Sat, 28 Nov 2009 03:08:21 +0200")
Message-ID: <m37hta28w9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxim Levitsky <maximlevitsky@gmail.com> writes:

> If we add in-kernel decoding, we still will end up with two different
> decoding, one in kernel and one in lirc.

And that's good. Especially for a popular and simple protocol such as
RC5.
Actually, it's not about adding the decoder. It's about fixing it.
I can fix it.
-- 
Krzysztof Halasa
