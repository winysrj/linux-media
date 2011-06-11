Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1FKJPo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 05:15:44 -0400
Message-ID: <4DF3324E.3050506@redhat.com>
Date: Sat, 11 Jun 2011 11:15:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Felipe Balbi <balbi@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
References: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Given the many comments in this thread, I'm just
going reply to this one, and try to also answer any
other ones in this mail.

As far as the dual mode camera is involved, I agree
that that should be fixed in the existing v4l2
drivers + libgphoto. I think that Felipe's solution
to also handle the stillcam part in kernel space for
dual mode cameras (and add a libgphoto cam driver which
knows how to talk the new kernel API for this), is
the best solution. Unfortunately this will involve
quite a bit of work, but so be it.


On 06/10/2011 04:48 PM, Alan Stern wrote:
> On Fri, 10 Jun 2011, Hans de Goede wrote:
>
>> Hi all,
>>
>> The current API for managing kernel ->  userspace is a bit
>> rough around the edges, so I would like to discuss extending
>> the API.
>>
>> First of all an example use case scenarios where the current API
>> falls short.
>>
>> 1) Redirection of USB devices to a virtual machine, qemu, vbox, etc.
>> all have the ability to redirect a USB device to the virtual machine,
>> and they all use usbfs for this. The first thing which will happen
>> here when the user selects a device to redirect is a
>> IOCTL_USBFS_DISCONNECT. This causes the kernel driver to see a
>> device unplug, with no chances for the kernel driver to do anything
>> against this.
>>
>> Now lets say the user does the following:
>> -write a file to a usb flash disk
>> -redirect the flash disk to a vm
>>
>> Currently this will cause the usb mass storage driver to see a
>> disconnect, and any possible still pending writes are lost ...
>>
>> This is IMHO unacceptable, but currently there is nothing we can
>> do to avoid this.
>
> You haven't given a proper description of the problem.  See below.

I think I've given an excellent description of the problem, drivers
can be unbound from devices, and there is no way for drivers to block
this. All I'm asking for is for a new usbfs try_disconnect ioctl which
the currently bound driver has a chance blocking nothing more nothing
less.

<snip dual mode camera stuff>

>> So what do we need to make this situation better:
>> 1) A usb_driver callback alternative to the disconnect callback,
>>      I propose to call this soft_disconnect. This serves 2 purposes
>>      a) It will allow the driver to tell the caller that that is not
>>         a good idea by returning an error code (think usb mass storage
>>         driver and mounted filesystem
>
> Not feasible.  usb-storage has no idea whether or not a device it
> controls has a mounted filesystem.  (All it does is send SCSI commands
> to a device and get back the results.)  Since that's the main use
> case you're interested in, this part of the proposal seems destined to
> fail.
>

This is not completely true, I cannot rmmod usb-storage as long as
disks using it are mounted. I know this is done through the global
module usage count, so this is not per usb-storage device. But extending
the ref counting to be per usb-storage device should not be hard.

All the accounting is already done for this.

> But userspace _does_ know where the mounted filesystems are.
> Therefore userspace should be responsible for avoiding programs that
> want to take control of devices holding these filesystems.  That's the
> reason why usbfs device nodes are owned by root and have 0644 mode;
> there're can be written to only by programs with superuser privileges
> -- and such programs are supposed to be careful about what they do.
>

Yes, and what I'm asking for is for an easy way for these programs to
be careful. A way for them to ask the kernel, which in general is
responsible for things like this and traditionally does resource
management and things which come with that like refcounting: "unbind
the driver from this device unless the device is currently in use".

Why can't this be done in userspace, simply put:
1) Process a checks if the usb-storage device is not used
2) Process b mounts it after the check
3) Process a unbinds the driver

Yes this can be avoided if all binding/unbinding and all mounting
happens under control of a single instance. However this requires
completely re-inventing userspace...

Also note that the notion of this can be extended to other devices,
want to ubs-redirect a usb printer to a vm better not do it halfway
through a printjob being spooled. Want to usb-redirect a usb webcam
to a vm, better not do it while something is streaming video from
the webcam, etc. etc.

And please don't come with the inevitable "if it hurts do not do
that" argument. We want to provide this kind of functionality to
non tech savy computer users, and things should just work, including
telling the user that the device is currently in use rather then
wrecking his printjob or filesystem.

Regards,

Hans
