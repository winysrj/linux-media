Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0CEeYia002290
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 09:40:34 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.240])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0CEeKnI026794
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 09:40:20 -0500
Received: by an-out-0708.google.com with SMTP id b2so3606523ana.36
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 06:40:20 -0800 (PST)
Message-ID: <a0580c510901120640p87b047es5bab2731616a314d@mail.gmail.com>
Date: Mon, 12 Jan 2009 16:40:19 +0200
From: "Eduardo Valentin" <edubezval@gmail.com>
To: "Tobias Lorenz" <tobias.lorenz@gmx.net>
In-Reply-To: <200811291506.11758.tobias.lorenz@gmx.net>
MIME-Version: 1.0
References: <5d5443650811282312w508c0804qf962f6cf5e859e2@mail.gmail.com>
	<200811291506.11758.tobias.lorenz@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: FM transmitter support under v4l2?
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

hello Tobias and Trilok


On 11/29/08, Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
>
> Hi Trilok,
>
>
> > Anybody working on FM transmitter related drivers support under v4l2?
> > If no, what parts of v4l2 which could be tweaked in right order to
> > support such devices? I see that SI471x series seem to have FM
> > transmitters too.
>
>
> right, there are several Si47xx series:
> Si470x: receivers only
> Si471x: transmitter only
> Si472x: transceivers
> Si473x: fm+am receivers


yes.

All are somehow related down to the register set.
>
> I see there two starting points:
> 1. Get the data sheets of the Si471x devices and compare what options they
> have more compared to an Si470x receiver.
> 2. Have a look at what you can configure on your amateur ham radio.



I'd say that first optionis the better starting point.

I'm almost sure, that you can use the alsa driver to transport audio to the
> silabs transmitters too.


Yes, it is a quite doable approach.


But there are obvisuouly some V4L2 interface additions necessary, e.g. ptt,
> transmit power, modulation, ...


yes, some points must  be reviewd in the api. I'd say that ptt, transmit
power, modulation,are somehow good  properties to  go through
vidioc_s/g_ctrl
calls.

Another thing is RDS. I think that for transmitters with rds support that
would
be good to have other way to expose it to u.s. other than sysfs for example.
Atg least the most common prop., ps, rt, ptty, etc.

And it would be really helpful to have a working reference device there too.
> As far as I know, silabs doesn't have one.



Is there any sdp from silabs?


BR,

> Bye,
> Toby
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
Eduardo Bezerra Valentin
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
