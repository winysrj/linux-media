Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:43519 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbZDFDxI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 23:53:08 -0400
Date: Sun, 5 Apr 2009 22:53:04 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: pvrusb2 IR changes coming [was: [PATCH 3/6] ir-kbd-i2c: Switch to
 the new-style device binding model]
In-Reply-To: <Pine.LNX.4.64.0904051315490.32738@cnc.isely.net>
Message-ID: <Pine.LNX.4.64.0904052226270.2076@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <20090404142837.3e12824c@hyperion.delvare> <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
 <20090405010539.187e6268@hyperion.delvare> <Pine.LNX.4.64.0904041807300.32720@cnc.isely.net>
 <20090405161803.70810455@hyperion.delvare> <Pine.LNX.4.64.0904051315490.32738@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Jean:

Here's a description of what I've got on the front burner right now:

1. The pvrusb2 driver now can unambiguously know if it is dealing with a 
device that is known to have ir-kbd-i2c compatible IR capabilities.

2. There is a new module option, "disable_autoload_ir_kbd", which if 
present and set to 1 will indicate that ir-kbd should not be loaded.

2. Based upon (1) and (2), the driver will optionally attempt to load 
ir-kbd using the code from your patch.

3. In the pvrusb2 case, the only i2c address that currently matters is 
0x18 (though I have some suspicions about another case but that can be 
dealt with later), so I trimmed the probe list in the register function 
you had added.

Since calling i2c_new_probed_device() for a non-existent target driver 
doesn't cause any harm, then merging the above now should not result in 
any kind of regression.  So it can go in even before the rest of your 
changes.  That I believe also removes the objection Mauro had - this way 
there's no issues / dependencies.  I've tested this enough to know that 
it at least doesn't do any further harm.

I will put this up in a changeset shortly.

With all that said, we should not ignore lirc and instead do whatever is 
reasonable to help ensure it continues to work.  Though admittedly 
there's been plenty of opportunity to update and this whole transition 
has been going on for a long time.  The stuff I describe above should at 
least keep the pvrusb2 driver out of the fray for now.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
