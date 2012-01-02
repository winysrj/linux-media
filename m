Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2ABVuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 16:50:11 -0500
Received: by eekc4 with SMTP id c4so15487694eek.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 13:50:10 -0800 (PST)
Message-ID: <4F02268F.4050107@gmail.com>
Date: Mon, 02 Jan 2012 22:50:07 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: "Kim, Heungjun" <riverful.kim@samsung.com>
CC: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, kyungmin.park@samsung.com,
	'Hans de Goede' <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <1325053428-2626-2-git-send-email-riverful.kim@samsung.com> <4EFB1B04.6060305@gmail.com> <201112281451.39399.laurent.pinchart@ideasonboard.com> <001101ccc5e7$d9f48620$8ddd9260$%kim@samsung.com> <4EFD92C9.1030704@gmail.com> <4F0134DC.507@samsung.com>
In-Reply-To: <4F0134DC.507@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi HeungJun,

On 01/02/2012 05:38 AM, Kim, Heungjun wrote:
> On 2011년 12월 30일 19:30, Sylwester Nawrocki wrote:
>> On 12/29/2011 06:08 AM, HeungJun, Kim wrote:
>>> I guess the WBP menu controls of pwc driver is probably defined in the other
>>> headers, for users being well known the PWC hardware. So it should be managed
>>> separately to videodev2.h. Is it right? Even if the way might be slightly
>>> different, it can't avoid to be "managed separately".
>>>
>>> It means the users being not well known the specific hardware like PWC,
>>> have difficulty to use that driver well.
>>> And, at least, It doesn't looks generic API for me.
>>> In this case, the unfamiliar user with such unique hardware, can use
>>> whatever he wants to use finally, after finding&  looking around the headers.
>> Applications can query drivers for supported controls and populate user control
>> panels dynamically, based on information from VIDIOC_QUERYCTRL and
>> VIDIOC_QUERYMENU
>> ioctls. Not needing to rely on menu items definition in videodev2.h.
>> I had a feeling you weren't considering such case. :)
> You're right in that meaning. And it might be a good point.
> But, I think these 2 ioctl can not handle about this issue.
> 
> Before using VIDIOC_QUERYCTRL and VIDIOC_QUERYMENU, the user should know which
> CID name
> is used in the videodev2.h, and anyway it can not be avoidable the user find out
> this name in it. :)

Yes, in many cases it is required to know the CID in advance, however it is not
mandatory for all applications.

> At least I've seen nobody makes the application just to open(), queryctrl(),
> querymenu(), and close(),
> only for scanning the specific control is existed or not.
> Until now, I have known these 2 ioctl is generally used for formating the UI
> componets like button, menu, and etc, on the screen.

Yup.

> So, it's safe to say that the user who knows that specific control is also know
> the CID name,
> the user knows such specific controls don't need even VIDIOC_QUERYCTRL and
> VIDIOC_QUERYMENU.

I respectfully disagree. Properly written applications must use VIDIOC_QUERYCTRL/
VIDIOC_QUERYMENU ioctls, as many v4l2 controls have now driver-specific value
range.

Please see this application for instance [1], it doesn't hard code any control
IDs in it, it only uses V4L2_CID_BASE, V4L2_CID_PRIVATE_BASE and V4L2_CID_LASTP1.

Yet, it can handle any control, as long as it supports the control's type.

> And IMHO, this is not related about pulling out the hidden(?) controls generally
> used in the camera,
> on the videodev2.h. I think it's only generic defined in videodev2.h.
> 
> I really had wondered why the controls I thought very general for camera is in
> hidden(?) the specific driver,
> not in the videodev2.h. It was just start to consider this issues.

I think you misunderstood me, I didn't mean to force anyone to use private
controls for common features. :)

> Regards,
> Heungjun Kim
> 
>> Perhaps it's uncommon in embedded systems though.

[1] http://sourceforge.net/projects/v4l2ucp/files/v4l2ucp/2.0/

-- 

Regards,
Sylwester
