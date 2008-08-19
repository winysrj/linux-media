Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7J0dicU032500
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 20:39:44 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7J0dWD6007588
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 20:39:32 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0808181017q1c2467c2g74973deb1c70db97@mail.gmail.com>
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
	<de8cad4d0808111433y4620b726wc664a06d7422e883@mail.gmail.com>
	<1218939204.3591.25.camel@morgan.walls.org>
	<de8cad4d0808180335l7a6f9377m97c3eff844e187ee@mail.gmail.com>
	<de8cad4d0808181017q1c2467c2g74973deb1c70db97@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 20:34:16 -0400
Message-Id: <1219106056.2687.39.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Waffle Head <narflex@gmail.com>, video4linux-list@redhat.com,
	linux-dvb@linuxtv.org, ivtv-devel@ivtvdriver.org
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

On Mon, 2008-08-18 at 13:17 -0400, Brandon Jenkins wrote:
> On Mon, Aug 18, 2008 at 6:35 AM, Brandon Jenkins <bcjenkins@tvwhere.com> wrote:
> > On Sat, Aug 16, 2008 at 10:13 PM, Andy Walls <awalls@radix.net> wrote:
> >> On Mon, 2008-08-11 at 17:33 -0400, Brandon Jenkins wrote:
> >>> On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net> wrote:
> >>> > Brandon,
> >>> >
> >>> > I have checked in a fix to defend against the Ooops we both encountered.
> >>> > The fix will also generate a WARN dump and some queue stats when it runs
> >>> > across the cause, but will otherwise try to clean up as best it can to
> >>> > allow further operation.
> >>> >
> >>> > The band-aid fix is the latest change at
> >>> >
> >>> > http://linuxtv.org/hg/~awalls/v4l-dvb
> >>> >
> >>> > Please provide the extra debug that happens if you encounter the warning
> >>> > in your logs.  I have only encountered the problem twice over a several
> >>> > month period, so its hard to get insight into the root cause buffer
> >>> > accounting error at that rate.
> >>>
> >>> Andy,
> >>>
> >>> I had an oops today, first one in a few days
> >>>
> >>> Brandon
> >>
> >> Brandon & Jeff,
> >>
> >> I have updated my repo at
> >>
> >> http://linuxtv.org/hg/~awalls/v4l-dvb
> >>
> >> with 3 changes:
> >>
> >> 1. Back out the original band aid fix
> >> 2. Simplify the queue flush routines (you will not see that oops again)
> >> 3. Fix the interrupt handler to obtain a queue lock (prevents queue
> >> corruption)
> >>
> >> >From most of the output you provided, it was pretty obvious that q_full
> >> was always claiming to have more buffers that it actually did.  I
> >> hypothesized this could come about at the end of a capture when the
> >> encoder hadn't really stopped transferring buffers yet (after we told it
> >> to stop) and then we try to clear q_full while the interrupt handler is
> >> still trying to add buffers.  This could happen because the interrupt
> >> handler never (ever) properly obtained a lock for manipulating the
> >> queues.  This could have been causing the queue corruption.
> >>
> >> Please test.  I need feedback that I haven't introduced a deadlock.
> >>
> >> It also appears that the last change requiring the interrupt handler to
> >> obtain a lock, completely mitigates me having to use the "-cache 8192"
> >> option to mplayer for digital captures, and greatly reduces the amount
> >> of cache I need to have mplayer use for analog captures.
> >>
> > [snip]
> >
> > Andy,
> >
> > I have update to the new code. Interestingly now I am getting audio
> > noises (chirping) while watching TV. Is there anything which has been
> > done that could affect sound?
> >
> > Otherwise no issues thus far.
> >
> > Brandon
> >
> Andy,
> 
> I also seeing these messages in dmesg:
> 
> [65288.817420] cx18-0: Cannot find buffer 58 for stream TS
> [65288.817440] cx18-0: Could not find buf 58 for stream TS
[9.2 minute interval]
> [65840.130797] cx18-0: Cannot find buffer 17 for stream TS
> [65840.130797] cx18-0: Could not find buf 17 for stream TS
[21 second interval]
> [65861.882721] cx18-0: Cannot find buffer 48 for stream TS
> [65861.882741] cx18-0: Could not find buf 48 for stream TS
[4.8 minute interval]
> [66151.627392] cx18-0: Cannot find buffer 107 for stream encoder MPEG
> [66151.627392] cx18-0: Could not find buf 107 for stream encoder MPEG
[24.7 minute interval]
> [67632.953680] cx18-0: Cannot find buffer 99 for stream encoder MPEG
> [67632.953680] cx18-0: Could not find buf 99 for stream encoder MPEG
[2.7 miunte interval]
> [67795.527911] cx18-0: Cannot find buffer 106 for stream encoder MPEG
> [67795.527911] cx18-0: Could not find buf 106 for stream encoder MPEG

So the encoder is saying it has buffers ready for a particular stream,
but we now occasionally can't find that buffer in q_free for the stream.

The funny part is that since the streams are alloc'ed in order at init
time, buffer id's 0-62 (or so) are used for stream MPEG and buffer id's
63-127 (or so) are used for stream TS.  The warnings clearly show a
mismatch.


So the warning messages above shows that either

a) the encoder firmware has a bug that it gives us back a buffer with
the wrong buffer id/stream handle pair

b) the cx18 driver somehow gives the wrong stream handle/buffer id pair
to the encoder firmware occasionally when giving it a buffer to use.

In the case of a) it's probably best to ignore the buffer it's best to
ignore the buffer from the encoder as who knows what's really in the
buffer.  If this happens 63 times for one capture during simultaneous
analog & digital captures, I think the encoder may get starved of
buffers for the other stream.  I'll have to check the code to make to
see what can be done to prevent that.

I'll also have to audit the code to see if case b) can happen somehow.


Off the cuff, these warnings seem unrelated to the test patch I
provided.  I can't begin to look at the problem until at least Friday.
Hopefully you can get by OK for now with the event happening on the
order of every 5 minutes or so.

Regards,
Andy

> Brandon
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
