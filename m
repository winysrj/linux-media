Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33387 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbcCDHDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 02:03:06 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] media: platform: Add missing MFD_SYSCON dependency on HAS_IOMEM
In-Reply-To: <1457053344-28992-1-git-send-email-k.kozlowski@samsung.com>
	(Krzysztof Kozlowski's message of "Fri, 04 Mar 2016 10:02:24 +0900")
References: <1457053344-28992-1-git-send-email-k.kozlowski@samsung.com>
Date: Fri, 04 Mar 2016 08:03:01 +0100
Message-ID: <87y49yd8t6.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:

> +	depends on HAS_IOMEM	# For MFD_SYSCON
                            ^^^^^^^^^^^^^^^^

I think this comment is not necessary, it's also highly unusual. On
other words: other patches like this don't add such comments.

You can always use "git blame" to find out why some line has changed the
way it changed ...
