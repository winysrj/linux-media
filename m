Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([64.81.146.143]:41203 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1ASPJr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 10:09:47 -0500
Date: Wed, 19 Jan 2011 09:09:47 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Jean Delvare <khali@linux-fr.org>
cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
In-Reply-To: <20110119155932.08d080b7@endymion.delvare>
Message-ID: <alpine.DEB.1.10.1101190902190.22872@cnc.isely.net>
References: <1295205650.2400.27.camel@localhost> <20110119155932.08d080b7@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 19 Jan 2011, Jean Delvare wrote:

> Hi Andy,
> 
> On Sun, 16 Jan 2011 14:20:49 -0500, Andy Walls wrote:
> > 3. I hear from Jean, or whomever really cares about ir-kbd-i2c, if
> > adding some new fields for struct IR_i2c_init_data is acceptable.
> > Specifically, I'd like to add a transceiver_lock mutex, a transceiver
> > reset callback, and a data pointer for that reset callback.
> > (Only lirc_zilog would use the reset callback and data pointer.)
> 
> Adding fields to these structures is perfectly fine, if you need to do
> that, just go on.
> 
> But I'm a little confused about the names you chose,
> "ir_transceiver_lock" and "transceiver_lock". These seem too
> TX-oriented for a mutex that is supposed to synchronize TX and RX
> access. It's particularly surprising for the ir-kbd-i2c driver, which
> as far as I know only supports RX. The name "xcvr_lock" you used for
> lirc_zilog seems more appropriate.

Actually the term "transceiver" is normally understood to mean both 
directions.  Otherwise it would be "receiver" or "transmitter".  
Another screwy as aspect of english, and I say this as a native english 
speaker.  The term "xcvr" is usually just considered to be shorthand for 
"transceiver".

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
