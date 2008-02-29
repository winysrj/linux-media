Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com ([10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1T9VaL6005648
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 04:52:34 -0500
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.180])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m1T9PHx1016414
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 04:25:17 -0500
Received: by el-out-1112.google.com with SMTP id r23so3557964elf.21
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 01:23:15 -0800 (PST)
Message-ID: <d9def9db0802290123t5e698f8fj1f2b7df0c73c2b70@mail.gmail.com>
Date: Fri, 29 Feb 2008 10:23:15 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "eric miao" <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] move sensor control out of kernel
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

On 2/29/08, eric miao <eric.y.miao@gmail.com> wrote:
> I know some one has different opinion, but since the sensor control logic is
> getting more and more complicated, and provided that differences between
> sensors and vendors are already too many. Is it better to move sensor
> control out of kernel.
>
> Most sensors come with a serial control channel, I2C as can be seen
> most commonly. Access to the control information can be done by
> i2c-dev interface if possible, thus the driver can be freed as an I2C
> stub only. So technically, this is practical.
>
> The benefits I can think of now are:
>
> 1. simplified sensor driver design
>
> 2. sensor control related debugging can be moved to user space thus
> reducing the debugging effort
>
> 3. accessing registers in user space can be done by many other ways
> say, UART. E.g.
> ADCM2650 and ADCM2670 differs in the control channel connection,
> one by I2C and the other by UART, the user space control logic has
> only to decide which device node to open: /dev/i2c/xxx or /dev/ttyXX
>
> Another biggest concern to the V4L2 API itself, sensor nowadays has
> more control ability than it used to be, some smart sensor provides
> even more like auto focus control, lens control, flash mode, and many
> other features that current V4L2 API cannot cover.
>
> Besides, along with the complicated image processing chain, it might
> be better described by kinds of pipeline, like what gstreamer is doing
> now. Moving some or most of the logic to user space will also significantly
> reduce the effort of kernel development.
>
> Now the problem is: we don't have a standard in user space :(
>

Video4Linux is still a proposal in userspace, vlc and xine only
support v4l1 once you come up with a sane interface it can easily be
adopted by providing a small plugin.
If you look at xine, it already provides a quite mature image
processing chain, the xine API itself is also abstracted to be very
easy.

I also like the way of having something more flexible in userspace,
the question came up how people can emulate a v4l device, there are
projects available for feeding digital datastreams from userspace into
the kernel and providing a video interface for streaming it back to
userspace
I think it's better to discuss such an interface on the Xine, VLC,
gstreamer or any other appropriate ML.

Your idea basically increases the system stability and portability of
the driver.
BSD systems are also able to export an i2c interface.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
