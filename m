Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:36831 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760152AbcCEEfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 23:35:20 -0500
MIME-Version: 1.0
In-Reply-To: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
References: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
Date: Sat, 5 Mar 2016 13:35:19 +0900
Message-ID: <CAJKOXPfOpqU2fGsNNaB6n_iuq2r-8z3TCSsqkncPbvkK2344Tg@mail.gmail.com>
Subject: Re: [PATCH 0/2] [media] exynos4-is: Trivial fixes for DT
 port/endpoint parse logic
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-03-05 5:20 GMT+09:00 Javier Martinez Canillas <javier@osg.samsung.com>:
> Hello,
>
> This series have two trivial fixes for issues that I noticed while
> reading as a reference the driver's functions that parse the graph
> port and endpoints nodes.
>
> It was only compile tested because I don't have access to a Exynos4
> hardware to test the DT parsing, but the patches are very simple.

Not directly related, but similar: my previous two patches for missing
of_node_put [0] are unfortunately still waiting. Although I have
Exynos4 boards, but I don't have infrastructure/scripts to test it.

Best regards,
Krzysztof

[0] https://patchwork.linuxtv.org/patch/32707/
