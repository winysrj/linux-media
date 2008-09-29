Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8T95adi003224
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 05:05:36 -0400
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8T95JcY002855
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 05:05:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@nokia.com>
Date: Mon, 29 Sep 2008 11:04:59 +0200
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200809061840.37997.hverkuil@xs4all.nl>
	<48E092E0.6020907@nokia.com>
In-Reply-To: <48E092E0.6020907@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809291105.00225.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: Re: Interfaces for composite devices (was: Re: [PATCH v2]
	soc-camera: add API documentation)
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

Hi Sakari!

On Monday 29 September 2008 10:33:36 Sakari Ailus wrote:
> Hello, Hans!
>
> I'm Cc:ing to Sergio Aguirre and Hari Nagalla as they are working
> with the OMAP 3 ISP and camera drivers at TI now. I'm also removing
> Mohit.
>
> ext Hans Verkuil wrote:
> > On Friday 05 September 2008 18:08:43 Sakari Ailus wrote:
> >> How about caller, does the caller need to ensure that a driver
> >> actually implements a function or how should this be handled?
> >
> > Easiest would be a something like this:
> >
> > // Note that client->ops is always non-zero, you would have
> > // gotten a BUG_ON earlier if it wasn't.
> > #define v4l2_client_call(client, o, f, args...) \
> > ({ \
> >         int err = -ENOIOCTLCMD; \
> >         if (client && client->ops->o && client->ops->o->f) \
> >                 err = client->ops->o->f(client , ##args); \
> >         err; \
> > })
> >
> >
> > struct v4l2_control ctrl = { ... };
> >
> > int result = v4l2_client_call(client, core, s_ctrl, &ctrl);
> >
> > Alternatively, if you know which client driver you are accessing
> > you can call it directly without checking:
> >
> > int result = client->ops->core->s_ctrl(client, &ctrl);
> >
> > There is little advantage in using the second variant so I would
> > prefer the first.
>
> I agree. Usually you don't want to know anything useless about the
> client.
>
> > There is also a similar define that will call all registered
> > clients with the same arguments. Similar to i2c_clients_command but
> > not limited to i2c clients. That obviously also checks whether a
> > function is present.
>
> I hope this would still be limited to a single v4l device, right? :)

Obviously :-)

> That would be actually needed in the OMAP 3 camera as it doesn't want
> to know which client implements a given control, for example.

Right. During the LPC conference the suggestion was made to allow the 
bridge driver to assign a group ID to clients and use that group ID to 
call only clients belonging to that group. It allows the bridge driver 
finer-grained control over which clients should be called. In the 
current proposal there is only a choice between calling one or all 
clients, having a group ID fixes this limitation. I will implement 
this.

> >> Compared to v4l2-int-if --- if there's no slave, you'll get
> >> -ENODEV, and in case of missing command, you get -ENOIOCTLCMD.
> >> That's not in the tree yet but it's part of OMAP 3 camera driver
> >> patches.
> >
> > In what use case can you ever have no slave? I can easily return
> > -ENODEV if client == NULL, but isn't the absence of a slave a
> > severe error so that you would have bailed out much earlier? Just
> > wondering.
>
> There's a valid use case for that.
>
> The OMAP 3 camera driver can drive a lenses and a flash, too. But
> lens or flash might not be part of every camera device. For example a
> secondary camera in a device could be without these.

I think I would prefer it if the bridge driver does the test against 
client == NULL. But I will have to think about this a bit more.

> > In general clients should stick to the main ops structs and only
> > add a client specific one if it is really needed. That said, I'm
> > not sure whether it is such a bad idea to have client specific ops
> > structs. My original idea was to add an ioctl type function to the
> > core ops that could be used to make client specific commands.
> > However, with an ops struct you have strong typing and a more
> > natural way of calling clients. That's actually quite nice.
>
> I would prefer the ioctl approach at least in some cases. Why not to
> allow both?
>
> Just as an example, consider the OMAP 3 camera again. A slave can
> quite well implement a private interface that it wants to export to
> userspace, like the OMAP 3 ISP driver does have ioctls for
> configuring the statistics collection and for obtaining the
> statistics. The camera driver does not need nor want to be involved
> with this. The statistics are used by the automatic white balance,
> exposure and focus algorithms.

Good point. I'll keep the ioctl for this purpose.

> I don't recognise need for private ops at the moment that would be
> useful to slave. If the master driver is supposed to be generic it
> really should not use directly any private operations.
>
> Dependencies between slaves can be handled in the board code instead.
> In that case the dependencies are not a problem because they already
> are inherent to that machine.
>
> >>  From your last mail I understood that you found the existing
> >> implementations of frameworks that offer some kind of abstraction
> >> between devices that make one V4L device more or less bad. I think
> >> we should first evaluate what is wrong in the current approaches
> >> so we don't repeat the mistakes done in them.
> >
> > The basic idea is the same in all approaches. However, see the
> > following shortcomings in the existing implementations:
> >
> > 1) They are not generic, but built to solve a specific problem. To
> > be specific: soc-camera.h and v4l2-int-device.h were written for
> > sensors.
>
> Not quite; v4l2-int-device is supposed to work with any other kind of
> devices as well. There are no dependencies to sensors.

You are correct.

> But I agree that different types of slaves are not differentiated so
> this could cause problems. The other thing is that during about one
> year no-one else has started to use this interface except the OMAP 1
> camera driver and one sensor driver that is used with the first.
>
> If we go with v4l2_client then I suppose we should forget about
> v4l2-int-if and maybe SoC camera also and convert all the drivers to
> use v4l2_client instead of unifying the first two. Instead if
> something would be done to old code that would be to convert it to
> use v4l2_client instead. That task probably would not be very big as
> the concepts are quite similar; just the implementation differs.
>
> (I still should take a closer look at the v4l2_client, sorry.)
>
> Sincerely,

During the LPC conference everyone liked the ideas behind v4l2_client 
and v4l2_device and the decision was made that I'll go ahead with it. 
It will be renamed to media_client since the same approach can also be 
used in the dvb subsystem in the future, so it is not v4l specific 
(although it will be initially).

I hope to get most of it into v4l-dvb in the next month. Once that's 
done it shouldn't be difficult to replace v4l2-int-if with media_client 
and to modify soc-camera to start using it as well. That should unify 
all these internal interfaces and simplify future drivers.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
