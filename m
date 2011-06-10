Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab1FJMTb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 08:19:31 -0400
Message-ID: <4DF20BC8.1060703@redhat.com>
Date: Fri, 10 Jun 2011 14:19:20 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
References: <20110610002103.GA7169@xanatos> <4DF1CDE1.4080303@redhat.com> <20110610082158.GH31396@legolas.emea.dhcp.ti.com> <4DF1D79F.3020401@redhat.com> <20110610084224.GI31396@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110610084224.GI31396@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/10/2011 10:42 AM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jun 10, 2011 at 10:36:47AM +0200, Hans de Goede wrote:
>>> On Fri, Jun 10, 2011 at 09:55:13AM +0200, Hans de Goede wrote:

<snip>

>>>> So what do we need to make this situation better:
>>>> 1) A usb_driver callback alternative to the disconnect callback,
>>>>     I propose to call this soft_disconnect. This serves 2 purposes
>>>>     a) It will allow the driver to tell the caller that that is not
>>>>        a good idea by returning an error code (think usb mass storage
>>>>        driver and mounted filesystem
>>>
>>> I'm not sure you even need a driver callback for that. Should we leave
>>> that to Desktop manager ?
>>
>> Not sure what you mean here, but we need for a way for drivers to say
>> no to a software caused disconnection. See my usb mass storage device
>> which is still mounted getting redirected to a vm example. This cannot
>
> in that case, why don't you just flush all data and continue ? Also,
> desktop manager knows that a particular device mounted, so it could also
> ask the user if s/he wants to continue.
>
> I'm not sure preventing a disconnect is a good thing.
>

I assume you are sure preventing data loss is a good thing? Because in
this example the 2 are the same.

Also note I'm not suggestion at always preventing the disconnect, I'm
suggesting to add a new try_disconnect ioctl, which apps which want
to behave nicely can use instead of the regular disconnect ioctl, and
then drivers can prevent the disconnect. Apps using the old ioctl will
still get an unconditional disconnect as before.

>> be reliably done from userspace. Where as it is trivial to do this
>> from kernel space. One could advocate to make the existing disconnect
>> ioctl use the new soft_disconnect usb_driver callback instead of
>> adding a new usbfs ioctl for this, but that means that a driver
>> can block any and all userspace triggered disconnects. Where as
>> having a new ioctl, means that apps which want to play nice can play
>> nice, while keeping the possibility of a hard userspace initiated
>> disconnect.
>>
>> One could also argue that making the existing disconnect ioctl return
>> -EBUSY in some cases now is an ABI change.
>
> OTOH, if the user really wants to move the usb device to the guest OS,
> he has just requested for that, so should we prevent it ? what we need
> is for the applications to be notified to exit cleanly and release the
> device because the user has requested to do so. No ?

We are talking about a device with a mounted file system on it here,
any process could be holding files open on there, and there currently
exists no mechanism to notify all apps to exit cleanly and release
the files. Even if there were some method for a desktop environment
like gnome to ask apps to release those files, and all gnome apps
where to be modified to support that mechanism, then there are still
1000-s of non gnome (or kde, xfce, whatever) apps which will not
support that.

We already have a mechanism to cleanly close down a filesystem, it
is called unmount. And it will fail if apps have files open. All I'm
suggesting is forwarding this ebusy failure to the application
trying to disconnect the driver from the usb mass storage interface.

Simply removing the filesystem from under apps holding files open will
lead to io errors, and very unhappy apps.

Regards,

Hans
