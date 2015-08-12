Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34146 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbbHLQ1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 12:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <1439363150-8661-32-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de> <1439363150-8661-32-git-send-email-hch@lst.de>
From: Catalin Marinas <catalin.marinas@gmail.com>
Date: Wed, 12 Aug 2015 17:26:44 +0100
Message-ID: <CAHkRjk6ykXd1=DLZ16dKiyrBXWmd80WC4gLyoN50JYigJG_-bQ@mail.gmail.com>
Subject: Re: [PATCH 31/31] dma-mapping-common: skip kmemleak checks for
 page-less SG entries
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, axboe@kernel.dk,
	Dan Williams <dan.j.williams@intel.com>, vgupta@synopsys.com,
	hskinnemoen@gmail.com, egtvedt@samfundet.no, realmz6@gmail.com,
	David Howells <dhowells@redhat.com>,
	Michal Simek <monstr@monstr.eu>,
	"x86@kernel.org" <x86@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	alex.williamson@redhat.com, grundler@parisc-linux.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
	linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
	linux-parisc@vger.kernel.org,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org,
	linux-nvdimm@ml01.01.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph,

On 12 August 2015 at 08:05, Christoph Hellwig <hch@lst.de> wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/asm-generic/dma-mapping-common.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> index 940d5ec..afc3eaf 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -51,8 +51,10 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
>         int i, ents;
>         struct scatterlist *s;
>
> -       for_each_sg(sg, s, nents, i)
> -               kmemcheck_mark_initialized(sg_virt(s), s->length);
> +       for_each_sg(sg, s, nents, i) {
> +               if (sg_has_page(s))
> +                       kmemcheck_mark_initialized(sg_virt(s), s->length);
> +       }

Just a nitpick for the subject, it should say "kmemcheck" rather than
"kmemleak" (different features ;)).

-- 
Catalin
