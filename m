Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44276 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753800AbaDJWgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:36:05 -0400
Message-ID: <53471CD3.3060306@iki.fi>
Date: Fri, 11 Apr 2014 01:36:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 7/9] Print timestamp type and source for dequeued
 buffers
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <5116965.JxiWPkm0Gp@avalon> <5346E9E1.2080702@iki.fi> <1981061.t1Onuu4osC@avalon>
In-Reply-To: <1981061.t1Onuu4osC@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> On Thursday 10 April 2014 21:58:41 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> Hi Sakari,
>>>
>>> Thank you for the patch.
>>>
>>> Given that the timestamp type and source are not supposed to change during
>>> streaming, do we really need to print them for every frame ?
>>
>> When processing frames from memory to memory (COPY timestamp type), the
>> it is entirely possible that the timestamp source changes as the flags
>> are copied from the OUTPUT buffer to the CAPTURE buffer.
>
> It's possible, but is it allowed by the V4L2 API ?

The spec states that:

	"The V4L2_BUF_FLAG_TIMESTAMP_COPY timestamp type which is used by e.g. 
on mem-to-mem devices is an exception to the rule: the timestamp source 
flags are copied from the OUTPUT video buffer to the CAPTURE video buffer."

>> These patches do not support it but it is allowed.
>>
>> One option would be to print the source on every frame only when the
>> type is COPY. For a program like yavta this might be overly
>> sophisticated IMO. :-)
>
> My concern is that this makes the lines output by yavta pretty long.

True as well. I could remove "type/src " from the timestamp source 
information. That's mostly redundant anyway. Then we shouldn't exceed 80 
characters per line that easily anymore.

Could this be the time to add a "verbose" option? :-)

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi
