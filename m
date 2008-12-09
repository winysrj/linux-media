Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9Co8qO008286
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 07:50:08 -0500
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9Cntih032275
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 07:49:55 -0500
Received: by gv-out-0910.google.com with SMTP id n8so489813gve.13
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 04:49:54 -0800 (PST)
Message-ID: <30353c3d0812090449g30b55d64r4da5069a41cd0b4e@mail.gmail.com>
Date: Tue, 9 Dec 2008 07:49:54 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <30353c3d0812081620v1e633530qa3539888c18a1cda@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228752855.1809.93.camel@tux.localhost>
	<30353c3d0812081403p11f1fcaam1b15a2650f05bcdf@mail.gmail.com>
	<208cbae30812081410i37ad8da8ue43f907ad9a54b@mail.gmail.com>
	<30353c3d0812081620v1e633530qa3539888c18a1cda@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] radio-mr800: correct unplug, fix to previous patch
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

On Mon, Dec 8, 2008 at 7:20 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> On Mon, Dec 8, 2008 at 5:10 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
>> On Tue, Dec 9, 2008 at 1:03 AM, David Ellingsworth
>> <david@identd.dyndns.org> wrote:
>>> This patch looks good, but I think it should remove the now unused
>>> user member of the amradio struct as well.
>>
>> Should i remake this patch now ? Or make one more patch ?
>>
>
> I'd make a separate patch. Leaving the users member variable doesn't
> cause any harm; removing it is just a driver simplification/cleanup.
>

I thought about this more and you might want to reconstitute the
meaning of the users member of the amradio struct. Currently
amradio_start is called whenever the device is opened and amradio_stop
is called whenever it is closed. Thus if the device were opened twice,
it would call the start routine twice. The other issue is that once it
has been opened more than one time, the first time it is closed,
amradio_stop is called. It may make more since to turn this member
into a counter that is incremented on open and decremented on close.
Then if the counter is 0 on open, before increment, call amradio_start
and if it's 0 on close, after decrement, call amradio_stop. Once this
is done, amradio_start will only be called once when the device is
initially opened and amradio_stop will be called once when during
close when all users all users have closed the device. I don't know if
it matters or not, but you may also want to take a look at the control
which mutes the device for it seems to call amradio_start and
amradio_stop as well. Ideally if the device is stopped by the user
before the final close amradio_stop should not be called, so you
should check if it's not muted as well.

Finally I noticed that the muted flag is not modified within the
context of the lock in amradio_start and amradio_stop. This should be
corrected to ensure a race condition doesn't exist between the two
states. I also think that amradio_start and amradio_stop should verify
the device's state before proceeding. For example if the device is not
muted during a call to amradio_start it should return an error since
it's already started. And if it's muted during a call to amradio_stop
it should return an error.

The suspend/resume functions needs to be fixed as well. amradio_start
should only be called if the device wasn't muted when it was
suspended. Likewise, amradio_stop should only be called during suspend
if the device isn't muted. Since the amradio_start and amradio_stop
manipulate the muted variable you may need another variable to
determine how to resume from suspend. You might be able to use the
muted variable, by resetting it to one to on suspend after calling
amradio_stop when it's not muted. And then resetting it to 0 in resume
if it's 1 before calling amradio_start in resume. None the less,
resume/suspend should return the device to it's prior state. IE. if it
was muted upon suspend, it should be muted upon resume and vice versa.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
