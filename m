Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55384 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1FCDTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 23:19:24 -0400
Received: by qwk3 with SMTP id 3so651818qwk.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 20:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307001127-11757-1-git-send-email-m.szyprowski@samsung.com>
References: <1307001127-11757-1-git-send-email-m.szyprowski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 2 Jun 2011 20:19:03 -0700
Message-ID: <BANLkTikvRA1ZetZQHJnvZ_UCKmqx4h=10A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add videobuf2 maintainers
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 2, 2011 at 00:52, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Add maintainers for the videobuf2 V4L2 driver framework.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  MAINTAINERS |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 29801f7..63be58b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6720,6 +6720,15 @@ S:       Maintained
>  F:     Documentation/filesystems/vfat.txt
>  F:     fs/fat/
>
> +VIDEOBUF2 FRAMEWORK
> +M:     Pawel Osciak <pawel@osciak.com>
> +M:     Marek Szyprowski <m.szyprowski@samsung.com>
> +M:     Kyungmin Park <kyungmin.park@samsung.com>
> +L:     linux-media@vger.kernel.org
> +S:     Maintained
> +F:     drivers/media/video/videobuf2-*
> +F:     include/media/videobuf2-*
> +
>  VIRTIO CONSOLE DRIVER
>  M:     Amit Shah <amit.shah@redhat.com>
>  L:     virtualization@lists.linux-foundation.org
> --
> 1.7.1.569.g6f426
>
>

Signed-off-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
