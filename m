Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1479 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3LUL7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 06:59:17 -0500
Message-ID: <52B58283.7090209@xs4all.nl>
Date: Sat, 21 Dec 2013 12:58:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v5 09/12] DocBook: fix wait.c location
References: <1387518594-11609-1-git-send-email-crope@iki.fi> <1387518594-11609-10-git-send-email-crope@iki.fi>
In-Reply-To: <1387518594-11609-10-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

This is already fixed in the mainline kernel, but not yet merged back into
our repository. Anyway, you can drop this patch.

Regards,

	Hans

On 12/20/2013 06:49 AM, Antti Palosaari wrote:
> Documentation did not compile as wait.c location was wrong.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/device-drivers.tmpl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 6c9d9d3..f517008 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -58,7 +58,7 @@
>       </sect1>
>       <sect1><title>Wait queues and Wake events</title>
>  !Iinclude/linux/wait.h
> -!Ekernel/wait.c
> +!Ekernel/sched/wait.c
>       </sect1>
>       <sect1><title>High-resolution timers</title>
>  !Iinclude/linux/ktime.h
> 
ZZ
