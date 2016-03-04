Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44546 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbcCDHF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 02:05:58 -0500
Subject: Re: [PATCH v2] media: platform: Add missing MFD_SYSCON dependency on
 HAS_IOMEM
To: Holger Schurig <holgerschurig@gmail.com>
References: <1457053344-28992-1-git-send-email-k.kozlowski@samsung.com>
 <87y49yd8t6.fsf@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <56D933CD.4070704@samsung.com>
Date: Fri, 04 Mar 2016 16:05:49 +0900
MIME-version: 1.0
In-reply-to: <87y49yd8t6.fsf@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.03.2016 16:03, Holger Schurig wrote:
> Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:
> 
>> +	depends on HAS_IOMEM	# For MFD_SYSCON
>                             ^^^^^^^^^^^^^^^^
> 
> I think this comment is not necessary, it's also highly unusual. On
> other words: other patches like this don't add such comments.
> 
> You can always use "git blame" to find out why some line has changed the
> way it changed ...

No problem, I can remove it. I thought it might be useful since this
dependency is not for the driver but for selected item.

Best regards,
Krzysztof

