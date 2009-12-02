Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:36734 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZLBDEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 22:04:33 -0500
Received: by ywh12 with SMTP id 12so5938813ywh.21
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 19:04:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259681414-30246-1-git-send-email-m-karicheri2@ti.com>
References: <1259681414-30246-1-git-send-email-m-karicheri2@ti.com>
Date: Wed, 2 Dec 2009 12:04:39 +0900
Message-ID: <aec7e5c30912011904o285ff2d8w25ad6868a352a1b5@mail.gmail.com>
Subject: Re: [PATCH] V4L - Fix videobuf_dma_contig_user_get() getting page
	aligned physical address
From: Magnus Damm <magnus.damm@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 2, 2009 at 12:30 AM,  <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> If a USERPTR address that is not aligned to page boundary is passed to the
> videobuf_dma_contig_user_get() function, it saves a page aligned address to
> the dma_handle. This is not correct. This issue is observed when using USERPTR
> IO machism for buffer exchange.
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>

Thanks for the patch. For non-page aligned user space pointers I agree
that a fix is needed. Don't you think the while loop in
videobuf_dma_contig_user_get() also needs to be adjusted to include
the last page? I think the while loop checks one page too little in
the non-aligned case today.

Cheers,

/ magnus
