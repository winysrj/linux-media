Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARANQPK021522
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 05:23:26 -0500
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARANDpT002935
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 05:23:14 -0500
Message-ID: <11380.62.70.2.252.1227781392.squirrel@webmail.xs4all.nl>
Date: Thu, 27 Nov 2008 11:23:12 +0100 (CET)
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

> On Thu, 27 Nov 2008 08:32:22 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Hi all,
>>
>> It been my opinion for quite some time now that we are too generous in
>> the number of kernel versions we support. I think that the benefits no
>> longer outweight the effort we have to put in.
>>
>> This is true in particular for the i2c support since that changed a lot
>> over time. Kernel 2.6.22 is a major milestone for that since it
>> introduced the new-style i2c API.
>
> I prefer to keep backward compat with older kernels. Enterprise distros
> like
> RHEL is shipped with older kernels (for example RHEL5 uses kernel 2.6.18).
> We
> should support those kernels.

Is RHEL (or anyone else for that matter) actually using our tree? I never
see any postings about problems or requests for these old kernels on the
v4l list.

Do you know if and how other subsystems handle this?

>
>> In order to keep the #ifdefs to a minimum I introduced the
>> v4l2-i2c-drv.h and v4l2-i2c-drv-legacy.h headers. These make sense when
>> used in the v4l-dvb tree context, but when they are stripped and used
>> in the actual kernel source they look very weird.
>
> We may use a different approach for the above files. For example, we may
> include the headers just for older kernels, like we did in the past with
> i2c
> backward compat with kernel 2.4. gentree can easily remove a #include line
> from
> the upstream patch.

You either using these headers, or you start using lots of #ifdefs in each
i2c driver. There is unfortunately no easy solution to this (I really
tried at the time). Dropping pre-2.6.22 support will make it feasible to
drop these headers. There would still be a few #ifdefs, but it will be
acceptable.

If you know of a distro or big customer that is actually using v4l-dvb on
old kernels, then I think we should keep it, but otherwise it is my
opinion that it is not worth the (substantial) hassle. I also have my
doubts about people using enterprise distros together with v4l. Doesn't
seem very likely to me.

Regards,

       Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
