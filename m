Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34881 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab1APT3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 14:29:53 -0500
Subject: Re: [RFC PATCH] ir-kbd-i2c, lirc_zilog: Allow bridge drivers to
 pass an IR trasnceiver mutex to I2C IR modules
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
In-Reply-To: <4D333877.6040900@redhat.com>
References: <1295149788.7147.34.camel@localhost>
	 <4D333877.6040900@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 14:29:27 -0500
Message-ID: <1295206167.2400.36.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-01-16 at 16:27 -0200, Mauro Carvalho Chehab wrote:
> Jarod/Andy,
> 
> For now, I'm marking all those ir-kbd-i2c/lirc_zilog patches as "RFC" at patchwork,
> as I'm not sure if they're ok, and because there are a few revisions of them and
> I'm afraid to apply some wrong version.

And that's just fine. :)

That particular RFC was to get mostly Jean's opinion on adding fields to
struct IR_i2c_init_data and struct IR_i2c and code to ir-kbd-i2c.



> Please, after finishing and testing, send me a patch series or, preferably, a
> git pull with those stuff.

I just sent a [GIT PATCHES for 2.6.38], which is my pull request.  It
fixes one minor regression in ir-kbd-i2c.c.  The rest of the patches are
limited to lirc_zilog and do not modify any bridge drivers.  The
lirc_zilog changes were tested by me using my HVR-1600.

Jarrod will have to ask you to pull any hdpvr fixes, when he feels they
are ready.


Note my pull request does *not* include the patches in the subject [RFC
PATCH], so no worries about pulling those in. :)  I'll submit a pull for
those when they are correct and ready.


Regards,
Andy


