Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46074 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1IXSYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 14:24:08 -0400
Received: by wyg34 with SMTP id 34so4844194wyg.19
        for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 11:24:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7DCE71.4030200@redhat.com>
References: <4E7DCE71.4030200@redhat.com>
Date: Sat, 24 Sep 2011 23:54:05 +0530
Message-ID: <CAHFNz9+-Yx4516uHdYk3q=K-bTrvgxc-sMTEt1CDH3CO=N8Zyw@mail.gmail.com>
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

> May,21 2011: Disable dynamic current limit for ttpci budget cards                   http://patchwork.linuxtv.org/patch/6669   Guy Martin <gmsoft@tuxicoman.be>

Strictly, the patch is incorrect.

- Dynamic Current Limiting is nothing but a PWM operation where Ton =
20mS, Toff = 900mS.
In fact, DCL is much more preferred, since it can protect the Power
tracks to the PCI slot in case the fuse on the card doesn't blow out.

This *might* prove problematic with some DiSEqC switches. Only in such
a case, it might be wise to disable DCL. But I haven't yet seen anyone
complain on the same, otherwise incorrect DiSEqC commands ?

Regards,
Manu
