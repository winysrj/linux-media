Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:38390 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3GWPox (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 11:44:53 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so540595wev.8
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 08:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 23 Jul 2013 21:14:32 +0530
Message-ID: <CA+V-a8ta1t3swEr3GibTqRt45b2nChbDtdJ=uk0ZAUepHrK0dA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Jul 22, 2013 at 11:34 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hello,
>
> This is a few patches for the v4l2-async API I wrote while adding
> the asynchronous subdev registration support to the exynos4-is
> driver.
>
> The most significant change is addition of V4L2_ASYNC_MATCH_OF
> subdev matching method, where host driver can pass a list of
> of_node pointers identifying its subdevs.
>
> I thought it's a reasonable and simple enough way to support device
> tree based systems. Comments/other ideas are of course welcome.
>
> Thanks,
> Sylwester
>
> Sylwester Nawrocki (5):
>   V4L2: Drop bus_type check in v4l2-async match functions
>   V4L2: Rename v4l2_async_bus_* to v4l2_async_match_*
>   V4L2: Add V4L2_ASYNC_MATCH_OF subdev matching type
>   V4L2: Rename subdev field of struct v4l2_async_notifier
>   V4L2: Fold struct v4l2_async_subdev_list with struct v4l2_subdev
>
Thanks for the patche's tested on DA850 EVM for VPIF driver.

for patches 1,2,4,5:

Acked-and-tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

and for patch 3:

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
