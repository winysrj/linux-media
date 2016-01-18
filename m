Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:32841 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcARFJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 00:09:51 -0500
MIME-Version: 1.0
In-Reply-To: <1453079073-30937-1-git-send-email-horms+renesas@verge.net.au>
References: <1453079073-30937-1-git-send-email-horms+renesas@verge.net.au>
Date: Mon, 18 Jan 2016 14:09:50 +0900
Message-ID: <CANqRtoT+fOYzpaTBGjm4FPvc3TzSAX2O27foVtS=gMT6gnC3Nw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update mailing list for Renesas SoC Development
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-renesas-soc@vger.kernel.org,
	SH-Linux <linux-sh@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pci@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2016 at 10:04 AM, Simon Horman
<horms+renesas@verge.net.au> wrote:
> Update the mailing list used for development of support for
> Renesas SoCs and related drivers.
>
> Up until now the linux-sh mailing list has been used, however,
> Renesas SoCs are now much wider than the SH architecture and there
> is some desire from some for the linux-sh list to refocus on
> discussion of the work on the SH architecture.
>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
>
> ---
> * This patch applies on top of Linus's tree where currently the head commit
>   is 984065055e6e ("Merge branch 'drm-next' of
>   git://people.freedesktop.org/~airlied/linux")
>
>   This has been used as a base instead of v4.4 so that it is based on the
>   following two commits which affect it:
>   - 1a4ca6dd3dc8 ("MAINTAINERS: Add co-maintainer for Renesas Pin Controllers")
>   - 3e46c3973cba ("MAINTAINERS: add Renesas usb2 phy driver")
> ---
>  MAINTAINERS | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d23f701489c..52a6ba79fa3f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1531,9 +1531,9 @@ F:        drivers/media/platform/s5p-jpeg/
>  ARM/SHMOBILE ARM ARCHITECTURE
>  M:     Simon Horman <horms@verge.net.au>
>  M:     Magnus Damm <magnus.damm@gmail.com>
> -L:     linux-sh@vger.kernel.org
> +L:     linux-renesas-soc@vger.kernel.org
>  W:     http://oss.renesas.com
> -Q:     http://patchwork.kernel.org/project/linux-sh/list/
> +Q:     http://patchwork.kernel.org/project/linux-renesas-soc/list/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git next
>  S:     Supported
>  F:     arch/arm/boot/dts/emev2*

Hi Simon,

Thanks a lot for handling this!

Acked-by: Magnus Damm <damm@opensource.se>

Cheers,

/ magnus
