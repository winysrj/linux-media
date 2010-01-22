Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab0AVVsU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 16:48:20 -0500
Message-ID: <4B5A1D1E.2000701@redhat.com>
Date: Fri, 22 Jan 2010 19:48:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: First -git merges
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As already announced, the patches are now being committed first on
-git tree and then backported to -hg.

In order to allow people to follow the patches that are being added
at -git, I added a git hook that will send announcement emails when
a patch is committed at:
	http://linuxtv.org/git/v4l-dvb.git

Unfortunately, the first 3 or 4 git commits got lost while the hooks
were being adjusted. Yet, as the first commits were small, it is easy
to see the commit history at the gitweb interface.

The backport to -hg will be done by Douglas.

Cheers,
Mauro.

-------- Mensagem original --------
Assunto: [linuxtv-commits] [git:v4l-dvb] The merge of all V4L/DVB trees	ready to upstream and linux-next branch, master,	updated. v2.6.33-rc4-647-ga533f16
Data: Fri, 22 Jan 2010 22:32:26 +0100
De: Mauro Carvalho Chehab <linuxtv-commits-bounces@linuxtv.org>
Para: linuxtv-commits@linuxtv.org

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "The merge of all V4L/DVB trees ready to upstream and linux-next".

The branch, master has been updated
       via  a533f16b29f8840adf344e4616195b10186986f7 (commit)
       via  6ba638cc4d68eb848d0d7db8b6eb1d2b85e2bff4 (commit)
       via  de199078f3fffc412a571586f384b5b1094d97b7 (commit)
       via  9ab78b16a50a10f7eae68c3b6e2a6337bbfe4dff (commit)
       via  5a53a97db877a3181f34aa5b1637a644374364ff (commit)
       via  0b8b15a2576c40f7bfddd1f7c9b6cca5cdee4294 (commit)
       via  124e063aaaf9d35402d7205fbcaa855ae246197b (commit)
       via  a8f0518d0306e2eb41bf5d3506c38265f340e555 (commit)
       via  759a3f07b8fd037738f17e535a60dcf2a0b4a1d4 (commit)
       via  cca769eb33d71ce46cc77da62586da9e4a242af3 (commit)
       via  606455919a764cfb8cde747e8300b046789708b4 (commit)
       via  f381973e65618734428d768e3409ce6ecb56cfb2 (commit)
       via  d08e8f2e17aa0c1c2936a3d6f079249a5bc77e8c (commit)
       via  95ce682cd886f283eb312dabeb117eabc3d8719a (commit)
       via  da54f5e853c00ac385d90fa2f120c3cd2b9f2ed1 (commit)
       via  5e9a302853301e0a2bb6671036daac3366fd85f4 (commit)
       via  c93a9c83cb7a1c84ae0e149a3005ec2c2b89c9c8 (commit)
       via  9b8efa3240c67e6421cded1645c38a58ffdef4d4 (commit)
       via  ea104b521648bccd0ab88a08e2e442e90f69a15e (commit)
       via  6ee6681ae870808ff694447194130d30806f2c4d (commit)
       via  0eac680b42f212a6ef8f60803669c89ac6f85d03 (commit)
      from  4aaf6746249827a699ec35a27ab1ce738b482afe (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit a533f16b29f8840adf344e4616195b10186986f7
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Jan 7 00:56:14 2010 -0300

    V4L/DVB: cx18-alsa: Fix the rates definition and move some buffer freeing code.
    
    Clarify the rates available for the device, and move the freeing of the buffer
    to the free routine instead of the close (per Takashi's suggestion).
    
    Thanks to Takashi Iwai for reviewing and providing feedback.
    
    This work was sponsored by ONELAN Limited.
    
    Cc: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 6ba638cc4d68eb848d0d7db8b6eb1d2b85e2bff4
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Jan 7 00:52:39 2010 -0300

    V4L/DVB: cx18: address possible passing of NULL to snd_card_free
    
    Eliminate the possibility of passing NULL to snd_card_free().
    
    Thanks to Takashi Iwai for reviewing and pointing this out.
    
    This work was sponsored by ONELAN Limited.
    
    Cc: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit de199078f3fffc412a571586f384b5b1094d97b7
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Sun Dec 20 23:53:46 2009 -0300

    V4L/DVB: cx18-alsa: codingstyle cleanup
    
    Move the cx18_alsa_announce_pcm_data() function further up in the file, since
    apparently "make checkpatch" has never heard of a forward declaration.  Note
    that despite the hg diff showing everything else as having been deleted/added,
    in reality it was only that one function that got moved (and the forward
    declaration was removed from the top of the file).
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 9ab78b16a50a10f7eae68c3b6e2a6337bbfe4dff
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Sun Dec 20 23:50:02 2009 -0300

    V4L/DVB: cx18-alsa: codingstyle cleanup
    
    Remove some dead code and make a PCM specific module debug parameter to avoid
    an extern reference.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 5a53a97db877a3181f34aa5b1637a644374364ff
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Sun Dec 20 23:29:02 2009 -0300

    V4L/DVB: cx18: codingstyle fixes
    
    Codingstyle fixes, some introduced as a result of the ALSA work, some
    pre-existing.  This patch is a whitespace change only.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 0b8b15a2576c40f7bfddd1f7c9b6cca5cdee4294
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Sun Dec 20 23:15:58 2009 -0300

    V4L/DVB: cx18-alsa: codingstyle fixes
    
    Fix codingstyle issues, and make the minimum version for cx18-alsa required
    to be 2.6.17, so that we don't need all the #ifdefs related to the changes
    to ALSA structures.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 124e063aaaf9d35402d7205fbcaa855ae246197b
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Sun Dec 20 23:01:46 2009 -0300

    V4L/DVB: cx18-alsa: fix codingstyle issue
    
    Address coding style issue with cx18-alsa-main.c
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit a8f0518d0306e2eb41bf5d3506c38265f340e555
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Sat Dec 12 17:38:53 2009 -0300

    V4L/DVB: cx18-alsa: fix memory leak in error condition
    
    If the stream is already in use, make sure we free up the memory allocated
    earlier.
    
    Thanks to Andy Wall for reviewing and pointing this out.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 759a3f07b8fd037738f17e535a60dcf2a0b4a1d4
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Sun Nov 22 23:42:33 2009 -0300

    V4L/DVB: cx18-alsa: remove a couple of warnings
    
    Remove a couple of warnings from dead code during driver development.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit cca769eb33d71ce46cc77da62586da9e4a242af3
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Fri Nov 20 02:15:20 2009 -0300

    V4L/DVB: cx18-alsa: name alsa device after the actual card
    
    Use the cx18 board name in the ALSA description, to make it easier for users
    who run "arecord -l" to see which device they should be looking for.
    
    Also, use strlcpy() instead of strcpy().
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 606455919a764cfb8cde747e8300b046789708b4
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Fri Nov 20 01:24:57 2009 -0300

    V4L/DVB: cx18: cleanup cx18-alsa debug logging
    
    Fix the debug macro so that it is dependent on the modprobe parameter.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit f381973e65618734428d768e3409ce6ecb56cfb2
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Fri Nov 20 01:15:54 2009 -0300

    V4L/DVB: cx18: rework cx18-alsa module loading to support automatic loading
    
    Restructure the way the module gets loaded so that it gets loaded automatically
    when cx18 is loaded, and make it work properly if there are multiple cards
    present (since the old code would only take one opportunity to connect to cx18
    instances when the module first loaded).
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit d08e8f2e17aa0c1c2936a3d6f079249a5bc77e8c
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Nov 19 23:35:36 2009 -0300

    V4L/DVB: cx18-alsa: remove unneeded debug line
    
    Remove an unneeded debug line, which was preventing the cx18-alsa module from
    loading.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 95ce682cd886f283eb312dabeb117eabc3d8719a
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Nov 19 23:23:57 2009 -0300

    V4L/DVB: cx18: export more symbols required by cx18-alsa
    
    Export a couple of more symbols required by the cx18-alsa module.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit da54f5e853c00ac385d90fa2f120c3cd2b9f2ed1
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Nov 19 23:17:40 2009 -0300

    V4L/DVB: cx18: add cx18-alsa module to Makefile
    
    Add cx18-alsa to the Makefile and Kconfig
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 5e9a302853301e0a2bb6671036daac3366fd85f4
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Mon Jan 18 21:29:51 2010 -0300

    V4L/DVB: cx18: overhaul ALSA PCM device handling so it works
    
    Add code so that the PCM ALSA device actually works, and update the
    cx18-streams mechanism so that it passes the data off to the cx18-alsa module.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit c93a9c83cb7a1c84ae0e149a3005ec2c2b89c9c8
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Nov 19 22:52:30 2009 -0300

    V4L/DVB: cx18: export a couple of symbols so they can be shared with cx18-alsa
    
    Expose a couple of symbols in the cx18 module so that locking of the PCM
    stream can be shared with the cx18-alsa module.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 9b8efa3240c67e6421cded1645c38a58ffdef4d4
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Nov 19 22:46:10 2009 -0300

    V4L/DVB: cx18: make it so cx18-alsa-main.c compiles
    
    Fix some basic compilation issues with Andy's original code.  In particular,
    temporarily #ifdef out the mixer code, add some additional exception handling,
    fix a couple of typos, and add a copyright line.
    
    This work was sponsored by ONELAN Limited.
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit ea104b521648bccd0ab88a08e2e442e90f69a15e
Author: Devin Heitmueller <dheitmueller@kernellabs.com>
Date:   Thu Nov 19 22:40:41 2009 -0300

    V4L/DVB: cx18: rename cx18-alsa.c
    
    Rename cx18-alsa.c to cx18-alsa-main.c so that we can call the final .ko file
    cx18-alsa.ko
    
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 6ee6681ae870808ff694447194130d30806f2c4d
Author: Andy Walls <awalls@radix.net>
Date:   Wed Jun 24 07:26:45 2009 -0300

    V4L/DVB: cx18-alsa: Add non-working cx18-alsa-pcm.[ch] files to avoid data loss
    
    Signed-off-by: Andy Walls <awalls@radix.net>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 0eac680b42f212a6ef8f60803669c89ac6f85d03
Author: Andy Walls <awalls@radix.net>
Date:   Mon May 25 21:40:25 2009 -0300

    V4L/DVB: cx18-alsa: Initial non-working cx18-alsa files
    
    Initial cx18-alsa module files check-in to avoid losing work.
    
    Signed-off-by: Andy Walls <awalls@radix.net>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

-----------------------------------------------------------------------

Summary of changes:
 drivers/media/video/cx18/Kconfig           |   11 +
 drivers/media/video/cx18/Makefile          |    2 +
 drivers/media/video/cx18/cx18-alsa-main.c  |  293 +++++++++++++++++++++++
 drivers/media/video/cx18/cx18-alsa-mixer.c |  191 +++++++++++++++
 drivers/media/video/cx18/cx18-alsa-mixer.h |   23 ++
 drivers/media/video/cx18/cx18-alsa-pcm.c   |  353 ++++++++++++++++++++++++++++
 drivers/media/video/cx18/cx18-alsa-pcm.h   |   27 ++
 drivers/media/video/cx18/cx18-alsa.h       |   59 +++++
 drivers/media/video/cx18/cx18-driver.c     |   40 +++-
 drivers/media/video/cx18/cx18-driver.h     |   10 +
 drivers/media/video/cx18/cx18-fileops.c    |    6 +-
 drivers/media/video/cx18/cx18-fileops.h    |    3 +
 drivers/media/video/cx18/cx18-mailbox.c    |   46 ++++-
 drivers/media/video/cx18/cx18-streams.c    |    2 +
 14 files changed, 1057 insertions(+), 9 deletions(-)
 create mode 100644 drivers/media/video/cx18/cx18-alsa-main.c
 create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.c
 create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.h
 create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.c
 create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.h
 create mode 100644 drivers/media/video/cx18/cx18-alsa.h


hooks/post-receive
-- 
The merge of all V4L/DVB trees ready to upstream and linux-next

_______________________________________________
linuxtv-commits mailing list
linuxtv-commits@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
