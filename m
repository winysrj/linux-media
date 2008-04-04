Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34Ct1Yp024494
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 08:55:01 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m34Cskdh029519
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 08:54:46 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Date: Fri, 4 Apr 2008 14:02:12 +0200
References: <1115343012.20080318233620@a-j.ru>
	<200804040456.57561@orion.escape-edv.de>
	<47F5AB2A.3020908@linuxtv.org>
In-Reply-To: <47F5AB2A.3020908@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041402.13210@orion.escape-edv.de>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
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

Michael Krufky wrote:
> Oliver Endriss wrote:
> > Mauro Carvalho Chehab wrote:
> >   
> >>>>> If we should go back to 2.6.23 level, so far nobody seems to have
> >>>>> realized a improvement for the LifeView Trio stuff, I'm not against it.
> >>>>>
> >>>>> The changeset in question to revert is mercurial 6579.
> >>>>>
> >>>>> If nobody else is interested and no comments, I also don't care anymore.
> >>>>>           
> >>>> (Basically I don't care because I am tired of discussing kernel
> >>>> politics.)
> >>>>
> >>>> Imho a fix should be applied, no matter how many lines it has.
> >>>> If that is not possible the offending patch should be reverted in
> >>>> 2.6.24.x.
> >>>>         
> >> ...
> >>
> >> Let me try to reset to a sane state.
> >>
> >> With the current tree (changesets 6579 and 7186), is there any broken board? If
> >> so, what board(s)?
> >>
> >> Both patches are already applied at mainstream and should be available on
> >> 2.6.25. Are those OK for 2.6.25?
> >>
> >> Is there any missing patch that should be sent to -stable (2.6.24)? If so, what
> >> patch?
> >>     
> >
> > The point is that 6579 was applied to 2.6.24.x, but 7186 wasn't.
> > So TTS_1401 support is broken for the 2.6.24 series.
> >
> > Imho 7186 _must_ be applied to 2.6.24, no matter how large the patch is.
> >   
> Are you saying that THIS is the patch that needs to be applied to 2.6.24.y ?
> 
> http://linuxtv.org/hg/v4l-dvb/rev/eb6bc7f18024
> 
> If so, this patch seems fine for -stable.  We just have to make sure it
> applies correctly, etc.

Correct, this is the patch.
I did a quick check: It applies to 2.6.24.2 with some hunks.

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
