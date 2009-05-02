Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:56329 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZEBBat (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 21:30:49 -0400
Date: Fri, 1 May 2009 20:30:48 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@isely.net>
Subject: Re: [PATCH 2/6] ir-kbd-i2c: Switch to the new-style device binding
   model
In-Reply-To: <Pine.LNX.4.64.0904230928410.3285@cnc.isely.net>
Message-ID: <Pine.LNX.4.64.0905012010220.15541@cnc.isely.net>
References: <20090417222927.7a966350@hyperion.delvare>
 <20090417223105.28b8957e@hyperion.delvare> <Pine.LNX.4.64.0904171831300.19718@cnc.isely.net>
 <20090418112519.774e0dae@hyperion.delvare> <20090418151625.254e466b@hyperion.delvare>
 <Pine.LNX.4.64.0904180842110.19718@cnc.isely.net> <20090423110038.59554982@hyperion.delvare>
 <Pine.LNX.4.64.0904230928410.3285@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Jean:

I have another idea that I think you'll like.  I'm putting the finishing 
touches on the patch right now.

What I have implements correct ir_video loading for the pvrusb2 driver.  
It also includes a lookup table (though with only 1 entry right now) to 
determine the proper I2C address and I use i2c_new_device() now instead 
of i2c_new_probed_device().  I've also renamed things to be "ir_video" 
everywhere instead of ir_kbd_i2c as was discussed.

In particular the disable option is there like before, but now it's 
called disable_autoload_ir_video.

So far this is exactly what I was saying before.  But I'm also making 
one more change: the disable_autoload_ir_video option default value will 
- for now - be 1, i.e. everything above I just described starts off 
disabled.  This means that the entire patch can be pulled _right_ _now_ 
without breaking anything at all, because the outward behavior is still 
unchanged.

Then, when you're ready to bring your stuff in, all you need to do is 
include a 1-line change to pvrusb2-i2c-core.c to switch the default 
value of disable_autoload_ir_video back to 0, which now enables all the 
corresponding pvrusb2 changes that you need to avoid any breakage inside 
my driver.  Just to be absolutely crystal clear, here's the change you 
will be able to do once these changes are in:

diff -r 8d2e1361520c linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	Fri May 01 20:23:39 2009 -0500
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	Fri May 01 20:24:23 2009 -0500
@@ -43,7 +43,7 @@
 module_param_array(ir_mode, int, NULL, 0444);
 MODULE_PARM_DESC(ir_mode,"specify: 0=disable IR reception, 1=normal IR");
 
+static int pvr2_disable_ir_video;
-static int pvr2_disable_ir_video = 1;
 module_param_named(disable_autoload_ir_video, pvr2_disable_ir_video,
 		   int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(disable_autoload_ir_video,

So with all this, what I am setting up right now will cause no harm to 
the existing situation, requires no actual messing with module options, 
and once you're reading, just include the 1-line change above and you're 
set.  There's no "race here", no gap in IR handling.

  -Mike


On Thu, 23 Apr 2009, Mike Isely wrote:

> 
> Hi Jean,
> 
> I had actually written out a longer, detailed, point-by-point reply 
> earlier today, but before I could finish it I got interrupted with a 
> crisis.  And then another.  And that's kind of how my day went.  Now I'm 
> finally back to this, but I have another e-mail debacle to immediately 
> deal with (thank you pobox.com, not!) so I'm tossing that unfinished 
> lengthy reply.  I think I can sum this whole thing up very simply.  
> Here's what I think should be happening:
> 
> 1a. Your existing IR changeset, minus the pvrusb2 changes, should be 
> merged.
> 
> 1b. In parallel with (1a) I modify my pvrusb2 changeset to use the right 
> module name and I adjust the driver option name to match.
> 
> 2. My pvrusb2 changeset, with changes from (1b) is merged.
> 
> 3. Andy's proposed change for ir_kbd_i2c to support additional IR 
> devices is investigated and probably merged.
> 
> 4. I test the changed ir_kbd_i2c against additional pvrusb2 devices 
> known not to work previously with ir_kbd_i2c.  If they work, then I will 
> create a pvrusb2 patch to load ir_video in those cases as well as the 
> cases already set up (which still won't cover all possible 
> pvrusb2-driven devices).
> 
> I think this satisfies the remaining issues, except that from between 
> steps 1 and 2 ir_kbd_i2c won't work with the pvrusb2 driver.  But you 
> know, I'm OK with that.  I expect (2) to happen within a few days after 
> (1) so the impact should be minimal.  It certainly won't escape into the 
> kernel tree that way.  In addition, my impression from the community of 
> pvrusb2 users is that the preferred IR strategy is lirc anyway, and it's 
> a foregone conclusion that they are all going to be, uh, impacted once 
> your compatibility parts are gone from i2c.  From where I'm sitting the 
> "gap" from (1) to (2) is trivial compared to that impending mess - 
> realize I'm not complaining since after all (a) it really falls to the 
> lirc developers to fix that, (b) you do need to get your changes in, and 
> (c) there's little I can do for lirc there except to keep it working as 
> long as possible with the pvrusb2 driver.  I'm just pointing out that 
> I'm OK with the step 1 -> 2 gap for the pvrusb2 driver because it's 
> small and will be nothing compared to what's about to happen with lirc.
> 
> If you still don't like any of that, well, then I give up.  In that 
> case, then merge your changes with the pvrusb2 changes included.  I 
> won't ack them, but I'll just deal with it later.  Because while your 
> changes might keep ir_kbd_i2c going, they will also immediately break 
> the more-useful and apparently more-used lirc (by always binding 
> ir_kbd_i2c even in cases in the pvrusb2 driver where it's known that it 
> can't even work but lirc would have) which as far as I'm concerned is 
> far worse than the step 1 - 2 gap above.  But it's just another gap and 
> I'll push another pvrusb2 changeset on top to clean it up.  So just do 
> whatever you think is best right now, if you disagree with the sequence 
> above.
> 
> Now I will go off and deal with the steamer that pobox.com has just 
> handed me :-(
> 
>   -Mike
> 
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
