Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38057 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754244Ab2DXU7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 16:59:36 -0400
Message-ID: <4F971435.10608@iki.fi>
Date: Tue, 24 Apr 2012 23:59:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/15] V4L: Add camera 3A lock control
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com> <1334657396-5737-11-git-send-email-s.nawrocki@samsung.com> <20120417160920.GG5356@valkosipuli.localdomain> <4F8E82D6.8060008@samsung.com> <20120423054627.GA7913@valkosipuli.localdomain> <4F970911.5000404@gmail.com>
In-Reply-To: <4F970911.5000404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dzien dobry Sylwester,

(I hope it's not too wrong time of the day for that! ;))

Sylwester Nawrocki wrote:
> Moikka Sakari,
>
> On 04/23/2012 07:47 AM, Sakari Ailus wrote:
>> Sylwester Nawrocki wrote:
>>> On 04/17/2012 06:09 PM, Sakari Ailus wrote:
>>>> On Tue, Apr 17, 2012 at 12:09:51PM +0200, Sylwester Nawrocki wrote:
>>>>> The V4L2_CID_3A_LOCK bitmask control allows applications to pause
>>>>> or resume the automatic exposure, focus and wite balance adjustments.
>>>>> It can be used, for example, to lock the 3A adjustments right before
>>>>> a still image is captured, for pre-focus, etc.
>>>>> The applications can control each of the algorithms independently,
>>>>> through a corresponding control bit, if driver allows that.
>>>>
>>>> How is disabling e.g. focus algorithm different from locking focus?
>>>
>>> The difference looks quite obvious to me. When some AUTO control is
>>> switched from auto to manual mode there is no guarantee about the
>>> related parameters the device will end up. E.g. lens may be positioned
>>> into default position, rather than kept at current one, exposure might
>>> be set to manual value from before AE was enabled, etc.
>>>
>>> I've seen separate registers at the sensor interfaces for AE, AWB
>>> locking/unlocking and for disabling/enabling those algorithms.
>>> With the proposed control applications can be sure that, for example,
>>> exposure is retained when the V4L2_CID_3A_LOCK is set.
>>>
>>> Does it answer your question ?
>>
>> Yes, it does.
>>
>> I was thinking how does the situation really differ from disabling the
>> corresponding automatic algorithm. There may be subtle differences in
>> practice albeit in principle the two are no different. And if some of the
>> sensors implement it as lock, then I guess it gives us few options for the
>> user space interface.
>
> Can you anticipate any any possible issues such diversity might bring to
> applications ? I imagine such control can be quite useful for snapshot,
> and with current control API design and the drivers' behaviour applications
> cannot be sure what settings a device ends up with after switching from
> "auto" to "manual" - last auto settings or the manual values. Usually its
> just the previous manual values.

On software controlled digital cameras, depending on what the manual 
configuration actually means, you either get the same than by locking 
the automatic control or the previous manual configuration. If the means 
for manual configuration are the same than what the automatic algorithm 
uses then it's the first case. However, I have a feeling that such low 
level controls might often not work the best for manual control: for 
white balance users seldom wish to fiddle with SRGB matrix or gamma 
tables directly. Colour balance might just do mostly the same and be 
more convenient, with the automatic algorithm still doing some work to 
configure the underlying low-level configuration.

Perhaps it would make sense to suggest that the control algorithm locks 
should be implemented even in cases where the lock would mean exactly 
the same than just disabling the algorithm. What do you think?

Shouldn't the lock be related to contiguous focus only btw.? Regular 
autofocus is typically a one-time operation, the lens ending up on a 
position where the AF algorithm left it.

> Such a bitmask control looks quite useful to me. Moreover, at the moment
> there is no control that would provide similar functionality for auto focus.
> The bitmask control allows to easily control auto exposure, wb and focus
> atomically. However that's not a big deal, since this could be well achieved
> with the extended control API.
>
> Although V4L2_CID_3A_LOCK might be hard to implement in driver which use
> the control framework, since it would depend on multiple other controls.
> But this could be worked around by updating proper control current values
> and sending a control event from driver manually, unless you want to cluster
> almost all controls.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
