Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41562 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3DMVYC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 17:24:02 -0400
Received: by mail-lb0-f169.google.com with SMTP id p11so3585559lbi.14
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 14:24:00 -0700 (PDT)
Message-ID: <5169CCB0.9010705@cogentembedded.com>
Date: Sun, 14 Apr 2013 01:22:56 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v9 15/20] sh-mobile-ceu-driver: support max width and
 height in DT
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de> <1365781240-16149-16-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-16-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12-04-2013 19:40, Guennadi Liakhovetski wrote:

> Some CEU implementations have non-standard (larger) maximum supported
> width and height values. Add two OF properties to specify them.

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

    Minor grammar nitpicking.

> diff --git a/Documentation/devicetree/bindings/media/sh_mobile_ceu.txt b/Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
> new file mode 100644
> index 0000000..1ce4e46
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
> @@ -0,0 +1,18 @@
> +Bindings, specific for the sh_mobile_ceu_camera.c driver:
> + - compatible: Should be "renesas,sh-mobile-ceu"
> + - reg: register base and size
> + - interrupts: the interrupt number
> + - interrupt-parent: the interrupt controller
> + - renesas,max-width: maximum image width, supported on this SoC
> + - renesas,max-height: maximum image height, supported on this SoC

    Commas not needed above.

WBR, Sergei

