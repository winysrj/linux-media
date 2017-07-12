Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54593 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbdGLXBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:01:42 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 0/9] Fix coding style in en50221 CAM functions
Date: Thu, 13 Jul 2017 01:00:49 +0200
Message-Id: <1499900458-2339-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

These patch series is the V2 version adapted to the already merged patches
from V1 and other merged patches. It does no longer rename constants, as
stated by Mauro as a no-go. It still fixed nearly all the style issues 
reported by checkpatch.pl in dvb-core/dvb_ca_en50221.c, but keeps more open
than the V1 version for good reasons. I also renamed the patch title,
because "Make checkpatch happy ?" is a bad title and checkpatch complained
about it. I also refactored the stat machine a bit more and added the new
function dvb_ca_en50221_poll_cam_gone in a new patch.
 
Two of them are "WARNING: memory barrier without comment". I have really
no clue why there is a call to "mb()" in that file, so I can't fill in a
good comment.
 
I kept some of the "WARNING: line over 80 characters" findings, which are 
strings for debugging, which shouldn't be split in several lines (will 
give other warning). And some lines, where a change would decrease the
readability. There it would be better to split the functions in new
subroutines, which I currently didn't.
 
And finally one "WARNING: Prefer [subsystem eg: netdev]_dbg", complaining
about the "dprintk" macro. In my opinion it is correctly used and it is
normally disabled anyway.
 
The main problem of the original code was the size of the lines and the
structural complexity of some functions. Beside refactoring of the thread
state machine, I used in nearly every function a helper pointer "sl" (for
"slot" structure) instead the whole structure path. This saved also a lot
of characters in long lines and made the code more readable in my opinion.
 
I split the patch set is small pieces for easier review, compiled each
step and tested the resulting driver on my hardware with the DD DuoFlex CI
(single) card. I took a lot of care in the first two patches to really
keep the code as is without loosing any line during refactoring.

Jasmin Jessich (9):
  [media] dvb-core/dvb_ca_en50221.c: Refactored dvb_ca_en50221_thread
  [media] dvb-core/dvb_ca_en50221.c: New function dvb_ca_en50221_poll_cam_gone
  [media] dvb-core/dvb_ca_en50221.c: use usleep_range
  [media] dvb-core/dvb_ca_en50221.c: Fixed block comments
  [media] dvb-core/dvb_ca_en50221.c: Avoid assignments in ifs
  [media] dvb-core/dvb_ca_en50221.c: Used a helper variable
  [media] dvb-core/dvb_ca_en50221.c: Added line breaks
  [media] dvb-core/dvb_ca_en50221.c: Removed useless braces
  [media] dvb-core/dvb_ca_en50221.c: Fixed 80 char limit

 drivers/media/dvb-core/dvb_ca_en50221.c | 774 ++++++++++++++++++--------------
 1 file changed, 441 insertions(+), 333 deletions(-)

-- 
2.7.4
