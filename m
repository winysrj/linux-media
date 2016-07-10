Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46665 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbcGJP1l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 11:27:41 -0400
Date: Sun, 10 Jul 2016 12:27:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 28/54] MAINTAINERS: Add file patterns for media device
 tree bindings
Message-ID: <20160710122735.240b07fc@recife.lan>
In-Reply-To: <1463907991-7916-29-git-send-email-geert@linux-m68k.org>
References: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
	<1463907991-7916-29-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 22 May 2016 11:06:05 +0200
Geert Uytterhoeven <geert@linux-m68k.org> escreveu:

> Submitters of device tree binding documentation may forget to CC
> the subsystem maintainer if this is missing.

I'm assuming that this patch will go via DT git tree, so:
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

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
> @@ -7376,6 +7376,7 @@ W:	https://linuxtv.org
>  Q:	http://patchwork.kernel.org/project/linux-media/list/
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/media/
>  F:	Documentation/dvb/
>  F:	Documentation/video4linux/
>  F:	Documentation/DocBook/media/


-- 
Thanks,
Mauro
