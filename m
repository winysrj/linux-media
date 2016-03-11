Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26460 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbcCKNDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 08:03:10 -0500
Subject: Re: [PATCH 2/2] [media] exynos4-is: FIMC port parse should fail if
 there's no endpoint
To: Javier Martinez Canillas <javier@osg.samsung.com>
References: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
 <1457122813-12791-3-git-send-email-javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <56E2C206.6020103@samsung.com>
Date: Fri, 11 Mar 2016 14:03:02 +0100
MIME-version: 1.0
In-reply-to: <1457122813-12791-3-git-send-email-javier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/2016 09:20 PM, Javier Martinez Canillas wrote:
> The fimc_md_parse_port_node() function return 0 if an endpoint node is
> not found but according to Documentation/devicetree/bindings/graph.txt,
> a port must always have at least one enpoint.
> 
> So return an -EINVAL errno code to the caller instead, so it knows that
> the port node parse failed due an invalid Device Tree description.

I don't think it is forbidden to have a port node in device tree
containing no endpoint nodes. Empty port node means only that,
for example, a subsystem has a port/bus for connecting external
devices but nothing is actually connected to it.

In case of Exynos CSIS it might not be so useful to have an empty
port node specified in some top level *.dtsi file and only
the endpoints specified in a board specific dts file. Nevertheless,
I wouldn't be saying in general a port node must always have some
endpoint node defined.

I could apply this patch as it doesn't do any harm considering
existing dts files in the kernel tree (arch/arm/boot/dts/
exynos4412-trats2.dts), but the commit description would need to
be changed.

-- 
Thanks,
Sylwester
