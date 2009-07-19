Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:27949 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZGSMzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 08:55:22 -0400
Date: Sun, 19 Jul 2009 14:55:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal
 get_key   funcs and set ir_type
Message-ID: <20090719145513.0502e0c9@hyperion.delvare>
In-Reply-To: <4A6316F9.4070109@rtr.ca>
References: <1247862585.10066.16.camel@palomino.walls.org>
	<1247862937.10066.21.camel@palomino.walls.org>
	<20090719144749.689c2b3a@hyperion.delvare>
	<4A6316F9.4070109@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

On Sun, 19 Jul 2009 08:52:09 -0400, Mark Lord wrote:
> While you folks are looking into ir-kbd-i2c,
> perhaps one of you will fix the regressions
> introduced in 2.6.31-* ?
> 
> The drive no longer detects/works with the I/R port on
> the Hauppauge PVR-250 cards, which is a user-visible regression.

This is bad. If there a bugzilla entry? If not, where can I read more
details / get in touch with an affected user?

-- 
Jean Delvare
