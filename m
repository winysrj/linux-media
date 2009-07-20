Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34763 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbZGTXjn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 19:39:43 -0400
Subject: Re: [PATCH 2/3] 2/3: cx18: Add i2c initialization for
 Z8F0811/Hauppage  IR transceivers
From: Andy Walls <awalls@radix.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Mark Lord <lkml@rtr.ca>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
In-Reply-To: <200907201451.33420.jarod@redhat.com>
References: <1247862585.10066.16.camel@palomino.walls.org>
	 <1247863615.10066.33.camel@palomino.walls.org>
	 <20090719153854.55fb9df7@hyperion.delvare>
	 <200907201451.33420.jarod@redhat.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 19:40:07 -0400
Message-Id: <1248133207.3148.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-07-20 at 14:51 -0400, Jarod Wilson wrote:
> On Sunday 19 July 2009 09:38:54 Jean Delvare wrote:
> > > 3. When using the new i2c binding model, I opted not to use ir_video for
> > > the Z8F0811 loaded with microcode from Zilog/Hauppauge.  Since I needed
> > > one name for Rx binding and one for Tx binding, I used these names:
> > > 
> > >       "ir_tx_z8f0811_haup"
> > >       "ir_rx_z8f0811_haup"
> > > 
> > > [Which is ir_(func)_(part number)_(firmware_oem)].  It made sense to me.
> > > I assume these are the names to which ir-kbd-i2c and lirc_* will have to
> > > bind.  Is that correct?
> > 
> > Yes, this is correct, and the approach is good. Ideally the "ir_video"
> > type would not exist (or would go away over time) and we would have a
> > separate type name for each IR chip, resulting in much cleaner code.
> > The reason for the current implementation is solely historical.
> 
> Cool. When fixing up lirc_i2c, I actually *did* have a question about
> that which I forgot about until reading this. The only name I could
> find in use anywhere at a glance was ir_video, so that's what lirc_i2c
> is set to hook up to for the moment, but yeah, device-specific names
> instead would be great. 

Yes, I noted "ir_video" implied an IR receiver, but the IR blaster on
the HVR-1600 and newer PVR-150's can't be called "ir_video" and have
lirc_zilog do the right thing obviously.  So "in for a penny, in for a
pound..."


Based on earlier posts from Jean, note that for microcontrollers the
chip part number is not enough to uniquely identify the IR
implementation since the firmware can be different.  I used the name
"haup" to distinguish a Z8F0811 loaded with firmware from
Hauppauge/Zilog.

Given reports from users using lirc_pvr150, the different versions of
firmware loaded into th Z8F0811 chips on the Hauppaugue boards all seem
to be compatable to some degree.  Plus the IR program firmware can
report its exact version if needed.



> Hrm. Offhand, I don't have a clue what the
> actual IR chip is on the PVR-x50 series,

There are a few different IR chips on the PVR-x50 series AFAIK.  I know
that if you find one sitting at 0x71 on the PVR-x50's, then it's likely
a Zilog Z8 Encore! family microcontroller loaded with firmware program
that probably originates from Zilog.  (A Zilog EULA comes with the
Hauppauge Windows drivers.)

Actually the Zilog Z8 chips respond to 0x70: blaster, 0x71 receiver,
0x72 ???, 0x73 ???

I was kind of hoping that addresses 0x72 and 0x73 might support some
sort of "raw mode" or "learning mode", so I could to avoid the whole
lirc_zilog "firmware image" mess.  But I haven't had time to expriment.

Regards,
Andy

>  let alone any of the other
> cards lirc_i2c claims to support...



