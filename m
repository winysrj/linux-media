Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47643 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1IXSP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 14:15:57 -0400
Received: by wwf22 with SMTP id 22so4983016wwf.1
        for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 11:15:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7DCE71.4030200@redhat.com>
References: <4E7DCE71.4030200@redhat.com>
Date: Sat, 24 Sep 2011 23:45:55 +0530
Message-ID: <CAHFNz9+KejWkNaDtNBX=oDnTRzp2ruMtE4uQZrdd4gKya+NDkQ@mail.gmail.com>
Subject: Re: Status of the patches under review at LMML (28 patches)
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 24, 2011 at 6:04 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Everything at patchwork were reviewed by me, and I've applied all patches
> that I didn't notice any review by the drivers maintainers.
>
> Driver maintainers:
> Please review the remaining patches.
>
>                == Patches for Manu Abraham <abraham.manu@gmail.com> review ==
>
> Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.linuxtv.org/patch/4104   Marko Ristola <marko.ristola@kolumbus.fi>

I did test this patch. It doesn't bring in any side effects in
general. It increases the latency, which  it is expected. On some
PCI-PCI chipset the patch makes the TS handling worser. But in other
cases, it looks okay.

Reviewed-by: Manu Abraham <manu@linuxtv.org>
