Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:36667 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3BQGVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 01:21:17 -0500
Received: by mail-ia0-f171.google.com with SMTP id z13so4435028iaz.30
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 22:21:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302071338.12025.hverkuil@xs4all.nl>
References: <201302071338.12025.hverkuil@xs4all.nl>
Date: Sun, 17 Feb 2013 14:21:17 +0800
Message-ID: <CAMiH66HCy5+wYuKqKoSY=Pn=2a0jzEn6V_y9PgzfBu2rimjcwA@mail.gmail.com>
Subject: Re: [RFC PATCHv2 18/18] tlg2300: update MAINTAINERS file.
From: Huang Shijie <shijie8@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 7, 2013 at 8:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Remove two maintainers: telegent.com no longer exists, so those email
> addresses are invalid as well.
>
> Added myself as co-maintainer and change the status to 'Odd Fixes'.
>
> Changes since v1: Added myself as co-maintainer and change the status to
> 'Odd Fixes'.
>
> Huang: can you Ack this? Once patches 01/18 and 18/18 are Acked I will post
> a pull request for this whole series (patches 02-17 are unchanged so I'm
> not reposting them).
>
> Regards,
>
>         Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  MAINTAINERS |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5334229..9a83a1c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6794,9 +6794,8 @@ F:        drivers/clocksource
>
>  TLG2300 VIDEO4LINUX-2 DRIVER
>  M:     Huang Shijie <shijie8@gmail.com>
> -M:     Kang Yong <kangyong@telegent.com>
> -M:     Zhang Xiaobing <xbzhang@telegent.com>
> -S:     Supported
> +M:     Hans Verkuil <hverkuil@xs4all.nl>
> +S:     Odd Fixes
>  F:     drivers/media/usb/tlg2300
>
>  SC1200 WDT DRIVER
> --
> 1.7.10.4
>
Acked-by: Huang Shijie <shijie8@gmail.com>
