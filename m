Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:20947 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbZGSRIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 13:08:41 -0400
Date: Sun, 19 Jul 2009 19:08:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal
 get_key    funcs and set ir_type
Message-ID: <20090719190833.29451277@hyperion.delvare>
In-Reply-To: <4A632FED.1000809@rtr.ca>
References: <1247862585.10066.16.camel@palomino.walls.org>
	<1247862937.10066.21.camel@palomino.walls.org>
	<20090719144749.689c2b3a@hyperion.delvare>
	<4A6316F9.4070109@rtr.ca>
	<20090719145513.0502e0c9@hyperion.delvare>
	<4A631B41.5090301@rtr.ca>
	<4A631CEA.4090802@rtr.ca>
	<4A632FED.1000809@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 19 Jul 2009 10:38:37 -0400, Mark Lord wrote:
> I'm debugging various other b0rked things in 2.6.31 here right now,
> so I had a closer look at the Hauppauge I/R remote issue.
> 
> The ir_kbd_i2c driver *does* still find it after all.
> But the difference is that the output from 'lsinput' has changed
> and no longer says "Hauppauge".  Which prevents the application from
> finding the remote control in the same way as before.

OK, thanks for the investigation.

> I'll hack the application code here now to use the new output,
> but I wonder what the the thousands of other users will do when
> they first try 2.6.31 after release ?

Where does lsinput get the string from?

What exactly was it before, and what is it exactly in 2.6.31?

-- 
Jean Delvare
