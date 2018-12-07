Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C24C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35447208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/t9Px1j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35447208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbeLGNkI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:40:08 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:56138 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGNkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:40:08 -0500
Received: by mail-it1-f195.google.com with SMTP id o19so6846761itg.5;
        Fri, 07 Dec 2018 05:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QZXOxCmXChwQnEIdXhUUmnLs50L3mvTVM/iVgJWrrCM=;
        b=G/t9Px1j0jXrR3MzTgIZSl56sw48OTkb7wwT4NJK1HgP9mMfek2XH8LyteYPPDm9nG
         i+kDA/BD7XgeAB5qBc2Uj6vR1uBOZVhfcdzJwSri8/byDDx1t4SXqetF0vAxBzMnbKme
         ry5Mya85zw1isLLie2MmFI+QPpGYZVepvMFVQpHD0zezwZFCPuN4kZFYWZpLd6TxTnLE
         +a2N2iy5SmEIhP/oG478K4vcYuvAO/xrpga2QLx0a8gWobxvoTn05LMHaCLojLIy1iiQ
         28jtPKT6d2GKGFeXSEV72WA9lZZQJ2ZE41n1bBb0oaDz4PCP5LJ9XG/UoFOwy9WB+Pg+
         3ZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZXOxCmXChwQnEIdXhUUmnLs50L3mvTVM/iVgJWrrCM=;
        b=DHTUHNDrGVQ4c4LCceTKpyc5msVkkUvHTGHbXOkrGeCLBXYCzd4UKUqWZNKKfWWZNy
         tNR8x17QCTeKYmtjRTHYtLjl2DrT5qI9SBaeuls3MgAROpUegSSQRB58Ps/3CDE33uqJ
         fPZwmUU8q+3UWDM7tykkOKF5zN1E/rMtzZ0DprkLjtoa21Hj5q24JLPw5tZ4O2V6U5Cr
         EiTOulZfspHNQUjf/xB+/4862sagatnVtRvES7tPOaO8QcU0BiZ3jwLqvCl4J0b/8Z5J
         LE34rZQP3pBTRiLG0kalWBCwv9TPovzDXYaKanKCwl1ocqE5hf1NtgX7xCsBu8oE7EJn
         74PA==
X-Gm-Message-State: AA+aEWaAAO31g2Dm0v9J6ZrJYxqTWm6QnLedACiTXsaPqDlXeeXL8OuX
        rtfTMq/XPEelBytZ+uP64mGTJglxsoCIDzIfwDI=
X-Google-Smtp-Source: AFSGD/XbOHW/zXOhA4bdEgg20HUHD0DtMFmBjzHois75dVpzcZAIuER3IN3Ri1068cAo7NanWHWDGr+Q3FjjtCIyzBA=
X-Received: by 2002:a02:3f0b:: with SMTP id d11mr1899652jaa.26.1544190005869;
 Fri, 07 Dec 2018 05:40:05 -0800 (PST)
MIME-Version: 1.0
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5> <20181130205521.GA21006@linux.intel.com>
 <1543611662.3031.20.camel@HansenPartnership.com> <20181130214405.GG23772@linux.intel.com>
 <1543615069.3031.27.camel@HansenPartnership.com> <20181130221219.GA25537@linux.intel.com>
 <20181130151459.3ca2f5c8@lwn.net> <CAMuHMdUkpLWm5NZmYj=uMgVncw6ZOb7j9KxFoDGhrnr7vzpx_w@mail.gmail.com>
In-Reply-To: <CAMuHMdUkpLWm5NZmYj=uMgVncw6ZOb7j9KxFoDGhrnr7vzpx_w@mail.gmail.com>
From:   Eric Curtin <ericcurtin17@gmail.com>
Date:   Fri, 7 Dec 2018 13:39:54 +0000
Message-ID: <CANpvso4ZjJkUA7+saYRR4qssvreZcm-74EPo3nrGSohFZF9akA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
To:     geert@linux-m68k.org
Cc:     corbet@lwn.net, jarkko.sakkinen@linux.intel.com,
        James.Bottomley@hansenpartnership.com, dave@stgolabs.net,
        keescook@chromium.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        amir73il@gmail.com, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, dja@axtens.net,
        davem@davemloft.net, linux@dominikbrodowski.net,
        dri-devel@lists.freedesktop.org, edumazet@google.com,
        federico.vaga@vaga.pv.it, geert+renesas@glider.be, deller@gmx.de,
        kumba@gentoo.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-media@vger.kernel.org,
        linux-mips@linux-mips.org, linux-mtd@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        pabeni@redhat.com, paul.burton@mips.com, pmladek@suse.com,
        robh@kernel.org, sean.wang@mediatek.com,
        sergey.senozhatsky@gmail.com, shannon.nelson@oracle.com,
        sbrivio@redhat.com, rostedt@goodmis.org, me@tobin.cc,
        makita.toshiaki@lab.ntt.co.jp, willemb@google.com, yhs@fb.com,
        yanjun.zhu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Guys,

I initially thought these patches were a joke. But I guess they are
not. I suppose 2018 is the year everything became offensive.

Could we avoid the s/fuck/hug/g though? I have nothing against
re-wording this stuff to remove the curse word, but it should at least
make sense.

What's going to happen is someone is a newbie is going to see a comment
like "We found an mark in the idr at the right wd, but it's not the
mark we were told to remove. eparis seriously hugged up somewhere",
probably google the term as they are unfamiliar with it, find out it's
an alias for "fucked" and if they are sensitive get offended anyway.

On Sat, 1 Dec 2018 at 08:20, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Jon,
>
> On Fri, Nov 30, 2018 at 11:15 PM Jonathan Corbet <corbet@lwn.net> wrote:
> > On Fri, 30 Nov 2018 14:12:19 -0800
> > Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > > As a maintainer myself (and based on somewhat disturbed feedback from
> > > other maintainers) I can only make the conclusion that nobody knows what
> > > the responsibility part here means.
> > >
> > > I would interpret, if I read it like at lawyer at least, that even for
> > > existing code you would need to do the changes postmorterm.
> > >
> > > Is this wrong interpretation?  Should I conclude that I made a mistake
> > > by reading the CoC and trying to understand what it *actually* says?
> > > After this discussion, I can say that I understand it less than before.
> >
> > Have you read Documentation/process/code-of-conduct-interpretation.rst?
> > As has been pointed out, it contains a clear answer to how things should
> > be interpreted here.
>
> Indeed:
>
> | Contributions submitted for the kernel should use appropriate language.
> | Content that already exists predating the Code of Conduct will not be
> | addressed now as a violation.
>
> However:
>
> | Inappropriate language can be seen as a
> | bug, though; such bugs will be fixed more quickly if any interested
> | parties submit patches to that effect.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
