Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:54503 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZIMGNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 02:13:12 -0400
Received: by pxi27 with SMTP id 27so1682818pxi.15
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 23:13:15 -0700 (PDT)
Subject: Re: Media controller: sysfs vs ioctl
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=euc-kr; format=flowed; delsp=yes
From: Nathaniel Kim <dongsoo.kim@gmail.com>
In-Reply-To: <200909120021.48353.hverkuil@xs4all.nl>
Date: Sun, 13 Sep 2009 15:13:04 +0900
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1BD4D6CB-4CEC-40D2-B168-BE5F8494189F@gmail.com>
References: <200909120021.48353.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


2009. 9. 12., ���� 7:21, Hans Verkuil �ۼ�:

> Hi all,
>
> I've started this as a new thread to prevent polluting the  
> discussions of the
> media controller as a concept.
>
> First of all, I have no doubt that everything that you can do with  
> an ioctl,
> you can also do with sysfs and vice versa. That's not the problem  
> here.
>
> The problem is deciding which approach is the best.
>
> What is sysfs? (taken from http://lwn.net/Articles/31185/)
>
> "Sysfs is a virtual filesystem which provides a userspace-visible  
> representation
> of the device model. The device model and sysfs are sometimes  
> confused with each
> other, but they are distinct entities. The device model functions  
> just fine
> without sysfs (but the reverse is not true)."
>
> Currently both a v4l driver and the device nodes are all represented  
> in sysfs.
> This is handled automatically by the kernel.
>
> Sub-devices are not represented in sysfs since they are not based on  
> struct
> device. They are v4l-internal structures. Actually, if the subdev  
> represents
> an i2c device, then that i2c device will be present in sysfs, but  
> not all
> subdevs are i2c devices.
>
> Should we make all sub-devices based on struct device? Currently  
> this is not
> required. Doing this would probably mean registering a virtual bus,  
> then
> attaching the sub-device to that. Of course, this only applies to  
> sub-devices
> that represent something that is not an i2c device (e.g. something  
> internal
> to the media board like a resizer, or something connected to GPIO  
> pins).
>
> If we decide to go with sysfs, then we have to do this. This part  
> shouldn't
> be too difficult to implement. And also if we do not go with sysfs  
> this might
> be interesting to do eventually.
>
> The media controller topology as I see it should contain the device  
> nodes
> since the application has to know what device node to open to do the  
> streaming.
> It should also contain the sub-devices so the application can  
> control them.
> Is this enough? I think that eventually we also want to show the  
> physical
> connectors. I left them out (mostly) from the initial media  
> controller proposal,
> but I suspect that we want those as well eventually. But connectors  
> are
> definitely not devices. In that respect the entity concept of the  
> media
> controller is more abstract than sysfs.
>
> However, for now I think we can safely assume that sub-devices can  
> be made
> visible in sysfs.
>

Hans,

First of all I'm very sorry that I had not enough time to go through  
your new RFC. I'll checkout right after posting this mail.

I think this is a good approach and I also had in my mind that sysfs  
might be a good method if we could control and monitor through this.  
Recalling memory when we had a talk in San Francisco, I was frustrated  
that there is no way to catch events from sort of sub-devices like  
lens actuator (I mean pizeo motors in camera module). As you know lens  
actuator is an extremely slow device in comparison with common v4l2  
devices we are using and we need to know whether it has succeeded or  
not in moving to expected position.
So I considered sysfs and udev as candidates for catching events from  
sub-devices. events like success/failure of lens movement, change of  
status of subdevices.
Does anybody experiencing same issue? I think I've seen a lens  
controller driver in omap3 kernel from TI but not sure how did they  
control that.

My point is that we need a kind of framework to give and event to user  
space and catching them properly just like udev does.
Cheers,

Nate

=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com