Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9S8bmtf031956
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:38:50 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9S8LxM6013197
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:21:59 -0400
Message-ID: <20914.62.70.2.252.1225182118.squirrel@webmail.xs4all.nl>
Date: Tue, 28 Oct 2008 09:21:58 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Jean Delvare" <khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
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

Hi Jean,

> Hi Laurent, hi Hans,
>
> As Laurent suggested that I share my experience of what worked and what
> did not work in the i2c subsystem, here you go. Note that I am not
> claiming that everything I say applies to the V4L2 case.
>
> On Tue, 28 Oct 2008 00:03:03 +0100, Laurent Pinchart wrote:
>> On Sunday 19 October 2008, Hans Verkuil wrote:
>> > The new structs are:
>> >
>> > v4l2_driver: basic driver support, provides a standardized way of
>> > numbering device instances.
>>
>> The driver id and name are redundant. Beside, maintaining a global
>> driver ID
>> registry will introduce compatibility issues with out-of-tree drivers.
>> The
>> I2C subsystem has gone that way and is now coming back. Jean should
>> probably
>> be able to comment on this with more details.
>
> This is true. The i2c subsystem originally used arbitrary IDs for both
> chip drivers and bus drivers (and even algorithm drivers but I managed
> to kill that years ago.) We are slowly moving to a device name-based
> approach instead.
>
> The problems I saw with ID-based approach were:
> * Hard to maintain. People were either asking for IDs they would
>   never use because they would give up driver development without
>   telling me, or forget to ask for IDs and either abuse already
>   assigned IDs or use reserved IDs. So I spent quite some time
>   assigning IDs and cleaning up the list.
> * Developers usually used the ID for things it wasn't meant for. For
>   example, instead of checking if an I2C adapter was able to do raw I2C
>   transactions using i2c_check_functionality() which is generic, they
>   would test for specific i2c adapter IDs, so the test would need to be
>   updated with each new V4L driver. Another misuse of the IDs is that
>   they are driver IDs while developers wanted to test for a specific
>   chip. As a given driver can support several chips, testing for the
>   driver ID may not be enough. And things get worse when support for a
>   given chip moves from one driver to another (remember the saa711x
>   family of chips.)
>
> So when converting the i2c subsystem to the standard device driver
> binding model, we made sure to not rely on arbitrary IDs anywhere.
> Instead we use device name strings. They are also arbitrary, but at
> least:
> * They don't need a look-up. It's pretty clear what a device named
>   "saa7115" is.
> * They don't need a central, maintained list. Every developer can guess
>   what the name of his device must be. The only problem is when two
>   developers write support for the same device: virtually both drivers
>   can bind to the device. But this is a problem that needs to be solved
>   anyway, as we don't want to have several drivers for the same device
>   in the first place.
> * They really designate the device, not the driver, so when you move
>   support for a device from a driver to another, the other drivers do
>   not need to be updated.

I had already decided to drop the driver ID. I agree that using names is
the better solution.

>> (...)
>> What's the rationale behind the instance counter ? If I understand
>> things
>> correctly, the counter is used to number instances and give them a
>> unique
>> name. As the counter is monotonic, instance numbers will always
>> increase.
>> With hotpluggable devices such as webcams the instance number will
>> become
>> quite meaningless for end-users.
>
> We used to have a per-driver instance counter as well for i2c devices.
> That's one of the first things I dropped when I started working on the
> i2c subsystem. These counters were adding code and I never could
> understand what purpose they were serving. As Laurent said, these
> counters are unstable by nature, as reloading the drivers or unplugging
> the devices will make them increase. Each i2c device already has a
> unique identifier (used in /sys/bus/i2c/device) which is (or should be)
> stable, so no need for an instance counter.

I'll look into this. The reason for the instance number was to have a
short prefix when logging (e.g. ivtv0, ivtv1, etc) rather than a longer
PCI/USB ID. However, I think I should move to that anyway.

>> Instead of maintaining a global list of devices that can be searched
>> using
>> v4l2_device_iterate, it might be better to use the device list available
>> in
>> struct device_driver. Except if you have a specific use-case in mind,
>> restricting device iteration to the related driver is probably a good
>> thing.
>
> This is also where the i2c subsystem is going. We have been using
> internal lists of devices and drivers for historical reasons, but the
> driver core is maintaining such lists for a long time now so this is
> redundant. And the duplication makes out locking model very ugly and
> fragile. Some features (e.g. I2C bus multiplexing) can't be implemented
> properly until this is all cleaned up.

I'll be looking at this as well. Based on other input from Andy I'll drop
the global device list. But I do need to have a global driver list and for
each driver I need to setup a list of devices. I'll see whether existing
structures can be used for that.

Thank you all for the feedback!

Regards,

          Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
