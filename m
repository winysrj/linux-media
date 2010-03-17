Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41504 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0CQORL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:17:11 -0400
Message-ID: <4BA0E434.1040402@maxwell.research.nokia.com>
Date: Wed, 17 Mar 2010 16:16:20 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
References: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com> <201003162330.17454.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894454137054@dlee02.ent.ti.com> <201003171514.27538.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201003171514.27538.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
>>>> I'm trying to get latest Sakari's tree (gitorious.org/omap3camera)
>>>> 'devel' branch running on my Zoom3 HW (which has an OMAP3630, and a
>>>> Sony IMX046 8MP sensor).
>>>>
>>>> I had first one NULL pointer dereference while the driver was
>>>> registering devices and creating entities, which I resolved with
>>>> the attached patch. (Is this patch acceptable, or maybe I am missing
>>>> something...)
>>>
>>> Either that, or make OMAP34XXCAM_VIDEODEVS dynamic (the value would be
>>> passed through platform data). The code will be removed (hopefully soon)
>>> anyway when the legacy video nodes will disappear.
>>
>> Ok, so should I keep this patch only to myself until this code is removed?
> 
> I'll let Sakari answer that, but I think they can still go in in the meantime.

Is there a need for the patch? The other possible device is just left
unused, right?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
