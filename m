Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61814 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2ABJxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 04:53:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LX600DDA0SG9940@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 09:53:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LX600IL70SGKY@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 09:53:04 +0000 (GMT)
Date: Mon, 02 Jan 2012 10:53:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
In-reply-to: <4EFB1B04.6060305@gmail.com>
To: "HeungJun, Kim" <riverful.kim@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com
Message-id: <4F017E80.8060102@samsung.com>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
 <4EFB1B04.6060305@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/28/2011 02:35 PM, Sylwester Nawrocki wrote:
> On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
>> It adds the new CID for setting White Balance Preset. This CID is provided as
>> menu type using the following items:

How about adding

V4L2_WHITE_BALANCE_PRESET_NONE or
V4L2_WHITE_BALANCE_PRESET_UNDEFINED

to this menu ? It might cover "Manual Mode" entry in pwc_auto_whitebal_qmenu.
Also it might be useful not only as a read-only item for applications,
when there are multiple means of setting up white balance supported by a
driver, i.e. blue/red balance, component gains, etc.

>> 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
>> 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
>> 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
>> 3 - V4L2_WHITE_BALANCE_CLOUDY,
>> 4 - V4L2_WHITE_BALANCE_SHADE,
> 
> I have been also investigating those white balance presets recently and noticed
> they're also needed for the pwc driver. Looking at
> drivers/media/video/pwc/pwc-v4l2.c there is something like:
> 
> const char * const pwc_auto_whitebal_qmenu[] = {
> 	"Indoor (Incandescant Lighting) Mode",
> 	"Outdoor (Sunlight) Mode",
> 	"Indoor (Fluorescent Lighting) Mode",
> 	"Manual Mode",
> 	"Auto Mode",
> 	NULL
> };

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
