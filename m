Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8T9QMI9009959
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 05:26:23 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8T9QApZ013370
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 05:26:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Mon, 29 Sep 2008 11:25:45 +0200
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0809280012330.10006@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0809280012330.10006@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809291125.45111.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Sunday 28 September 2008 00:38:23 Guennadi Liakhovetski wrote:
> Hi Hans,
>
> On Thu, 28 Aug 2008, Hans Verkuil wrote:
> > Lately I've been experimenting with improving the V4L2 framework.
> > Prototyping code can be found in my hg/~hverkuil/v4l-dvb-ng/ tree.
> > It provides a new generic 'ops' structure (see media/v4l2-client.h)
> > that can be used both by i2c drivers and non-i2c driver alike, that
> > is easy to extend and that will work for all client drivers, not
> > just sensors. And it can be implemented in existing i2c drivers
> > without requiring that the current PCI/USB drivers that use them
> > need to be converted at the same time.
> >
> > The client ops structure is this:
> >
> > struct v4l2_client_ops {
> >         const struct v4l2_client_core_ops  *core;
> >         const struct v4l2_client_tuner_ops *tuner;
> >         const struct v4l2_client_audio_ops *audio;
> >         const struct v4l2_client_video_ops *video;
> > };
> >
> > Basically it's a bunch of (possibly NULL) pointers to other ops
> > structures. The pointers can by NULL so that client drivers that
> > are video only do not need to implement e.g. audio ops. It is easy
> > to extend this with other ops structs like a sensor_ops. It
> > probably fits fairly well with soc_camera which does something
> > similar, except that this approach is general.
>
> [...]
>
> Finally I took a couple of minutes and looked at your v4l-dvb-ng tree
> - I really did:-) Do I understand it right, that you currently only
> have some infrastructure in place (v4l2-client.h, v4l2-client.c,
> v4l2-common.c) and some client drivers like saa717x.c, but no "host"
> (USB or PCI or SoC) drivers and no APIs for host / client
> communication? And it is exactly this part that makes this
> generalisation so interesting. How you let the host driver specify
> what interface it has to the client (slave serial, or master
> parallel, 8 or 10 bits...) and what data (pixel) formats it is
> prepared to accept. Like:
>
> Host: I have a XYZ-compatible device at i2c-address II
> Client: XYZ-device version ABC detected at i2c-address II
> User: need format U
> Client: device is capabale of formats O, P, Q over bus types L, M, N
> Host: suggest you send me format O using bus type L, I convert it to
> U
>
> Or even
>
> Core: Host: enumerate capabilities
> Core: Client: enumerate capabilities
> Core: Host: prepare pipe-X converting O on L to U
> Core: Client: start sending O over L
>
> (note, I'm not saying soc-camera can handle all these negotiation
> perfectly as it stands now). I like your struct v4l2_client_ops, and
> I think it is not very different from what soc-camera is doing in
> this regard at the moment - but only the video part. So, it should be
> possible to convert the soc-camera interface to your v4l2_client.
> Then, I think, we could think about the host-client negotiation and
> maybe design it in a way similar to what soc-camera is doing ATM?
>
> Note, I am away the whole next week, and quite possibly will not have
> proper internet connection, only back on 9 October.

My current prototype implementation uses ivtv as its test driver (since 
I maintain ivtv that was the logical choice for me).

Since ivtv is an MPEG encoder driver there are obviously no sensor 
ioctls implemented. But when v4l2_client is used for sensor drivers I 
expect that a 'const struct v4l2_client_sensor_ops *sensor;' field will 
be added that contains the sensor-specific ops. Remember that it is an 
internal API so it is easy to modify/extend these ops.

v4l2_client/v4l2_device are meant to provide a consistent framework of 
working with client drivers. Almost all v4l2 drivers need this and very 
few (if any) drivers do this correctly. The simple act of unloading a 
client driver while the bridge driver is still loaded is usually enough 
to at best prevent the device from working correctly and at worst to 
create an oops. In addition upcoming changes to the i2c core will make 
this even harder so it becomes essential to create a unified framework 
for this so that you can create utility functions that do the hard part 
of loading and registering client drivers.

This close dependency between the bridge and client drivers is pretty 
much unique for v4l2 and the lack of proper support for this meant that 
most drivers do it wrong. Most people do not realize this since it for 
normal usage it works fine, but as soon as you start messing around 
with rmmod you will run into problems. Combine that with the fact that 
i2c modules can be delayed-loaded in the future and you really need 
better support in the v4l2 framework since that's a non-trivial problem 
to solve.

Note that during the LPC conference it was decided that I can go ahead 
with implementing this, so you can expect to see media_client and 
media_device structs appearing in v4l-dvb during the next month.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
