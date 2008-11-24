Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOAMH8o023497
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 05:22:17 -0500
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOAM3lb021991
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 05:22:03 -0500
Message-ID: <9014.62.70.2.252.1227522121.squirrel@webmail.xs4all.nl>
Date: Mon, 24 Nov 2008 11:22:01 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH 2/2] TVP514x V4L int device driver support
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

> Hans,
>
> Thanks,
> Vaibhav Hiremath
>
>> -----Original Message-----
>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>> owner@vger.kernel.org] On Behalf Of Trilok Soni
>> Sent: Monday, November 24, 2008 2:13 PM
>> To: Hans Verkuil
>> Cc: video4linux-list@redhat.com; linux-omap@vger.kernel.org;
>> davinci-linux-open-source@linux.davincidsp.com
>> Subject: Re: [PATCH 2/2] TVP514x V4L int device driver support
>>
>> Hi Hans,
>>
>> >
>> > The v4l2-int-device.h stuff should never have been added. Ditto
>> for
>> > parts of the soc-camera framework that duplicates v4l2-int-
>> device.h. My
>> > new v4l2_subdev support will replace the three methods of using
>> i2c
>> > devices (or similar) that are currently in use. It's exactly to
>> reduce
>> > the confusion that I'm working on this.
>> >
>> > It's been discussed before on the v4l mailinglist and the relevant
>> > developers are aware of this. It's almost finished, just need to
>> track
>> > down a single remaining oops.
>>
>> Right, I will wait for your updates.
>>
>> I am planning to send omap24xxcam and ov9640 drivers (now deleted)
>> available from linux-omap tree after syncing them with latest
>> linux-2.6.x tree, and the whole driver and the sensor is written
>> using
>> v4l2-int-device framework. I am going to send it anyway, so that it
>> can have some review comments.
>>
> [Hiremath, Vaibhav] Is your current development accessible through
> linuxtv.org? Can you share it with us, so that we can have a look into it?
> Which driver you are migrating to new interface (which I can refer to as a
> sample)?

Yes, it is. Look at these two trees:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2
http://linuxtv.org/hg/~hverkuil/v4l-dvb-ng

The second tree is meant to be merged into the v4l-dvb master, but is
missing the converted ivtv driver: there is still a kernel oops there in a
corner case when loading the ivtv driver that I need to fix first.

The first tree has slightly older (but almost identical) code and a
converted ivtv driver that you can look at. Most important are the files
Documentation/video4linux/v4l2-framework.txt that explains the new structs
and the v4l2-device.h and v4l2-subdev.h headers.

Note that there are currently no sensor support ops in v4l2-subdev.h. This
will have to be added (should be trivial).

> Again I would like to know, how are we handling current drivers
> (soc-camera and v4l2-int)?

soc-camera and v4l2-int are the exceptions. All other drivers use the i2c
command function to communicate with i2c drivers (ioctl-like API).

Just a note on soc-camera: it's only the soc_camera_ops struct that I want
to see replaced (eventually) by v4l2_subdev. What I want is that subdevice
drivers like tvp514x, but also sensor drivers like mt9xxxx should be
independent of the host (bridge) driver. That way they can be reused
properly. For example, having the mt9m001.c driver use soc_camera makes it
much harder to use with e.g. a USB webcam driver which is not based on the
soc_camera framework.

Regards,

       Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
