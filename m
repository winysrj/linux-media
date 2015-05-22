Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:54085 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbbEVTwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 15:52:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	mchehab@osg.samsung.com, jarod@wilsonet.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [Y2038] [PATCH] Staging: media: lirc: Replace timeval with ktime_t
Date: Fri, 22 May 2015 21:52:04 +0200
Message-ID: <3768175.5Bdztn7jIp@wuerfel>
In-Reply-To: <1432310322-3745-1-git-send-email-ksenija.stanojevic@gmail.com>
References: <1432310322-3745-1-git-send-email-ksenija.stanojevic@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 22 May 2015 17:58:42 Ksenija Stanojevic wrote:
> 'struct timeval last_tv' is used to get the time of last signal change
> and 'struct timeval last_intr_tv' is used to get the time of last UART
> interrupt.
> 32-bit systems using 'struct timeval' will break in the year 2038, so we
> have to replace that code with more appropriate types.
> Here struct timeval is replaced with ktime_t.
> 
> Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
