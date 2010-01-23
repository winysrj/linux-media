Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33495 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab0AWOty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 09:49:54 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Sat, 23 Jan 2010 08:49:39 -0600
Subject: RE: [RFC] Procedures for git push
Message-ID: <A24693684029E5489D1D202277BE89445071D65E@dlee02.ent.ti.com>
References: <4B5B08B3.50408@redhat.com>
In-Reply-To: <4B5B08B3.50408@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

One small suggestion below.

> ________________________________________
> From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab [mchehab@redhat.com]
> Sent: Saturday, January 23, 2010 8:33 AM
> To: Linux Media Mailing List
> Subject: [RFC] Procedures for git push
>
> As already discussed during the -git announcement, one important part is how
> we'll handle -git pushes.
>
> So, I'm sending a procedure explaining how should be the new submission process for
> sending patches via GIT PULL requests.
>
> Feel free to comment and send suggestions to improve it. I intend to add its content
> to README.patches or to add it as README.git next week, after getting some review.
>
> Cheers,
> Mauro
>
> ---
>
> Mauro Carvalho Chehab <mchehab at infradead dot org>   Updated on 2010 January 23
>
>
> 1. KERNEL DEVELOPMENT PROCEDURES FOR UPSTREAM
> =============================================
>
> Before starting with the RFC, it is important that people understand how upstream
> development works.
>
> Kernel development has 2 phases:
>
> 1) a merge window typically with 2 weeks (although Linus is gave some
> indications that he may reduce it on 2.6.34), starting with the release
> of a new kernel version;
>
> 2) the -rc period, where the Kernel is tested and receive fixes.
>
> The length of the -rc period depends on the number and relevance of the fixes. Considering
> the recent history, it ranges from -rc6 to -rc8, where each -rc takes one week.
>
> Those are the latest -rc kernels since 2.6.12:
>         2.6.12-rc6
>         2.6.13-rc7
>         2.6.14-rc5
>         2.6.15-rc7
>         2.6.16-rc6
>         2.6.17-rc6
>         2.6.18-rc7
>         2.6.19-rc6
>         2.6.20-rc7
>         2.6.21-rc7
>         2.6.22-rc7
>         2.6.23-rc9
>         2.6.24-rc8
>         2.6.25-rc9
>         2.6.26-rc9
>         2.6.27-rc9
>         2.6.28-rc9
>         2.6.29-rc8
>         2.6.30-rc8
>         2.6.31-rc9
>         2.6.32-rc8
>
> In general, the announcement of a new -rc kernel gives some hints when that -rc kernel
> may be the last one.
>
> The required procedure, on subsystem trees is that:
>
> a) During -rc period (e.g. latest main kernel available is 2.6.x, the latest -rc kernel
> is 2.6.[x+1]-rc<y>):
>
>         - fix patches for the -rc kernel (2.6.[x+1]) should be sent upstream,
> being a good idea to send them for some time at linux-next tree, allowing other
> people to test it, and check for potential conflicts with the other arch's;
>
>         - patches for 2.6.[x+2] should be sent to linux-next.
>
> b) the release of 2.6.[x+1] kernel:
>         - closes the -rc period and starts the merge window.
>
> c) During the merge window:
>
>         - the patch that were added on linux-next during the -rc period
> for 2.6.[x+2] should be sent upstream;
>
>         - new non-fix patches should be hold until the next -rc period starts,
> so, they'll be added on 2.6.[x+3];
>
>         - fix patches for 2.6.[x+2] should go to linux-next, wait for a few days
> and then send upstream.
>
> d) the release of 2.6.[x+2]-rc1 kernel:
>
>         - the merge window has closed. No new features are allowed.
>
>         - the patches with new features that arrived during the merge window will
> be moved to linux-next
>
> So, in other words, as currently x=32, and we are at the -rc period, being that
> the latest stable kernel is 2.6.32 and the latest -rc kernel 2.6.33-rc5, we are receiving
> patches for new features that will be available on kernel 2.6.34. After the release
> of 2.6.33, new features we receive will be added on 2.6.35.
>
> So, we're always developing features that will be there on the next 2 kernels.
>
> In the specific case of new drivers that don't touch on existing features, it could
> be possible to send it during the -rc period, but it is safer to assume that those
> drivers should follow the above procedure, as a later submission may be nacked.
>
> Sometimes, a fix patch corrects a problem that happens also on stable kernels (e. g.
> on kernel 2.6.x or even 2.6.y, where y < x). In this case, the patch should be sent to
> stable@kernel.org, in order to be added on stable kernels.
>
> 2. KERNEL DEVELOPMENT PROCEDURES FOR V4L/DVB
> ============================================
>
> That's the RFC on how we should work with -git.
>
> 1) fixes and linux-next patches
>
> One of the big problems of our model is that we're using just one tree/branch for everything,
> with mercurial. This makes hard to send some fix patches for 2.6.[x+1], as they may have conflicts
> with the patches for 2.6.[x+2]. So, when the conflict is simple to solve, the patch is sent as
> fixes. Otherwise, it generally is hold to the next cycle. The fix patches should be tagged by the
> developer with "Priority: high" on mercurial.
>
> Unfortunately, sometimes people mark the driver with the wrong tag. For example, I merged yesterday
> a patch marked with "high" that doesn't apply at the fixes tree. This patch fix a regression introduced
> by a driver that weren't merged yet, so, the patch were added as normal patch.
>
> How to solve those issues?
>
> Well, basically, we should work with more than one tree (or branch), on upstream submission:
>         a tree/branch with the fix patches;
>         a tree/branch with the new feature patches.
>
> So, the idea is that we'll use those two -git trees:
>         http://linuxtv.org/git//v4l-dvb.git     - Patches for linux-next
>         http://linuxtv.org/git//fixes.git       - Patches for upstream
>
> While we'll keep accepting patches via -hg, due to the merge conflicts its mentioned, the better is that,
> even those developers that prefer to develop patches use the old way, to send us the fixes via -git.
> This way, if is there a conflict, he is the one that can better solve it. Also, it avoids the risk of
> a patch being wrongly tagged.
>
> Also, after having a patch added on one of the above trees, we can't simply remove it, as others will
> be cloning that tree. So, the only option would be to send a revert patch, causing the patch history
> to be dirty and could be resulting on some troubles when submitting upstream. I've seen some nacks on
> receiving patches upstream from dirty git trees. So, we should really avoid this.
>
> 2) how to submit a -git pull request
>
> As the same git tree may have more than one branch, and we'll have 2 -git trees for upstream, it is required
> that people specify what should be done. Internally, my workflow is based on different mail queues for
> each type of requesting I receive. I have some scripts here to automate the proccess, so it is important
> that everyone sends me -git pull requests at the same way.
>
> So, I'm basically proposing that a -git pull request to be send with the following email tags:
>
> From: <your real email>
> Subject: [GIT FIX FOR 2.6.33] Fixes for driver cx88
> To: linux-media@vger.kernel.org
>
> The from line may later be used by the git mailbomb script to send you a copy when the patch were committed,
> so it should be your real email.
>
> The indication between [] on the subject will be handled by my mailer to put the request at the right
> queue. So, if tagged wrong, it may not be committed.
>
> Don't send a copy of the pull to my addresses. I'll be filtering based on the subject and on the mailing list.
> If you send a c/c to me, it will be simply discarded.
>
> NEVER send a copy of any pull request to a subscribers-only mailing list. Everyone is free to answer to the
> email, reviewing your patches. Don't penalty people that wants to contribute with you with SPAM bouncing emails,
> produced by subscribers only lists.
>
> When a patch touches on other subsystem codes, please copy the other subsystem maintainers. This is important
> for patches that touches on arch files, and also for -alsa non-trivial patches.
>
> The first line in the body should specify the tree and the branch. Something like:
>
>         Please pull from: git://linuxtv.org//mcctest/linux-2.6.git master
>
> Always send me the -git URL, followed by the branch name, both on the same line. The scripts will
> discard any comments that may appear before the tree/branch, but I'll read the entire email.
>
> At the email, please always send a summary of what's being send. Such summary is produced by
> this commands:
>         git diff -M --stat --summary $ORIGIN `git branch |grep ^\*|cut -b3-`
>         echo
>         git log --pretty=short $ORIGIN..|git shortlog
>
> where $ORIGIN is the commit hash of the tree before your patches.

