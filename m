Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab1CDNM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 08:12:27 -0500
MIME-Version: 1.0
In-Reply-To: <4D6FBC7F.1080500@matrix-vision.de>
References: <4D6D219D.7020605@matrix-vision.de>
	<201103022018.23446.laurent.pinchart@ideasonboard.com>
	<4D6FBC7F.1080500@matrix-vision.de>
Date: Fri, 4 Mar 2011 15:12:26 +0200
Message-ID: <AANLkTikAKy=CzTqEv-UGBQ1EavqmCStPNFZ5vs7vH5VK@mail.gmail.com>
Subject: Re: omap3isp cache error when unloading
From: David Cohen <dacohen@gmail.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	fernando.lugo@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org, Hiroshi.DOYU@nokia.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

[snip]

> Sorry, I should've mentioned: I'm using your media-0005-omap3isp branch
> based on 2.6.38-rc5.  I didn't have the problem with 2.6.37, either.
> It's actually not related to mis-configuring the ISP pipeline like I
> thought at first- it also happens after I have successfully captured images.
>
> I've since tracked down the problem, although I don't understand the
> cache management well enough to be sure it's a proper fix, so hopefully
> some new recipients on this can make suggestions/comments.
>
> The patch below solves the problem, which modifies a commit by Fernando
> Guzman Lugo from December.
>
> -Michael
>
> From db35fb8edca2a4f8fd37197d77fd58676cb1dcac Mon Sep 17 00:00:00 2001
> From: Michael Jones <michael.jones@matrix-vision.de>
> Date: Thu, 3 Mar 2011 16:50:39 +0100
> Subject: [PATCH] fix iovmm slab cache error on module unload
>
> modify "OMAP: iommu: create new api to set valid da range"
>
> This modifies commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb.
> ---
>  arch/arm/plat-omap/iovmm.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index 6dc1296..2fba6f1 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c
> @@ -280,7 +280,10 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>        alignement = PAGE_SIZE;
>
>        if (flags & IOVMF_DA_ANON) {
> -               start = obj->da_start;
> +               /*
> +                * Reserve the first page for NULL
> +                */
> +               start = obj->da_start + PAGE_SIZE;

IMO if obj->da_start != 0, no need to add PAGE_SIZE. Otherwise, it
does make sense to correct wrong obj->da_start == 0. Another thing is
this piece of code is using alignement (alignment) variable instead of
PAGE_SIZE (which is the same value).

Br,

David
