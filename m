Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85GGPDX025884
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 12:18:44 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m85G7UqE010258
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 12:08:12 -0400
Message-ID: <48C1598B.3010805@nokia.com>
Date: Fri, 05 Sep 2008 19:08:43 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl>
	<48B7E8C4.5060605@nokia.com>
	<200808291543.27863.hverkuil@xs4all.nl>
In-Reply-To: <200808291543.27863.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

ext Hans Verkuil wrote:
> I prefer strong typing whereever possible. Basically this solution 
> allows you to subdivide the full range of operations into several 
> interfaces and drivers can choose to implement one or more of those as 
> needed. If a driver doesn't do anything with audio, then there is no 
> need to define the audio interface, so it doesn't take up any space 
> either (except for a single NULL v4l2_client_audio_ops pointer).

How about caller, does the caller need to ensure that a driver actually
implements a function or how should this be handled?

Compared to v4l2-int-if --- if there's no slave, you'll get -ENODEV,
and in case of missing command, you get -ENOIOCTLCMD. That's not in the
tree yet but it's part of OMAP 3 camera driver patches.

Commands in v4l2-int-if could be arranged so that sensor commands are 
grouped together, although they would still share the same namespace, 
unlike in v4l2_client.

> And it was indeed my intention to add a union as well to the client_ops 
> where you can put in mutually-exclusive interfaces. And quite possibly 
> a union as well where you can put in driver-specific interfaces. E.g.:
> 
> // forward references
> // If you want to use these ops, then you
> // have to include drv_foo.h first for the full definition
> struct drv_foo_ops;
> struct drv_bar_ops;
> 
> struct v4l2_client_ops {
>         const struct v4l2_client_core_ops  *core;
>         const struct v4l2_client_tuner_ops *tuner;
>         const struct v4l2_client_audio_ops *audio;
>         const struct v4l2_client_video_ops *video;
> 	int drv_id;
> 	union {
> 		const struct drv_foo_ops *foo;
> 		const struct drv_bar_ops *bar;
> 	} drv;
> };
> 
> Since v4l2_client_ops is completely an internal API it can be changed 
> fairly easily if it turns out that the interfaces need to be rearranged 
> for more optimal use.

Union drv will grow huge over time if the interface becomes widely used. 
And there's a dependency to every driver, too. :I

>> Additionally both can employ the use of machine specific glue code if
>> needed. It might be that direct OMAP 3 camera driver -> ISP control
>> path should go away. There are only a few places where this is done
>> at the moment.
>>
>> (Please correct me if I'm mistaken somewhere above. And otherwise,
>> too. :))
> 
> ISP = In-System Programming?

ISP stands for Image Signal Processor. It's the block in OMAP 3 that the 
sensors interface to and which does some image processing, too, e.g. 
noise filtering and lens shading correction.

> I definitely agree that an effort should be made to unify these two. It 
> seems to be the logical approach. But what I am even more interested in 
> is to work on embedding all the v4l drivers into a larger framework of 
> code v4l types providing core v4l services.
> 
> So by using v4l2_client as the basic type for all client drivers 
> (sensors, lens controllers, audio muxes, video encoders/decoders, you 
> name it), it becomes possible to write basic services for that as well: 
> for example my v4l-dvb-ng tree also contains a v4l2_device type which 
> embodies a v4l device instance (e.g. a webcam, a PCI framegrabber, 
> etc). This structure has a list where all the v4l2_clients register 
> themselves, and they are automatically unloaded when the v4l device is 
> unloaded. In addition, the v4l2_device can be registered with a single 
> global list of v4l2_devices.
> 
> It's all pretty simple, but every driver is reinventing this stuff again 
> and again. And the quality of those implementations differs enormously.
> 
> As far as I can see it would be relatively easy to implement both soc 
> and v4l2-int-device on top of v4l2_client: several ops already fall 
> within either core_ops or video_ops, the remainder can initially go 
> into a soc_ops or int_ops. Later these two can be merged into one or 
> more ops structs.

 From your last mail I understood that you found the existing 
implementations of frameworks that offer some kind of abstraction 
between devices that make one V4L device more or less bad. I think we 
should first evaluate what is wrong in the current approaches so we 
don't repeat the mistakes done in them.

v4l2_client approach solves more or less the same problem than 
v4l2-int-device, as far as I understand.

SoC camera is a generic camera driver but it does have its own calling 
convention. So the current convention could be replaced but a generic 
camera driver is still needed.

-- 
Sakari Ailus
sakari.ailus@nokia.com


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
