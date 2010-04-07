Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3710 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0DGG4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 02:56:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mike Isely <isely@isely.net>
Subject: Re: RFC: exposing controls in sysfs
Date: Wed, 7 Apr 2010 08:56:40 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
References: <201004052347.10845.hverkuil@xs4all.nl> <alpine.DEB.1.10.1004061008500.27169@cnc.isely.net> <201004070039.20167.hverkuil@xs4all.nl>
In-Reply-To: <201004070039.20167.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004070856.40867.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 07 April 2010 00:39:20 Hans Verkuil wrote:
> On Tuesday 06 April 2010 17:16:17 Mike Isely wrote:
> > On Tue, 6 Apr 2010, Laurent Pinchart wrote:
> > 
> > > Hi Andy,
> > > 
> > > On Tuesday 06 April 2010 13:06:18 Andy Walls wrote:
> > > > On Tue, 2010-04-06 at 08:37 +0200, Hans Verkuil wrote:
> > > 
> > > [snip]
> > > 
> > > > > Again, I still don't know whether we should do this. It is dangerously
> > > > > seductive because it would be so trivial to implement.
> > > > 
> > > > It's like watching ships run aground on a shallow sandbar that all the
> > > > locals know about.  The waters off of 'Point /sys' are full of usability
> > > > shipwrecks.  I don't know if it's some siren's song, the lack of a light
> > > > house, or just strange currents that deceive even seasoned
> > > > navigators....
> > > > 
> > > > Let the user run 'v4l2-ctl -d /dev/videoN -L' to learn about the control
> > > > metatdata.  It's not as easy as typing 'cat', but the user base using
> > > > sysfs in an interactive shell or shell script should also know how to
> > > > use v4l2-ctl.  In embedded systems, the final system deployment should
> > > > not need the control metadata available from sysfs in a command shell
> > > > anyway.
> > > 
> > > I fully agree with this. If we push the idea one step further, why do we need 
> > > to expose controls in sysfs at all ?
> > 
> > I have found it useful to have the sysfs interface within the pvrusb2 
> > driver.
> > 
> > If it is going to take a lot of work to specifically craft a sysfs 
> > interface that exports the V4L API, then it will probably be a pain to 
> > maintain going forward.  By "a lot of work" I mean that each V4L API 
> > function would have to be explicitly coded for in this interface, thus 
> > as the V4L API evolves over time then extra work must be expended each 
> > time to keep the sysfs interface in step.  If that is to be the case 
> > then it may not be worth it.
> 
> No, that is no work at all. For all practical purposes there are two objects
> (OK, really three, but the node object is just internal). The first object
> is the control handler, the second is the control object. Handlers have
> controls. Handlers can also inherit controls from other handlers. If they
> already had the same control, then they effectively override the inherited
> control. Controls can also be private to a handler, i.e. they will never be
> inherited by other handlers.
> 
> Sound familiar? It's your basic C++ class inheritance scheme with public
> and private fields (or controls in this case).
> 
> The sysfs implementation is just bolted on top of this: each video_device
> struct is associated with a control handler and sysfs will expose all controls
> that that handler references.
> 
> You can take a look at the header of the control framework:
> 
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-fw/raw-file/bf7cd2fb7a35/linux/include/media/v4l2-ctrls.h
> 
> <brainstorm mode on>
> 
> It would be trivial to add e.g. a V4L2 control class that could be used
> to expose all sorts of V4L2 functionality to sysfs. It would be handled
> differently in that you don't want to expose those through VIDIOC_QUERYCTRL
> and friends, just to sysfs. Heck, it could be implemented almost completely
> transparently from drivers. For example, an 'echo 1 >/sys/..../v4l2_input'
> could be converted automatically to a VIDIOC_S_INPUT command that's issued
> to the driver. Similar to what you did in pvrusb2, except you went the other
> way around: ioctls are converted to controls. That is not feasible, though,
> since you do not want to completely redo all drivers.
> 
> There are definitely some snags, but the basic premise is sound.
> 
> Of course, just the fact that you can easily do something does not mean that
> you should. The first version of the framework will not contain any sysfs. It
> is clear that the last word has not been said on this. It's not a big deal,
> sysfs was just an add-on and not part of the core.
> 
> But having it in the kernel will make it a nice foundation on which to experiment.
> 
> Just a thought experiment: take VIDIOC_S_FREQUENCY. The struct has three
> fields: tuner, type, frequency. So that's a cluster of three controls. So you
> would need a 's_ctrl' function like this:
> 
> 	switch (id) {
> 	/* handle the frequency cluster */
> 	case V4L2_CID_V4L_FREQ_TUNER:
> 		struct v4l2_frequency f;
> 		f.tuner = freq_tuner->cur.val;
> 		f.type = freq_type->cur.val;
> 		f.frequency = freq_freq->cur.val;
> 		return vdev->ioctl_ops->s_frequency(&f);
> 	}
> 
> Pseudo-code, of course, and there are some little things like the 'file' and 'fh'
> args to s_frequency, but you could use the framework to make a very clean
> implementation of this. Especially since the framework supports 'clustering' of
> controls. Effectively creating a single composite control from the point of view
> of the driver. Hmm, sounds awfully like a struct, doesn't it? :-)
> 
> > In the pvrusb2 driver this has not been the case because the code I 
> > wrote which implements the sysfs interface for the driver does this 
> > programmatically.  That is, there is nothing in the pvrusb2-sysfs.c 
> > module which is specific to a particular function.  Instead, when the 
> > module initializes it is able to enumerate the API on its own and 
> > generate the appropriate interface for each control it finds.  Thus as 
> > the pvrusb2 driver's implementation has evolved over time, the sysfs 
> > implementation has simply continues to do its job, automatically 
> > reflecting internal changes without any extra work in that module's 
> > code.  I don't know if that same strategy could be done in the V4L core.  
> > If it could, then this would probably alleviate a lot of concerns about 
> > testing / maintenance going forward.
> 
> In other words, yes, it could do this. And with relatively little work and
> completely transparent to all drivers.
> 
> But I have a big question mark whether we really want to go that way. The
> good thing about it is that the ioctls remain the primary API, as they should
> be. Anything like this will definitely be a phase 3 (or 4, or...), but it
> is at least nice to realize how easy it would be. That's a good sign of the
> quality of the code.

Perhaps we should just not do this in sysfs at all but in debugfs? We have a
lot more freedom there. No requirement of one-value-per-file, and if we need
to we can change things in the future. It would actually be easier to issue
ioctl commands to a driver from debugfs since we have a proper struct file
there.

It could be implemented as a separate module that can be loaded if debugfs is
enabled and suddenly you have all this extra debug functionality.

I admit, I would really enjoy writing something like this. I just don't want
to do this in sysfs as that makes it too 'official' so to speak. In other words,
mainline applications should not use sysfs, but home-grown scripts are free to
use it as far as I am concerned.

How much of a problem would that be for you, Mike? On the one hand users have
to mount debugfs, but on the other hand it will be consistent for all drivers
that use the control framework. And you should be able to ditch a substantial
amount of code :-)

A typical debugfs structure would be (for example):

/dbg/video4linux/video0/controls
/dbg/video4linux/video0/types
/dbg/video4linux/video0/v4l2

with controls still showing all controls, types contains type information for
all objects (both controls and v4l2) and v4l2 would contain the v4l2 'front-end
controls'.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
