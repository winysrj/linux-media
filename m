Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:58785 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbEDKO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 06:14:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: y2038@lists.linaro.org, Kamil Debski <k.debski@samsung.com>,
	linux-samsung-soc@vger.kernel.org, mchehab@osg.samsung.com,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	kyungmin.park@samsung.com, thomas@tommie-lie.de,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com
Subject: Re: [Y2038] [PATCH v4 06/10] cec: add HDMI CEC framework: y2038 question
Date: Mon, 04 May 2015 12:14:39 +0200
Message-ID: <4726638.QZKcRc97FC@wuerfel>
In-Reply-To: <554722EC.3060301@xs4all.nl>
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com> <553DE7EB.6090900@xs4all.nl> <554722EC.3060301@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 04 May 2015 09:42:36 Hans Verkuil wrote:
> Ping! (Added Arnd to the CC list)

Hi Hans,

sorry I missed this the first time

> On 04/27/2015 09:40 AM, Hans Verkuil wrote:
> > Added the y2038 mailinglist since I would like to get their input for
> > this API.
> > 
> > Y2038 experts, can you take a look at my comment in the code below?
> > 
> > Thanks!
> 
> Arnd, I just saw your patch series adding struct __kernel_timespec to
> uapi/linux/time.h. I get the feeling that it might take a few kernel
> cycles before we have a timespec64 available in userspace. Based on that
> I think this CEC API should drop the timestamps for now and wait until
> timespec64 becomes available before adding it.
> 
> The timestamps are a nice-to-have, but not critical. So adding it later
> shouldn't be a problem. What is your opinion?

It will take a little while for the patches to make it in, I would guess
4.3 at the earliest. Using your own struct works just as well and would
be less ambiguous.

However, for timestamps, I would recommend not using timespec anyway.
Instead, just use a single 64-bit nanosecond value from ktime_get_ns()
(or ktime_get_boot_ns() if you need a time that keeps ticking across
suspend). This is more efficient to get and simpler to use as long
as you don't need to convert from nanosecond to timespec.

	Arnd
