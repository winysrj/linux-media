Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:33120 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbZKWWxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 17:53:05 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:  Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <m3einork1o.fsf@intrepid.localdomain>
	<829197380911231354y764e01b7hc0c5721b3ebf1f26@mail.gmail.com>
	<m36390rhzp.fsf@intrepid.localdomain>
	<829197380911231437v909a111rcc2967af3e4fffa2@mail.gmail.com>
Date: Mon, 23 Nov 2009 23:53:08 +0100
In-Reply-To: <829197380911231437v909a111rcc2967af3e4fffa2@mail.gmail.com>
	(Devin Heitmueller's message of "Mon, 23 Nov 2009 17:37:00 -0500")
Message-ID: <m31vjorgyz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller@kernellabs.com> writes:

> For example, you might want the IR receiver to be listening for codes
> using the "Universal Remote Control XYZ" profile and the IR
> transmitter pretending to be "Cable Company Remote Control ABC" when
> blasting IR codes to the cable box.  Ideally, there would be a single
> shared database of the definitions of the remote controls, regardless
> of whether you are IR receiving or transmitting.

Well, with different receivers, the maps must certainly be different.
There can be single database in the userspace but the kernel must be
uploaded the relevant info only.
-- 
Krzysztof Halasa
