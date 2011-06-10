Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1FJIg7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:36:59 -0400
Message-ID: <4DF1D79F.3020401@redhat.com>
Date: Fri, 10 Jun 2011 10:36:47 +0200
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
References: <20110610002103.GA7169@xanatos> <4DF1CDE1.4080303@redhat.com> <20110610082158.GH31396@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110610082158.GH31396@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/10/2011 10:22 AM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jun 10, 2011 at 09:55:13AM +0200, Hans de Goede wrote:
>> Currently this will cause the usb mass storage driver to see a
>> disconnect, and any possible still pending writes are lost ...
>>
>> This is IMHO unacceptable, but currently there is nothing we can
>> do to avoid this.
>>
>> 2) So called dual mode cameras are (cheap) stillcams often even
>> without an lcdscreen viewfinder, and battery backed sram instead
>> of flash, which double as a webcam. We have drivers for both the
>> stillcam function of these (in libgphoto2, so using usbfs) as
>> well as for the webcam function (v4l2 kernel drivers).
>>
>> These drivers work well, and are mature. Yet the user experience
>> is rather poor. Under gnome the still-cam contents will be
>> automatically be made available as a "drive" using a gvfs-gphoto2 fuse
>> mount. This however involves sending a disconnect to the v4l2 kernel
>> driver, and thus the /dev/video# node disappearing. So if a user
>> wants to use the device as a webcam he/she needs to first go to
>> nautilus and unmount the gvfs mount. Until that is done the user will
>> simply get a message from an app like cheese that he has no webcam,
>> not even an ebusy error, just that he has no such device.
>
> that sounds quite weird. Should only happen if still image and video
> functions are on different configurations or different alt-settings of
> the same interface. But if they are on same configurations and separate
> interfaces, you should be able to bind gphoto to the still image
> interface and v4l2 to the camera interface.
>
> How's the device setup ?
>

These are very cheap devices, and as such poorly designed. There still
and webcam functionality is on the same interface. This is likely done
this way because the devices cannot handle both functions at the same
time.

>> So what do we need to make this situation better:
>> 1) A usb_driver callback alternative to the disconnect callback,
>>     I propose to call this soft_disconnect. This serves 2 purposes
>>     a) It will allow the driver to tell the caller that that is not
>>        a good idea by returning an error code (think usb mass storage
>>        driver and mounted filesystem
>
> I'm not sure you even need a driver callback for that. Should we leave
> that to Desktop manager ?

Not sure what you mean here, but we need for a way for drivers to say
no to a software caused disconnection. See my usb mass storage device
which is still mounted getting redirected to a vm example. This cannot
be reliably done from userspace. Where as it is trivial to do this
from kernel space. One could advocate to make the existing disconnect
ioctl use the new soft_disconnect usb_driver callback instead of
adding a new usbfs ioctl for this, but that means that a driver
can block any and all userspace triggered disconnects. Where as
having a new ioctl, means that apps which want to play nice can play
nice, while keeping the possibility of a hard userspace initiated
disconnect.

One could also argue that making the existing disconnect ioctl return
-EBUSY in some cases now is an ABI change.

Regards,

Hans





