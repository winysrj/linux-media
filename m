Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52507 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZAKTUR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 14:20:17 -0500
Subject: Re: Early insights from conversion of cx18 to new v4l2_device
	framework
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
In-Reply-To: <200901111854.32735.hverkuil@xs4all.nl>
References: <1231650228.10110.67.camel@palomino.walls.org>
	 <1231681589.3112.37.camel@palomino.walls.org>
	 <200901111854.32735.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 14:22:19 -0500
Message-Id: <1231701740.3123.65.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-01-11 at 18:54 +0100, Hans Verkuil wrote:
> On Sunday 11 January 2009 14:46:29 Andy Walls wrote:
> > > > > I'm very interested in how easy it is for you to convert cx18
> > > > > to v4l2_subdev. Please let me know anything that is unclear or
> > > > > that can be improved in the documentation or code!
> >
> > Hans,
> >
> > Converting cx18 to use a v4l2_device object was easy enough.  There's
> > not a lot to do, because on it's own it doesn't do to much.  At this
> > early stage, without the v4l2_subdev work done, it's simply one more
> > piece of kernel rigamarole with which to deal, along with struct
> > pci_dev, struct device, struct video_dev.
> >
> > As I begin the conversion process to v4l2_subdev, I realize it's not
> > the straightforward hack for which I was hoping.  A clear first step
> > in the porting process needs to be to answer design questions:
> >
> > 1. What are the v4l2_subdev's for this family of capture devices? 
> > (This is actually harder to answer than I thought.)
> 
> tuner, cs5345 and cx18-av (the digitizer core). Probably gpio as well; 
> this was very useful with ivtv.
> 
> > 2. Do I need to write any bridge specific v42l_subdev's?
> 
> For the av core and gpio, yes. Note that the reasons for doing this are 
> technical (it makes the code easier), rather than compulsory as is the 
> case for the external i2c devices.
> 
> You can take a peek at ivtv-gpio.c to see how to make a bridge-specific 
> subdev. It's trivial.

Hans,

Right.  I wasn't specifically looking for answers from you (but hey
thanks!), but more wanted to bring attention to the issues so that
others can learn from my stumbling/poor planning.

But anyway, I wanted to propose some guidance/thought on what should be
implmented as subdevs (Design question #1).  I came up with the
following:

a) discrete support chips (obviously)
b) a function controlled by discrete GPIO lines
c) bridge chip internal blocks that are loosely coupled in both the
register set *and* with other internal blocks

d) avoid separate subdevs for chip internal functions that are not
loosely coupled in register set or not loosely coupled in relation to
other chip internal blocks
e) avoid ganging all the GPIO control discretes together into one "gpio"
subdev, unless all those discretes are truly related in function.

In the above, c) and d) are exactly aimed at the A/V decoder core that
is embedded in the cx23418 and other chips.  This core is very loosely
coupled to the rest of the chip including it's register set.  Note that
the A/V core's analog mux/frontend, video, vbi, IR, and audio processing
sub-blocks are also loosely coupled in the register set as well (well
defined partitions in register ranges), but their operation is somewhat
coupled to very coupled by the clocks and timing, so that all these
functions are really part of one A/V core subdev.

In the above, I think c) also applies to the Serial Audio vs. Tuner
audio muxing done in cx18_audio_set_io().  That mux falls into the
category of being very loosely coupled to the A/V core register set and
being very loosely coupled to the AV core as well (AFAICT).

In the above, d) is also aimed at not having separate "logical" subdevs
of one discrete chip: the CS5345 supports audio mux-ing and audio
control (e.g. volume), but these functions are tightly coupled in the
register set so it's should be only one subdev (obvious due to the chip
boundary, but worth a mention).

In the above, e) is aimed at the rather independent nature of the
possible GPIO connected devices: LED's, audio mux, device resets, tuner
resets, and IR blaster debug serial port.

Thus, I saw the cx18 driver needing the following v4l2_subdevs:

cs5345
tuner (analog - are synthesizer/mixer & IF demod separate?)
cx18_av_core
cx18_i2s_mux
gpio audio mux
gpio reset controller
gpio LED controller
IR microcontroller debugger port (via GPIO - future effort)



> > 3. What functions do all the needed v4l2_subdev's perform?
> 
> It's just a layer on top of i2c devices, making it easier to load and 
> initialize them and to call them (and of course v4l2_subdev is no 
> longer i2c-specific). The functionality didn't change at all so subdevs 
> perform exactly the same functions that they did before.
>
> > 4. What functions will I need from all the functions a
> > chip/v4l2_subdev provides?
> 
> Again, nothing changed here. The ioctl command maps to the corresponding 
> function, that's all.

