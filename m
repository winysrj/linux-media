Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:35049 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab3BBOIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2013 09:08:25 -0500
Received: by mail-bk0-f47.google.com with SMTP id jc3so2165326bkc.6
        for <linux-media@vger.kernel.org>; Sat, 02 Feb 2013 06:08:24 -0800 (PST)
Message-ID: <510D1DD4.3060302@googlemail.com>
Date: Sat, 02 Feb 2013 15:08:20 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Riku Voipio <riku.voipio@linaro.org>
CC: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] v4l-utils: use openat when available
References: <1358872642-30843-1-git-send-email-riku.voipio@linaro.org>
In-Reply-To: <1358872642-30843-1-git-send-email-riku.voipio@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 1/22/13 5:37 PM, Riku Voipio wrote:
> New architectures such as 64-Bit arm build kernels without legacy
> system calls - Such as the the no-at system calls. Thus, use
> SYS_openat whenever it is available.

> +#ifdef SYS_openat
> +#define SYS_OPEN(file, oflag, mode) \
> +	syscall(SYS_openat, AT_FDCWD, (const char *)(file), (int)(oflag), (mode_t)(mode))
> +#else
>  #define SYS_OPEN(file, oflag, mode) \
>  	syscall(SYS_open, (const char *)(file), (int)(oflag), (mode_t)(mode))
> +#endif

This would reduce compatibility to Linux >= 2.6.16 where openat was
introduced. How about testing for absence of SYS_open instead? Or fall
back to SYS_open if SYS_openat is not implemented?

Thanks,
Gregor

