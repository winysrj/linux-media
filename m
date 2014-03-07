Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16981 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaCGKH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:07:56 -0500
Message-id: <53199A77.9090602@samsung.com>
Date: Fri, 07 Mar 2014 11:07:51 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, a.hajda@samsung.com
Subject: Re: [PATCH v6 09/10] ARM: dts: Add rear camera nodes for Exynos4412
 TRATS2 board
References: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
 <1394122819-9582-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1394122819-9582-10-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kukjin,

On 06/03/14 17:20, Sylwester Nawrocki wrote:
> This patch enables the rear facing camera (s5c73m3) on TRATS2 board
> by adding the I2C0 bus controller, s5c73m3 sensor, MIPI CSI-2 receiver
> and the sensor's voltage regulator supply nodes.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Could still patches 9, 10 be queued for v3.15, or is arm-soc
already closed for this merge windiw ?

--
Thanks,
Sylwester
