Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12117 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBYNh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 08:37:26 -0500
Message-id: <530C9C8D.2040800@samsung.com>
Date: Tue, 25 Feb 2014 14:37:17 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	mark.rutland@arm.com, linux-samsung-soc@vger.kernel.org,
	a.hajda@samsung.com, kyungmin.park@samsung.com, robh+dt@kernel.org,
	galak@codeaurora.org, kgene.kim@samsung.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 04/10] V4L: Add driver for s5k6a3 image sensor
References: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
 <1393263322-28215-5-git-send-email-s.nawrocki@samsung.com>
 <20140224193838.GL4869@tarshish> <530C6692.6090307@samsung.com>
 <20140225095515.GV4869@tarshish>
In-reply-to: <20140225095515.GV4869@tarshish>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/02/14 10:55, Baruch Siach wrote:
> Thanks for the explanation. However, I've found no reference to the 
> s5k6a3_sd_internal_ops struct in the driver code. There surly has to be at 
> least one reference for the upper layer to access these ops.

There is indeed an assignment missing to sd->internal_ops in probe().
Thanks for spotting this, I've corrected that for next iteration.

--
Regards,
Sylwester
