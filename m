Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34704 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbcEWNnq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 09:43:46 -0400
Received: by mail-it0-f66.google.com with SMTP id k76so4968081ita.1
        for <linux-media@vger.kernel.org>; Mon, 23 May 2016 06:43:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463907991-7916-29-git-send-email-geert@linux-m68k.org>
References: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
	<1463907991-7916-29-git-send-email-geert@linux-m68k.org>
Date: Mon, 23 May 2016 09:29:51 -0400
Message-ID: <CABxcv=kuQa_A03bdkgBjHF3XyOWY1C6y4j_k9z2CRVSf5gVeXw@mail.gmail.com>
Subject: Re: [PATCH 28/54] MAINTAINERS: Add file patterns for media device
 tree bindings
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Geert,

On Sun, May 22, 2016 at 5:06 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Submitters of device tree binding documentation may forget to CC
> the subsystem maintainer if this is missing.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
> Please apply this patch directly if you want to be involved in device
> tree binding documentation for your subsystem.
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7acb65bb2590a321..c230cd9ec8aefe45 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7376,6 +7376,7 @@ W:        https://linuxtv.org
>  Q:     http://patchwork.kernel.org/project/linux-media/list/
>  T:     git git://linuxtv.org/media_tree.git
>  S:     Maintained
> +F:     Documentation/devicetree/bindings/media/
>  F:     Documentation/dvb/
>  F:     Documentation/video4linux/
>  F:     Documentation/DocBook/media/

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
