Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43978 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1IXSL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 14:11:56 -0400
Received: by wwf22 with SMTP id 22so4980830wwf.1
        for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 11:11:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7DCE71.4030200@redhat.com>
References: <4E7DCE71.4030200@redhat.com>
Date: Sat, 24 Sep 2011 23:41:54 +0530
Message-ID: <CAHFNz9KJW1AYW8ZEofPYCbPfPrGdbhtFo-OVKvrY0gLxBpc2Jg@mail.gmail.com>
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
> Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.linuxtv.org/patch/3639   Florent AUDEBERT <florent.audebert@anevia.com>

A single byte doesn't make much of a difference, but well it is still
a difference. The DiSEqC has some known issues and has some tricky
workarounds for different Silicon cuts. This patch *might* be good on
some chips while have an adverse effect. But that said I have not
tested this patch.

If general users would like to have this patch and is proven good on
different versions, I have no objection for this patch to go in.

In which case; Acked-by: Manu Abraham <manu@linuxtv.org>
