Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:59107 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3E0FCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 01:02:04 -0400
Received: by mail-la0-f47.google.com with SMTP id fq12so6055587lab.20
        for <linux-media@vger.kernel.org>; Sun, 26 May 2013 22:02:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369556151-4614-1-git-send-email-diego.viola@gmail.com>
References: <1369556151-4614-1-git-send-email-diego.viola@gmail.com>
Date: Mon, 27 May 2013 01:02:02 -0400
Message-ID: <CA+ToGPE-UXUG5j4Qoq7vN64ggsEho79O_VQekAi4txP2BEnMtw@mail.gmail.com>
Subject: Re: [PATCH] Fix spelling of Qt in .desktop file (typo)
From: Diego Viola <diego.viola@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is for v4l-utils.git. Please apply it.

Thanks,

Diego

On Sun, May 26, 2013 at 4:15 AM, Diego Viola <diego.viola@gmail.com> wrote:
> Proper spelling of Qt is Qt, not QT.  "QT" is often confused with
> QuickTime, here is a minor patch to fix this issue in the .desktop file.
>
> Signed-off-by: Diego Viola <diego.viola@gmail.com>
> ---
>  utils/qv4l2/qv4l2.desktop | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/utils/qv4l2/qv4l2.desktop b/utils/qv4l2/qv4l2.desktop
> index 00f3e33..69413e1 100644
> --- a/utils/qv4l2/qv4l2.desktop
> +++ b/utils/qv4l2/qv4l2.desktop
> @@ -1,5 +1,5 @@
>  [Desktop Entry]
> -Name=QT V4L2 test Utility
> +Name=Qt V4L2 test Utility
>  Name[pt]=Utilitário de teste V4L2
>  Comment=Allow testing Video4Linux devices
>  Comment[pt]=Permite testar dispositivos Video4Linux
> --
> 1.8.2.3
>
