Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAREIe3b003035
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 09:18:40 -0500
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAREIPgN001864
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 09:18:26 -0500
Message-ID: <17446.62.70.2.252.1227795504.squirrel@webmail.xs4all.nl>
Date: Thu, 27 Nov 2008 15:18:24 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: RFC: drop support for kernels < 2.6.22
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

> On Thu, 27 Nov 2008 11:23:12 +0100 (CET)
> "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
>
>> > On Thu, 27 Nov 2008 08:32:22 +0100
>> > Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >
>> >> Hi all,
>> >>
>> >> It been my opinion for quite some time now that we are too generous
>> in
>> >> the number of kernel versions we support. I think that the benefits
>> no
>> >> longer outweight the effort we have to put in.
>> >>
>> >> This is true in particular for the i2c support since that changed a
>> lot
>> >> over time. Kernel 2.6.22 is a major milestone for that since it
>> >> introduced the new-style i2c API.
>> >
>> > I prefer to keep backward compat with older kernels. Enterprise
>> distros
>> > like
>> > RHEL is shipped with older kernels (for example RHEL5 uses kernel
>> 2.6.18).
>> > We
>> > should support those kernels.
>>
>> Is RHEL (or anyone else for that matter) actually using our tree? I
>> never
>> see any postings about problems or requests for these old kernels on the
>> v4l list.
>
> RHEL bugs come to redhat bugzilla. Generated patches there should be
> tested
> against the latest version and applied upstream.
>
>> If you know of a distro or big customer that is actually using v4l-dvb
>> on
>> old kernels, then I think we should keep it, but otherwise it is my
>> opinion that it is not worth the (substantial) hassle. I also have my
>> doubts about people using enterprise distros together with v4l. Doesn't
>> seem very likely to me.
>
> Yes, there are customers with enterprise distros using V4L drivers.
>
> Also, I am using V4L/DVB tree with a 2.6.18 kernel on some machines.
> Removing
> support for 2.6.18 will be a pain for me.
>
> I suspect that Laurent is also using RHEL (or some uvc users), since he
> sent
> some patches fixing compilation with RHEL.

Darn. Oh well, so be it...

Regards,

        Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
