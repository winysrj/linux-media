Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78Eaqqe008477
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:36:52 -0400
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m78EacKq007625
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:36:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Fri, 8 Aug 2008 16:35:20 +0200
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
In-Reply-To: <1218205108.3003.44.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081635.20640.hverkuil@xs4all.nl>
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

On Friday 08 August 2008 16:18:28 Andy Walls wrote:
> On Thu, 2008-08-07 at 09:36 -0400, Brandon Jenkins wrote:
> > On Wed, Aug 6, 2008 at 8:55 PM, Andy Walls <awalls@radix.net> wrote:
> > > from the offending build to me.  That way I can see the assembled
> > > machine code and verify where in the function the NULL
> > > dereference is happening.
> > >
> > > If you have the exact same problem as me, I can give you a
> > > "band-aid" patch which will lessen the problem in short order. 
> > > It'll be a band aid because it won't fix the accounting problem
> > > though.  I need to do more extensive test and debug to find out
> > > where the accounting of buffers is getting screwed up.
> > >
> > > Regards,
> > > Andy
>
> Brandon,
>
> I have checked in a fix to defend against the Ooops we both
> encountered. The fix will also generate a WARN dump and some queue
> stats when it runs across the cause, but will otherwise try to clean
> up as best it can to allow further operation.
>
> The band-aid fix is the latest change at
>
> http://linuxtv.org/hg/~awalls/v4l-dvb
>
> Please provide the extra debug that happens if you encounter the
> warning in your logs.  I have only encountered the problem twice over
> a several month period, so its hard to get insight into the root
> cause buffer accounting error at that rate.
>
>
> Hans,
>
> The provided patch is a bit ugly, so I'm not sure I want it to go to
> the main repo as is.  Since the cx18_queue_move() and
> cx18_queue_move_buf() functions are a bit general for how cx18 is
> using them (compared to ivtv) and a bit confusing at first, I was
> going to rewrite them down to the minimum needed for cx18.  Do you
> have any objection?

No objection at all. If you look at where cx18_queue_move is used, then 
you'll notice that it is only in cx18_flush_queues(). And all it has to 
do there is to move any buffers in the q_io or q_full queue to the 
q_free queue and initialize all those buffers to their initial state. 
You do not need all that complicated code for that. I suggest that you 
make a new function instead that replaces cx18_queue_move and 
cx18_queue_move_buf.

> I normally like the fact that cx18 mirrors ivtv in many aspects as it
> provides an certain economy for common bug fixes.  Here I think cx18
> is carrying complexity and unused code (and maybe bugs) for only that
> reason.

Definitely. These two functions should be replaced for the cx18.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
