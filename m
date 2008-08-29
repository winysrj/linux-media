Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TCGMEJ018652
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 08:16:23 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TCGEHn019757
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 08:16:14 -0400
Message-ID: <48B7E8C4.5060605@nokia.com>
Date: Fri, 29 Aug 2008 15:17:08 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>	<20080824115725.GG10168@pengutronix.de>	<Pine.LNX.4.64.0808281646420.6514@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl>
In-Reply-To: <200808282058.26623.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

Hi,

(I'm adding Mohit Jalori at TI to Cc:.)

ext Hans Verkuil wrote:
> This is not really a comment on this patch, but more on sensor APIs in 
> general. I'm beginning to be concerned about the many different 
> approaches. We have soc-camera, v4l2-int-device.h which some of the 
> omap drivers want to use, gspca which basically sees the bridge driver 
> and sensor as one unit, and probably other attempts that I do not know 
> about.

I agree. Although I didn't know about the rest beyond SoC camera and 
v4l2-int-if.

I'm kind of responsible for the v4l2-int-device stuff. At the time there 
was no SoC camera and it was my attempt to break the connection between 
the camera controller and the sensor. It also aims to be usable outside 
camera V4L devices.

Guennadi published SoC camera before he knew about v4l2-int-if and so we 
had two approaches. Lately I haven't had time to pay attention to new 
developments which I'm a bit sorry for.

> I am strongly in favor of discussing this situation during the Portland 
> Linux Plumbers Conference where at least Mauro, Hans de Goede, Manju 
> from TI and myself will be present.

I'm unlikely to be able to participate. :I

> Lately I've been experimenting with improving the V4L2 framework. 
> Prototyping code can be found in my hg/~hverkuil/v4l-dvb-ng/ tree. It 
> provides a new generic 'ops' structure (see media/v4l2-client.h) that 
> can be used both by i2c drivers and non-i2c driver alike, that is easy 
> to extend and that will work for all client drivers, not just sensors. 
> And it can be implemented in existing i2c drivers without requiring 
> that the current PCI/USB drivers that use them need to be converted at 
> the same time.
> 
> The client ops structure is this:
> 
> struct v4l2_client_ops {
>         const struct v4l2_client_core_ops  *core;
>         const struct v4l2_client_tuner_ops *tuner;
>         const struct v4l2_client_audio_ops *audio;
>         const struct v4l2_client_video_ops *video;
> };
> 
> Basically it's a bunch of (possibly NULL) pointers to other ops 
> structures. The pointers can by NULL so that client drivers that are 
> video only do not need to implement e.g. audio ops. It is easy to 
> extend this with other ops structs like a sensor_ops. It probably fits 
> fairly well with soc_camera which does something similar, except that 
> this approach is general.

The major diff to v4l2-int-if is that this defines device types. I guess 
this way it's easier to define what kind of ioctls are expected to work 
for clients. Although I didn't want to define such list as I wasn't 
quite sure I could come up with a definite one at the time. So now it's 
actually defined by what the master expects but the size of the 
structure holding the slave function calls does not grow even if the 
slave calls themselves change or more calls are added. It was due to 
this argument that ioctl-like interface was selected for v4l2-int-if 
instead. Think of all the ioctls supported by V4L2.

struct v4l2_client_ops should at least be a union. But this should not 
be a problem as long as the clients have a type.

> Remember, it is only prototyping code, but I consider it to be a very 
> promising approach. There is a serious lack of V4L2 core support which 
> means that drivers tend to re-invent the wheel and all to often that 
> wheel looks suspiciously square to me.

It is not completely obvious to me, at least, what are the calls that 
are requred to be implemented by the sensor driver. The current sensors 
that are supported by Linux (at least the ones I know) are so-called 
smart sensors. All the control algorithms (AE, AWB and possibly AF) are 
run directly on the microcontroller inside the sensor module itself.

The direction, as far as I see, is towards separating the sensor from 
the image processing. An example of this is the OMAP 3 ISP. The OMAP 3 
camera driver is able to work with smart sensors, too, but it's meant to 
be used with raw sensors that just produce raw bayer matrix.

The bayer matrix input is converted (to YUV422, for example) and scaled 
based on user requirements.

The ISP with a raw bayer sensor does not implement the same 
functionality that smart sensors offer. It only produces statistics 
(OMAP 3 ISP, for example) that are useful for the actual control 
algorithms (AE, AWB and AF). One of the consequences are that the 
algorithms are run on host system and these algorithms require 
additional information, something that used to be handled only inside 
the smart sensor. It's not that much different, though.

> Sorry for the 'rant' about the state the V4L2 sub-system is in, it's not 
> a reflection on your patch, it only provided the trigger for this 
> outburst of mine.

:)

I've been thinking it could make sense to unify v4l2-int-if and SoC 
camera efforts in longer term.

Although the approach in SoC camera is somewhat different than in 
v4l2-int-if they share some similarities. V4l2-int-if tries to define 
common set of commands for commanding different hardware devices that 
make one V4L2 device, e.g. /dev/video0. SoC camera, OTOH, is a 
hardware-independent camera driver that can interface with different 
camera controllers and image sensors.

Interestingly, the concepts used in v4l2-int-if and SoC camera are quite
similar. Roughly equivalent pieces can be found easily:

v4l2-int-if + OMAP 3 camera		SoC camera

OMAP 3 camera driver (int if master)	SoC camera driver
OMAP 3 ISP driver			host
sensor (int if slave)            	device
lens (int if slave)
flash (int if slave)

Control flow:

SoC camera
|    \
|     \
|      \
|       \
host    device

OMAP 3 camera driver
|    |        |   \
|    |        |    \
|    |        |     \
|    |        |      \
|    sensor   lens    flash
|    |
|    |
|    machine/platform specific code
|      /
|     /
|    /
|   /
|  /
ISP

Additionally both can employ the use of machine specific glue code if
needed. It might be that direct OMAP 3 camera driver -> ISP control
path should go away. There are only a few places where this is done at
the moment.

(Please correct me if I'm mistaken somewhere above. And otherwise, too. :))

I think few hardware-specific things are ending up in the OMAP 3 camera 
driver. On that side it seems we could perhaps even make OMAP 3 camera 
driver a generic camera driver that could support lens and flash devices 
as well.

Making the ISP driver a v4l2-int-if slave would help a lot --- this
would remove the camera driver -> ISP driver dependency. The ISP driver
would be the fourth slave for the camera driver in that case. But it 
required a standard interface, too. In this case it might make sense to 
separate image processing capabilities from the bare sensor hw interface 
(i.e. CCP2 receiver).

Best regards,

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
