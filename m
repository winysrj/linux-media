Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m340iXg6023364
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 20:44:33 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m340iA5f011694
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 20:44:10 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Oliver Endriss <o.endriss@gmx.de>
In-Reply-To: <200804040232.33855@orion.escape-edv.de>
References: <1115343012.20080318233620@a-j.ru>
	<1207179525.14887.13.camel@pc08.localdom.local>
	<1207265002.3364.12.camel@pc08.localdom.local>
	<200804040232.33855@orion.escape-edv.de>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 02:43:58 +0200
Message-Id: <1207269838.3365.4.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Am Freitag, den 04.04.2008, 02:32 +0200 schrieb Oliver Endriss:
> hermann pitton wrote:
> > Am Donnerstag, den 03.04.2008, 01:38 +0200 schrieb hermann pitton:
> > > Hi again,
> > > 
> > > Am Mittwoch, den 02.04.2008, 22:47 +0400 schrieb Andrew Junev:
> > > > Hello Hermann,
> > > > 
> > > > Thanks a lot for this detailed explanation!
> > > > I really appreciate your help!
> > > > 
> > > > One small question: does it mean that kernels 2.6.24.5 or 2.6.24.6
> > > > _should_ have this patch already included?
> > > > 
> > > 
> > > seems we hang in current stable kernel rules.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=Documentation/stable_kernel_rules.txt;hb=HEAD
> > > 
> > > If we go back to 2.6.23 level, that patch might have less than 100 lines
> > > with context, but we break the
> > > 
> > >  - It must fix only one thing
> > > 
> > > rule, since we break the 2.6.24 LifeView Trio DVB-S support too then.
> > > 
> > > Seems sombody with such a device should reopen the bug on Bugzilla ...
> > > 
> > 
> > Hi Guys,
> > 
> > should we really let hang it like this on 2.6.24?
> > 
> > I'm not that happy with a recommendation for the distributions to pick
> > something out of it.
> > 
> > If we should go back to 2.6.23 level, so far nobody seems to have
> > realized a improvement for the LifeView Trio stuff, I'm not against it.
> > 
> > The changeset in question to revert is mercurial 6579.
> > 
> > If nobody else is interested and no comments, I also don't care anymore.
> 
> (Basically I don't care because I am tired of discussing kernel
> politics.)
> 
> Imho a fix should be applied, no matter how many lines it has.
> If that is not possible the offending patch should be reverted in
> 2.6.24.x.
> 
> CU
> Oliver


I fully agree!

But that is exactly where they hang us and I have it totally sick,
especially in combination with current checkpatch.pl brain damage.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
