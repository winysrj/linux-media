Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MJIE05012825
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 15:18:14 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MJHWpC027350
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 15:17:33 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080422062938.0e491c0c.akpm@linux-foundation.org>
References: <20080421081639.GE26724@vidsoft.de>
	<20080421223751.GD9073@plankton.ifup.org>
	<1208822912.10519.24.camel@pc10.localdom.local>
	<20080422062938.0e491c0c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 21:17:04 +0200
Message-Id: <1208891824.3311.44.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	mchehab@infradead.org, stable@kernel.org
Subject: Re: 2.6.25 regression: vivi - scheduling while atomic
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Am Dienstag, den 22.04.2008, 06:29 -0700 schrieb Andrew Morton:
> > On Tue, 22 Apr 2008 02:08:32 +0200 hermann pitton <hermann-pitton@arcor.de> wrote:
> > Hi,
> > 
> > Am Montag, den 21.04.2008, 15:37 -0700 schrieb Brandon Philips:
> > > On 10:16 Mon 21 Apr 2008, Gregor Jasny wrote:
> > > > Call Trace:
> > > >  [<ffffffff803efc9b>] schedule+0xe5/0x5c7
> > > >  [<ffffffff80251c90>] __rmqueue_smallest+0x88/0x107
> > > >  [<ffffffff8023e84b>] getnstimeofday+0x2f/0x83
> > > >  [<ffffffff8023cf8a>] ktime_get_ts+0x17/0x48
> > > >  [<ffffffff803f0424>] schedule_timeout+0x1e/0xad
> > > >  [<ffffffff80220498>] enqueue_task+0x13/0x1e
> > > >  [<ffffffff803efab8>] wait_for_common+0xf6/0x16b
> > > >  [<ffffffff802230a0>] default_wake_function+0x0/0xe
> > > >  [<ffffffff8023a270>] kthread_create+0xa3/0x108
> > > >  [<ffffffff880d2471>] :vivi:vivi_thread+0x0/0x779
> > > >  [<ffffffff802634cb>] remap_vmalloc_range+0xa1/0xe6
> > > >  [<ffffffff80231242>] lock_timer_base+0x26/0x4c
> > > >  [<ffffffff8023138e>] __mod_timer+0xb6/0xc5
> > > >  [<ffffffff880d23fc>] :vivi:vivi_start_thread+0x54/0xc9
> > > >  [<ffffffff88053603>] :videobuf_core:videobuf_streamon+0x6c/0xaa
> > > >  [<ffffffff8809dba3>] :videodev:__video_do_ioctl+0x1327/0x2ad9
> > > >  [<ffffffff80222d76>] __wake_up+0x38/0x4f
> > > >  [<ffffffff80242f1f>] futex_wake+0xdb/0xfa
> > > >  [<ffffffff8809f6ab>] :videodev:video_ioctl2+0x17c/0x210
> > > >  [<ffffffff8025bb36>] handle_mm_fault+0x6b1/0x6cb
> > > >  [<ffffffff8027b47d>] vfs_ioctl+0x55/0x6b
> > > >  [<ffffffff8027b6e6>] do_vfs_ioctl+0x253/0x264
> > > >  [<ffffffff8027b733>] sys_ioctl+0x3c/0x5d
> > > >  [<ffffffff8020afcb>] system_call_after_swapgs+0x7b/0x80
> > > >
> > > > This happenes on a vanilla 2.6.25 with loaded nvidia graphics module.
> > > > System architecture is x86_64. If it matters I'll try to reproduce this
> > > > error on a non tainted kernel.
> > > 
> > > No need to reproduce on a non-tainted Kernel.  This is a known issue
> > > with patches merged into the v4l-dvb tree several weeks ago but it seems
> > > to not have made it into 2.6.25 :(
> > > 
> > >  http://linuxtv.org/hg/v4l-dvb/rev/06eb92ed0b18
> > >  http://linuxtv.org/hg/v4l-dvb/rev/c50180f4ddfc
> > > 
> > > I can rebase the patches for 2.6.25 but they are too big to go into the
> > > stable 2.6.25 tree...
> > > 
> > > Thanks for the report,
> > > 
> > > 	Brandon
> > > 
> > 
> > hmm, because of that 100 lines only rule including offsets?
> > 
> > The current v4l-dvb on 2.6.24 has 233 modules.
> > 
> > It is usual that changes, if needed, are going over lots of them.
> > 
> > How far one can come with _such_ rules, given that one single line
> > changed counts up to seven with the offsets?
> > 
> > How can one even comment on that brain damage?
> > 
> 
> There is no "100 line rule" for -stable patches, if that is what you were
> referring to.
> 
> Please just send the patches to stable@kernel.org, along with a full
> description of why they are needed in 2.6.25.x.  If those fine folk see a
> problem with merging the patches then they will explain that problem and
> discussion will ensue.  It will not involve the term "100 line rule"!

Yes, the people are fine and it is always worth to show them possible
fixes.

However, recently I was close to give up on forwarding a fix to
2.6.24.4. It didn't get the usual immediate attention of our guys
forwarding such, likely also because it was about some exotic details on
22kHz tone generation on new or rare cards and difficult to test on all
affected drivers and cards and had a 9 months history.

Also there was a report on bugzilla, that a patch, which was for testing
on the lists, fixed one of the newer cards, but we still had no reports
yet what happened with the older. No testers available. It went into the
2.6.24 release and only recently we got the reports for the older cards,
broken by us ...

Considering to send the fix myself to stable I did read
Documentation/stable_kernel_rules and started ranting at home :)

For the price that we'll have support for lots of new card types now and
in the future, we have a bug on 2.6.24 and we hang on a 100 line rule to
fix it?

It helped immediately, but better would be to improve that text.
The 100 line rule is there, see below. It might cause that people not
even try to submit.

Also that one needs to run checkpatch.pl against such will cause a lot
of unrelated fixes in the offsets on the old code we have around.

Thanks,
Hermann


Everything you ever wanted to know about Linux 2.6 -stable releases.

Rules on what kind of patches are accepted, and which ones are not, into the
"-stable" tree:

 - It must be obviously correct and tested.
 - It cannot be bigger than 100 lines, with context.
 - It must fix only one thing.
 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).
 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.
 - No "theoretical race condition" issues, unless an explanation of how the
   race can be exploited is also provided.
 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).
 - It must follow the Documentation/SubmittingPatches rules.
 - It or an equivalent fix must already exist in Linus' tree.  Quote the
   respective commit ID in Linus' tree in your patch submission to -stable.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
