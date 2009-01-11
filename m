Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2280 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbZAKRy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 12:54:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Early insights from conversion of cx18 to new v4l2_device framework
Date: Sun, 11 Jan 2009 18:54:32 +0100
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
References: <1231650228.10110.67.camel@palomino.walls.org> <1231681589.3112.37.camel@palomino.walls.org>
In-Reply-To: <1231681589.3112.37.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111854.32735.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 11 January 2009 14:46:29 Andy Walls wrote:
> > > > I'm very interested in how easy it is for you to convert cx18
> > > > to v4l2_subdev. Please let me know anything that is unclear or
> > > > that can be improved in the documentation or code!
>
> Hans,
>
> Converting cx18 to use a v4l2_device object was easy enough.  There's
> not a lot to do, because on it's own it doesn't do to much.  At this
> early stage, without the v4l2_subdev work done, it's simply one more
> piece of kernel rigamarole with which to deal, along with struct
> pci_dev, struct device, struct video_dev.
>
> As I begin the conversion process to v4l2_subdev, I realize it's not
> the straightforward hack for which I was hoping.  A clear first step
> in the porting process needs to be to answer design questions:
>
> 1. What are the v4l2_subdev's for this family of capture devices? 
> (This is actually harder to answer than I thought.)

tuner, cs5345 and cx18-av (the digitizer core). Probably gpio as well; 
this was very useful with ivtv.

> 2. Do I need to write any bridge specific v42l_subdev's?

For the av core and gpio, yes. Note that the reasons for doing this are 
technical (it makes the code easier), rather than compulsory as is the 
case for the external i2c devices.

You can take a peek at ivtv-gpio.c to see how to make a bridge-specific 
subdev. It's trivial.

> 3. What functions do all the needed v4l2_subdev's perform?

It's just a layer on top of i2c devices, making it easier to load and 
initialize them and to call them (and of course v4l2_subdev is no 
longer i2c-specific). The functionality didn't change at all so subdevs 
perform exactly the same functions that they did before.

> 4. What functions will I need from all the functions a
> chip/v4l2_subdev provides?

Again, nothing changed here. The ioctl command maps to the corresponding 
function, that's all.

> 5. How will I manage the subdevs to get at just the particular subdev
> functions I need for any given task?

There are roughly three approaches:

1) Just call them all using v4l2_device_call_all(). Usually this works 
best and I think this might be all you need for cx18. If a subdev 
doesn't support the function then it is just skipped.

2) You can assign some non-zero value to the grp_id of a subdev and pass 
that value with v4l2_device_call_all() to call only subdevs with that 
grp_id.

3) You can store v4l2_subdev pointer somewhere and use that with 
v4l2_subdev_call().

Note that I recommend making some handy variants of 
v4l2_device_call_all() that use the cx18 pointer as their first 
argument. It makes life a bit easier.

> 6. Do I try to deal with the DTV subdevices on my hybrid cards now,
> or wait until later?

No. For now v4l2 sub-devices only deal with V4L2 devices and not with 
DVB devices. Nothing changes on the DVB side.

> These are all up front design questions that I would have done on a
> professional project with a full up front design.  What I found with
> trying to iteratively hack was that decisions come up at many
> junctures with porting this framework to cx18.  I suspect the
> framework will be great for maintenance activities once in place, but
> initial porting of existing drivers probably requires an above
> average level of discipline.
>
> I will elaborate on how I encountered the design questions above,
> later today (I've got to head to out soon).  I'll also propose what I
> think is some guidance to answer question 1 at least. (For highly
> integrated devices with loose internal couplings in places, like
> CX23418, it's not as simple as a "chip" or "something connected to
> I2C, GPIO or other bus lines".)

I'd forgotten about the av-core of the cx23418 that needs to be 
converted to v4l2_subdev. Basically the same work that I did with the 
cx25840 i2c driver. That makes it more work than I realized. Note that 
this is unique to cx18, I don't think other bridge drivers need this.

In general one could say that any a/v encoder/decoder/muxer/tuner device 
is a candidate for v4l2_subdev, whether it is connected through GPIO, 
I2C or part of an integrated device. This is true in particular if the 
same command should be handled by more than one device. E.g. 
VIDIOC_S_STD is typically a command that needs to be sent to multiple 
subdevs (a/v digitizers, tuner), and so it makes sense to view the 
digitizer part of the cx23418 as a subdev as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
