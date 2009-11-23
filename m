Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:42237 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbZKWWbD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 17:31:03 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:  Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <m3einork1o.fsf@intrepid.localdomain>
	<829197380911231354y764e01b7hc0c5721b3ebf1f26@mail.gmail.com>
Date: Mon, 23 Nov 2009 23:31:06 +0100
In-Reply-To: <829197380911231354y764e01b7hc0c5721b3ebf1f26@mail.gmail.com>
	(Devin Heitmueller's message of "Mon, 23 Nov 2009 16:54:44 -0500")
Message-ID: <m36390rhzp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller@kernellabs.com> writes:

> There is an argument to be made that since it may be desirable for
> both IR receivers and transmitters to share the same table of remote
> control definitions, it might make sense to at least *consider* how
> the IR transmitter interface is going to work, even if it is decided
> to not implement such a design in the first revision.
>
> Personally, I would hate to see a situation where we find out that we
> took a bad approach because nobody considered what would be required
> for IR transmitters to reuse the same remote control definition data.

I briefly though about such possibility, but dismissed it with
assumption that we won't transmit the same codes (including "key" codes)
that we receive.

Perhaps I'm wrong.
-- 
Krzysztof Halasa
