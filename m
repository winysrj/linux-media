Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49285 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2AMVtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 16:49:45 -0500
Received: by eaal12 with SMTP id l12so331305eaa.19
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2012 13:49:44 -0800 (PST)
Message-ID: <4F10A50A.4040009@gmail.com>
Date: Fri, 13 Jan 2012 22:41:30 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <4F007DED.4070201@gmail.com> <20120104203933.GJ9323@valkosipuli.localdomain> <201201042157.17040.laurent.pinchart@ideasonboard.com> <4F04C394.5050302@iki.fi> <4F04CD55.2000500@gmail.com> <20120111223616.GT9323@valkosipuli.localdomain>
In-Reply-To: <20120111223616.GT9323@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/11/2012 11:36 PM, Sakari Ailus wrote:
>>> This is what the spec says:
>>>
>>> "This is an action control. When set (the value is ignored), the device will do
>>> a white balance and then hold the current setting. Contrast this with the
>>> boolean V4L2_CID_AUTO_WHITE_BALANCE, which, when activated, keeps adjusting the
>>> white balance."
>>>
>>> I wonder if that should be then changed --- or is it just me who got a different
>>> idea from the above description?
>>
>> Only you ? :-) Same as Laurent, I understood this control can be used to do white
>> balance after pointing camera to a white object. Not sure if the description
>> needs to be changed.
> 
> Definitely it needs to be changed. Who will submit the patch? :-)

If it really bugs you, feel free to send a patch :) Or I'll do it, but only after
I handle all other pending controls from my to-do list.

Cheers,
Sylwester
