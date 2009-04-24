Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:43758 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZDXCoX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 22:44:23 -0400
Date: Thu, 23 Apr 2009 21:44:17 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	isely@isely.net
Subject: Re: [PATCH 2/6] ir-kbd-i2c: Switch to the new-style device binding
   model
In-Reply-To: <20090423110038.59554982@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904230928410.3285@cnc.isely.net>
References: <20090417222927.7a966350@hyperion.delvare>
 <20090417223105.28b8957e@hyperion.delvare> <Pine.LNX.4.64.0904171831300.19718@cnc.isely.net>
 <20090418112519.774e0dae@hyperion.delvare> <20090418151625.254e466b@hyperion.delvare>
 <Pine.LNX.4.64.0904180842110.19718@cnc.isely.net> <20090423110038.59554982@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Jean,

I had actually written out a longer, detailed, point-by-point reply 
earlier today, but before I could finish it I got interrupted with a 
crisis.  And then another.  And that's kind of how my day went.  Now I'm 
finally back to this, but I have another e-mail debacle to immediately 
deal with (thank you pobox.com, not!) so I'm tossing that unfinished 
lengthy reply.  I think I can sum this whole thing up very simply.  
Here's what I think should be happening:

1a. Your existing IR changeset, minus the pvrusb2 changes, should be 
merged.

1b. In parallel with (1a) I modify my pvrusb2 changeset to use the right 
module name and I adjust the driver option name to match.

2. My pvrusb2 changeset, with changes from (1b) is merged.

3. Andy's proposed change for ir_kbd_i2c to support additional IR 
devices is investigated and probably merged.

4. I test the changed ir_kbd_i2c against additional pvrusb2 devices 
known not to work previously with ir_kbd_i2c.  If they work, then I will 
create a pvrusb2 patch to load ir_video in those cases as well as the 
cases already set up (which still won't cover all possible 
pvrusb2-driven devices).

I think this satisfies the remaining issues, except that from between 
steps 1 and 2 ir_kbd_i2c won't work with the pvrusb2 driver.  But you 
know, I'm OK with that.  I expect (2) to happen within a few days after 
(1) so the impact should be minimal.  It certainly won't escape into the 
kernel tree that way.  In addition, my impression from the community of 
pvrusb2 users is that the preferred IR strategy is lirc anyway, and it's 
a foregone conclusion that they are all going to be, uh, impacted once 
your compatibility parts are gone from i2c.  From where I'm sitting the 
"gap" from (1) to (2) is trivial compared to that impending mess - 
realize I'm not complaining since after all (a) it really falls to the 
lirc developers to fix that, (b) you do need to get your changes in, and 
(c) there's little I can do for lirc there except to keep it working as 
long as possible with the pvrusb2 driver.  I'm just pointing out that 
I'm OK with the step 1 -> 2 gap for the pvrusb2 driver because it's 
small and will be nothing compared to what's about to happen with lirc.

If you still don't like any of that, well, then I give up.  In that 
case, then merge your changes with the pvrusb2 changes included.  I 
won't ack them, but I'll just deal with it later.  Because while your 
changes might keep ir_kbd_i2c going, they will also immediately break 
the more-useful and apparently more-used lirc (by always binding 
ir_kbd_i2c even in cases in the pvrusb2 driver where it's known that it 
can't even work but lirc would have) which as far as I'm concerned is 
far worse than the step 1 - 2 gap above.  But it's just another gap and 
I'll push another pvrusb2 changeset on top to clean it up.  So just do 
whatever you think is best right now, if you disagree with the sequence 
above.

Now I will go off and deal with the steamer that pobox.com has just 
handed me :-(

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
