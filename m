Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35052 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1CHUJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 15:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <1299614690-15100-1-git-send-email-dacohen@gmail.com>
References: <1299614690-15100-1-git-send-email-dacohen@gmail.com>
Date: Tue, 8 Mar 2011 22:09:46 +0200
Message-ID: <AANLkTi=6kaSNQ1YUJ3SGQ+izttfs+yec8UpXtbNancQ5@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] *** SUBJECT HERE ***
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, fernando.lugo@ti.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 10:04 PM, David Cohen <dacohen@gmail.com> wrote:
> *** BLURB HERE ***

Sorry for this garbage :/

Br,

David

>
> David Cohen (2):
>  omap3: change ISP's IOMMU da_start address
>  omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED flag
>
> Michael Jones (1):
>  omap: iovmm: disallow mapping NULL address
>
>  arch/arm/mach-omap2/omap-iommu.c        |    2 +-
>  arch/arm/plat-omap/include/plat/iovmm.h |    2 --
>  arch/arm/plat-omap/iovmm.c              |   30 +++++++++++++++---------------
>  3 files changed, 16 insertions(+), 18 deletions(-)
>
>
