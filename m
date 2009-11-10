Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:41489 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbZKJA13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 19:27:29 -0500
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules
	using  XC2028 and XC3028L tuners
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
In-Reply-To: <1257810825.5540.8.camel@pc07.localdom.local>
References: <1257630476.15927.400.camel@localhost>
	 <1257644240.6895.5.camel@palomino.walls.org>
	 <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
	 <1257645834.15927.634.camel@localhost>
	 <20091108012042.798835dd@pedra.chehab.org>
	 <1257723149.3249.50.camel@pc07.localdom.local>
	 <20091108224313.705ec3cc@pedra.chehab.org>
	 <1257732169.3300.38.camel@pc07.localdom.local>
	 <20091109093702.1a74b709@pedra.chehab.org>
	 <1257810825.5540.8.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 01:19:33 +0100
Message-Id: <1257812373.5540.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[snip]
> 
> If there are no known issues with latest, we should ask Philips/NXP if
> we are allowed to distribute it with the kernel.

To make it more clear.

OEMs did modify the eeprom content of their devices not following the
Philips rules anymore and causing troubles.

I would like to know, if this can happen for firmware too.

I really hope it never came to this point.

Cheers,
Hermann


