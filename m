Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77Daw3U002584
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 09:36:58 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77Dag7U029901
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 09:36:42 -0400
Received: by nf-out-0910.google.com with SMTP id d3so177228nfc.21
	for <video4linux-list@redhat.com>; Thu, 07 Aug 2008 06:36:42 -0700 (PDT)
Message-ID: <de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
Date: Thu, 7 Aug 2008 09:36:41 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1218070521.2689.15.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
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

On Wed, Aug 6, 2008 at 8:55 PM, Andy Walls <awalls@radix.net> wrote:
> On Wed, 2008-08-06 at 06:57 -0400, Brandon Jenkins wrote:
>> On Tue, Aug 5, 2008 at 9:29 PM, Andy Walls <awalls@radix.net> wrote:
>> > On Tue, 2008-08-05 at 21:04 -0400, Brandon Jenkins wrote:
>> >> Hi All
>> >>
>> >> I am running kernel 2.6.26 on  Ubuntu 8.04. Any thoughts?
>> >
>> > I ran into a similar Oops in the same function on 23 July.  I had it at
>> > a lower priority since no one had complained about it and it seems rare.
>> >
>> > I'll try and get to it before Saturday morning.  If anyone wants to
>> > submit a patch before then, I'll review it ASAP after receipt.
>> >
>> > Regards,
>> > Andy
>> >
>> >> Thanks in advance
>> >>
>> >> Brandon
>> >>
>
>> >> [35037.080852] Code: 74 22 31 c9 0f 1f 80 00 00 00 00 48 89 c8 48 03
>> >> 47 28 8b 10 0f ca 89 10 8d 41 04 48 83 c1 04 39 47 30 77 e7 f3 c3 0f
>> >> 1f 44 00 00 <4c> 8b 0e 49 89 d2 49 8b 41 08 49 8b 11 48 89 42 08 48 89
>> >> 10 49
>> >> [35037.080976] RIP  [<ffffffffa01e4180>] :cx18:cx18_queue_move_buf+0x0/0xa0
>> >> [35037.080992]  RSP <ffff810217c4be50>
>> >> [35037.081000] CR2: 0000000000000000
>> >> [35037.081192] ---[ end trace 10100555b3a0d104 ]---
>> >> [35037.090147] note: java[15894] exited with preempt_count 1
>> >>
>> >> --
>> >> video4linux-list mailing list
>> >> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> >> https://www.redhat.com/mailman/listinfo/video4linux-list
>> >>
>> >
>> >
>> Here's another one. Is there something I could do to lessen the issue
>> while a patch is being worked? Rebuild the kernel without preempting?
>
>
> Nope.  The problem I have has to do with per stream queue and buffer
> accounting being slightly but you'll only notice when it's being freed.
>
> I suspect you have the same problem, but I can't tell for sure as you
> system is compiling the code differently than mine.
>
> Could you please send the output of
>
> $ cd v4l-dvb
> $ objdump -D v4l/cx18-queue.o
>
> from the offending build to me.  That way I can see the assembled
> machine code and verify where in the function the NULL dereference is
> happening.
>
> If you have the exact same problem as me, I can give you a "band-aid"
> patch which will lessen the problem in short order.  It'll be a band aid
> because it won't fix the accounting problem though.  I need to do more
> extensive test and debug to find out where the accounting of buffers is
> getting screwed up.
>
> Regards,
> Andy

Andy,

Reposting with the file hosted in my dropbox instead. I didn't realize
there was a size limit on the devel list.

Brandon

https://dl.getdropbox.com/u/4976/cx18-queue.o.objdump.tar.gz

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
