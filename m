Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52444 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965AbaBJKVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:21:21 -0500
Message-ID: <52F8A8DB.90505@iki.fi>
Date: Mon, 10 Feb 2014 12:24:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4.2 3/4] v4l: Add timestamp source flags, mask and document
 them
References: <1393149.6OyBNhdFTt@avalon> <1391813548-818-1-git-send-email-sakari.ailus@iki.fi> <52F8A0B2.3090907@xs4all.nl>
In-Reply-To: <52F8A0B2.3090907@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On 02/07/2014 11:52 PM, Sakari Ailus wrote:
>> Some devices do not produce timestamps that correspond to the end of the
>> frame. The user space should be informed on the matter. This patch achieves
>> that by adding buffer flags (and a mask) for timestamp sources since more
>> possible timestamping points are expected than just two.
>>
>> A three-bit mask is defined (V4L2_BUF_FLAG_TSTAMP_SRC_MASK) and two of the
>> eight possible values is are defined V4L2_BUF_FLAG_TSTAMP_SRC_EOF for end of
>> frame (value zero) V4L2_BUF_FLAG_TSTAMP_SRC_SOE for start of exposure (next
>> value).
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> I would prefer to split the uvc change into a separate patch. It doesn't really
> belong here.

Fine for me. I'll take that into account in the next version.

-- 
Sakari Ailus
sakari.ailus@iki.fi
