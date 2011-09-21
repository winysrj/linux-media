Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28964 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1IUNY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 09:24:27 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRV003FUJWPKU@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 14:24:25 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV00JKZJWP67@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 14:24:25 +0100 (BST)
Date: Wed, 21 Sep 2011 15:24:24 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 1/2] v4l2: Add the polarity flags for parallel camera
 bus FIELD signal
In-reply-to: <201109210112.39469.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <4E79E588.4000608@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1316450497-6723-1-git-send-email-s.nawrocki@samsung.com>
 <1316452075-10700-1-git-send-email-s.nawrocki@samsung.com>
 <201109210112.39469.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/21/2011 01:12 AM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> Thanks for the patch.
> 
> On Monday 19 September 2011 19:07:55 Sylwester Nawrocki wrote:
>> FIELD is an Even/Odd field selection signal, as specified in ITU-R BT.601
>> standard. Add corresponding flag for configuring the FIELD signal polarity.
>> Also add a comment about usage of V4L2_MBUS_[HV]SYNC* flags for the
>> hardware that uses [HV]REF signals.
> 
> I like this approach better.
> 
...
>> +/* Field selection signal for interlaced scan mode */
>> +#define V4L2_MBUS_FIELD_ACTIVE_HIGH		(1 << 10)
>> +#define V4L2_MBUS_FIELD_ACTIVE_LOW		(1 << 11)
> 
> What does this mean ? The FIELD signal is used to select between odd and even 
> fields. Does "active high" mean that the field is odd or even when the signal 
> has a high level ? The comment should make it explicit, or we could even 
> rename those two constants to FIELD_ODD_HIGH/FIELD_ODD_LOW (or 
> FIELD_EVEN_HIGH/FIELD_EVEN_LOW).

Yes, certainly I didn't think enough about this. I silently assumed that for
V4L2_MBUS_FIELD_ACTIVE_HIGH FIELD = 0 selects Field1 (odd) and FIELD = 1 selects
Field2 (even).
I think it would be good to construct the macro so it is possibly self-explanatory,
rather than requiring often to dig in the documentation.

So I would go for V4L2_MBUS_FIELD_ODD_LOW/V4L2_MBUS_FIELD_ODD_HIGH.
Unless someone proposes something different/better I'll send an amended version
tomorrow. 


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
