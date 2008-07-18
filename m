Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I7ZUee006181
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:35:30 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6I7ZC2f023653
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:35:12 -0400
Received: by rv-out-0506.google.com with SMTP id f6so250462rvb.51
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 00:35:11 -0700 (PDT)
Message-ID: <d9def9db0807180035p7edf4dc1me46de4fba4c24246@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:35:11 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200807171833.00972.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <566157.38298.qm@web59602.mail.ac4.yahoo.com>
	<200807171833.00972.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: Question on V4L2 VBI operation
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

On Thu, Jul 17, 2008 at 6:33 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thursday 17 July 2008 18:25:07 Krish K wrote:
>> Thanks for the response.  I am trying to implement a video driver and
>> looking for information on how V4L2 expects the driver to provide
>> VBI: separately or embedded in the frame data. I have looked at the
>> V4L2 doucmentation; which is very good, but doesn't seem to
>> explicitly address this aspect.
>
> Hi Krish,
>
> Applications expect the VBI to come through the /dev/vbiX device and
> never as part of a video frame. While it is technically possible to
> deliver a video frame that includes the VBI data that preceeds it, in
> practice this is never used and I'm not even sure whether there is a
> driver that can do it.
>

it is the em28xx driver on mcentral.de does that actually.
http://img402.imageshack.us/my.php?image=00000008zd8.png

the driver cuts off the heading VBI data and delivers it to /dev/vbi[n]

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
