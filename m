Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA04hbg011913
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 19:04:43 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA04R0g028586
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 19:04:27 -0500
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0812090930k75d973em4f21d36777ee02a2@mail.gmail.com>
References: <de8cad4d0812090930k75d973em4f21d36777ee02a2@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 19:03:06 -0500
Message-Id: <1228867386.3283.36.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

On Tue, 2008-12-09 at 12:30 -0500, Brandon Jenkins wrote:
> Hi Andy,
> 
> I noticed you made some code updates in your tree and I am anxious to
> try them out. Based on the info provided in your notes,

If trying stuff out early, only use the stuff from 

http://linuxtv.org/hg/~awalls/v4l-dvb

I've tested it on one machine and am testing on my other two machines
tonight and tomorrow (hopefully).


>  I am unable to
> determine what levels I should set to provide to increase performance
> of my 3 cards.

Well, what you set depends on what's the most important performance
parameters to you: memory consumption, system throughput, and/or
latency.


>  Any pointers you can provide would be most appreciated.
> Here's my current modprobe.conf statement:
> 
> options cx18 enc_yuv_buffers=0 enc_vbi_buffers=0 enc_pcm_buffers=0
> debug=3 enc_mpg_buffers=8 enc_ts_buffers=8
> 
> But it sounds like I should be decreasing buffers and not increasing
> them to remove artifacts.

Well of the new parameters coming in, here's how I recommend you use
them:

1. enc_mpg_buffers, enc_ts_buffers, etc.: don't specify these.

They still have almost the same behavior, and I left them in for legacy
compatibility with existing user setups (per Mauro's suggestion).  They
still work, but can be overridden by specifying the new enc_mpg_bufs,
enc_ts_bufs, etc. parameters.


2. enc_mpg_bufsize, enc_ts_bufsize, enc_yuv_bufsize, etc.: These are the
size of individual transfer buffers in kB for each stream.  For better
responsiveness (lower latency on buffer transfers) for live TV, set
lower numbers, for better system I/O throughput and lower CPU
utilization, set larger numbers.

Note the defaults for the MPEG and TS stream are 32 kB, YUV has a
default of 128 kB, and PCM audio has a default of 4 kB.  Specifying
numbers that are not a multiple of the standard 4 kB page size will
waste some memory.  Specifying number below 4 kB really doesn't make
sense, unless you really need very low latency and are willing to throw
away memory to get it.

3. enc_mpg_bufs, enc_ts_bufs, enc_yuv_bufs, etc.:  These specify the
number of buffers to be used by that stream type.  To save memory, you
can specify these lower, as long as your application can keep emptying
the buffers fast enough and return them.  If you have a really app
that's really slow at times when it can't process buffers rapidly, set
this number higher to make sure the firmware always has buffers
available.

Note this (approximate) relationship:

enc_mpg_buffers = enc_mpg_bufsize * enc_mpg_bufs / 1024

Which is why I say not to bother with specifying the older enc_*_buffers
parameters.


Since the firmware only can handle 63 buffers at a time, additional
buffer tracking logic is now in the cx18 driver to handle the tasks of
keeping the number of buffers available to firmware as high as possible
(~63), while still allowing more than that to be allocated for use in
case of slow applications.

Because of the special handling of the digital TS buffers directly by
the dvb subsystem, it makes no sense to specify more than
enc_ts_buffers=64 for the TS: 1 buffer being given to the DVB subsystem
while the firmware has the other 63 for use.

Note YUV buffers take up 128 kB, so there's only 8 YUV buffers by
default.  BTW it's okay to specify buffer counts lower than 63 as far as
the driver is concerned, but a sometimes slow app may end up starving
the firmware of buffers for period of time if the number you use is too
low.



So maybe I'd try something like this for a one card system running myth
TV watching live TV:

modprobe cx18 enc_mpg_bufs=128 enc_mpg_bufsize=16 enc_ts_bufs=64 \
	enc_ts_bufsize=16 enc_yuv_bufs=0

I have no data recorded on PCM data buffer depth required, but the
default seems a little ridiculous now: 277 buffers of 4 kB.  I left that
that way as it was: close to the approximate amount being allocated
before - but I think it's way overkill.


Anyway happy testing!  Let me know how it goes.  My initial cut at it
over the weekend had mystery buffer handling problems that resulted in
frequent artifacts in the MPEG stream.  By Sunday afternoon I had it
worked out using a new technique for moving buffers around.


After this, I'm getting the raw VBI changes worked in, some firmware
loading changes (in hopes to improve audio problems) and a laundry list
of items ivtv-* list users have collected for me to fix to get rid of
video/audio skips, and reported PAL problems.


Regards,
Andy

> Regards,
> 
> Brandon
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
