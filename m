Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52193 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3GYPwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 11:52:22 -0400
Message-id: <51F149B3.7000708@samsung.com>
Date: Thu, 25 Jul 2013 17:52:19 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Add driver for Samsung S5K5BAF camera sensor
References: <1374688263-31907-1-git-send-email-s.nawrocki@samsung.com>
 <201307251642.21451.hverkuil@xs4all.nl>
In-reply-to: <201307251642.21451.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 07/25/2013 04:42 PM, Hans Verkuil wrote:
>
> Would it be an idea to create a library with rectangle manipulation functions?
> Looking at this driver and similar ones as well that I had to deal with that
> support cropping/scaling/composing I see a lot of rectangle manipulation.
> 
> Moving that into a separate source that can be shared should simplify
> development.

Yes, I talked before about this exactly with Andrzej. We will consider
creating such a library, but I can't tell at the moment when we can start
working on this. There is still a few basic unsupported features of those
cameras to take care of. :)

Thanks,
Sylwester
