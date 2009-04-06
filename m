Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36301 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbZDFKz7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 06:55:59 -0400
Subject: Re: Test results for ir-kbd-i2c.c changes (Re: [PATCH 0/6]
 ir-kbd-i2c  conversion to the new i2c binding model)
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>
In-Reply-To: <20090406105436.05ecaf4d@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090405070116.17ecadef@pedra.chehab.org>
	 <20090405164024.1459e4fe@hyperion.delvare>
	 <1238977379.2796.19.camel@morgan.walls.org>
	 <20090406105436.05ecaf4d@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 07:56:22 -0400
Message-Id: <1239018982.3157.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-04-06 at 10:54 +0200, Jean Delvare wrote:
> Hi Andy,


> Note that struct IR_i2c_init_data only contains the fields I needed at
> the moment, but it would be trivial to extend it to allow bridge
> drivers to pass more setup information if needed, for example ir_type.

Yeah, I could have mucked with it myself, but communicating back the
whole merged diff would have been a hassle.  I was just testing anyway.


> > Success.
> 
> OK, good to know that adding support for the cx18 will be possible and
> easy. I propose that we postpone this addition until after my code is
> merged though, to avoid making the situation more complex than it
> already is.

Yeah.  So far one user has asked for it.


> Thanks a lot for the testing!


You're welcome.

Sorry for being such a pain to what I suspect you hoped was to be a
"simple" change.

Regards,
Andy


