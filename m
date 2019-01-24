Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A860FC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7588520854
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eLwzymyw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfAXJHL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:07:11 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44747 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfAXJHK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:07:10 -0500
Received: by mail-ot1-f68.google.com with SMTP id g16so595395otg.11
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 01:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcuJ7o6GNo8x17v/dH/5G6NdXueyDstuYD8Zc4S9Y7s=;
        b=eLwzymywGD+CIk/31TbpTyWXUjDdnn811AZrBe5if7mUFts3Hx2POFLLXiqOvzu0XS
         iqI1nzMkWWSVMGrpr3r6HUmz4woqu0H14TEtWeU3SaT53N9gvYLeTEyPrOjj4FLCF3kx
         EwmvkfGOt2tORe2Lt/T3s5TKFolFWT1TqfDJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcuJ7o6GNo8x17v/dH/5G6NdXueyDstuYD8Zc4S9Y7s=;
        b=oJz8biaPftB12Np/ZO7SSxkUqM/UBsYuJVANCCbcOG8NBNRud3uSTj73gEhLtIWfB6
         M7egGrDfEZIfak+37vVrpb0w6/i4sB/oRK18QXhBUqePUufkfiEDjtmCkCEQ1LLt+cbU
         kFlTLU172/KC78K2MBN7C7CB3HxMDKThzkKp++80QIq9eERuLCS8NN7BL2uvXLRumzMf
         B6C6Cp5tVPt8DG/lJZ0Up8RGfNAS54U1HzgdW2+62hhpbielHnx83DhKmgxnIrXkXM+5
         oEoxN2yd3DkDqBwU9AWR6DbdDTSXu6wd7xjtMHue5Cb7WBrOiVXtN3zaycs36WZV9zC7
         izzw==
X-Gm-Message-State: AJcUukeQKo0FZ5Eijhhhx9woAfEuVA0JJuA92XuRjxvYFOjXQgBsT9vV
        6Jx9foUK3e+tHOjUrFmVutQ15aYgHTw=
X-Google-Smtp-Source: ALg8bN7edRvZbtbE3K/qWDArjEfvIA4LEUEmlVIf5ZQwcJ2JhpEUkFCmdMsDUARQGv1VqXtkbWU7/w==
X-Received: by 2002:a9d:3287:: with SMTP id u7mr3943535otb.80.1548320829869;
        Thu, 24 Jan 2019 01:07:09 -0800 (PST)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com. [209.85.167.174])
        by smtp.gmail.com with ESMTPSA id r11sm10543125oib.45.2019.01.24.01.07.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 01:07:07 -0800 (PST)
Received: by mail-oi1-f174.google.com with SMTP id m6so4220595oig.11
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 01:07:06 -0800 (PST)
X-Received: by 2002:aca:c2c3:: with SMTP id s186mr604655oif.173.1548320826474;
 Thu, 24 Jan 2019 01:07:06 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-2-tfiga@chromium.org>
 <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl> <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
 <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl> <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
In-Reply-To: <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 24 Jan 2019 18:06:54 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BPJv3cbJOWrziEjz_yE32DhfZv9vb-pG1Ltx-KS2=PQg@mail.gmail.com>
Message-ID: <CAAFQd5BPJv3cbJOWrziEjz_yE32DhfZv9vb-pG1Ltx-KS2=PQg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 23, 2019 at 2:27 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Tue, Jan 22, 2019 at 11:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 01/22/19 11:02, Tomasz Figa wrote:
[snip]
> > >>> +   one ``CAPTURE`` buffer, the following cases are defined:
> > >>> +
> > >>> +   * one ``OUTPUT`` buffer generates multiple ``CAPTURE`` buffers: the same
> > >>> +     ``OUTPUT`` timestamp will be copied to multiple ``CAPTURE`` buffers,
> > >>> +
> > >>> +   * multiple ``OUTPUT`` buffers generate one ``CAPTURE`` buffer: timestamp of
> > >>> +     the ``OUTPUT`` buffer queued last will be copied,
> > >>> +
> > >>> +   * the decoding order differs from the display order (i.e. the
> > >>> +     ``CAPTURE`` buffers are out-of-order compared to the ``OUTPUT`` buffers):
> > >>> +     ``CAPTURE`` timestamps will not retain the order of ``OUTPUT`` timestamps
> > >>> +     and thus monotonicity of the timestamps cannot be guaranteed.
> >
> > I think this last point should be rewritten. The timestamp is just a value that
> > is copied, there are no monotonicity requirements for m2m devices in general.
> >
>
> Actually I just realized the last point might not even be achievable
> for some of the decoders (s5p-mfc, mtk-vcodec), as they don't report
> which frame originates from which bitstream buffer and the driver just
> picks the most recently consumed OUTPUT buffer to copy the timestamp
> from. (s5p-mfc actually "forgets" to set the timestamp in some cases
> too...)
>
> I need to think a bit more about this.

Actually I misread the code. Both s5p-mfc and mtk-vcodec seem to
correctly match the buffers.

Best regards,
Tomasz
