Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC65C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F8AF214AE
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ea7vJ//T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfCLIWd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:22:33 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:45071 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfCLIWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:22:32 -0400
Received: by mail-ot1-f54.google.com with SMTP id i12so1667099otp.12
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 01:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nvcGQxZhe9BibTs23j7xMMTea0XKIFWkw1bKelIjns8=;
        b=ea7vJ//TgO/VmWrtfcT+4AG9eyz2ckIU7Xu7lL3K9aM0NtUkA2i7001wTSatwQcj1h
         utwWMnNJmgmZ/xxe+ILUUj8NIRle9SMp1aFdYAHWuYrPe69hQ+6viUo+ZsMz5XWiSfJH
         DRGqYgU/jI1oVb2TLigAiCdTc58ureir5DRcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nvcGQxZhe9BibTs23j7xMMTea0XKIFWkw1bKelIjns8=;
        b=fsPaw3b9NCvC5m8JDayP2nGFHBZUL3QOtEZdYM+KGwSWSKHVi3VfPtuXZeQmlspyme
         M+pptzldTkaqlcOcO8jkTU9Wr8b6+KnPQn2zYEWp/x2yt1Jzy+2M3w0jJTmjqQ13lU1E
         AoVW/6/3ojmV7pBOQBUCvSpjKwfsCjiOAyNbkSQRqHUZYeH25xCOP9MEmNjGTy9zHUoN
         8vgvfwZLxAUW4uGZw0blNf5ESH0JIGKViYX/Ev/ZL6tbHQ8flDqRBgQxKOPQgTAx4KVl
         V0j3byuiuYBSynmpaw75ul+KGuDYtVU8EHCB0oqSBYfPdZLU45YS9WxxTcfduBPh8q1v
         j8jQ==
X-Gm-Message-State: APjAAAWPxLDVDNCz1foT4iJ1wZkJthqk1ooTZJqHqRviYD7CCjg9HuFy
        halCzJPrSrsM6i5NDRrmD5kLwTjychI=
X-Google-Smtp-Source: APXvYqyLo39Rfl1UFPj7vtvnfCbSXMuKEtVzNeXds15Kg+8//qIIO7Mk/fGN1g8sy7YSEtSbo+8NLw==
X-Received: by 2002:a9d:4799:: with SMTP id b25mr23966569otf.294.1552378950535;
        Tue, 12 Mar 2019 01:22:30 -0700 (PDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.gmail.com with ESMTPSA id n12sm3201433otl.22.2019.03.12.01.22.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 01:22:29 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id i5so1682838oto.9
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 01:22:29 -0700 (PDT)
X-Received: by 2002:a9d:4c85:: with SMTP id m5mr23061291otf.367.1552378949006;
 Tue, 12 Mar 2019 01:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info>
In-Reply-To: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 12 Mar 2019 17:22:17 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DY0n0oDvE9o6rAXY5inL20wwAC=jPxN9EwrD1Ubv0iJg@mail.gmail.com>
Message-ID: <CAAFQd5DY0n0oDvE9o6rAXY5inL20wwAC=jPxN9EwrD1Ubv0iJg@mail.gmail.com>
Subject: Re: media: rockchip: the memory layout of multiplanes buffer for DMA address
To:     Ayaka <ayaka@soulik.info>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, myy@miouyouyou.fr,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 28, 2019 at 12:13 AM Ayaka <ayaka@soulik.info> wrote:
>
> Hello all
>
> I am writing the v4l2 decoder driver for rockchip. Although I hear the su=
ggest from the Hans before, it is ok for decoder to use single plane buffer=
 format, but I still decide to the multi planes format.
>
> There is not a register for vdpau1 and vdpau2 setting the chroma starting=
 address in both pixel image output(it has one only applied for jpeg) and r=
eference. And the second plane should follow the first plane. It sounds pre=
tty fix for the single plane, but the single plane can=E2=80=99t describe o=
ffset of the second plane, which is not the result of bytes per line multip=
les the height.
>
> There are two different memory access steps in those rockchip device, 16b=
ytes for vdpau1 and vdpau2, 64bytes for rkvdec and 128bytes for rkvdec with=
 a high resolution. Although those access steps can be adjusted by the memo=
ry cache registers. So it is hard to describe the pixel format with the sin=
gle plane formats or userspace would need to do more work.

Why not just adjust the bytes per line to a multiple of 16/64/128
bytes? Most of the platforms allocate buffers this way for performance
reasons anyway.

>
> Currently, I use the dma-contig allocator in my driver, it would allocate=
 the second plane first, which results that the second plane has a lower ad=
dress than first plane, which device would request the second plane follows=
 the first plane. I increase the sizeimage of the first plane to solve this=
 problem now and let device can continue to run, but I need a way to solve =
this problem.
>
> Is there a way to control how does dma-contig allocate a buffer? I have n=
ot figured out the internal flow of the videobuf2. I know how to allocate t=
wo planes in different memory region which the s5p-mfc does with two alloc_=
devs, but that is not what I want.
>
> Last time in FOSDEM, kwiboo and I talk some problems of the request API a=
nd stateless decoder, I say the a method to describe a buffer with many off=
sets as the buffer meta data would solve the most of  problems we talked, b=
ut I have no idea on how to implement it. And I think a buffer meta describ=
ing a buffer with many offsets would solve this problem as well.
>
> Sent from my iPad

P.S. Please fix your email client to properly wrap the lines around
the ~75 column line.

Best regards,
Tomasz
