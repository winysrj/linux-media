Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55844 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZGTSxZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 14:53:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 2/3] 2/3: cx18: Add i2c initialization for Z8F0811/Hauppage  IR transceivers
Date: Mon, 20 Jul 2009 14:51:32 -0400
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Mark Lord <lkml@rtr.ca>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
References: <1247862585.10066.16.camel@palomino.walls.org> <1247863615.10066.33.camel@palomino.walls.org> <20090719153854.55fb9df7@hyperion.delvare>
In-Reply-To: <20090719153854.55fb9df7@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907201451.33420.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 19 July 2009 09:38:54 Jean Delvare wrote:
> > 3. When using the new i2c binding model, I opted not to use ir_video for
> > the Z8F0811 loaded with microcode from Zilog/Hauppauge.  Since I needed
> > one name for Rx binding and one for Tx binding, I used these names:
> > 
> >       "ir_tx_z8f0811_haup"
> >       "ir_rx_z8f0811_haup"
> > 
> > [Which is ir_(func)_(part number)_(firmware_oem)].  It made sense to me.
> > I assume these are the names to which ir-kbd-i2c and lirc_* will have to
> > bind.  Is that correct?
> 
> Yes, this is correct, and the approach is good. Ideally the "ir_video"
> type would not exist (or would go away over time) and we would have a
> separate type name for each IR chip, resulting in much cleaner code.
> The reason for the current implementation is solely historical.

Cool. When fixing up lirc_i2c, I actually *did* have a question about
that which I forgot about until reading this. The only name I could
find in use anywhere at a glance was ir_video, so that's what lirc_i2c
is set to hook up to for the moment, but yeah, device-specific names
instead would be great. Hrm. Offhand, I don't have a clue what the
actual IR chip is on the PVR-x50 series, let alone any of the other
cards lirc_i2c claims to support...

-- 
Jarod Wilson
jarod@redhat.com
