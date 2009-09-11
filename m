Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53048 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZIKPqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 11:46:16 -0400
Received: by fxm17 with SMTP id 17so884664fxm.37
        for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 08:46:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090911121342.08dd1939@caramujo.chehab.org>
References: <200909100913.09065.hverkuil@xs4all.nl>
	 <20090910172013.55825d2e@caramujo.chehab.org>
	 <200909102335.52770.hverkuil@xs4all.nl>
	 <20090911121342.08dd1939@caramujo.chehab.org>
Date: Fri, 11 Sep 2009 11:46:18 -0400
Message-ID: <829197380909110846t493deb9cga3a2af754f2e40cd@mail.gmail.com>
Subject: Re: RFCv2: Media controller proposal
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 11, 2009 at 11:13 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Thu, 10 Sep 2009 23:35:52 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> > First of all, a generic comment: you enumerated on your RFC several needs that
>> > you expect to be solved with a media controller, but you didn't mention what
>> > userspace API will be used to solve it (e. g. what ioctls, sysfs interfaces,
>> > etc). As this is missing, I'm adding a few notes about how this can be
>> > implemented. For example, as I've already pointed when you sent the first
>> > proposal and at LPC, sysfs is the proper kernel API for enumerating things.
>>
>> I hate sysfs with a passion. All of the V4L2 API is designed around ioctls,
>> and so is the media controller.
>>
>> Note that I did not go into too much implementation detail in this RFC. The
>> best way to do that is by trying to implement it. Only after implementing it
>> for a few drivers will you get a real feel of what works and what doesn't.
>>
>> Of course, whether to use sysfs or ioctls is something that has to be designed
>> beforehand.
>
>> > > 1) Discovering the various device nodes that are typically created by a video
>> > > board, such as: video nodes, vbi nodes, dvb nodes, alsa nodes, framebuffer
>> > > nodes, input nodes (for e.g. webcam button events or IR remotes).
>> >
>> > In fact, this can already be done by using the sysfs interface. the current
>> > version of v4l2-sysfs-path.c already enumerates the associated nodes to
>> > a /dev/video device, by just navigating at the already existing device
>> > description nodes at sysfs. I hadn't tried yet, but I bet that a similar kind
>> > of topology can be obtained from a dvb device (probably, we need to do some
>> > adjustments).
>>
>> sysfs is crap. It's a poorly documented public API that is hell to use. Take
>> a device node entity as enumerated by the media controller: I want to provide
>> the application with information like the sort of node (alsa, fb, v4l, etc),
>> how to access it (alsa card nr or major/minor), a description ("Captured MPEG
>> stream"), possibly some capabilities and addition data. With an ENUM ioctl
>> you can just call it. With sysfs you have to open/read/close files for each of
>> these properties, walk through the tree to find related alsa/v4l/fb devices,
>
> sysfs is an hierarchical description of the kernel objects, used to describe
> devices, buses, sub-devices, etc. navigating on it, reading, etc is very fast,
> since it is done in ram, as described in:
>
>        http://lwn.net/Articles/31185/
>
> Unfortunately, it were designed after V4L2 API, otherwise, probably several
> things at the API would be different.
>
> Of course, we need to properly document the media controller sysfs nodes at V4L2.
>
>> and in drivers you must write a hell of a lot of code just to make those sysfs
>> nodes. It's an uncontrollable mess.
>
> Huh? How much sysfs code is currently present at the drivers? Nothing. Yet, you
> can already enumerate several things as shown with v4l2-sysfs-path, since V4L2 core
> already has the code for implementing it. Of course if you want to have a
> customized set of nodes for changing some attributes, you'll need to say to
> sysfs the name of the attribute, and have a get/set pair of methods. Nothing
> different from what we currently have. In a matter of fact, it is even simpler,
> since you don't need to add an enum method.
>
> So, it is the proper Kernel API for the objectives you described. Doing it via
> ioctl will duplicate things, since the sysfs stuff will still be there, and
> will use a wrong API.
>
> So, we should use sysfs for media controller.
>
>> > The big missing component is an userspace library that will properly return the
>> > device components to the applications. Maybe we need to do also some
>> > adjustments at the sysfs nodes to represent all that it is needed.
>>
>> So we write a userspace library that collects all that information? So that
>> has to:
>>
>> 1) walk through the sysfs tree trying to find all the related parts of the
>> media board.
>> 2) open the property that we are interested in.
>> 3) attempt to read the property's value.
>> 4) the driver will then copy that value into a buffer that is returned to the
>> application, usually through a sprintf() call.
>> 5) the library than uses atol() to convert the string back to an integer and
>> stores the result in a struct.
>> 6) repeat for all properties.
>>
>> Isn't that the same as calling an enum ioctl() with a struct pointer? Except
>> a zillion times slower and more obfuscated?
>
> You'll need a similar process with enum, to get each value. Also, by using
> sysfs, it is easy to write udev rules that, once a new sysfs node is created,
> some action will be started, like for example the action of setting the board
> into the needed configuration.
>
>> > The better would be to create a /sys/class/media node, and having the
>> > media controllers above that struct. So, mc0 will be at /sys/class/media/mc0.
>>
>> Why? It's a device. Devices belong in /dev. That's where applications and users
>> look for devices. Not in sysfs.
>
> A device is something that does some sort of input/output transfer,
> not something that controls the config of other devices. A media controller is
> not a device. It is just a convenient kernel object to describe a group of
> devices. So, we should never create a /dev for it.
>
>> You should be able to use this even without sysfs being mounted (on e.g. an
>> embedded system). Another reason BTW not to use sysfs, BTW.
>
> If the embedded system needs it, it will need to mount it. What's wrong on that?
>
>> > > All this requires that there has to be a way to connect and disconnect parts
>> > > of the internal topology of a video board at will.
>> >
>> > We should design this with care, since each change at the internal topology may
>> > create/delete devices.
>>
>> No, devices aren't created or deleted. Only links between devices.
>
> I think that there are some cases where devices are created/deleted. For
> example, on some hardware, you have some blocks that allow you to have either 4 SD
> video inputs or 1 HD video input. So, if you change the type of input, you'll
> end by creating or deleting devices.
>
>> > If you do such changes at topology, udev will need to
>> > delete the old devices and create the new ones.
>>
>> udev is not involved at all. Exception: open issue #2 suggests that we
>> dynamically register device nodes when they are first linked to some source
>> or sink. That would involve udev.
>>
>> All devices are setup when the board is configured. But the links between
>> them can be changed. This is nothing more than bringing the board's block
>> diagram to life: each square of the diagram (video device node, resizer, video
>> encoder or decoder) is a v4l2-subdev with inputs and outputs. And in some cases
>> you can change links dynamically (in effect this will change a mutex register).
>
> See above. If you're grouping 4 A/D blocks into one A/D for handling HD, you're
> doing more than just changing links, since the HD device will be just one
> device: one STD, one video input mux, one audio input mux, etc.
>
>> > This will happen on separate
>> > threads and may cause locking issues at the device, especially since you can be
>> > modifying several components at the same time (being even possible to do it on
>> > separate threads).
>>
>> This is definitely not something that should be allowed while streaming. I
>> would like to hear from e.g. TI whether this could be a problem or not. I
>> suspect that it isn't a problem unless streaming is in progress.
>
> Even when streaming, providing that you don't touch at the used IC blocks, it
> should be possible to reconfigure the unused parts. It is just a matter of
> having the right resource locks at the driver.
>
>> > I've seen some high-end core network routers that implements topology changes
>> > on an interesting way: any changes done are not immediately applied at the
>> > node, but are stored into a file, where the configuration that can be changed
>> > anytime. However, the topology changes only happen after giving a commit
>> > command. After commit, it validates the new config and apply them atomically
>> > (e. g. or all changes are applied or none), to avoid bad effects that
>> > intermediate changes could cause.
>> >
>> > As we are at kernelspace, we need to take care to not create a very complex
>> > interface. Yet, the idea of applying the new topology atomically seems
>> > interesting.
>>
>> I see no need for it. At least, not for any of the current or forthcoming
>> devices that I am aware of. Should it ever be needed, then we can introduce a
>> 'shadow topology' in the future. You can change the shadow links and when done
>> commit it. That wouldn't be too difficult and we can easily prepare for that
>> eventuality (e.g. have some 'flags' field available where you can set a SHADOW
>> flag in the future).
>
>> > Alsa is facing a similar problem with pinup quirks needed with HD-audio boards.
>> > They are proposing a firmware like interface:
>> >     http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-09/msg03198.html
>> >
>> > On their case, they are just using request_firmware() for it, at board probing
>> > time.
>>
>> That seems to be a one-time setup. We need this while the system is up and
>> running.
>
> It would be easy to implement something like:
>
>        echo 1 >/sys/class/media/mc0/config_reload
>
> to call request_firmware() and load the new topology. This is enough to have an
> atomic operation, and we don't need to implement a shadow config.
>
>> > > What would be a good solution is to give access to the various components of
>> > > the board and allow the application to send component-specific ioctls or
>> > > controls to it. Any application that will do this is by default tailored to
>> > > that board. In addition, none of these new controls or commands will pollute
>> > > the namespace of V4L2.
>> >
>> > For dynamic configs, I see this a problem: we had already some troubles in
>> > the past where certain webcam drivers works fine only with an specific (closed
>> > source, paid) application, since the driver had a generic interface to allow
>> > raw changes at the registers, and those registers weren't documented. That's
>> > basically why all direct register access are under the advanced debug Kconfig
>> > option. So, no matter how we expose such controls, they need to be properly
>> > documented to allow open source applications to make use of them.
>>
>> Absolutely. I need to clearly state that in my RFC. All the rules still apply:
>> no direct register access and all the APIs specific to a particular sub-device
>> must be documented properly in the corresponding public header. Everyone must
>> be able to use it, not just closed source applications.
>
> Fine.
>
>> > > The idea is this:
>> > >
>> > > // Select a particular target entity
>> > > ioctl(mc, VIDIOC_S_SUBDEV, &entityID);
>> > > // Send S_FMT directly to that entity
>> > > ioctl(mc, VIDIOC_S_FMT, &fmt);
>> > > // Send a custom ioctl to that entity
>> > > ioctl(mc, VIDIOC_OMAP3_G_HISTOGRAM, &hist);
>> > >
>> > > This requires no API changes and is very easy to implement.
>> >
>> > Huh? This is an API change.
>>
>> No, this all goes through the media controller, which does not affect the
>> existing API that goes through a v4l device node.
>
> Ok. Yet, you're creating a new API (the mc API). so, it is a V4L2 API change ;)
>
> As I said before, sysfs is the way a media controller should be coded, since it
> is not really a device, but a kernel object.
>
> So, if you need to enable an histogram at an omap3 video device, you could do something like:
>
> echo 1 >/sys/class/media/mc0/video:vin0/histogram
>
>> > Also, in the above particular case, I'm assuming that you want to just change
>> > the format of a subdevice specified at the first ioctl, and call a new ioctl
>> > for it, right?
>>
>> Hmm, I knew I should have made a more realistic example. I just took a random
>> ioctl and S_FMT isn't the best one to pick. Forget that one, I've removed it
>> from the RFC.
>
> Ok.
>
>> > You'll need to specify the API for the two new ioctls, specify at the API specs
>> > how this is supposed to work and maybe add some new return errors, that will
>> > need to be reflected inside the code.
>>
>> VIDIOC_S_SUBDEV is part of the new media controller API, but
>> VIDIOC_OMAP3_G_HISTOGRAM would be an ioctl that is specific to the omap3
>> histogram sub-device and would typically be defined and documented in a public
>> header in e.g. linux/include/linux/omap3-histogram.h. These ioctls are highly
>> specific to particular hardware and impossible to make generic.
>
> It is OK to have (properly documented) specific attributes for some boards. If
> this will be commanded via media controller, that means that it will be a sysfs
> node. It should be equally ok to implement it as an ioctl at the device node
> (/dev/video[0-9]+).
>
>> > What are the needs in this specific case? If there are just a few ioctls, IMO,
>> > the better is to have an specific set of ioctls for it.
>>
>> I don't follow you. If you are talking about sub-device specific ioctls: you
>> can expect to see a lot of them. Statistics gathering, histograms, colorspace
>> converters, image processing pipelines, and all of them very difficult to
>> generalize. Some things like a colorspace conversion matrix might actually be
>> fairly standard, so we could standardize some ioctls. But then only for use
>> with colorspace conversion sub-devices accessed through the media controller.
>
> I was talking not about specific attributes, but about the V4L2 API controls
> that you may eventually need to "hijack" (using that context-sensitive
> thread-unsafe approach you described).
>
> Anyway, by using sysfs, you won't have any thread issues, since you'll be able
> to address each sub-device individually:
>
> echo 1 >/sys/class/media/mc0/video:dsp0/enable_stats
>
>
>
> Cheers,
> Mauro

Mauro,

Please, *seriously* reconsider the notion of making sysfs a dependency
of V4L.  While sysfs is great for a developer who wants to poke around
at various properties from a command line during debugging, it is an
absolute nightmare for any developer who wants to write an application
in C that is expected to actually use the interface.  The amount of
extra code for all the string parsing alone would be ridiculous (think
of how many calls you're going to have to make to sscanf or atoi).
It's so much more straightforward to be able to have ioctl() calls
that can return an actual struct with nice things like enumeration
data types etc.

Just my opinion, of course.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
