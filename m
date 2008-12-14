Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBEEogoE028446
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 09:50:42 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBEEoTJS019431
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 09:50:30 -0500
Received: by ewy14 with SMTP id 14so2761427ewy.3
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 06:50:29 -0800 (PST)
Message-ID: <de8cad4d0812140650s6e13a1b2nca4b0ebe8266b3bb@mail.gmail.com>
Date: Sun, 14 Dec 2008 09:50:29 -0500
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1228867386.3283.36.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de8cad4d0812090930k75d973em4f21d36777ee02a2@mail.gmail.com>
	<1228867386.3283.36.camel@morgan.walls.org>
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

On Tue, Dec 9, 2008 at 7:03 PM, Andy Walls <awalls@radix.net> wrote:

> So maybe I'd try something like this for a one card system running myth
> TV watching live TV:
>
> modprobe cx18 enc_mpg_bufs=128 enc_mpg_bufsize=16 enc_ts_bufs=64 \
>        enc_ts_bufsize=16 enc_yuv_bufs=0
>
> I have no data recorded on PCM data buffer depth required, but the
> default seems a little ridiculous now: 277 buffers of 4 kB.  I left that
> that way as it was: close to the approximate amount being allocated
> before - but I think it's way overkill.
>
>
> Anyway happy testing!  Let me know how it goes.  My initial cut at it
> over the weekend had mystery buffer handling problems that resulted in
> frequent artifacts in the MPEG stream.  By Sunday afternoon I had it
> worked out using a new technique for moving buffers around.
>
>
> After this, I'm getting the raw VBI changes worked in, some firmware
> loading changes (in hopes to improve audio problems) and a laundry list
> of items ivtv-* list users have collected for me to fix to get rid of
> video/audio skips, and reported PAL problems.
>
>
> Regards,
> Andy
>
Andy,

I used the above changes with a pull from this morning and I have not
seen any artifacts in the images thusfar (about 2 hours of TV). This
is a huge improvement. The only other issue I am seeing is a frequent
pausing of the feed which lasts about 1-2 seconds and resumes. dmesg
indicates the following:

cx18-1 warning: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs
for RPU acknowledgement
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 174380) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 175357) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 175436) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 175492) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 175761) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 176163) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 176220) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 176712) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 177058) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 178080) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 178096) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 178280) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 178449) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 178948)
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 179061) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 179227) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 179604) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 180444) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 180899) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 181282) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 181484) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 182102) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 182124) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 182241)
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 182325) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 182634) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 182790) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 182888) while processing
cx18-1 warning: Possibly falling behind: CPU self-ack'ed our incoming
CPU to EPU mailbox (sequence no. 183534) while processing

In a three card system, should I increase the buffers allocated or
decrease for performance? Is this part of the issues you're tracking
from the ivtv list?

Thanks again for all of your efforts.

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
