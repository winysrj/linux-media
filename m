Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:47283 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3G2FkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 01:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
References: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
Date: Mon, 29 Jul 2013 11:10:09 +0530
Message-ID: <CALt3h7-bSoj7nf0D20Su=oe9bOiVr9Os7bnFiZP6rZwrXBu1EA@mail.gmail.com>
Subject: Re: [REVIEW PATCH 0/6] exynos4-is: Asynchronous subdev registration support
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Jul 24, 2013 at 12:09 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> This patch series is a refactoring of the exynos4-is driver to get rid
> of the common fimc-is-sensor driver and to adapt it to use "standard"
> sensor subdev drivers, one per each image sensor type.
> Then a clock provider is added to the exynos4-is driver and the s5k6a3
> subdev is modified to use one of the clocks registered by exynos4-is.
>
> Arun, I think you could reuse the s5k6a3 sensor for your work on the
> Exynos5 FIMC-IS driver. One advantage of separate sensor drivers is
> that the power on/off sequences can be written specifically for each
> sensor. We are probably going to need such sequences per board in
> future. Also having the clock control inside the sensor subdev allows
> to better match the hardware power on/off sequence requirements,
> however the S5K6A3 sensor can have active clock signal on its clock
> input pin even when all its power supplies are turned off.
>
> I'm posting this series before having a proper implementation for
> clk_unregister() in the clock framework, so you are not blocked with
> your Exynos5 FIMC-IS works.
>


Thank you for the patches. I am modifying exynos5-is based on
the same design.

Thanks & Regards
Arun
