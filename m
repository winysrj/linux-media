Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:62620 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030329AbbKEIgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2015 03:36:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	y2038@lists.linaro.org, Junghak Sung <jh1009.sung@samsung.com>
Subject: Re: Which type to use for timestamps: u64 or s64?
Date: Thu, 05 Nov 2015 09:36:24 +0100
Message-ID: <10717379.s8aWAKUxAs@wuerfel>
In-Reply-To: <563B0817.2060508@xs4all.nl>
References: <563B0817.2060508@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 November 2015 08:41:11 Hans Verkuil wrote:
> Hi Arnd,
> 
> We're redesigning the timestamp handling in the video4linux subsystem moving away
> from struct timeval to a single timestamp in ns (what ktime_get_ns() gives us).
> But I was wondering: ktime_get_ns() gives a s64, so should we use s64 as well as
> the timestamp type we'll eventually be returning to the user, or should we use u64?
> 
> The current patch series we made uses a u64, but I am now beginning to doubt that
> decision.

I would lean towards u64, but I don't think it really matters either way,
especially since all the drivers should be using monotonic timestamps now.

	Arnd
