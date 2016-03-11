Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26829 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbcCKNJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 08:09:07 -0500
Subject: Re: [PATCH 0/2] [media] exynos4-is: Trivial fixes for DT port/endpoint
 parse logic
To: Javier Martinez Canillas <javier@osg.samsung.com>
References: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
 <CAJKOXPfOpqU2fGsNNaB6n_iuq2r-8z3TCSsqkncPbvkK2344Tg@mail.gmail.com>
 <56DD48C1.8010004@samsung.com> <56DD9086.7070903@osg.samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <56E2C36C.6030709@samsung.com>
Date: Fri, 11 Mar 2016 14:09:00 +0100
MIME-version: 1.0
In-reply-to: <56DD9086.7070903@osg.samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2016 03:30 PM, Javier Martinez Canillas wrote:
> Thanks, I just noticed another similar issue in the driver now and is
> that fimc_is_parse_sensor_config() uses the same struct device_node *
> for looking up the I2C sensor, port and endpoint and thus not doing a
> of_node_put() for all the nodes on the error path.
> 
> I think the right fix is to have a separate struct device_node * for
> each so their reference counter can be incremented and decremented.

Yes, the node reference count is indeed not handled very well there,
feel free to submit a patch to fix that bug.

-- 
Regards,
Sylwester
