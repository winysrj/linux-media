Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:27221 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdFTK6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 06:58:39 -0400
Subject: Re: [PATCH 1/2] v4l2-ioctl/exynos: fix G/S_SELECTION's type
 handling
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hansverk@cisco.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <20324ca5-6b04-4969-9d4a-a4d39a928c1d@samsung.com>
Date: Tue, 20 Jun 2017 12:58:28 +0200
MIME-version: 1.0
In-reply-to: <20170619134910.10138-2-hverkuil@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170619134910.10138-1-hverkuil@xs4all.nl>
        <CGME20170619134933epcas3p34fd7ffaebaac7f9c493517522d8248a5@epcas3p3.samsung.com>
        <20170619134910.10138-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2017 03:49 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hansverk@cisco.com>
> 
> The type field in struct v4l2_selection is supposed to never use the
> _MPLANE variants. E.g. if the driver supports V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> then userspace should still pass V4L2_BUF_TYPE_VIDEO_CAPTURE.
> 
> The reasons for this are lost in the mists of time, but it is really
> annoying. In addition, the exynos drivers didn't follow this rule and
> instead expected the _MPLANE type.
> 
> To fix that code is added to the v4l2 core that maps the _MPLANE buffer
> types to their regular equivalents before calling the driver.
> 
> Effectively this allows for userspace to use either _MPLANE or the regular
> buffer type. This keeps backwards compatibility while making things easier
> for userspace.
> 
> Since drivers now never see the _MPLANE buffer types the exynos drivers
> had to be adapted as well.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Thanks,
Sylwester
