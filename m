Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60072 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaEWJkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 05:40:22 -0400
Message-ID: <537F1783.7060502@linux.intel.com>
Date: Fri, 23 May 2014 12:40:19 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: Check pad arguments for [gs]_frame_interval
References: <1396254188-7277-1-git-send-email-sakari.ailus@linux.intel.com> <26941099.67PAgQvcPC@avalon>
In-Reply-To: <26941099.67PAgQvcPC@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thank you for the patch.
>
> On Monday 31 March 2014 11:23:08 Sakari Ailus wrote:
>> VIDIOC_SUBDEV_[GS]_FRAME_INTERVAL IOCTLs argument structs contain the pad
>> field but the validity check was missing. There should be no implications
>> security-wise from this since no driver currently uses the pad field in the
>> struct.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Mauro has already pulled the set which this patch was a part of. Good 
that no problems were found. Thanks. :-)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