Either that, or you can use following command:

http://www.kernel.org/pub/software/scm/git/docs/git-request-pull.html

;)

Regards,
Sergio

>
> For example, for the patches merged directly from -hg on my -git trees on Jan, 22 2010,
> the above commands will produce:
>
>  drivers/media/common/tuners/tuner-xc2028.c  |   11 +-
>  drivers/media/dvb/dm1105/Kconfig            |    1 +
>  drivers/media/dvb/dm1105/dm1105.c           |  501 ++++++++++++++-------------
>  drivers/media/video/cx18/Kconfig            |   11 +
>  drivers/media/video/cx18/Makefile           |    2 +
>  drivers/media/video/cx18/cx18-alsa-main.c   |  293 ++++++++++++++++
>  drivers/media/video/cx18/cx18-alsa-mixer.c  |  191 ++++++++++
>  drivers/media/video/cx18/cx18-alsa-mixer.h  |   23 ++
>  drivers/media/video/cx18/cx18-alsa-pcm.c    |  353 +++++++++++++++++++
>  drivers/media/video/cx18/cx18-alsa-pcm.h    |   27 ++
>  drivers/media/video/cx18/cx18-alsa.h        |   59 ++++
>  drivers/media/video/cx18/cx18-driver.c      |   40 ++-
>  drivers/media/video/cx18/cx18-driver.h      |   10 +
>  drivers/media/video/cx18/cx18-fileops.c     |    6 +-
>  drivers/media/video/cx18/cx18-fileops.h     |    3 +
>  drivers/media/video/cx18/cx18-mailbox.c     |   46 +++-
>  drivers/media/video/cx18/cx18-streams.c     |    2 +
>  drivers/media/video/cx25840/cx25840-core.c  |   48 ++-
>  drivers/media/video/ivtv/ivtv-irq.c         |    5 +-
>  drivers/media/video/ivtv/ivtv-streams.c     |    6 +-
>  drivers/media/video/ivtv/ivtv-udma.c        |    1 +
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c   |    1 +
>  drivers/media/video/saa7134/saa7134-cards.c |    4 +-
>  include/media/v4l2-subdev.h                 |    1 +
>  24 files changed, 1380 insertions(+), 265 deletions(-)
>  create mode 100644 drivers/media/video/cx18/cx18-alsa-main.c
>  create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.c
>  create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.h
>  create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.c
>  create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.h
>  create mode 100644 drivers/media/video/cx18/cx18-alsa.h
>
> Andy Walls (4):
>       V4L/DVB: cx25840, v4l2-subdev, ivtv, pvrusb2: Fix ivtv/cx25840 tinny audio
>       V4L/DVB: ivtv: Adjust msleep() delays used to prevent tinny audio and PCI bus hang
>       V4L/DVB: cx18-alsa: Initial non-working cx18-alsa files
>       V4L/DVB: cx18-alsa: Add non-working cx18-alsa-pcm.[ch] files to avoid data loss
>
> Devin Heitmueller (20):
>       V4L/DVB: xc3028: fix regression in firmware loading time
>       V4L/DVB: cx18: rename cx18-alsa.c
>       V4L/DVB: cx18: make it so cx18-alsa-main.c compiles
>       V4L/DVB: cx18: export a couple of symbols so they can be shared with cx18-alsa
>       V4L/DVB: cx18: overhaul ALSA PCM device handling so it works
>       V4L/DVB: cx18: add cx18-alsa module to Makefile
>       V4L/DVB: cx18: export more symbols required by cx18-alsa
>       V4L/DVB: cx18-alsa: remove unneeded debug line
>       V4L/DVB: cx18: rework cx18-alsa module loading to support automatic loading
>       V4L/DVB: cx18: cleanup cx18-alsa debug logging
>       V4L/DVB: cx18-alsa: name alsa device after the actual card
>       V4L/DVB: cx18-alsa: remove a couple of warnings
>       V4L/DVB: cx18-alsa: fix memory leak in error condition
>       V4L/DVB: cx18-alsa: fix codingstyle issue
>       V4L/DVB: cx18-alsa: codingstyle fixes
>       V4L/DVB: cx18: codingstyle fixes
>       V4L/DVB: cx18-alsa: codingstyle cleanup
>       V4L/DVB: cx18-alsa: codingstyle cleanup
>       V4L/DVB: cx18: address possible passing of NULL to snd_card_free
>       V4L/DVB: cx18-alsa: Fix the rates definition and move some buffer freeing code.
>
> Ian Armstrong (1):
>       V4L/DVB: ivtv: Fix race condition for queued udma transfers
>
> Igor M. Liplianin (4):
>       V4L/DVB: Add Support for DVBWorld DVB-S2 PCI 2004D card
>       V4L/DVB: dm1105: connect splitted else-if statements
>       V4L/DVB: dm1105: use dm1105_dev & dev instead of dm1105dvb
>       V4L/DVB: dm1105: use macro for read/write registers
>
> JD Louw (1):
>       V4L/DVB: Compro S350 GPIO change
>
> This helps to identify what's expected to be found at the -git tree and to double
> check if the merge happened fine.
>
> 3) Tags that a patch receive after its submission
>
> This is probably the most complex issue to solve. So, I'd like to see some suggestions here.
>
> Signed-off-by/Acked-by/Tested-by/Nacked-by tags may be received after a patch or a -git
> submission. This can happen even while the patch is being tested at linux-next, from
> people reporting problems on the existing patches, or reporting that a patch worked fine.
>
> Also, the driver maintainer and the subsystem maintainer that is committing those patches
> should sign each one, to indicate that he reviewed and has accepted the patch.
>
> Currently, if a new tag is added to a committed patch, its hash will change. I saw some
> discussions about allowing adding new tags on -git without changing the hash, but I think
> this weren't implemented (yet?).
>
> The same problem occurs with -hg, but, as -hg doesn't support multiple branches (well, it
> has a "branch" command, but the concept of branch there is different), it was opted that
> the -hg trees won't have all the needed SOBs. Instead, those would be added only at the
> submission tree.
>
> With -git, a better procedure can be used:
>
> The developer may have two separate branches on his tree. For example, let's assume that the
> developer has the following branches on his tree:
>         - media-master          (associated with "linuxtv" remote)
>         - fixes
>         - devel
>
> His development happens on devel branch. When the patches are ready to submission will be
> copied into a new for_submission branch:
>         git branch for_submission devel
>
> And a pull request from the branch "for_submission" will be sent.
>
> Eventually, he'll write new patches on his devel branch.
>
> After merged, the developer updates the linuxtv remote and drops the for_submission branch.
> This way, "media-master" will contain his patches that got a new hash, due to the maintainer's
> SOB. However, he has some new patches on his devel, that applies over the old hashes.
>
> Fortunately, git has a special command to automatically remove the old objects: git rebase.
>
> All the developer needs to do is:
>         git remote update       # to update his remotes, including "linuxtv"
>         git checkout devel      # move to devel branch
>         git pull . media-master # to make a recursive merge from v4l/dvb upstream
>         git rebase media-master # to remove the legacy hashes
>
> After this, his development branch will contain only upstream patches + the new ones he added
> after sending the patches for upstream submission.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