I think I miscommunicated in these questions.

Yes as far as the subdev usage goes, they support the following high
level Use Cases by the bridge chip driver, another driver (i.e. lirc),
or the kernels:

a) device initialization
b) device status/state
c) supporting ioctl() calls
d) supporting normal ops via systems calls (open(), read(), write(),
etc) and for interrupts
e) direct access to subdevs for functions and algorithms not performed
in the bridge driver (i2c_dev and lirc come to mind).



But what I was really asking were the questions that a developer needs
to consider in the design up front (which I negelected to do).

For example, the CS5345 can support audio multiplexing as well as audio
(volume) control.  Which will the bridge driver use: both or only one?
Right now cx18 only uses the audio mux function of the CS5345.  But I
may want to use the volume control in the CS5345 for I2S audio.

Those sort of design decisions is what I was trying to highlight.


> > 5. How will I manage the subdevs to get at just the particular subdev
> > functions I need for any given task?
> 
> There are roughly three approaches:
> 
> 1) Just call them all using v4l2_device_call_all(). Usually this works 
> best and I think this might be all you need for cx18. If a subdev 
> doesn't support the function then it is just skipped.

Yes, that was my first choice - at least for the first cut.


> 2) You can assign some non-zero value to the grp_id of a subdev and pass 
> that value with v4l2_device_call_all() to call only subdevs with that 
> grp_id.

I'd probably base my group id's on ioctl() serviced by the subdev.


> 3) You can store v4l2_subdev pointer somewhere and use that with 
> v4l2_subdev_call().

I think I'd need a linked list of subdev's for the "audio muxing" group.
Since the total list of subdevs should be short for any one card, the
group id is probably better to use.


> Note that I recommend making some handy variants of 
> v4l2_device_call_all() that use the cx18 pointer as their first 
> argument. It makes life a bit easier.

Noted.



> > 6. Do I try to deal with the DTV subdevices on my hybrid cards now,
> > or wait until later?
> 
> No. For now v4l2 sub-devices only deal with V4L2 devices and not with 
> DVB devices. Nothing changes on the DVB side.

My concern is that the DVB tuner and demod are on the same I2C bus as
some of the other subdevs, plus the "reset controller" I'm planning on
will be able to reset them.  

Also I'm concerned about the case when an mxl5005s is used for both
analog and digital in the future.  I guess I'm concerned about rework -
but since I can't see the future clearly, I'll leave them alone. :)


> > These are all up front design questions that I would have done on a
> > professional project with a full up front design.  What I found with
> > trying to iteratively hack was that decisions come up at many
> > junctures with porting this framework to cx18.  I suspect the
> > framework will be great for maintenance activities once in place, but
> > initial porting of existing drivers probably requires an above
> > average level of discipline.
> >
> > I will elaborate on how I encountered the design questions above,
> > later today (I've got to head to out soon).  I'll also propose what I
> > think is some guidance to answer question 1 at least. (For highly
> > integrated devices with loose internal couplings in places, like
> > CX23418, it's not as simple as a "chip" or "something connected to
> > I2C, GPIO or other bus lines".)
> 
> I'd forgotten about the av-core of the cx23418 that needs to be 
> converted to v4l2_subdev. Basically the same work that I did with the 
> cx25840 i2c driver. That makes it more work than I realized.

Yes.  Coming to that realization at 1130 at night after a few hours of
reading and hacking is not a joyful experience.  Oh well, shame on me
for not going through a proper design.


>  Note that 
> this is unique to cx18, I don't think other bridge drivers need this.

I thought that A/V core might show up in a few Conexant chips.

The A/V core isn't the only internal bridge chip block that can be a
subdev, in general IMO, so other drivers may run across this as well.



> In general one could say that any a/v encoder/decoder/muxer/tuner device 
> is a candidate for v4l2_subdev, whether it is connected through GPIO, 
> I2C or part of an integrated device. This is true in particular if the 
> same command should be handled by more than one device. E.g. 
> VIDIOC_S_STD is typically a command that needs to be sent to multiple 
> subdevs (a/v digitizers, tuner), and so it makes sense to view the 
> digitizer part of the cx23418 as a subdev as well.

Agree.  I'm partial to the criteria/guidance I gave above,a)-e) in the
discussion for design question 1, for deciding if a device should be
handled as a v4l2_subdev. 

Regards,
Andy

> Regards,
> 
> 	Hans


