Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52964 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2K0X1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 18:27:47 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so5053067eaa.19
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2012 15:27:46 -0800 (PST)
Message-ID: <50B54C70.8030607@gmail.com>
Date: Wed, 28 Nov 2012 00:27:44 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>, t.stanislaws@samsung.com
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 0/9] [media] s5p-tv: Checkpatch Fixes and cleanup
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2012 05:48 AM, Sachin Kamat wrote:
> Build tested based on samsung/for_v3.8 branch of
> git://linuxtv.org/snawrocki/media.git tree.

How about testing it on Origen board ?

Tomasz, are you OK with this patch series ?

As a side note, for v3.9, when common clock framework support for the Exynos
platforms is merged this driver will need to have clk_(un)prepare added.
It will fail to initialize otherwise.

> Sachin Kamat (9):
>    [media] s5p-tv: Add missing braces around sizeof in sdo_drv.c
>    [media] s5p-tv: Add missing braces around sizeof in mixer_video.c
>    [media] s5p-tv: Add missing braces around sizeof in mixer_reg.c
>    [media] s5p-tv: Add missing braces around sizeof in mixer_drv.c
>    [media] s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
>    [media] s5p-tv: Add missing braces around sizeof in hdmi_drv.c
>    [media] s5p-tv: Use devm_clk_get APIs in sdo_drv.c
>    [media] s5p-tv: Use devm_* APIs in mixer_drv.c
>    [media] s5p-tv: Use devm_clk_get APIs in hdmi_drv
>
>   drivers/media/platform/s5p-tv/hdmi_drv.c    |   28 +++------
>   drivers/media/platform/s5p-tv/hdmiphy_drv.c |    2 +-
>   drivers/media/platform/s5p-tv/mixer_drv.c   |   87 +++++++--------------------
>   drivers/media/platform/s5p-tv/mixer_reg.c   |    6 +-
>   drivers/media/platform/s5p-tv/mixer_video.c |   18 +++---
>   drivers/media/platform/s5p-tv/sdo_drv.c     |   43 ++++---------
>   6 files changed, 57 insertions(+), 127 deletions(-)

--

Thanks,
Sylwester
