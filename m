Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43750 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161148AbbKEHlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2015 02:41:23 -0500
Message-ID: <563B0817.2060508@xs4all.nl>
Date: Thu, 05 Nov 2015 08:41:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>
CC: Junghak Sung <jh1009.sung@samsung.com>
Subject: Which type to use for timestamps: u64 or s64?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

We're redesigning the timestamp handling in the video4linux subsystem moving away
from struct timeval to a single timestamp in ns (what ktime_get_ns() gives us).
But I was wondering: ktime_get_ns() gives a s64, so should we use s64 as well as
the timestamp type we'll eventually be returning to the user, or should we use u64?

The current patch series we made uses a u64, but I am now beginning to doubt that
decision.

Regards,

	Hans
