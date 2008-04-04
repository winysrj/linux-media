Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m340XuLY015822
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 20:33:56 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m340Xg6l005366
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 20:33:43 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: hermann pitton <hermann-pitton@arcor.de>
Date: Fri, 4 Apr 2008 02:32:32 +0200
References: <1115343012.20080318233620@a-j.ru>
	<1207179525.14887.13.camel@pc08.localdom.local>
	<1207265002.3364.12.camel@pc08.localdom.local>
In-Reply-To: <1207265002.3364.12.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040232.33855@orion.escape-edv.de>
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

hermann pitton wrote:
> Am Donnerstag, den 03.04.2008, 01:38 +0200 schrieb hermann pitton:
> > Hi again,
> > 
> > Am Mittwoch, den 02.04.2008, 22:47 +0400 schrieb Andrew Junev:
> > > Hello Hermann,
> > > 
> > > Thanks a lot for this detailed explanation!
> > > I really appreciate your help!
> > > 
> > > One small question: does it mean that kernels 2.6.24.5 or 2.6.24.6
> > > _should_ have this patch already included?
> > > 
> > 
> > seems we hang in current stable kernel rules.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=Documentation/stable_kernel_rules.txt;hb=HEAD
> > 
> > If we go back to 2.6.23 level, that patch might have less than 100 lines
> > with context, but we break the
> > 
> >  - It must fix only one thing
> > 
> > rule, since we break the 2.6.24 LifeView Trio DVB-S support too then.
> > 
> > Seems sombody with such a device should reopen the bug on Bugzilla ...
> > 
> 
> Hi Guys,
> 
> should we really let hang it like this on 2.6.24?
> 
> I'm not that happy with a recommendation for the distributions to pick
> something out of it.
> 
> If we should go back to 2.6.23 level, so far nobody seems to have
> realized a improvement for the LifeView Trio stuff, I'm not against it.
> 
> The changeset in question to revert is mercurial 6579.
> 
> If nobody else is interested and no comments, I also don't care anymore.

(Basically I don't care because I am tired of discussing kernel
politics.)

Imho a fix should be applied, no matter how many lines it has.
If that is not possible the offending patch should be reverted in
2.6.24.x.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
