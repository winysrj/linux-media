Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0CSTBp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 15:01:45 -0400
Message-ID: <4BA3CA58.1070108@redhat.com>
Date: Fri, 19 Mar 2010 20:02:48 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>    <201003190904.53867.laurent.pinchart@ideasonboard.com> <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
In-Reply-To: <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/19/2010 09:46 AM, Hans Verkuil wrote:
>
>> On Friday 19 March 2010 08:59:08 Hans Verkuil wrote:
>>> Hi all,
>>>
>>> V4L1 support has been marked as scheduled for removal for a long time.
>>> The
>>> deadline for that in the feature-removal-schedule.txt file was July
>>> 2009.
>>>
>>> I think it is time that we remove the V4L1 compatibility support from
>>> V4L2
>>> drivers for 2.6.35.
>>
>> Do you mean just removing V4L1-specific code from V4L2 drivers, or
>> removing
>> the V4L1 compatibility layer completely ?
>
> The compat layer as well. So the only V4L1 code left is that for V4L1-only
> drivers.
>
> This means that V4L2 drivers can only be used by V4L2-aware applications
> and can no longer be accessed by V4L1-only applications.
>

I'm fine with removing the v4l1 compat code inside the drivers, but please
let the compat code live for a while, there are apps out there depending
on it.

Now most of those apps should be using libv4l1, but libv4l depends on
the compat layer! (but not on the driver specific v4l1 compat bits, only
on the generic compat layer).

>>> It would help with the videobuf cleanup as well, but that's just a
>>> bonus.
>>
>> Do we still have V4L1-only drivers that use videobuf ?
>
> No V4L1-only drivers use videobuf, but videobuf has support for the V4L1
> compat support in V4L2 drivers (the cgmbuf ioctl). So when we remove the
> compat support, then that videobuf code can be removed as well.

Removing that bit is fine (from a libv4l1 pov). libv4l1 is written to
work with v4l2 drivers which offer no assistance what so ever (such as
uvcvideo), but it does depend on the generic ioctl compatibility stuff.

Fixing this in libv4l1 is not hard but:
1) Requires me to have some time for it
2) Takes a while to get picked up by distros

So may I suggest that:

1) If not done already v4l1 compat gets turned into a clearly marked
    kernel config option
2) This option gets marked as deprecated
3) It gets scheduled for removal (so added to the feature removal schedule
    txt file.

Regards,

Hans
