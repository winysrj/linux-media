Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m86Gf7b1002258
	for <video4linux-list@redhat.com>; Sat, 6 Sep 2008 12:41:08 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m86Getum014454
	for <video4linux-list@redhat.com>; Sat, 6 Sep 2008 12:40:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@nokia.com>
Date: Sat, 6 Sep 2008 18:40:37 +0200
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808291543.27863.hverkuil@xs4all.nl>
	<48C1598B.3010805@nokia.com>
In-Reply-To: <48C1598B.3010805@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809061840.37997.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2] soc-camera: add API documentation
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

On Friday 05 September 2008 18:08:43 Sakari Ailus wrote:
> ext Hans Verkuil wrote:
> > I prefer strong typing whereever possible. Basically this solution
> > allows you to subdivide the full range of operations into several
> > interfaces and drivers can choose to implement one or more of those
> > as needed. If a driver doesn't do anything with audio, then there
> > is no need to define the audio interface, so it doesn't take up any
> > space either (except for a single NULL v4l2_client_audio_ops
> > pointer).
>
> How about caller, does the caller need to ensure that a driver
> actually implements a function or how should this be handled?

Easiest would be a something like this:

// Note that client->ops is always non-zero, you would have
// gotten a BUG_ON earlier if it wasn't.
#define v4l2_client_call(client, o, f, args...) \
({ \
        int err = -ENOIOCTLCMD; \
        if (client && client->ops->o && client->ops->o->f) \
                err = client->ops->o->f(client , ##args); \
        err; \
})


struct v4l2_control ctrl = { ... };

int result = v4l2_client_call(client, core, s_ctrl, &ctrl);

Alternatively, if you know which client driver you are accessing you can 
call it directly without checking:

int result = client->ops->core->s_ctrl(client, &ctrl);

There is little advantage in using the second variant so I would prefer 
the first.

There is also a similar define that will call all registered clients 
with the same arguments. Similar to i2c_clients_command but not limited 
to i2c clients. That obviously also checks whether a function is 
present.

> Compared to v4l2-int-if --- if there's no slave, you'll get -ENODEV,
> and in case of missing command, you get -ENOIOCTLCMD. That's not in
> the tree yet but it's part of OMAP 3 camera driver patches.

In what use case can you ever have no slave? I can easily return -ENODEV 
if client == NULL, but isn't the absence of a slave a severe error so 
that you would have bailed out much earlier? Just wondering.

> Commands in v4l2-int-if could be arranged so that sensor commands are
> grouped together, although they would still share the same namespace,
> unlike in v4l2_client.
>
> > And it was indeed my intention to add a union as well to the
> > client_ops where you can put in mutually-exclusive interfaces. And
> > quite possibly a union as well where you can put in driver-specific
> > interfaces. E.g.:
> >
> > // forward references
> > // If you want to use these ops, then you
> > // have to include drv_foo.h first for the full definition
> > struct drv_foo_ops;
> > struct drv_bar_ops;
> >
> > struct v4l2_client_ops {
> >         const struct v4l2_client_core_ops  *core;
> >         const struct v4l2_client_tuner_ops *tuner;
> >         const struct v4l2_client_audio_ops *audio;
> >         const struct v4l2_client_video_ops *video;
> > 	int drv_id;
> > 	union {
> > 		const struct drv_foo_ops *foo;
> > 		const struct drv_bar_ops *bar;
> > 	} drv;
> > };
> >
> > Since v4l2_client_ops is completely an internal API it can be
> > changed fairly easily if it turns out that the interfaces need to
> > be rearranged for more optimal use.
>
> Union drv will grow huge over time if the interface becomes widely
> used. And there's a dependency to every driver, too. :I

There no such dependency. The v4l2-client.h only needs to provide a 
single forward struct definition. Only if you actually use that 
drv_foo_ops will you need to include the header containing that 
definition.

In general clients should stick to the main ops structs and only add a 
client specific one if it is really needed. That said, I'm not sure 
whether it is such a bad idea to have client specific ops structs. My 
original idea was to add an ioctl type function to the core ops that 
could be used to make client specific commands. However, with an ops 
struct you have strong typing and a more natural way of calling 
clients. That's actually quite nice.

> >> Additionally both can employ the use of machine specific glue code
> >> if needed. It might be that direct OMAP 3 camera driver -> ISP
> >> control path should go away. There are only a few places where
> >> this is done at the moment.
> >>
> >> (Please correct me if I'm mistaken somewhere above. And otherwise,
> >> too. :))
> >
> > ISP = In-System Programming?
>
> ISP stands for Image Signal Processor. It's the block in OMAP 3 that
> the sensors interface to and which does some image processing, too,
> e.g. noise filtering and lens shading correction.

