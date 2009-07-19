Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:44703 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbZGSMwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 08:52:12 -0400
Message-ID: <4A6316F9.4070109@rtr.ca>
Date: Sun, 19 Jul 2009 08:52:09 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal get_key
  funcs and set ir_type
References: <1247862585.10066.16.camel@palomino.walls.org>	<1247862937.10066.21.camel@palomino.walls.org> <20090719144749.689c2b3a@hyperion.delvare>
In-Reply-To: <20090719144749.689c2b3a@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While you folks are looking into ir-kbd-i2c,
perhaps one of you will fix the regressions
introduced in 2.6.31-* ?

The drive no longer detects/works with the I/R port on
the Hauppauge PVR-250 cards, which is a user-visible regression.

Cheers
