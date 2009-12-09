Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65354 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZLIM7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 07:59:52 -0500
Received: by yxe17 with SMTP id 17so5861793yxe.33
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 04:59:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260308217-22871-1-git-send-email-m-karicheri2@ti.com>
References: <1260308217-22871-1-git-send-email-m-karicheri2@ti.com>
Date: Wed, 9 Dec 2009 21:59:58 +0900
Message-ID: <aec7e5c30912090459q1854c483hdfbe370a73ea94a8@mail.gmail.com>
Subject: Re: [PATCH - v1] V4L-Fix videobuf_dma_contig_user_get() for
	non-aligned offsets
From: Magnus Damm <magnus.damm@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 9, 2009 at 6:36 AM,  <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> If a USERPTR address that is not aligned to page boundary is passed to the
> videobuf_dma_contig_user_get() function, it saves a page aligned address to
> the dma_handle. This is not correct. This issue is observed when using USERPTR
> IO machism for buffer exchange.
>
> Updates from last version:-
>
> Adding offset for size calculation as per comment from Magnus Damm. This
> ensures the last page is also included for checking if memory is
> contiguous.
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>

Hi Murali,

I've spent some time testing this patch with the SuperH CEU driver in
USERPTR mode. My test case is based on capture.c with places a bunch
of QVGA frames directly after each other. The size of each QVGA frame
is not an even multiple of 4k page size, so some of the frames will
use a non-aligned start addresses. Currently the CEU driver page
aligns the size of each frame, but I'll fix that in an upcoming patch.
Thank you!

Acked-by: Magnus Damm <damm@opensource.se>
