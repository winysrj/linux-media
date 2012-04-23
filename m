Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36990 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751912Ab2DWFrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 01:47:19 -0400
Date: Mon, 23 Apr 2012 08:47:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/15] V4L: Add camera 3A lock control
Message-ID: <20120423054627.GA7913@valkosipuli.localdomain>
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
 <1334657396-5737-11-git-send-email-s.nawrocki@samsung.com>
 <20120417160920.GG5356@valkosipuli.localdomain>
 <4F8E82D6.8060008@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4F8E82D6.8060008@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> Hi Sakari,
>
> On 04/17/2012 06:09 PM, Sakari Ailus wrote:
>> Hi Sylwester,
>>
>> On Tue, Apr 17, 2012 at 12:09:51PM +0200, Sylwester Nawrocki wrote:
>>> The V4L2_CID_3A_LOCK bitmask control allows applications to pause
>>> or resume the automatic exposure, focus and wite balance adjustments.
>>> It can be used, for example, to lock the 3A adjustments right before
>>> a still image is captured, for pre-focus, etc.
>>> The applications can control each of the algorithms independently,
>>> through a corresponding control bit, if driver allows that.
>>
>> How is disabling e.g. focus algorithm different from locking focus?
>
> The difference looks quite obvious to me. When some AUTO control is
> switched from auto to manual mode there is no guarantee about the
> related parameters the device will end up. E.g. lens may be positioned
> into default position, rather than kept at current one, exposure might
> be set to manual value from before AE was enabled, etc.
>
> I've seen separate registers at the sensor interfaces for AE, AWB
> locking/unlocking and for disabling/enabling those algorithms.
> With the proposed control applications can be sure that, for example,
> exposure is retained when the V4L2_CID_3A_LOCK is set.
>
> Does it answer your question ?

Yes, it does.

I was thinking how does the situation really differ from disabling the
corresponding automatic algorithm. There may be subtle differences in
practice albeit in principle the two are no different. And if some of the
sensors implement it as lock, then I guess it gives us few options for the
user space interface.

-- 
Sakari Ailus
sakari.ailus@iki.fi
