Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB38C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 05:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFB652184C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 05:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="c2e04vG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfAXFfi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 00:35:38 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:38043 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbfAXFfi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 00:35:38 -0500
Received: by mail-oi1-f178.google.com with SMTP id a77so3894047oii.5
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 21:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIzyFjbkHz7eLeSmzXs4E6/8FSv4B9OOHqHnhukwa2M=;
        b=c2e04vG+zSeBhggnTo458acTV1bv1iVIXwUzJmNuA9PI//Fj0jd/GNOxg7UChPaOUU
         PmkpV2UxHdbvgh+Qdfvs55VkVFH31wMp1N/x5LoIKiu6u8DWExyDNBoKIWgL0IWtkJnd
         K9xIZZnXUglYjSFlqq+/zAsNNR0jSCquJ2PGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIzyFjbkHz7eLeSmzXs4E6/8FSv4B9OOHqHnhukwa2M=;
        b=anpn824qnTaZj31dN5bsJ5m8RNNK1OL0LV01DJxHa1Vftif9ZMhF1cQ31BKjr00oLb
         GRu/ioC96EXg5aC/QLvtNluDOMDx362XrE5pXMY38givocy7fUo5/K3XMZnXDrWjTw4c
         cqmDRdw6sz62ie0n7eoeqwF/FRRksEvrPpJXJy+vQeEDVmgPEVfutfIk4LUbY4syHEfF
         hZosQajfSTwdUj8ZoJKkPhgquHCPw7zesJg2/kfYFIsi0MDZQl1/my4XVi45HMZxCDOO
         Lmc58S4CrQO9b43zet2autaBQfWNQ+9vrxHXFujkPWR6+ReGwHS0GdZl2O24WLns3IA8
         AwSA==
X-Gm-Message-State: AJcUukdcA89hE2CD5saGkB6BhnYF/SqEg1hyeo2dXdvMo5wckF0B7PL3
        MPIkvkslhIwbl2WhN9mkADSYvUWY9ec=
X-Google-Smtp-Source: ALg8bN6hDqGfFRWuYK4u2tPFudOXRWifv2YRUyVIZdMRJe0gkulFaPZhGpFtlCdzB68MnkWf8rd2eA==
X-Received: by 2002:aca:b804:: with SMTP id i4mr222946oif.280.1548308136146;
        Wed, 23 Jan 2019 21:35:36 -0800 (PST)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com. [209.85.167.181])
        by smtp.gmail.com with ESMTPSA id x127sm9886071oia.20.2019.01.23.21.35.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 21:35:35 -0800 (PST)
Received: by mail-oi1-f181.google.com with SMTP id j21so3882800oii.8
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 21:35:34 -0800 (PST)
X-Received: by 2002:aca:b882:: with SMTP id i124mr231522oif.127.1548308134379;
 Wed, 23 Jan 2019 21:35:34 -0800 (PST)
MIME-Version: 1.0
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
 <20190122112727.12662-4-hverkuil-cisco@xs4all.nl> <4792b823-6eb1-536b-08d6-5cad28bb2f24@xs4all.nl>
In-Reply-To: <4792b823-6eb1-536b-08d6-5cad28bb2f24@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 24 Jan 2019 14:35:23 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DpL=LvHxK4zmt2jdJqbfy96iK=TsmFwGKRhSv2OQzD+A@mail.gmail.com>
Message-ID: <CAAFQd5DpL=LvHxK4zmt2jdJqbfy96iK=TsmFwGKRhSv2OQzD+A@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] Documentation/media: rename "Codec Interface"
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Wed, Jan 23, 2019 at 5:07 PM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>
> The "Codec Interface" chapter is poorly named since codecs are just one
> use-case of the Memory-to-Memory Interface. Rename it and clean up the
> text a bit.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> Incorporated Tomasz' comments.
>
> Note that I moved the section about codec controls to the end. The idea
> is that when we add the codec specs this section is updated and the
> links to those specs is added there.
> ---
>  .../media/uapi/mediactl/request-api.rst       |  4 +-
>  .../v4l/{dev-codec.rst => dev-mem2mem.rst}    | 41 +++++++++----------
>  Documentation/media/uapi/v4l/devices.rst      |  2 +-
>  .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  2 +-
>  5 files changed, 25 insertions(+), 26 deletions(-)
>  rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (50%)
>

Thanks a lot!

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
