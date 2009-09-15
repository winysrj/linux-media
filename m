Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60289 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZIOOJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 10:09:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Media controller: sysfs vs ioctl
Date: Tue, 15 Sep 2009 16:10:38 +0200
Cc: linux-media@vger.kernel.org
References: <200909120021.48353.hverkuil@xs4all.nl>
In-Reply-To: <200909120021.48353.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909151610.38397.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 12 September 2009 00:21:48 Hans Verkuil wrote:
> Hi all,
> 
> I've started this as a new thread to prevent polluting the discussions of
>  the media controller as a concept.

[snip]
 
> What sort of interaction do we need with sub-devices?
 
[snip]
 
> 2) Private ioctls. Basically a way to set and get data that is hardware
> specific from the sub-device. This can be anything from statistics,
>  histogram information, setting resizer coefficients, configuring
>  colorspace converters, whatever. Furthermore, just like the regular V4L2
>  API it has to be designed with future additions in mind (i.e. it should
>  use something like reserved fields).
> 
> In my opinion ioctls are ideal for this since they are very flexible and
>  easy to use and efficient. Especially because you can combine multiple
>  fields into one unit. So getting histogram data through an ioctl will also
>  provide the timestamp. And you can both write and read data in one atomic
>  system call. Yes, you can combine data in sysfs reads as well. Although an
>  IORW ioctls is hard to model in sysfs. But whereas an ioctl can just copy
>  a struct from kernel to userspace, for sysfs you have to go through a
>  painful process of parsing and formatting.
> 
> And not all this data is small. Histogram data can be 10s of kilobytes.
>  'cat' will typically only read 4 kB at a time, so you will probably have
>  to keep track of how much is read in the read implementation of the
>  attribute. Or does the kernel do that for you?

If I'm not mistaken sysfs binary attributes can't be bigger than 4kB in size.

[snip]

> The final part is how to represent the topology. Device nodes and
>  sub-devices can be exposed to sysfs as discussed earlier. Representing
>  both the possible and current links between them is a lot harder. This is
>  especially true for non-v4l device nodes since we cannot just add
>  attributes there. I think this can be done though by providing that
>  information as attributes of an mc sysfs node. That way it remains under
>  control of the v4l core.

I was a bit concerned (to say the least) when I started catching up with my e-
mails and reading this thread that the discussion would heat up and split 
developers between two sides. While trying to find arguments to convince 
people that my side is better (and of course it is, otherwise I would be on 
the other side :-)) I realized that the whole media controller problem might 
be understood differently by the two sides. I'll try to shed some light on 
this in the hope that it will bring the v4l developers together.

sysfs was designed to expose kernel objects arranged in a tree-like fashion. 
It does that pretty well, although one of its weak points is that it can be 
easily abused.

>From the kernel point of view, (most of) the various sub-devices in a media 
device are arranged in a tree of kernel objects. Most of the time we have an 
I2C controller and various devices sitting on the I2C bus, one or several 
video devices that sit on some internal bus (usually a SoC internal bus for 
the most complex and recent platforms), and possibly SPI and other devices as 
well.

Realizing that, as all those sub-devices are already exposed in sysfs in one 
way or the other, it was tempting to add a few attributes and soft links to 
solve the media controller problem.

However, that solution, even if it might seem simple, misses a very important 
point. Sub-devices are arranged in a tree-like objects structure from the 
kernel point of view, but from the media controller point of view they are 
not. While the kernel cares about kernel objects that are mostly devices on 
busses in parent-children relationships, the media controller cares about how 
video is transferred between sub-devices. And those two concepts are totally 
different.

The sub-devices, from the media controller point of view, make an oriented 
graph of connected nodes. When setting video controls, selecting formats and 
streaming video, what we care about it how the video will flow from its source 
(a sensor, a physical connector, memory, whatever) to its sink (same list of 
possible whatevers). This is what the media controller needs to deal with.

We need to expose a connected graph of nodes to userspace, and let userspace 
access the nodes and the links for various operations. Of course it would be 
possible to handle that through sysfs, as sub-devices are already exposed 
there. But let's face it, it wouldn't be practical, efficient or even clean.

Hans already mentioned several reasons why using sysfs attributes to replace 
all media controller ioctls would be cumbersome. I would add that we need to 
transfer large amounts of aggregated data in some cases (think about 
statistics), and sysfs attributes are simply not designed for that. There's a 
4kB limit for text attributes, and Documentation/filesystems/sysfs.txt states 
that

"Attributes should be ASCII text files, preferably with only one value
per file. It is noted that it may not be efficient to contain only one
value per file, so it is socially acceptable to express an array of
values of the same type.

Mixing types, expressing multiple lines of data, and doing fancy
formatting of data is heavily frowned upon. Doing these things may get
you publically humiliated and your code rewritten without notice."

In the end, I believe that the reason why we need a media controller device 
(which could be called differently of course) and ioctls is exactly the same 
reason why we need ioctls for v4l devices. Would it be possible to replace 
VIDIOC_[GS]_FMT with sysfs attributes ? Yes. Would it be useful, clean and 
efficient ? No.

This discussion isn't meant to convince people of the pros and cons of sysfs. 
Sysfs is useful, it exposes the tree of kobjects to userspace, and thus lets 
userspace knows about the tree of devices that make the platform applications 
run on. This is invaluable and led to things like hal and udev that really 
made a huge difference for Linux. However, sysfs doesn't wash your clothes nor 
does it solve world hunger. No need to be sad about that, it wasn't designed 
for it in the first place. Let's not abuse it and try to make the media 
controller problem fit the sysfs design using hammers and crowbars. In the end 
both the media controller and sysfs would suffer.

The media controller is required to solve a very complex problem brought by 
very complex hardware. The problem has been solved using lots of ugly hacks on 
proprietary platforms, let's show that Linux can solve it cleanly and simply.

-- 
Laurent Pinchart
