Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:13725 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab1BLUsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 15:48:01 -0500
Subject: Re: [get-bisect results]: DViCO FusionHDTV7 Dual Express I2C write
 failed
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Zimmerman <markzimm@frii.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110212190504.GA43693@io.frii.com>
References: <20101207190753.GA21666@io.frii.com>
	 <20110212152954.GA20838@io.frii.com> <1297528048.2413.22.camel@localhost>
	 <20110212163607.GA27853@io.frii.com> <1297529173.2413.32.camel@localhost>
	 <20110212190504.GA43693@io.frii.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Feb 2011 15:48:07 -0500
Message-ID: <1297543687.2413.41.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-02-12 at 12:05 -0700, Mark Zimmerman wrote:
> On Sat, Feb 12, 2011 at 11:46:13AM -0500, Andy Walls wrote:
> > On Sat, 2011-02-12 at 09:36 -0700, Mark Zimmerman wrote:
> > > On Sat, Feb 12, 2011 at 11:27:27AM -0500, Andy Walls wrote:
> > > > On Sat, 2011-02-12 at 08:29 -0700, Mark Zimmerman wrote:
> > > > > On Tue, Dec 07, 2010 at 12:07:53PM -0700, Mark Zimmerman wrote:
> > > > > > Greetings:
> > > > > > 
> > > > > > I have a DViCO FusionHDTV7 Dual Express card that works with 2.6.35 but
> > > > > > which fails to initialize with the latest 2.6.36 kernel. The firmware
> > > > > > fails to load due to an i2c failure. A search of the archives indicates
> > > > > > that this is not the first time this issue has occurred.
> > > > > > 
> > > > > > What can I do to help get this problem fixed?
> > > > > > 
> > > > > > Here is the dmesg from 2.6.35, for the two tuners: 
> > > > > > 
> > > > > > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > > > > > xc5000: firmware read 12401 bytes. 
> > > > > > xc5000: firmware uploading... 
> > > > > > xc5000: firmware upload complete... 
> > > > > > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > > > > > xc5000: firmware read 12401 bytes. 
> > > > > > xc5000: firmware uploading... 
> > > > > > xc5000: firmware upload complete..
> > > > > > 
> > > > > > and here is what happens with 2.6.36: 
> > > > > > 
> > > > > > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > > > > > xc5000: firmware read 12401 bytes. 
> > > > > > xc5000: firmware uploading... 
> > > > > > xc5000: I2C write failed (len=3) 
> > > > > > xc5000: firmware upload complete... 
> > > > > > xc5000: Unable to initialise tuner 
> > > > > > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > > > > > xc5000: firmware read 12401 bytes. 
> > > > > > xc5000: firmware uploading... 
> > > > > > xc5000: I2C write failed (len=3) 
> > > > > > xc5000: firmware upload complete...
> > > > > > 
> > > > > 
> > > > > I did a git bisect on this and finally reached the end of the line.
> > > > > Here is what it said:
> > > > > 
> > > > > qpc$ git bisect bad
> > > > > 82ce67bf262b3f47ecb5a0ca31cace8ac72b7c98 is the first bad commit
> > > > > commit 82ce67bf262b3f47ecb5a0ca31cace8ac72b7c98
> > > > > Author: Jarod Wilson <jarod@redhat.com>
> > > > > Date:   Thu Jul 29 18:20:44 2010 -0300
> > > > > 
> > > > >     V4L/DVB: staging/lirc: fix non-CONFIG_MODULES build horkage
> > > > >     
> > > > >     Fix when CONFIG_MODULES is not enabled:
> > > > >     
> > > > >     drivers/staging/lirc/lirc_parallel.c:243: error: implicit declaration of function 'module_refcount'
> > > > >     drivers/staging/lirc/lirc_it87.c:150: error: implicit declaration of function 'module_refcount'
> > > > >     drivers/built-in.o: In function `it87_probe':
> > > > >     lirc_it87.c:(.text+0x4079b0): undefined reference to `init_chrdev'
> > > > >     lirc_it87.c:(.text+0x4079cc): undefined reference to `drop_chrdev'
> > > > >     drivers/built-in.o: In function `lirc_it87_exit':
> > > > >     lirc_it87.c:(.exit.text+0x38a5): undefined reference to `drop_chrdev'
> > > > >     
> > > > >     Its a quick hack and untested beyond building, since I don't have the
> > > > >     hardware, but it should do the trick.
> > > > >     
> > > > >     Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > > >     Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > > > >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > > > > 
> > > > > :040000 040000 f645b46a07b7ff87a2c11ac9296a5ff56e89a0d0 49e50945ccf8e1c8567c049908890d2752443b72 M      drivers
> > > > 
> > > > Hmm.  git log --patch 82ce67bf262b3f47ecb5a0ca31cace8ac72b7c98 shows the
> > > > commit is completely unrealted.
> > > > 
> > > > Please try and see if things are good or bad at commit
> > > > 18a87becf85d50e7f3d547f1b7a75108b151374d:
> > > > 
> > > >         commit 18a87becf85d50e7f3d547f1b7a75108b151374d
> > > >         Author: Jean Delvare <khali@linux-fr.org>
> > > >         Date:   Sun Jul 18 17:05:17 2010 -0300
> > > >         
> > > >             V4L/DVB: cx23885: i2c_wait_done returns 0 or 1, don't check for < 0 return v
> > > >             
> > > >             Function i2c_wait_done() never returns negative values, so there is no
> > > >             point in checking for them.
> > > >             
> > > >             Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > >             Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > > >             Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > > >         
> > > > Which is the first commit, prior to the one you found, that seems to me
> > > > to have any direct bearing to I2C transactions.
> > > > 
> > > > If that commit is good, then these commits in between would be my next
> > > > likely suspects:
> > > > e5514f104d875b3d28cbcd5d4f2b96ab2fca1e29
> > > > dbe83a3b921328e12b2abe894fc692afba293d7f
> > > > 
> > > > Regards,
> > > > Andy
> > > > 
> > > 
> > > Sorry to require so much hand holding, but I am new to all of this git
> > > gymnastics. Would you mind sending me the correct git command to get
> > > to a specific commit?
> > 
> > It should just be
> > 
> > $ git checkout 18a87becf85d50e7f3d547f1b7a75108b151374d
> > 
> > or whatever the commit number git log shows you for the change I suspect
> > is the problem.
> > 
> > 
> > >  Also, do I need to do a bisect reset?
> > 
> > I wouldn't reset the git bisect yet.  If you test a commit and it is
> > good, you will want to mark it with 'git bisect good <commit-hash>', and
> > if it is bad, you will want to mark it with 'git bisect bad
> > <commit-hash>'
> 
> OK, I did a git checkout 18a87becf85d50e7f3d547f1b7a75108b151374d and
> turned CONFIG_STAGING back on in .config and the kernel built fine.
> The i2c problem is there, however.
> 
> I wonder if I should start over with a reset, then replay the good/bad
> commands up to the last good one, then do git bisect bad 18a8... and
> proceed from there. Does that make sense?

Well, looking at your git bisect log, the last known good declaration
you made was:

efce8ca3c5d8a35018f801d687396e1911cfc868 (July 29, 2010)

which comes after

18a87becf85d50e7f3d547f1b7a75108b151374d (July 18, 2010)

which you say just tested bad.  Also the previous one declared good,
9895850b23886e030cd1e7241d5529a57e969c3d, happens after both of those.
One or more of those declarations has to be incorrect.

So there's either something not quite right with your build/install/test
process or you're dealing with a bug that intermittently does not show
symptoms.

So my recommendations:

1. Turn CONFIG_STAGING off.  git bisect doesn't really care, but if the
flaky drivers in there are causing problem with some kernel builds, then
they are wasting your time - don't compile them.


2. When using git bisect to make declarations:

good means the *precise* symptoms that you care about do not manifest 
bad  means the *precise* symptoms that you care about do manifest

Don't use bad for "the kernel didn't build".  use git bisect skip for
that case and git will try to pick another nearby commit.


3. Make sure with every kernel iteration you rebuild all the kernel
source and modules you have configured to be built, install the newly
built modules and the newly built kernel, and reboot.  Not rebuilding
everything you are installing may invalidate your testing.


4. Yeah you'll probably need to restart the git bisect process with
commits you have high confidence are known good and known bad.  For your
I2C & XC5000 related problem you can limit git bisect to changes in: 

	drivers/media include/media drivers/i2c include/linux/i2c*

which might keep the number of iterations down.  'git help bisect' shows
the manual page.  The command would look something like:

$ git bisect start <bad-commit> <good-commit> -- drivers/media include/media drivers/i2c include/linux/i2c*

Where <good-commit> is a commit hash or version tags that should have
been before the <bad-commit> commit hash or version tag.  Note that git
log outputs commits in reverse chronological order (newest first).

5.  When testing each kernel iteration, try to test such that you
hopefully avoid any "false good" indications caused by intermittent
behavior of the bug.  I have no recommendation on what would constitute
a thorough enough test.

Regards,
Andy



