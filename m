Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:38559 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab2FKLqX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 07:46:23 -0400
Message-ID: <4FD5DA91.7040003@iki.fi>
Date: Mon, 11 Jun 2012 14:46:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/4] V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
 V4L2_SEL_TGT_[CROP/COMPOSE]
References: <4FD4F6B6.1070605@iki.fi> <1339356878-2179-1-git-send-email-sakari.ailus@iki.fi> <4FD5D514.20306@gmail.com>
In-Reply-To: <4FD5D514.20306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> thanks for working on this.
> 
> On 06/10/2012 09:34 PM, Sakari Ailus wrote:
>> From: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>
>> This patch drops the _ACTIVE part from the selection target names as
>> a prerequisite to unify the selection target names on subdevs and regular
>> video nodes.
> 
> There is a newer version of this patch, that I made after comments 
> from Mauro: http://patchwork.linuxtv.org/patch/11357. Could you use 
> this one instead ?

I missed that one --- I'll pick it instead. Thanks!

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi


