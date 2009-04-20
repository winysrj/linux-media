Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbZDTOmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 10:42:38 -0400
Date: Mon, 20 Apr 2009 11:42:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [0904_1] Siano: core header - update license and
 include files
Message-ID: <20090420114231.5065bd03@pedra.chehab.org>
In-Reply-To: <230177.85090.qm@web110811.mail.gq1.yahoo.com>
References: <230177.85090.qm@web110811.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 01:09:16 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1238689930 -10800
> # Node ID c3f0f50d46058f07fb355d8e5531f35cfd0ca37e
> # Parent  7311d23c3355629b617013cd51223895a2423770
> [PATCH] [0904_1] Siano: core header - update license and included files
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> This patch does not include any implementation changes.
> It update the smscoreapi.h license to be identical to 
> other Siano's headers and the #include files list.

s/update/updates/

>  #include <linux/version.h>
>  #include <linux/device.h>
> @@ -28,15 +28,23 @@
>  #include <linux/mm.h>
>  #include <linux/scatterlist.h>
>  #include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/compat.h>
> +#include <linux/wait.h>
> +#include <linux/timer.h>
> +
>  #include <asm/page.h>
> -#include <linux/mutex.h>
> -#include "compat.h"

Hmm... Why do you need the above changes? Also, #include "compat.h" is
required, in order to compile inside the out-of-tree kernel tree.

Also, the header changes should be on a different changeset, since they aren't
related to what's described, e. g. this has nothing to do with licensing change.


Cheers,
Mauro
