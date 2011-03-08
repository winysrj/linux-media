Return-path: <mchehab@pedra>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60036 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849Ab1CHSGZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 13:06:25 -0500
MIME-Version: 1.0
In-Reply-To: <1299588365-2749-2-git-send-email-dacohen@gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
	<1299588365-2749-2-git-send-email-dacohen@gmail.com>
Date: Tue, 8 Mar 2011 12:06:18 -0600
Message-ID: <AANLkTikkUYFuhH-b2vKX8jVoT18wH_+WPzGbfFNWQK6K@mail.gmail.com>
Subject: Re: [PATCH 1/3] omap: iovmm: disallow mapping NULL address
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: David Cohen <dacohen@gmail.com>
Cc: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	Michael Jones <michael.jones@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 6:46 AM, David Cohen <dacohen@gmail.com> wrote:
> From: Michael Jones <michael.jones@matrix-vision.de>
>
> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
> the NULL address if da_start==0, which would then not get unmapped.
> Disallow this again.  And spell variable 'alignment' correctly.
>
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  arch/arm/plat-omap/iovmm.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index 6dc1296..11c9b76 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c
> @@ -271,20 +271,24 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>                                           size_t bytes, u32 flags)
>  {
>        struct iovm_struct *new, *tmp;
> -       u32 start, prev_end, alignement;
> +       u32 start, prev_end, alignment;
>
>        if (!obj || !bytes)
>                return ERR_PTR(-EINVAL);
>
>        start = da;
> -       alignement = PAGE_SIZE;
> +       alignment = PAGE_SIZE;
>
>        if (flags & IOVMF_DA_ANON) {
> -               start = obj->da_start;
> +               /* Don't map address 0 */
> +               if (obj->da_start)
> +                       start = obj->da_start;
> +               else
> +                       start = obj->da_start + alignment;

else part obj->da_star is always 0, so why not?
start = alignment;

so, why I understand, it now it is possible mapp address 0x0 only if
IOVMF_DA_ANON is not set, right? maybe that would be mention in the
patch.

Regards,
Fernando.

>
>                if (flags & IOVMF_LINEAR)
> -                       alignement = iopgsz_max(bytes);
> -               start = roundup(start, alignement);
> +                       alignment = iopgsz_max(bytes);
> +               start = roundup(start, alignment);
>        } else if (start < obj->da_start || start > obj->da_end ||
>                                        obj->da_end - start < bytes) {
>                return ERR_PTR(-EINVAL);
> @@ -304,7 +308,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>                        goto found;
>
>                if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
> -                       start = roundup(tmp->da_end + 1, alignement);
> +                       start = roundup(tmp->da_end + 1, alignment);
>
>                prev_end = tmp->da_end;
>        }
> --
> 1.7.0.4
>
>
