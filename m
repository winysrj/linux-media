Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m79HhNZa026672
	for <video4linux-list@redhat.com>; Sat, 9 Aug 2008 13:43:23 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m79Hh9s4002461
	for <video4linux-list@redhat.com>; Sat, 9 Aug 2008 13:43:09 -0400
Received: by nf-out-0910.google.com with SMTP id d3so532111nfc.21
	for <video4linux-list@redhat.com>; Sat, 09 Aug 2008 10:43:09 -0700 (PDT)
Message-ID: <de8cad4d0808091043o385ce57fvaebca69d650e8012@mail.gmail.com>
Date: Sat, 9 Aug 2008 13:43:08 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1218205108.3003.44.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
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

On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net> wrote:
> On Thu, 2008-08-07 at 09:36 -0400, Brandon Jenkins wrote:
>> On Wed, Aug 6, 2008 at 8:55 PM, Andy Walls <awalls@radix.net> wrote:
>
>> > from the offending build to me.  That way I can see the assembled
>> > machine code and verify where in the function the NULL dereference is
>> > happening.
>> >
>> > If you have the exact same problem as me, I can give you a "band-aid"
>> > patch which will lessen the problem in short order.  It'll be a band aid
>> > because it won't fix the accounting problem though.  I need to do more
>> > extensive test and debug to find out where the accounting of buffers is
>> > getting screwed up.
>> >
>> > Regards,
>> > Andy
>
> Brandon,
>
> I have checked in a fix to defend against the Ooops we both encountered.
> The fix will also generate a WARN dump and some queue stats when it runs
> across the cause, but will otherwise try to clean up as best it can to
> allow further operation.
>
> The band-aid fix is the latest change at
>
> http://linuxtv.org/hg/~awalls/v4l-dvb
>
> Please provide the extra debug that happens if you encounter the warning
> in your logs.  I have only encountered the problem twice over a several
> month period, so its hard to get insight into the root cause buffer
> accounting error at that rate.
>
>
> Hans,
>
> The provided patch is a bit ugly, so I'm not sure I want it to go to the
> main repo as is.  Since the cx18_queue_move() and cx18_queue_move_buf()
> functions are a bit general for how cx18 is using them (compared to
> ivtv) and a bit confusing at first, I was going to rewrite them down to
> the minimum needed for cx18.  Do you have any objection?
>
> I normally like the fact that cx18 mirrors ivtv in many aspects as it
> provides an certain economy for common bug fixes.  Here I think cx18 is
> carrying complexity and unused code (and maybe bugs) for only that
> reason.
>
> Regards,
> Andy
>
>

Andy,

I have not experienced a recurrence yet, but  a friend has. We're both
users of SageTV, I asked him for info on reproducing the error to see
if I can make it trip as well.

Thanks for the help.

Brandon

PS - You'll note he's testing the HDPVR device as am I. Janne
performed a tree merge 3 days ago so it is fairly fresh.

He sent me the following output:

[18101.988000] WARNING: at /root/hdpvr/v4l/cx18-queue.c:204
cx18_queue_move()
[18101.988000]  [<f0abe656>] cx18_queue_move+0x246/0x250 [cx18]
[18101.988000]  [<f0abe69c>] cx18_flush_queues+0x3c/0x50 [cx18]
[18101.988000]  [<f0abfb17>] cx18_release_stream+0x77/0xc0 [cx18]
[18101.988000]  [<f0abff5c>] cx18_v4l2_close+0x9c/0x130 [cx18]
[18101.988000]  [<c01816bd>] __fput+0xad/0x1a0
[18101.988000]  [<c017ea97>] filp_close+0x47/0x80
[18101.988000]  [<c017febb>] sys_close+0x6b/0xd0
[18101.988000]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[18101.988000]  =======================
[18101.988000] cx18-1: queue_move: driver bug! errant steal attempt
for to/from_free queue move, dumping queue stats
[18101.988000] cx18-1: queue_move: thought bytes_available = 32768
with needed = 32768 and initial destination size = 2031616
[18101.988000] cx18-1: queue_log: stream 'encoder MPEG'  buffers = 63
buf_size = 32768  buffers_stolen = 0
[18101.988000] cx18-1: queue_log: &q_free = ea9e819c  &q_full =
ea9e81b0 &q_io = ea9e81c4
[18101.988000] cx18-1: queue_log: q = ea9e81b0   buffers = 1  length =
32768 bytesused = 2048
[18101.988000] cx18-1: queue_log: stream 'encoder MPEG'  buffers = 63
buf_size = 32768  buffers_stolen = 0
[18101.988000] cx18-1: queue_log: &q_free = ea9e819c  &q_full =
ea9e81b0 &q_io = ea9e81c4
[18101.988000] cx18-1: queue_log: q = ea9e819c   buffers = 62  length
= 2031616  bytesused = 0
[18101.988000] cx18-1: queue_log: i = 0  buf->id = 53  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 1  buf->id = 54  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 2  buf->id = 55  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 3  buf->id = 56  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 4  buf->id = 57  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 5  buf->id = 58  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 6  buf->id = 59  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 7  buf->id = 60  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 8  buf->id = 61  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 9  buf->id = 62  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 10  buf->id = 0  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 11  buf->id = 1  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 12  buf->id = 2  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 13  buf->id = 3  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 14  buf->id = 4  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 15  buf->id = 5  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 16  buf->id = 6  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 17  buf->id = 7  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 18  buf->id = 8  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 19  buf->id = 9  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 20  buf->id = 10  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 21  buf->id = 11  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 22  buf->id = 12  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 23  buf->id = 13  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 24  buf->id = 14  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 25  buf->id = 15  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 26  buf->id = 16  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 27  buf->id = 17  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 28  buf->id = 18  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 29  buf->id = 20  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 30  buf->id = 21  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 31  buf->id = 22  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 32  buf->id = 23  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 33  buf->id = 24  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 34  buf->id = 25  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 35  buf->id = 26  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 36  buf->id = 27  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 37  buf->id = 28  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 38  buf->id = 29  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 39  buf->id = 30  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 40  buf->id = 31  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 41  buf->id = 32  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 42  buf->id = 33  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 43  buf->id = 34  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 44  buf->id = 35  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 45  buf->id = 36  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 46  buf->id = 37  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 47  buf->id = 38  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 48  buf->id = 39  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 49  buf->id = 40  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 50  buf->id = 41  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 51  buf->id = 42  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 52  buf->id = 43  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 53  buf->id = 44  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 54  buf->id = 45  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 55  buf->id = 46  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 56  buf->id = 47  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 57  buf->id = 48  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 58  buf->id = 49  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 59  buf->id = 50  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 60  buf->id = 51  buf->bytesused
= 0 buf->readpos = 0
[18101.988000] cx18-1: queue_log: i = 61  buf->id = 52  buf->bytesused
= 0 buf->readpos = 0

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
