Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35140 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3KAKxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 06:53:37 -0400
Received: by mail-ea0-f174.google.com with SMTP id z15so1969653ead.5
        for <linux-media@vger.kernel.org>; Fri, 01 Nov 2013 03:53:36 -0700 (PDT)
Message-ID: <5273882D.4000908@gmail.com>
Date: Fri, 01 Nov 2013 11:53:33 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.13 v2] s5p/exynos driver updates
References: <52653459.4000609@samsung.com>
In-Reply-To: <52653459.4000609@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/21/2013 04:04 PM, Sylwester Nawrocki wrote:
> Hi Mauro,
>
> This is an updated version with one more patch added.
>
> Patches included here are mostly s5p/exynos driver cleanups and fixes;
> an addition of the v4l2-m2m ioctl helper functions and device tree support
> for the exynos4 camera subsystem driver and s5k6a3, s5c73m3 sensors.
>
> The following changes since commit 8ca5d2d8e58df7235b77ed435e63c484e123fede:
>
>    [media] uvcvideo: Fix data type for pan/tilt control (2013-10-17 06:55:29 -0300)
>
> are available in the git repository at:
>
>    git://linuxtv.org/snawrocki/samsung.git for-v3.13-1

Mauro,

just wanted to mention that this pull request doesn't depend on my other
one https://patchwork.linuxtv.org/patch/20457 .


> for you to fetch changes up to aa9a5054cc14b947094eeda4787433fc646239e3:
>
>    exynos4-is: Simplify fimc-is hardware polling helpers (2013-10-21 15:56:42 +0200)

Regards,
Sylwester
