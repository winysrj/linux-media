Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DD3C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2824A20878
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LyQrrGIM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2824A20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbeLFSgj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:36:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42964 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbeLFSgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 13:36:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id q18so1468338wrx.9
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2018 10:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iWUr7Fzhs7F7L/IAnUlV9KmS1qWX8dGbaOkSAf/nesg=;
        b=LyQrrGIMt78pw3RTL80JbAwjk4b1z1k72nzg+7WIvYlb158TXYxB7xjdgkeOBiHx9V
         J9OO7PCbssNXsggZHXddB6flG0Kxmt28z9G2F3fxhY2+POTwUfa5S1rJCKg5d34BCG0L
         R9VtB7qtUXpCyszaYad0xbfNBZ7tfycMv4xqdC7Jo3iK/eIRwn9N3UCHkGZwVNYfKDVC
         hqPMwxnnmKILQPchKlo0HP6ig7DCUIMcCjcW0Xo/T70bhXwsbVtYCoYYvpkv1mVNXbdk
         dJGhYOPpxk7W6dXWfd4w4CcyhaftdgU/K6j/Fp0j8Vny2RjGD88Ya7jBDxUybRlpvHpC
         /N+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iWUr7Fzhs7F7L/IAnUlV9KmS1qWX8dGbaOkSAf/nesg=;
        b=fX5adVl4G1xko/9/qzt3CrX39ruPA+meFSAuyuNAk/jJn1wT9AJsXdVDn+PSBKbfbf
         a0R28VW39EBcBUj7cUDY1mC0PH6OAVSPbJlQhp0HbypH99Gj446vp7a5b5N+3V1MwMx3
         z3FMxNXer8PkpJc2qBjwSSNDa6G/EHlgjPKuKtDItevI2+KudnWVturp3aRpFAFKIm+R
         7UIomIY1WrlAVvOLZ4bEd/V+0fQ5Y5y3AB4Wlz3RSs/18gPJo3j0FNcTEdPKEp7Q1TdS
         /ybSM9lo3MB7ai5oLUcjQOpCsPFj7f/L1Xf4ydD8YYGQwxTSNTcPIJEl8YtAcshjhW0y
         3w4g==
X-Gm-Message-State: AA+aEWafz1gZ+Wure77u7Cs4FE7OuOklMesntMNM+AntJS6HeAdsJAQa
        Nm/Hz3Mhb6CCjvauCZ46VLjjySNA/r/twUYRU8I=
X-Google-Smtp-Source: AFSGD/XC8In+o+0rPEPwEql0yLgUROXmAsNJR3dLIIoxw5Z1PU8HBdBt9i9xQwnkQfVx7O+KLqfCGtbWcDz/iPbNBN8=
X-Received: by 2002:adf:ef0d:: with SMTP id e13mr26158394wro.29.1544121397665;
 Thu, 06 Dec 2018 10:36:37 -0800 (PST)
MIME-Version: 1.0
References: <3d7393a6287db137a69c4d05785522d5@gmx.de> <20181205090721.43e7f36c@coco.lan>
 <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc> <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
 <20181206160145.2d23ac0e@coco.lan>
In-Reply-To: <20181206160145.2d23ac0e@coco.lan>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 6 Dec 2018 13:36:24 -0500
Message-ID: <CADnq5_P-jQWQMLnJcESZf8ygPheE3F5XUq8isB9jXzCKa=L=Og@mail.gmail.com>
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     mchehab@kernel.org
Cc:     markus.dobel@gmx.de, Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 6, 2018 at 1:05 PM Mauro Carvalho Chehab <mchehab@kernel.org> wrote:
>
> Em Thu, 06 Dec 2018 18:18:23 +0100
> Markus Dobel <markus.dobel@gmx.de> escreveu:
>
> > Hi everyone,
> >
> > I will try if the hack mentioned fixes the issue for me on the weekend (but I assume, as if effectively removes the function).
>
> It should, but it keeps a few changes. Just want to be sure that what
> would be left won't cause issues. If this works, the logic that would
> solve Ryzen DMA fixes will be contained into a single point, making
> easier to maintain it.
>
> >
> > Just in case this is of interest, I neither have Ryzen nor Intel, but an HP Microserver G7 with an AMD Turion II Neo  N54L, so the machine is more on the slow side.
>
> Good to know. It would probably worth to check if this Ryzen
> bug occors with all versions of it or with just a subset.
> I mean: maybe it is only at the first gen or Ryzen and doesn't
> affect Ryzen 2 (or vice versa).

The original commit also mentions some Xeons are affected too.  Seems
like this is potentially an issue on the device side rather than the
platform.

>
> The PCI quirks logic will likely need to detect the PCI ID of
> the memory controllers found at the buggy CPUs, in order to enable
> the quirk only for the affected ones.
>
> It could be worth talking with AMD people in order to be sure about
> the differences at the DMA engine side.
>

It's not clear to me what the pci or platform quirk would do.  The
workaround seems to be in the driver, not on the platform.

Alex