Ah, thanks.

> > I definitely agree that an effort should be made to unify these
> > two. It seems to be the logical approach. But what I am even more
> > interested in is to work on embedding all the v4l drivers into a
> > larger framework of code v4l types providing core v4l services.
> >
> > So by using v4l2_client as the basic type for all client drivers
> > (sensors, lens controllers, audio muxes, video encoders/decoders,
> > you name it), it becomes possible to write basic services for that
> > as well: for example my v4l-dvb-ng tree also contains a v4l2_device
> > type which embodies a v4l device instance (e.g. a webcam, a PCI
> > framegrabber, etc). This structure has a list where all the
> > v4l2_clients register themselves, and they are automatically
> > unloaded when the v4l device is unloaded. In addition, the
> > v4l2_device can be registered with a single global list of
> > v4l2_devices.
> >
> > It's all pretty simple, but every driver is reinventing this stuff
> > again and again. And the quality of those implementations differs
> > enormously.
> >
> > As far as I can see it would be relatively easy to implement both
> > soc and v4l2-int-device on top of v4l2_client: several ops already
> > fall within either core_ops or video_ops, the remainder can
> > initially go into a soc_ops or int_ops. Later these two can be
> > merged into one or more ops structs.
>
>  From your last mail I understood that you found the existing
> implementations of frameworks that offer some kind of abstraction
> between devices that make one V4L device more or less bad. I think we
> should first evaluate what is wrong in the current approaches so we
> don't repeat the mistakes done in them.

The basic idea is the same in all approaches. However, see the following 
shortcomings in the existing implementations:

1) They are not generic, but built to solve a specific problem. To be 
specific: soc-camera.h and v4l2-int-device.h were written for sensors. 
By contrast, the ioctl-type interface used in most other i2c drivers 
(e.g. saa7115, msp3400, etc) is generic.

2) Using 'ops'-like structs is the preferred way of doing such things 
inside the kernel. It is fast, the ops structs themselves can be setup 
as static const and initialized at compile time, and you have strong 
typing. Of the three only soc-camera uses this.

3) Independent of the whatever bus is used by the client driver. This is 
true for soc-camera and v4l2-int-device, but not for the ioctl 
interface used by all other i2c drivers. That relies on the i2c core.

4) Having a single v4l2_client struct as the gateway for all client 
drivers makes it much easier to create supporting functions in the 
v4l2-core that will take over some of the boring bits. For example, 
something like G_CHIP_IDENT can be implemented by a generic 
v4l2_client_g_chip_ident function and by adding a chip_ident and 
chip_rev field to the v4l2_client struct. That function can do all the 
needed checks for you. The same is true for control handling. All 
drivers whether i2c or pci/usb basically need to implement the same 
checks. That can be done much smarter, but it makes only sense if all 
drivers use the same building blocks. I have more ideas, but this gives 
you an idea.

> v4l2_client approach solves more or less the same problem than
> v4l2-int-device, as far as I understand.
>
> SoC camera is a generic camera driver but it does have its own
> calling convention. So the current convention could be replaced but a
> generic camera driver is still needed.

Obviously. It's the calling convention that I'm looking at. Among 
others, since this is just part of what I want to do.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
