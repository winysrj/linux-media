Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UChNHT019065
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 08:43:23 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UCguni017492
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 08:42:56 -0400
Received: by fg-out-1718.google.com with SMTP id e21so923713fga.7
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 05:42:55 -0700 (PDT)
Message-ID: <30353c3d0806300542r5ba585e3n304c33851051a028@mail.gmail.com>
Date: Mon, 30 Jun 2008 08:42:55 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <30353c3d0806292203p193ff610i866b938271391f81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
	<200806300315.42610.laurent.pinchart@skynet.be>
	<30353c3d0806292009r5556afd6s5d5e271d1c7ff575@mail.gmail.com>
	<30353c3d0806292203p193ff610i866b938271391f81@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] videodev: properly reference count video_device
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

On Mon, Jun 30, 2008 at 1:03 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> On Sun, Jun 29, 2008 at 11:09 PM, David Ellingsworth
> <david@identd.dyndns.org> wrote:
>> On Sun, Jun 29, 2008 at 9:15 PM, Laurent Pinchart
>> <laurent.pinchart@skynet.be> wrote:
>>> Hi David,
>>>
>>> On Sunday 29 June 2008, David Ellingsworth wrote:
>>>> I noticed that the video_device structure wasn't properly being
>>>> reference counted. Under certain circumstances,
>>>
>>> Can you detail those certain circumstances ?
>>>
>> Sure.
>>
>> For drivers which have to handle unexpected disconnects, I.E. usb and
>> pci drivers, it's possible for a user to physically remove the device
>> while it is in use. In the usb/pci disconnect callback, the correct
>> thing to do is to unregister the device in order to prevent future
>> opens. When video_unregister_device is called in this context, it sets
>> video_device[minor number] to NULL and calls device_unregister().
>> device_unregister() causes the release callback to be called when the
>> sysfs entry is no longer in use. Under most circumstances, the release
>> callback occurs right after the call to device_unregister(). This will
>> cause a crash in __video_do_ioctl(), called from video_ioctl2, when
>> subsequent ioctls are encountered since the return value of
>> video_devdata() is NULL
>>
>> Current drivers do one of two things to avoid this crash. They either
>> use a custom ioctl callback and return an error when video_devdata()
>> is NULL, or they delay the call to video_unregister_device until the
>> final close occurs. The first solution means that if a usb/pci driver
>> uses video_devdata() in its ioctl or release callback, it has to check
>> that the return is not NULL. The second means the drivers must be
>> prepared to handle opens after the pci/usb disconnect callback has
>> been called since the video device is still registered.
>>
>> This patch prevents the video_device struct from being freed under the
>> circumstances above, and should not affect the behavior of current
>> drivers. The reference count is set to 1 during video_register_device,
>> incremented during video_open, and decremented during video_close and
>> video_unregister_device. Thus allowing for the following series of
> The reference count is decremented in the sysfs release callback not
> video_unregister_device.
>
>> calls to occur.
>>
>> With patch:
>> -----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect -> video_unregister_device
>> video_ioctl2
>> video_close -> usb/pci_close
>> release_callback
>>
>> Without patch:
>> -----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect -> video_unregister_device
>> release_callback
>> video_ioctl2 (crash)
>>
>> Without patch (crash avoidance #1)
>> ----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect -> video_unregister_device
>> release_callback
>> usb/pci_ioctl (return err, video_devdata() is NULL)
>> usb/pci_close (return err, video_devdata() is NULL)
>>
>> Without patch (crash avoidance #2)
>> ----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect
>> video_ioctl2
>> usb/pci_close -> video_unregister_device
>> release_callback
>>
>> Regards,
>>
>> David Ellingsworth
>>
>>>> it is possible that
>>>> the release callback of the video_device struct is called while the
>>>> device is still open thus causing a crash. This patch adds the
>>>> necessary reference counting to the video_device struct in order to
>>>> avoid freeing the video_device struct while it is still in use.
>>>>
>>>> Regards,
>>>>
>>>> David Ellingsworth
>>>>
>>
>
> [RFC v3] videodev: add ref count to video_device
>
> Moved mutex_[un]lock(&videodev_lock) calls from
> video_unregister_device to the sysfs release callback. In v2 a call to
> close and then video_unregister_device would have resulted in a
> deadlock. The lock is not needed in video_unregister_device, but is
> needed in the sysfs callback video_release since it could potentially
> call video_free. Patch attached.
>
> Regards,
>
> David Ellingsworth
>

One could argue that when the sysfs release callback of videodev is
called, the associated release callback defined by
video_device.release should be called as well. While I completely
agree with this argument, the video_device.release callback has been
advertised as the location where the video_device should be freed. To
this regard even the article on LWN at http://lwn.net/Articles/203924/
indicates taking this action. The proper thing for a subdriver to do
in the video_device.release callback is to decrement the ref count on
their internal structure. And once that ref count reaches 0 to free
their structure as well as the video_device structure. The subdriver
is after all the one that alloced the video_device structure to begin
with. Given the number of drivers currently calling
video_device_release from the video_device.release callback, it's
currently unsafe for this callback to occur during the sysfs release
callback in videodev unless the video_device structure is no longer in
use. The patch I've provided currently handles this situation, however
I think steps should be taken to correct drivers that directly call
video_device_release via this callback as this is obviously incorrect.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
