Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NHZPUj009104
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 13:35:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NHZEFJ018303
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 13:35:14 -0400
Date: Wed, 23 Apr 2008 14:34:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080423143454.0d50b209@gaivota>
In-Reply-To: <480B6AD8.9090404@linuxtv.org>
References: <20080420122736.20d60eff@the-village.bc.nu>
	<200804201806.33464.hverkuil@xs4all.nl>
	<480B6AD8.9090404@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Frank Bennett <biercenator@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
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

On Sun, 20 Apr 2008 12:10:00 -0400
Michael Krufky <mkrufky@linuxtv.org> wrote:

> Hans Verkuil wrote:
> > On Sunday 20 April 2008 13:27:36 Alan Cox wrote:
> >   
> >> Frank Bennett reported that ivtv was causing skype to crash. With
> >> help from one of their developers he showed it was a kernel problem.
> >> VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
> >> that are too long and does not truncate them so corrupts a few bytes
> >> of the app data area.
> >>
> >> Possibly the names also want trimming but for now this should fix the
> >> corruption case.
> >>     
> >
> > Ouch, nasty one.
> >
> > Mauro, can you apply this patch to the v4l-dvb master?
> >
> > Mike, this one should obviously go into a 2.6.25 dot-release, and I 
> > think also to a 2.6.24 dot-release.
> >
> > Frank, thank you for reporting this!
> >
> > 	Hans
> >
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> >   
> 
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

In this case, it should be reviewed-by.

I should be sending this soon to Linus.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
