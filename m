Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34463 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab3FSRKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 13:10:55 -0400
Message-id: <51C1E61C.8030808@samsung.com>
Date: Wed, 19 Jun 2013 19:10:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: kishon@ti.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] video: exynos_dsi: Use generic PHY driver
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
 <1371231951-1969-4-git-send-email-s.nawrocki@samsung.com>
 <1502179.yCdHZgQgqV@flatron>
In-reply-to: <1502179.yCdHZgQgqV@flatron>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2013 11:15 PM, Tomasz Figa wrote:
> On Friday 14 of June 2013 19:45:49 Sylwester Nawrocki wrote:
>> > Use the generic PHY API instead of the platform callback to control
>> > the MIPI DSIM DPHY.
>> > 
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> > ---
>> >  drivers/video/display/source-exynos_dsi.c |   36
>> > +++++++++-------------------- include/video/exynos_dsi.h               
>> > |    5 ----
>> >  2 files changed, 11 insertions(+), 30 deletions(-)
>
> Yes, this is what I was really missing a lot while developing this driver.
> 
> Definitely looks good! It's a shame we don't have this driver in mainline 
> yet ;)

Yes, I should have mentioned in the cover letter this patch depends
on modified version of this [1] patch set of yours. I'll drop this
patch and will update the driver staying in mainline now, but I won't
be able to test it, on a non-dt platform.

I guess even some pre-eliminary display (panel) API would be helpful.
The CDF development seems to have been stalled for some time. I wonder
if we could first have something that works for limited set of devices
and be extending it gradually, rather than living with zero support
for displays on DT based ARM platforms.

[1] http://www.spinics.net/lists/linux-fbdev/msg09689.html

Regards,
Sylwester
