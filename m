Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56112 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbbFATyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 15:54:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: y2038@lists.linaro.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: Re: [PATCH v3] [media] dvb-frontend: Replace timeval with ktime_t
Date: Mon, 01 Jun 2015 21:54:18 +0200
Message-ID: <3326613.N7IomTdCIE@wuerfel>
In-Reply-To: <20150531071706.GA3940@tinar>
References: <20150531071706.GA3940@tinar>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 31 May 2015 12:47:06 Tina Ruchandani wrote:
> struct timeval uses a 32-bit seconds representation which will
> overflow in the year 2038 and beyond. This patch replaces
> the usage of struct timeval with ktime_t which is a 64-bit
> timestamp and is year 2038 safe.
> This patch is part of a larger attempt to remove all instances
> of 32-bit timekeeping variables (timeval, timespec, time_t)
> which are not year 2038 safe, from the kernel.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> Suggested-by: Arnd Bergmann <arndb@arndb.de>
> 
> 


Reviewed-by: Arnd Bergmann <arnd@arndb.de>
