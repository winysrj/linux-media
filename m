Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40287 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2DRJBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 05:01:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2O0053K3Q7HB90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Apr 2012 10:01:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2O00L3U3PW9R@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Apr 2012 10:01:09 +0100 (BST)
Date: Wed, 18 Apr 2012 11:01:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 10/15] V4L: Add camera 3A lock control
In-reply-to: <20120417160920.GG5356@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F8E82D6.8060008@samsung.com>
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
 <1334657396-5737-11-git-send-email-s.nawrocki@samsung.com>
 <20120417160920.GG5356@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/17/2012 06:09 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> On Tue, Apr 17, 2012 at 12:09:51PM +0200, Sylwester Nawrocki wrote:
>> The V4L2_CID_3A_LOCK bitmask control allows applications to pause
>> or resume the automatic exposure, focus and wite balance adjustments.
>> It can be used, for example, to lock the 3A adjustments right before
>> a still image is captured, for pre-focus, etc.
>> The applications can control each of the algorithms independently,
>> through a corresponding control bit, if driver allows that.
> 
> How is disabling e.g. focus algorithm different from locking focus?

The difference looks quite obvious to me. When some AUTO control is
switched from auto to manual mode there is no guarantee about the
related parameters the device will end up. E.g. lens may be positioned
into default position, rather than kept at current one, exposure might
be set to manual value from before AE was enabled, etc.

I've seen separate registers at the sensor interfaces for AE, AWB
locking/unlocking and for disabling/enabling those algorithms.
With the proposed control applications can be sure that, for example,
exposure is retained when the V4L2_CID_3A_LOCK is set.

Does it answer your question ?

--
Regards,
Sylwester
