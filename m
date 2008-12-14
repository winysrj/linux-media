Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBELMwMX021116
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 16:22:58 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBELMiQ8027449
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 16:22:44 -0500
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0812140650s6e13a1b2nca4b0ebe8266b3bb@mail.gmail.com>
References: <de8cad4d0812090930k75d973em4f21d36777ee02a2@mail.gmail.com>
	<1228867386.3283.36.camel@morgan.walls.org>
	<de8cad4d0812140650s6e13a1b2nca4b0ebe8266b3bb@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 14 Dec 2008 16:19:59 -0500
Message-Id: <1229289599.3154.17.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: Changes in cx18 - Request more info
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

On Sun, 2008-12-14 at 09:50 -0500, Brandon Jenkins wrote:
> On Tue, Dec 9, 2008 at 7:03 PM, Andy Walls <awalls@radix.net> wrote:
> 
> > So maybe I'd try something like this for a one card system running myth
> > TV watching live TV:
> >
> > modprobe cx18 enc_mpg_bufs=128 enc_mpg_bufsize=16 enc_ts_bufs=64 \
> >        enc_ts_bufsize=16 enc_yuv_bufs=0
> >
> > I have no data recorded on PCM data buffer depth required, but the
> > default seems a little ridiculous now: 277 buffers of 4 kB.  I left that
> > that way as it was: close to the approximate amount being allocated
> > before - but I think it's way overkill.
> >
> >
> > Anyway happy testing!  Let me know how it goes.  My initial cut at it
> > over the weekend had mystery buffer handling problems that resulted in
> > frequent artifacts in the MPEG stream.  By Sunday afternoon I had it
> > worked out using a new technique for moving buffers around.
> >
> >
> > After this, I'm getting the raw VBI changes worked in, some firmware
> > loading changes (in hopes to improve audio problems) and a laundry list
> > of items ivtv-* list users have collected for me to fix to get rid of
> > video/audio skips, and reported PAL problems.
> >
> >
> > Regards,
> > Andy
> >
> Andy,
> 
> I used the above changes with a pull from this morning and I have not
> seen any artifacts in the images thusfar (about 2 hours of TV). This
> is a huge improvement. The only other issue I am seeing is a frequent
> pausing of the feed which lasts about 1-2 seconds and resumes.

There is the CVBS and SVideo audio/video sync which may cause this to
happen.  This may be realted to that problem, which I yet to address.

It also could be that the firmware actually ran out of buffers.  If
v4l2-ctl --log-status shows the stream using almost at the buffers at
some particular time (close to 100% in use in q_full waiting for an app
to read data) then that can be the cause of the pause.  I think that is
unlikely.  I only ever get that when I intentionally pause mplayer.


>  dmesg
> indicates the following:
> 
> cx18-1 warning: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs
> for RPU acknowledgement

I don't know why the firmware doesn't give us an interrupt response
sometimes within 10 msecs.  It just happens...


> cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
> CPU to EPU mailbox (sequence no. 174380) while processing
> cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
> CPU to EPU mailbox (sequence no. 175357) while processing

The message that ends "while processing" is OK.  It means we got a good
copy of the mailbox, but by the time we went to Ack it to the firmware,
the firmware had moved on.  It indicates that your system is on the
"cusp".  You should not make individual transfer buffers any smaller for
this stream type.

[snip]

> cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
> CPU to EPU mailbox (sequence no. 178948)

This means we're processing a stale mailbox, which hopefully the
firmware hasn't changed yet.  You want to avoid this situation happening
too often.  Again, don't set individual transfer buffers sizes any
smaller to avoid increasing the frequency of these.



> In a three card system, should I increase the buffers allocated or
> decrease for performance?

If you're doing lots of simultaneous recordings and very little live TV,
I'd make the individual transfer buffers larger, and keep the number of
buffers per stream at a moderate to large level.  That way you'll
decrease the frequency of the "Possibly falling behind" messages, but
you'll also keep the firmware with a good amount of buffers if the app
takes time to pull buffers out of the driver.

You should check the v4l2-ctl --log-status out for each card every so
often to see how many of the buffers for a stream are ever in use (i.e.
in q_full waiting to be read by applications) at once.

The number of buffers you'd ideally want is that high watermark you'd
ever encounter in q_full + anywhere from 2 to 63 more buffers for the
firmware to have for use.  Anymore is really a waste.  Since the digital
TS never uses q_full but does have one buffer floating at times, you'd
never want more than 64 buffers for those streams.  Anymore would be a
waste.


>  Is this part of the issues you're tracking
> from the ivtv list?

Somewhat.  There's an issue with audio/video sync and possible stalls
when using CVBS or SVideo which is the last real plague to resolve.


Regards,
Andy

> Thanks again for all of your efforts.
> 
> Brandon
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
