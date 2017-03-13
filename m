Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60985
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933322AbdCMBKo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 21:10:44 -0400
Date: Sun, 12 Mar 2017 22:02:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 12/23] MAINTAINERS: Add file patterns for media
 device tree bindings
Message-ID: <20170312220231.193801fd@vento.lan>
In-Reply-To: <1489324627-19126-13-git-send-email-geert@linux-m68k.org>
References: <1489324627-19126-1-git-send-email-geert@linux-m68k.org>
        <1489324627-19126-13-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 12 Mar 2017 14:16:56 +0100
Geert Uytterhoeven <geert@linux-m68k.org> escreveu:

> Submitters of device tree binding documentation may forget to CC
> the subsystem maintainer if this is missing.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

As the To: is devicetree, I'm assuming that this patch will be
applied there, so:

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I may also merge via my tree, if that would be better. Just let me
know in such case.

> Cc: linux-media@vger.kernel.org
> ---
> Please apply this patch directly if you want to be involved in device
> tree binding documentation for your subsystem.
> 
> v2:
>   - Add Reviewed-by.
> 
> Impact on next-20170310:
> 
> -Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS,commit_signer:24/39=62%)
> +Mauro Carvalho Chehab <mchehab@kernel.org> (maintainer:MEDIA INPUT INFRASTRUCTURE (V4L/DVB))
> +Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
>  Mark Rutland <mark.rutland@arm.com> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
> -Mauro Carvalho Chehab <mchehab@kernel.org> (commit_signer:34/39=87%)
> -Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:13/39=33%)
> -Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> (commit_signer:11/39=28%,authored:3/39=8%)
> -Marek Szyprowski <m.szyprowski@samsung.com> (commit_signer:4/39=10%,authored:4/39=10%)
> -Kieran Bingham <kieran+renesas@bingham.xyz> (authored:3/39=8%)
> -Martin Blumenstingl <martin.blumenstingl@googlemail.com> (authored:2/39=5%)
> -Eric Engestrom <eric@engestrom.ch> (authored:2/39=5%)
> +linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB))
>  devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
>  linux-kernel@vger.kernel.org (open list)
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2692055d221e2bb2..3e108e31636d4db2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8085,6 +8085,7 @@ W:	https://linuxtv.org
>  Q:	http://patchwork.kernel.org/project/linux-media/list/
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/media/
>  F:	Documentation/media/
>  F:	drivers/media/
>  F:	drivers/staging/media/


-- 
Thanks,
Mauro
