Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36541 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbbDFSlh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 14:41:37 -0400
Date: Mon, 6 Apr 2015 20:41:00 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sergio Serrano <sergio.badalona@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: using TSOP receiver without lircd
Message-ID: <20150406184100.GA23493@hardeman.nu>
References: <CAK-SLvBcZG5VN4BkUV+jS0z_xqXpVwJFMXfMaQF7kfFxJ7En9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-SLvBcZG5VN4BkUV+jS0z_xqXpVwJFMXfMaQF7kfFxJ7En9A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 06, 2015 at 06:01:52PM +0200, Sergio Serrano wrote:
>Hi members!
>
>In the hope that someone can help me, I has come to this mailing list after
>contacting David Hardeman (thank you!).
>He has already given me some clues. This is my scenario.
>
>I'm using a OMAP2 processor and capturing TSOP34836 (remote RC5 compatible)
>signals through GPIO+interrupt. I have created the /dev/lirc0 device , here
>comes my question: If possible I don't want to deal with LIRC and irrecord
>stuff. Is it possible? What will be the first steps?

Your next step would be a kernel driver that receives the GPIO
interrupts and feeds them into rc-core as "edge" events.

drivers/media/rc/gpio-ir-recv.c is probably what you want as a starting
point (though you'll need to find a way to feed it the right
parameters...)

Regards,
David

