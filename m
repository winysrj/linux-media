Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40013 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LFRhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 12:37:03 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVS002Z6M9O02@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:37:00 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVS0032GM9NFN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:37:00 +0000 (GMT)
Date: Tue, 06 Dec 2011 18:36:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v2 4/4] v4l: Update subdev drivers to handle
 framesamples parameter
In-reply-to: <201112061712.30748.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	g.liakhovetski@gmx.de, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EDE52BB.9060400@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1322734853-8759-1-git-send-email-s.nawrocki@samsung.com>
 <1322734853-8759-5-git-send-email-s.nawrocki@samsung.com>
 <201112061712.30748.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/06/2011 05:12 PM, Laurent Pinchart wrote:
> On Thursday 01 December 2011 11:20:53 Sylwester Nawrocki wrote:
>> Update the sub-device drivers having a devnode enabled so they properly
>> handle the new framesamples field of struct v4l2_mbus_framefmt.
>> These drivers don't support compressed (entropy encoded) formats so the
>> framesamples field is simply initialized to 0.
> 
> Wouldn't it be better to memset the whole structure before filling it ? This 
> would handle reserved fields as well. One option would be to make the caller 

Sounds like a good improvement to me. Then we wouldn't have to do any
modifications when in future someone converts the reserved field into
something useful.

> zero the structure, I think that would likely result in a smaller patch.

Do you mean to memset the whole structure before v4l2_subdev_call, in
subdev_do_ioctl() ? I guess no, since it could only be done for get_fmt.

> 
>> There is a few other drivers that expose a devnode (mt9p031, mt9t001,
>> mt9v032) but they already implicitly initialize the new data structure
>> field to 0, so they don't need to be touched.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
