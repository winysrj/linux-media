Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VBZ9pQ001012
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 07:35:09 -0400
Received: from smtp-vbr13.xs4all.nl (smtp-vbr13.xs4all.nl [194.109.24.33])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9VBYT31009280
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 07:34:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Fri, 31 Oct 2008 12:34:16 +0100
References: <200810191632.36406.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0810310955190.5691@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0810310955190.5691@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810311234.16439.hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>, v4l <video4linux-list@redhat.com>
Subject: Re: Feedback wanted: V4L2 framework additions
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

On Friday 31 October 2008 10:26:07 Guennadi Liakhovetski wrote:
> Hi Hans,
>
> On Sun, 19 Oct 2008, Hans Verkuil wrote:
> > Hi all,
> >
> > During the Linux Plumbers Conference I proposed additions to the
> > V4L2 framework that should simplify driver development and ensure
> > better consistency between drivers.
> >
> > The last few days I worked to get this framework in place and I
> > would like to get feedback on what I have right now.
> >
> > The repository is here:
> >
> > http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/
> >
> > The documentation is in:
> >
> > linux/Documentation/video4linux/v4l2-framework.txt
> >
> > The documentation is pretty complete, so that's probably a good
> > place to start.
> >
> > The purpose of the framework is to move common administrative tasks
> > to the framework so that drivers do not have to do that themselves.
> > In addition, having all drivers use the same basic structures will
> > make it much easier to write new helper functions that only use
> > those basic structures and so can be independent of the
> > driver-specific structs.
>
> [snip]
>
> ok, I had a very short look at your proposed framework. I only looked
> at the video part, because that's what I'm working with, and that's
> what I'm going to comment on here.
>
> And there is at least one thing I haven't found there at all, which,
> I think, belongs to such an interface (and what currently makes up a
> significant part of the soc-camera framework): hardware interface
> parameter negotiation. Maybe this is not a big problem on closed
> cards / dongles, where the interface is fixed, but even then, I
> think, if you have two usb cameras with the same sensor, they might
> use different video interface configurations. If you want to share
> that sensor driver, you have to be able to negotiate with it which
> configuration to use. E.g., some sensors support both master and
> slave modes, some only master, maybe there are some, that only
> support the slave mode (I haven't seen any, but there can be some).
> Some hosts support one or the other mode, and some support both and
> have to be programmed accordingly. We assume, those who design
> hardware will only choose valid host / sensor configurations. So,
> let's assume, you have one USB camera with host A and sensor X, and
> one camera with host A and sensor Y, where X only runs as a master,
> and Y only as a slave. As long as you have two completely different
> drivers AX and AY, you just hard code master or slave and you're
> done. However, if you share the A driver and want to be able to talk
> to X and Y, you have to ask them what modes they support. Same goes
> for signal polarities (hsync, vsync, pixel clock, master clock,
> data), bus width.
>
> Then there's a question of on-the-wire data representation, which I
> tried to discuss here:
>
> http://marc.info/?l=linux-video&m=122423270414747&w=2
>
> Ok, if I really wanted to start a discussion, I should have used a
> new thread with a different subject, but so far almost all my
> attempts to discuss design decisions on v4l ended up with silence:-)
> In any case, there came one reply from Magnus Damm, and he agreed
> with my idea to treat every possible pixel-format as transferred over
> the data bus as a new fourcc format, but I cannot say I'm quite happy
> about this, and not quite sure this wouldn't lead to an explosive
> growth of the number of fourcc codes, of which many will actually
> provide the same "end-user experience" and only differ in the way
> they are transferred from the sensor to the host.
>
> So, if we decide to only maintain a minimal number of really
> different (from the user PoV) fourcc codes and use additional
> parameters (endianness, packing,...) to describe their on-the-wire
> representation, we'd need to handle that in such a host-device
> interface too.

Hi Guennadi,

First of all, if you request information and you receive no answer 
within a few days, then just repost your mail. People are busy, working 
on other things or abroad, and so postings can sometimes go without an 
answer. Reposting usually helps, if only because it also tells us that 
someone really cares. It's perfectly acceptable to repost every so 
often if you don't get an answer.

Now, regarding my API: I fully expect that a sensor API will be added. 
I'm not going to do that myself since I'm no expert in that area. 
However, if you need changes in the underlying framework, please just 
ask. Don't work around limitations, but bring them to my attention so 
that they can be fixed.

With respect to fourcc: any unique image format that the user 
application can receive from the driver should have its own unique 
fourcc. Also, no image conversion from one format to another should 
take place inside a driver. Instead you should add support for the 
non-standard fourcc code to the v4l library from Hans de Goede. That's 
the correct way of doing it. So yes, this will probably result in a 
large number of fourcc codes, but that's not a problem as long as the 
v4l lib can be used to convert it to something more standard.

When it comes to the internal signalling between the sensor and the 
host, I expect that to be set by the sensor API. The user doesn't have 
to set this, right? This is driver internal?

Assuming that's the case, then you just need to add a struct 
v4l2_subdev_sensor_ops.

One thing that was not mentioned in any of the docs (but discussed 
during the Portland conference in September) is that if needed it is 
easy to add a callback to v4l2_device so that the sub device driver can 
call the bridge device driver. The idea is to have something like:

  int (*callback)(struct v4l2_subdev *sd, int cmd, void *arg);

inside struct v4l2_device(). The main purpose is for notifications.
However, I'm not going to add that unless there is a clear need for it.

I hope to continue with this framework this weekend. I've got some good 
feedback and some changes are needed. But I'm planning no changes to 
v4l2_subdev as I didn't receive any feedback on that part.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
