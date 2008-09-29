Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8T9k4LC016295
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 05:46:04 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8T9jk5C024529
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 05:45:46 -0400
Date: Mon, 29 Sep 2008 11:45:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200809291125.45111.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0809291139220.5947@axis700.grange>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0809280012330.10006@axis700.grange>
	<200809291125.45111.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Mon, 29 Sep 2008, Hans Verkuil wrote:

> > Core: Host: enumerate capabilities
> > Core: Client: enumerate capabilities
> > Core: Host: prepare pipe-X converting O on L to U
> > Core: Client: start sending O over L
> >
> > (note, I'm not saying soc-camera can handle all these negotiation
> > perfectly as it stands now). I like your struct v4l2_client_ops, and
> > I think it is not very different from what soc-camera is doing in
> > this regard at the moment - but only the video part. So, it should be
> > possible to convert the soc-camera interface to your v4l2_client.
> > Then, I think, we could think about the host-client negotiation and
> > maybe design it in a way similar to what soc-camera is doing ATM?
> >
> > Note, I am away the whole next week, and quite possibly will not have
> > proper internet connection, only back on 9 October.
> 
> My current prototype implementation uses ivtv as its test driver (since 
> I maintain ivtv that was the logical choice for me).
> 
> Since ivtv is an MPEG encoder driver there are obviously no sensor 
> ioctls implemented. But when v4l2_client is used for sensor drivers I 
> expect that a 'const struct v4l2_client_sensor_ops *sensor;' field will 
> be added that contains the sensor-specific ops. Remember that it is an 
> internal API so it is easy to modify/extend these ops.
> 
> v4l2_client/v4l2_device are meant to provide a consistent framework of 
> working with client drivers. Almost all v4l2 drivers need this and very 
> few (if any) drivers do this correctly. The simple act of unloading a 
> client driver while the bridge driver is still loaded is usually enough 
> to at best prevent the device from working correctly and at worst to 
> create an oops. In addition upcoming changes to the i2c core will make 
> this even harder so it becomes essential to create a unified framework 
> for this so that you can create utility functions that do the hard part 
> of loading and registering client drivers.
> 
> This close dependency between the bridge and client drivers is pretty 
> much unique for v4l2 and the lack of proper support for this meant that 
> most drivers do it wrong. Most people do not realize this since it for 
> normal usage it works fine, but as soon as you start messing around 
> with rmmod you will run into problems. Combine that with the fact that 
> i2c modules can be delayed-loaded in the future and you really need 
> better support in the v4l2 framework since that's a non-trivial problem 
> to solve.

FWIW, with soc-camera all loading and unloading has been tested and worked 
- at least at the time I was developing it. The central module allowes 
arbitrary loading order, and modules use-count is increased as long as 
components are in use.

> Note that during the LPC conference it was decided that I can go ahead 
> with implementing this, so you can expect to see media_client and 
> media_device structs appearing in v4l-dvb during the next month.

Good, looking forward to it! Just, please, make sure to think about 
negotiation issues I mentioned before. I think, we want some standard API 
for those too, at least as much as possible.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
