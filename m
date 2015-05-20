Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56500 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbbETMUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 08:20:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
Cc: y2038@lists.linaro.org, linux-media@vger.kernel.org,
	john.stultz@linaro.org
Subject: Re: [PATCH v4] Staging: media: lirc: Replace timeval with ktime_t
Date: Wed, 20 May 2015 14:20:19 +0200
Message-ID: <7681913.NKVEKRNDrL@wuerfel>
In-Reply-To: <1432061242-11227-1-git-send-email-ksenija.stanojevic@gmail.com>
References: <1432061242-11227-1-git-send-email-ksenija.stanojevic@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 19 May 2015 20:47:22 Ksenija Stanojevic wrote:
> 'struct timeval last_tv' is used to get the time of last signal change
> and 'struct timeval last_intr_tv' is used to get the time of last UART
> interrupt.
> 32-bit systems using 'struct timeval' will break in the year 2038, so we
> have to replace that code with more appropriate types.
> Here struct timeval is replaced with ktime_t.
> 
> Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>

Looks good to me now,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
