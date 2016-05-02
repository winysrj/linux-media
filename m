Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:54405 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbcEBSlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2016 14:41:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] s5p-mfc: Don't try to put pm->clock if lookup failed
Date: Mon, 02 May 2016 20:41:11 +0200
Message-ID: <2610031.B6nN8fjXyO@wuerfel>
In-Reply-To: <1462210075-5320-1-git-send-email-javier@osg.samsung.com>
References: <1462210075-5320-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 02 May 2016 13:27:54 Javier Martinez Canillas wrote:
> Failing to get the struct s5p_mfc_pm .clock is a non-fatal error so the
> clock field can have a errno pointer value. But s5p_mfc_final_pm() only
> checks if .clock is not NULL before attempting to unprepare and put it.
> 
> This leads to the following warning in clk_put() due s5p_mfc_final_pm():
> 

Better assign the pointer to NULL in case of a non-fatal error
return code. That way, the reader doesn't have to wonder why you
have the IS_ERR_OR_NULL() check here.

	Arnd
