Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:51758 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab0IYOAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Sep 2010 10:00:24 -0400
Date: Sat, 25 Sep 2010 08:01:34 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] cafe_ccic: Fix hang in command write processing
Message-ID: <20100925080134.0ee58da8@tpl.lwn.net>
In-Reply-To: <20100924171717.B3A969D401B@zog.reactivated.net>
References: <20100924171717.B3A969D401B@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 24 Sep 2010 18:17:17 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> This patch, which basically reverts 6d77444ac, fixes an occasional
> on-boot or on-capture hang on the XO-1 laptop.
> 
> It seems like the cafe hardware is flakier than we thought and that in
> some cases, the commands get executed but are never reported as completed
> (even if we substantially increase the delays before reading registers).
> 
> Reintroduce the 1-second CAFE_SMBUS_TIMEOUT to catch and avoid this
> strange hardware bug.

>From a *quick* airport-lounge look, these all look OK, though the first
one is a little sad.

I think that a lot of problems come from trying to speak SMBUS to the
sensor - it doesn't actually do that very well.  With the via-camera
driver, life got a lot better when I went to straight i2c
transactions.  Doing that with the cafe controller will be a little bit
trickier, probably requiring the implementation of a simple bit-banging
i2c driver.  It's probably worth a try, though, when somebody gets a
chance.

Meanwhile, feel free to toss my Acked-by onto this set.

Thanks,

jon
