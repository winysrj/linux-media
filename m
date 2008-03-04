Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24EO17s002526
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 09:24:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24ENTOk027926
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 09:23:30 -0500
Date: Tue, 4 Mar 2008 11:23:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Message-ID: <20080304112320.6dadf6df@gaivota>
In-Reply-To: <fq9c8n$hg$1@ger.gmane.org>
References: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
	<fq8v17$bm9$1@ger.gmane.org>
	<f17812d70802290725o77db19daic50aee0380a1dc59@mail.gmail.com>
	<fq9c8n$hg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Fri, 29 Feb 2008 18:35:18 +0200
Paulius Zaleckas <paulius.zaleckas@teltonika.lt> wrote:

> 
> eric miao wrote:
> >>  > The benefits I can think of now are:
> >>  >
> >>  > 1. simplified sensor driver design
> >>
> >>  It is pretty simple with soc-camera framework also. And the best thing
> >>  is that it is unified. If you implement sensor driver in userspace then
> >>  what kind of interface should V4L data bus driver expose.
> >>
> > 
> > The soc-camera is pretty good. Yet it doesn't solve the issue of
> > complicated sensor control. mt9m001.c and mt9v022.c are two
> > good examples, but are all too simple. I have a sensor driver here
> > with more than 4000 lines of code.
> 
> Yes I can imagine driver for analog devices ADV family video decoder :)
> Some time ago I wrote driver for ADV...
> 
> But I don't imagine application or library with support for all 
> devices... Kernel is easy to configure and to compile only drivers you 
> need. Also kernel modules are good to load only the driver you need.
> 
> Another thing is that there will be different multiple implementations 
> of this "4000 lines of code" driver. This means that each of them will 
> be tested less than the single one in kernel.

Having this at kernel avoids duplicating the code. Also, a kernel driver without
the sensor means a broken driver, since it won't work without the userspace
counterpart.

> >>  > Another biggest concern to the V4L2 API itself, sensor nowadays has
> >>  > more control ability than it used to be, some smart sensor provides
> >>  > even more like auto focus control, lens control, flash mode, and many
> >>  > other features that current V4L2 API cannot cover.
> >>
> >>  Implement these controls. Make a patch and send it here. If everything
> >>  is OK it should be merged and V4L will be capable to handle these controls.
> >>
> > 
> > Mmm...then do you expect an API growing into a monster in the kernel space?
> 
> I guess this will happen anyway, because of tv tuners, dvb-t cards and 
> etc. There is no way there to separate "sensor" from the data bus.

This is just a matter of adding newer controls to VIDIOC_[G/S/ENUM]_CTRL. 
This way, generic apps like qv4l2 can properly configure any device. This also
avoids the need of having special userspace apps for certain devices.

If you don't standardize the controls at the API, then you'll have a real mess
at the userspace.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
