Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54847 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1LHMak (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 07:30:40 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVV00IUCXF280@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Dec 2011 12:30:38 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVV0054MXF1ZC@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Dec 2011 12:30:38 +0000 (GMT)
Date: Thu, 08 Dec 2011 13:30:37 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
In-reply-to: <201112081130.37875.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@redhat.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EE0ADED.6030109@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com>
 <201111291958.48671.laurent.pinchart@ideasonboard.com>
 <4EE083D2.3010102@samsung.com>
 <201112081130.37875.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/08/2011 11:30 AM, Laurent Pinchart wrote:
>> Another use case for control range update would be with an auto-exposure
>> metering spot location controls. An available range for x and y coordinates
>> would depend on selected pixel resolution. If we would have created two
>> controls for (x, y) their range would depend on pixel (width, height)
>> respectively. So when a new format is set such controls would need to get
>> their range updated.
> 
> To be honest I'm not sure whether points, and especially rectangles, should be 
> handled as controls. We have no structure-like control type at the moment, 
> adding points might be possible, but rectangles would require either 2 point-
> liek controls or 4 controls (left, top, width, height). I don't really like 
> that. A new API (possibly based on the selection API ?) might be better.

Indeed, I don't like having 4 controls for specifying a rectangle as well, it
doesn't just sound right. I was concerned about specifying a point using
the selection API. But it could be just (left=x, top=y, width=1, height=1).


--
Regards,
Sylwester
