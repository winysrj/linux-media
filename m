Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m897WKL5001275
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 03:32:21 -0400
Received: from smtp-vbr16.xs4all.nl (smtp-vbr16.xs4all.nl [194.109.24.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m897W58k007289
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 03:32:06 -0400
Message-ID: <24048.62.70.2.252.1220945521.squirrel@webmail.xs4all.nl>
Date: Tue, 9 Sep 2008 09:32:01 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
Subject: Re: [PATCH 0/7] V4L changes for OMAP 3 camera
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

> [PATCH 4/7] V4L: Add VIDIOC_G_PRIV_MEM ioctl:
>
> On Monday 08 September 2008 23:18:14 ext Hans Verkuil wrote:
>> Patch 4/7: I'm having problems with this one. Shouldn't it be better to
>> make this a driver-private ioctl? And then that ioctl can actually
>
> Do you mean that the ioctl number would be defined inside
> sensor (=camera module) driver header file?
>
> Many camera modules have EEPROM and it seems waste to need
> it to be defined again and again in different drivers.

Perhaps, perhaps not. It depends on what sort of information is stored in
the eeproms and what it is used for.

Having a EEPROM reading ioctl is all very nice, but it shifts the burden
of decoding it to the application. Since the eeprom content is device
specific (right?) I think this belongs in the driver, not in the
application.

Would it perhaps be possible to let the driver create read-only controls
that contain that information? Similar to say the uvc driver that can
create controls dynamically based on the camera information.

>> return a struct containing those settings, rather than a eeprom dump.
>> It is highly device specific, after all, so let the device extract and
>> return the useful information instead of requiring an application to do
>> that.
>
> OK, can be done, but it seems likely that the returned structure
> will need to be updated often, because I think it is likely
> that new camera modules will have new fields in EEPROM.

For this reason as well using private controls wouldn't be such a bad idea
(as long as the extended controls are used as it has a better way of
dealing with private controls).

Regards,

         Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
