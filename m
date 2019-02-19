Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E81C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E041217D9
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeRg3YVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfBSQ3F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:29:05 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36449 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfBSQ3F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 11:29:05 -0500
Received: by mail-ed1-f67.google.com with SMTP id g9so6753673eds.3;
        Tue, 19 Feb 2019 08:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eTIyXcANNF9vHPfm+eipaAYN5nRj6Ks336GiU+ADjVI=;
        b=OeRg3YVUxJ7IzgY9z/DIA7Dy5M8ZWx/YTqEmmWKt3eVtwvFJmjOCQ3P2UzT58CBcZN
         Hh5cahHgILLf7yQeTCRs0SDDcqGKX5cf+cOW7UXJgDjuCKVwYdH+Kaggy1ZWzP9XzsMl
         ACcyg9nYf/0PZlRUWtC2DQQs+rDpwYpvCejH764GGWfInox0sfeN2q3MSjS0L3EaNZEy
         xrf7hgKE75AYjvu8V0elwo8vqcEhbKeadgfp9UCKIMRxZaXfqsHizmUeVCyl/NrdFCmG
         pCXe5v4ktg9sPzOf0nrH9S1jVuEs5DhE8uksijG6pTvNEzSt9MRsUOk+wKbFAxVGO/Dl
         +uiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eTIyXcANNF9vHPfm+eipaAYN5nRj6Ks336GiU+ADjVI=;
        b=BAWzeEFSyGxfLqDmv/dqHvyG/KU8lfZApgOgonltdB+kHEjOcdxfSBP3Xx70EPwJHQ
         vTB3+c3flpcrvvrKCXPVFJgnno9/9O0txUVgLlbOLe/8KNsf7+BawWTEmaxOpZMsi817
         IPkyiwP0AYGezkMP3Qo7Ygrz3Kae2VfUqfk9A4ycX+LNk7oTglg7zy10yWA7v/Hk5k4M
         b5SqzqoekR3TqZU7dRUejCvr2ys7fFAxbT9zioV7Nz+jsZ88BPy2WLou3d1wjM7cN/TW
         m43uY/IB25o0pXTAzCEY15ubVeGMAzMUCUkCVvtSFe6AQ2MXezew1rSBVUsKs6zXBzzF
         HuUw==
X-Gm-Message-State: AHQUAuZgnWqw7UHWuer9i0Azf6bNtw5FJeu+F59rGg7hgdcgryyGpDvC
        EmX+qCJvBitlBGB0d6BNhIohFUCG1RpSLsV+qdq6xVpi
X-Google-Smtp-Source: AHgI3IYOZRjfpkz3EsLDWUp7uicPN2zhoQ0WQy7Hc/jxy/V4J6Lkh3s31x4MUoG2yfxIzm5JKoDsE8Lu2p8HQI7hQzE=
X-Received: by 2002:a50:9b50:: with SMTP id a16mr23011268edj.135.1550593743766;
 Tue, 19 Feb 2019 08:29:03 -0800 (PST)
MIME-Version: 1.0
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
 <8ad3211c5c6c6835997237af02df71eeb2c78c17.1550518128.git.mchehab+samsung@kernel.org>
In-Reply-To: <8ad3211c5c6c6835997237af02df71eeb2c78c17.1550518128.git.mchehab+samsung@kernel.org>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 19 Feb 2019 16:28:36 +0000
Message-ID: <CA+V-a8vCQ3grhE9xeen0vfs9O4LFR2t9fK+OcjkyOet9x=5FsA@mail.gmail.com>
Subject: Re: [PATCH 12/14] media: include: fix several typos
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Mon, Feb 18, 2019 at 7:29 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Use codespell to fix lots of typos over frontends.
>
> Manually verified to avoid false-positives.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  include/media/davinci/dm355_ccdc.h         | 4 ++--
>  include/media/davinci/dm644x_ccdc.h        | 2 +-
For the above,

Reviewed-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
Prabhakar
