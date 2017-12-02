Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34419 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdLBHu7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 02:50:59 -0500
Date: Sat, 2 Dec 2017 05:50:47 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Jaedon Shin <jaedon.shin@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH 0/3] Add support compat in dvb_frontend.c
Message-ID: <20171202055047.7613db42@vento.lan>
In-Reply-To: <20171201123130.23128-1-jaedon.shin@gmail.com>
References: <20171201123130.23128-1-jaedon.shin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jaedon,

Em Fri,  1 Dec 2017 21:31:27 +0900
Jaedon Shin <jaedon.shin@gmail.com> escreveu:

> This patch series supports compat ioctl for 32-bit user space applications
> in 64-bit system.
> 
> Jaedon Shin (3):
>   media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
>   media: dvb_frontend: Add compat_ioctl callback
>   media: dvb_frontend: Add commands implementation for compat ioct

Thanks for the series. Yeah, indeed we need something like that.

Yet, I suspect that you should also move the logic inside
dvb_frontend_handle_ioctl() with copies from/to userspace.

We don't want the logic there to be called when a 32-bit userspace
copy happens, as it should now use the new compat32 code.


Thanks,
Mauro
