Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m780r8l0030522
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 20:53:08 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m780pfN6014804
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 20:51:41 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 20:46:34 -0400
Message-Id: <1218156394.2744.9.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: CX18 Oops
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

On Thu, 2008-08-07 at 09:36 -0400, Brandon Jenkins wrote:
> On Wed, Aug 6, 2008 at 8:55 PM, Andy Walls <awalls@radix.net> wrote:
> > On Wed, 2008-08-06 at 06:57 -0400, Brandon Jenkins wrote:
> >> On Tue, Aug 5, 2008 at 9:29 PM, Andy Walls <awalls@radix.net> wrote:
> >> > On Tue, 2008-08-05 at 21:04 -0400, Brandon Jenkins wrote:

> >
> > Nope.  The problem I have has to do with per stream queue and buffer
> > accounting being slightly but you'll only notice when it's being freed.
> >
> > I suspect you have the same problem, but I can't tell for sure as you
> > system is compiling the code differently than mine.
> >
> > Could you please send the output of
> >
> > $ cd v4l-dvb
> > $ objdump -D v4l/cx18-queue.o
> >
> > from the offending build to me.  That way I can see the assembled
> > machine code and verify where in the function the NULL dereference is
> > happening.
> >
> > If you have the exact same problem as me, I can give you a "band-aid"
> > patch which will lessen the problem in short order.  It'll be a band aid
> > because it won't fix the accounting problem though.  I need to do more
> > extensive test and debug to find out where the accounting of buffers is
> > getting screwed up.
> >
> > Regards,
> > Andy
> 
> Andy,
> 
> Reposting with the file hosted in my dropbox instead. I didn't realize
> there was a size limit on the devel list.

Brandon,

I got the file anyway.  You have the exact same problem I had in the
oops.  Ubuntu's compilation options appear to be a little more
aggressive than Fedora's, but it's the same NULL pointer.

The problem is when moving all the buffers for a stream back to the
q_free queue, it appears the source queue claims to have more bytes to
move back to q_free than it actually does.  The old general purpose
code, copied from ivtv I think, then tries to steal buffers from another
queue to satisfy the request to move all the remaining bytes that the
first queue lied about having. But there is no queue to steal from, so
you deref a NULL pointer.

I'll have a quick fix sometime tomorrow.  It's been a long day and
experience tells me I'll only code up bugs tonight when I'm tired. :)

Regards,
Andy



> Brandon
> 
> https://dl.getdropbox.com/u/4976/cx18-queue.o.objdump.tar.gz
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
