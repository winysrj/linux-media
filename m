Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:48422 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab0DFOif (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 10:38:35 -0400
Date: Tue, 6 Apr 2010 09:33:30 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <201004052347.10845.hverkuil@xs4all.nl>
Message-ID: <alpine.DEB.1.10.1004060848540.27169@cnc.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Comments below...

On Mon, 5 Apr 2010, Hans Verkuil wrote:

> Hi all,
> 
> The new control framework makes it very easy to expose controls in sysfs.
> The way it is implemented now in the framework is that each device node
> will get a 'controls' subdirectory in sysfs. Below which are all the controls
> associated with that device node.
> 
> So different device nodes can have different controls if so desired.
> 
> The name of each sysfs file is derived from the control name, basically making
> it lowercase, replacing ' ', '-' and '_' with '_' and skipping any other non-
> alphanumerical characters. Seems to work well.
> 
> For numerical controls you can write numbers in decimal, octal or hexadecimal.
> 
> When you write to a button control it will ignore what you wrote, but still
> execute the action.
> 
> It looks like this for ivtv:
> 
> $ ls /sys/class/video4linux/video1
> controls  dev  device  index  name  power  subsystem  uevent
> 
> $ ls /sys/class/video4linux/video1/controls
> audio_crc                    chroma_gain                   spatial_chroma_filter_type  video_bitrate_mode
> audio_emphasis               contrast                      spatial_filter              video_encoding
> audio_encoding               hue                           spatial_filter_mode         video_gop_closure
> audio_layer_ii_bitrate       insert_navigation_packets     spatial_luma_filter_type    video_gop_size
> audio_mute                   median_chroma_filter_maximum  stream_type                 video_mute
> audio_sampling_frequency     median_chroma_filter_minimum  stream_vbi_format           video_mute_yuv
> audio_stereo_mode            median_filter_type            temporal_filter             video_peak_bitrate
> audio_stereo_mode_extension  median_luma_filter_maximum    temporal_filter_mode        video_temporal_decimation
> balance                      median_luma_filter_minimum    video_aspect                volume
> brightness                   mute                          video_b_frames
> chroma_agc                   saturation                    video_bitrate
> 
> 
> The question is, is this sufficient?
> 
> One of the few drivers that exposes controls in sysfs is pvrusb2. As far as
> I can tell from the source it will create subdirectories under the device
> node for each control. Those subdirs have the name ctl_<control-name> (e.g.
> ctl_volume), and below that are files exposing all the attributes of that
> control: name, type, min_val, max_val, def_val, cur_val, custom_val, enum_val
> and bit_val. Most are clear, but some are a bit more obscure. enum_val is
> basically a QUERYMENU and returns all menu options. bit_val seems to be used
> for some non-control values like the TV standard that pvrusb2 also exposes
> and where bit_val is a bit mask of all the valid bits that can be used.
> 
> Mike, if you have any additional information, just let us know. My pvrusb2
> is in another country at the moment so I can't do any testing.

Hans:

What you see in the pvrusb2 driver is the result of an idea I had back 
in 2005.  The pvrusb2 driver has an internal "control" API; my original 
idea back then was to then reimplement other interfaces on top of that 
API, in a manner that is as orthogonal as possible.  The reality today 
is still pretty close to that concept (except for DVB unfortunately 
since that framework's architecture effectively has to take over the RF 
tuner...); the V4L2 implementation in the driver certainly works this 
way.  The sysfs interface you see here is the result of implementing the 
same API through sysfs.  Right now with the pvrusb2 driver the only 
thing not exported through sysfs is the actual streaming of video 
itself.

The entire sysfs implementation in the driver can be found in 
pvrusb2-sysfs.c.  Notice that the file is generic; there is not anything 
in it that is specific to any particular control.  Rather, 
pvrusb2-sysfs.c is able to iterate through the driver's controls, 
picking up the control's name, its type, and accessors.  Based on what 
it finds, this module then synthesizes the interface that you see in 
/class/pvrusb2/* - it's actually possible to add new controls to the 
driver without changing anything in pvrusb2-sysfs.c.


> 
> Personally I think that it is overkill to basically expose the whole
> QUERYCTRL information to sysfs. I see it as an easy and quick way to read and
> modify controls via a command line.

Over time, I have ended up using pretty much every control in that 
interface.  Obviously not every control always gets touched, but I have 
found it extremely valuable to have such direct access to every "knob" 
in the driver this way.

Also, the original concept was that the interface was to be orthogonal; 
in theory any kind of control action in one interface should be just as 
valid in another.


> 
> Mike, do you know of anyone actively using that additional information?

Yes.

The VDR project at one time implemented a plugin to directly interface 
to the pvrusb2 driver in this manner.  I do not know if it is still 
being used since I don't maintain that plugin.

I have over the years seen feedback from many users who just love using 
the sysfs interface - by using sysfs for access to all the knobs & 
switches while just using "cat /dev/video0" (or whatever) to grab the 
video stream, it's possible to nearly completely operate the device 
without writing a single line of C code.  I have read of some people who 
have hacked up shell scripts for special purposes using this driver.  

When I say "nearly completely" above, the big asterisk there is DVB.  
The analog side is completely operable via sysfs.  However because of 
the way DVB works it is currently not possible to export the digital 
side of the driver through anything except DVB itself (a situation that 
I find to be "wrong" but probably will be very difficult to solve 
technically due to DVB's architecture and will likely be impossible 
anyway because the kinds of pvrusb2 driver changes that I think would be 
required probably won't be accepted by others anyway so I haven't been 
very motivated to attack the problem).


> 
> And which non-control values do you at the moment expose in pvrusb2 through
> sysfs? Can you perhaps give an ls -R of all the files you create in sysfs
> for pvrusb2?

*ALL* of them are exposed.  The exact set is synthesized at run-time by 
pvrusb2-sysfs.c via introspection of the control API defined in 
pvrusb2-hdw.h.  In the in-V4L version of the pvrusb2 driver this set of 
controls is likely a constant, but it has certainly changed over time as 
V4L and the pvrusb2 driver have evolved.  In the standalone pvrusb2 
driver, the control set can actually vary due to ifdef's in 
pvrusb2-hdw.c, which are affected by the kernel version and v4l-dvb 
snapshot against which the driver is compiled.


> 
> I am wondering whether some of those should get a place in the 
> framework as well. While I don't think e.g. cropping parameters are 
> useful, things like the current input or tuner frequency can be handy. 
> However, for those to be useful they would have to be wired up 
> internally through the framework. For example, VIDIOC_S_FREQUENCY 
> would have to be hooked up internally to a control. That would ensure 
> that however you access it (ioctl or sysfs) it will both end up in the 
> same s_ctrl function.

I think you're missing a critical point here.

There isn't any logic in the module within the pvrusb2 driver which 
"decides" which controls to expose.  The driver itself has an internal 
API used by everything else, and all that pvrusb2-sysfs.c does is 
enumerate that to expose all of the controls.  It would actually be 
extra work in the pvrusb2 driver to impose a policy on which controls 
are visible.  The cropping parameters are an example of this.  Another 
pvrusb2 driver user wanted to get cropping to work (which unfortunately 
*still* requires v4l-dvb changes that are not implemented).  Part of his 
implementation involved adding a few extra knobs within the driver to 
control the cropping behavior.  Once he did that, the knobs 
automatically became available via sysfs.


> 
> It will be nice to hear from you what your experience is.

Here's my experience:

I originally did the sysfs interface back in 2005 as a proof of concept.  
I wanted to prove that the internal API within the driver was 
functionally complete and relatively easy to use.  I had recently 
finished reading the LDDv3 and learned of the sysfs class interface.  
It occurred to me back then that it would be easy to define a sysfs 
class interface for the pvrusb2 driver in terms of that API.  So I did, 
and it was literally a 2 day hack.  It's worked fabulously well ever 
since.  In terms of popularity, I find that the user community loves it, 
while the developer community seems to tolerate it.

I routinely use the sysfs interface for my own testing.  It's just 
simply trivial to tweak things in the driver at the shell level using 
that interface.  I remember once using all the mpeg knobs to experiment 
with all the ways that filtering could be controlled, for example.  A 
common use-case for me during testing is to use mplayer as a dumb 
streaming app while tweaking the driver via sysfs.

I've had feedback from many users over the years who, upon discovering 
this interface, just latch onto it.  On more than one occassion I've had 
feedback to the effect of "I don't care about any V4L app; I just want 
to stream video and the sysfs interface makes this trivial to control".  
Probably the fact that only just a small handful of V4L apps (xawtv, 
mythtv and recently now mplayer?) even handle mpeg video has amplified 
this behavior: Many users have found it simpler to forget about V4L apps 
and just instead "cat /dev/video0" along with some shell hacking.

And long ago I know the VDR application gained a plugin script which 
itself used the sysfs interface to control the driver.

One aspect of that sysfs interface that I think has had a lot of value 
over time is that it is (within limits) self-describing.  For each 
control you get not only the ability to get (and usually set) its value, 
but you can inspect its limits, learn what the default value is, 
retrieve a description (though being english only that has limited 
utility), and discover its type.  The sysfs interface in the driver 
tries to use symbolic values where possible, including when setting / 
clearing bits in a bit mask.  The fact that such information is there 
helps when writing, say, a generic dialog-based wrapper to provide a TUI 
(Text User Interface) over the interface without having to encode too 
much specific information in the wrapper itself.  Thus if new controls 
get added (or changed) later then such things just automatically adapt.  
Of course this isn't a perfect thing, but it helps.

> 
> Comments? Ideas? Once we commit to something it is there for a long time to
> come since sysfs is after all a public API (although it seems to be more
> changable than ioctls).

I have found it useful over a long period of time.

I also suggest that if such an interface is defined in the general case 
that it should include some introspection capabilities, which will make 
it easier (or even possible) to evolve the interface over time while 
minimizing backwards compatibility issues.

If such a generic interface were made available, I could see an argument 
to remove the sysfs interface from the pvrusb2 driver.  HOWEVER there is 
a community using it, and also unless the generic interface were a 
complete replacement, the pvrusb2 piece will probably have to stay.  
(Note: the sysfs interface in the pvrusb2 driver is already a CONFIG_XX 
parameter so it's easy to deselect it when building the driver.)

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
