Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:58788 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0ELLA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 07:00:57 -0400
Message-ID: <4BEA8A59.7070507@maxwell.research.nokia.com>
Date: Wed, 12 May 2010 14:00:41 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 03/15] [RFC] Documentation: add v4l2-controls.txt documenting
 the new controls API.
References: <cover.1272267136.git.hverkuil@xs4all.nl> <6f82d49ed27478ed94b2d5487993d101152f687c.1272267137.git.hverkuil@xs4all.nl> <201005022239.11635.laurent.pinchart@ideasonboard.com> <201005030021.46500.hverkuil@xs4all.nl>
In-Reply-To: <201005030021.46500.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
[clip]
>> Should't v4l2_ctrl_new_std take a control type as well ?
> 
> The type is set automatically as that is determined by the control ID.
> 
>> What about hardware for which the boundaries are only known at runtime, or 
>> could depend on the values of other controls ? I'm thinking about UVC devices 
>> for instance, the boundaries, step and default values need to be retrieved 
>> from the hardware. I currently do that at runtime when the control is queried 
>> for the first time and cache the values, as doing it during initialization 
>> (probe function) crashes a few webcams. That doesn't seem to be possible with 
>> the control framework.
> 
> It is possible to add controls to an existing control handler at runtime.
> It is also possible to change boundaries at runtime: you just change the
> relevant values in v4l2_ctrl. There is no function for that, it's enough
> to call v4l2_ctrl_lock(), change the values and call unlock().
> 
> I could make a function that does this, but UVC is the only driver that I
> know of that might need this.

It won't be for long. Think of the sensor drivers, for example. The
maximum exposure time (often expressed in lines) is dependent on the
active sensor area (lines) plus vertical blanking. I'd assume the active
area to be selected in other ways than using controls, however.

The vertical blanking, though, also affects the frame rate, and thus
available exposure time. Not quite sure whether the user should be left
to touch the vertical blanking directly.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
