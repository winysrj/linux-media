Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:44821 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0CQO65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:58:57 -0400
Message-ID: <4BA0EE24.7030309@maxwell.research.nokia.com>
Date: Wed, 17 Mar 2010 16:58:44 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
References: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com> <201003162330.17454.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894454137054@dlee02.ent.ti.com> <201003171514.27538.laurent.pinchart@ideasonboard.com> <4BA0E434.1040402@maxwell.research.nokia.com> <A24693684029E5489D1D202277BE8944541370C5@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944541370C5@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> 
> 
>> -----Original Message-----
>> From: Sakari Ailus [mailto:sakari.ailus@maxwell.research.nokia.com]
>> Sent: Wednesday, March 17, 2010 9:16 AM
>> To: Laurent Pinchart
>> Cc: Aguirre, Sergio; linux-media@vger.kernel.org
>> Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
>>
>> Laurent Pinchart wrote:
>>>>>> I'm trying to get latest Sakari's tree (gitorious.org/omap3camera)
>>>>>> 'devel' branch running on my Zoom3 HW (which has an OMAP3630, and a
>>>>>> Sony IMX046 8MP sensor).
>>>>>>
>>>>>> I had first one NULL pointer dereference while the driver was
>>>>>> registering devices and creating entities, which I resolved with
>>>>>> the attached patch. (Is this patch acceptable, or maybe I am missing
>>>>>> something...)
>>>>>
>>>>> Either that, or make OMAP34XXCAM_VIDEODEVS dynamic (the value would be
>>>>> passed through platform data). The code will be removed (hopefully
>> soon)
>>>>> anyway when the legacy video nodes will disappear.
>>>>
>>>> Ok, so should I keep this patch only to myself until this code is
>> removed?
>>>
>>> I'll let Sakari answer that, but I think they can still go in in the
>> meantime.
>>
>> Is there a need for the patch? The other possible device is just left
>> unused, right?
> 
> There is need for it _if_ I don't change OMAP34XXCAM_VIDEODEVS in
> drivers/media/video/omap34xxcam.h, and if I have less devices listed
> in the platform data passed from the boardfile.
> 
> In this case, OMAP34XXCAM_VIDEODEVS is hardcoded to N900 case, which is 2,
> and I only have 1 sensor in my Zoom3.
> 
> I guess the patch is just protecting for potential pointer dereferencing, unless we get rid of current OMAP34XXCAM_VIDEODEVS hardcoded value.

What exactly does not work?

The video devices are registered dynamically based on the number of
sensors available so in this case the second video device is not even
registered.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
