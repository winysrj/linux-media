Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9LJUtb026728
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:19:30 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9LIT3A005155
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:18:29 -0500
Received: by nf-out-0910.google.com with SMTP id d3so42435nfc.21
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 13:18:29 -0800 (PST)
Message-ID: <de8cad4d0812091318h348d4417lef4e98dc9593445e@mail.gmail.com>
Date: Tue, 9 Dec 2008 16:18:28 -0500
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812091918.00276.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15114.62.70.2.252.1228832086.squirrel@webmail.xs4all.nl>
	<200812091918.00276.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-compat-ioctl32 update?
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

Hi Hans,

Received the following during compilation:

CC [M]  /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.o
/root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c: In function
'put_v4l2_ext_controls32':
/root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: 'kcontrols'
undeclared (first use in this function)
/root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: (Each
undeclared identifier is reported only once
/root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: for each
function it appears in.)
make[3]: *** [/root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.o] Error 1
make[2]: *** [_module_/root/drivers/hdpvr/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.27-ARCH'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/drivers/hdpvr/v4l'
make: *** [all] Error 2

Brandon
On Tue, Dec 9, 2008 at 1:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday 09 December 2008 15:14:46 Hans Verkuil wrote:
>> OK, I'll mail you a diff this evening. In the meantime, can you
>> compile v4l2-ctl for 32-bit? That's the test tool for several of my
>> tests.
>
> Hi Brandon,
>
> As promised I've attached the diff with my current changes.
>
> You should be able to test it fairly well with v4l2-ctl. In particular,
> please test getting and setting controls (MPEG controls use S_EXT_CTRLS
> while user controls use the older VIDIOC_S_CTRL ioctl).
>
> Also try --get-audio-input, --list-audio-inputs, --get-cropcap,
> --get-input, --set-input and --list-inputs.
>
> Basically test as many ioctls as you can :-) And of course with sagetv!
>
> Thanks,
>
>        Hans
>
>>
>> Regards,
>>
>>        Hans
>>
>> > Hans,
>> >
>> > I would love to test! I am using 3 HVR-1600s and an HD-PVR for
>> > encoders.
>> >
>> > Brandon
>> >
>> > On Tue, Dec 9, 2008 at 9:03 AM, Hans Verkuil <hverkuil@xs4all.nl>
> wrote:
>> >> Hi Brandon,
>> >>
>> >> As you noticed I found suspicious code in the current source. At
>> >> the moment I have no easy way of testing this, although I hope to
>> >> be able to do that some time in the next week or the week after
>> >> that.
>> >>
>> >> However, if you are able to do some testing for me, then that
>> >> would be very welcome and definitely speed things up.
>> >>
>> >> I have a patch that I can mail you and a bunch of tests to
>> >> perform.
>> >>
>> >> Let me know if you can help.
>> >>
>> >> Regards,
>> >>
>> >>        Hans
>> >>
>> >>> Hi Hans,
>> >>>
>> >>> I noted over the weekend that you were working on updating the
>> >>> v4l2-compat-ioctl32 module, thank you! Do you have a sense of
>> >>> timing for availability in your tree? I know of a few SageTV
>> >>> users who will be glad to see it done. :)
>> >>>
>> >>> Thanks in advance,
>> >>>
>> >>> Brandon
>> >>
>> >> --
>> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
