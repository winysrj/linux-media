Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A30CC67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3AED2080F
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:41:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vanguardiasur-com-ar.20150623.gappssmtp.com header.i=@vanguardiasur-com-ar.20150623.gappssmtp.com header.b="fzOeiimQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3AED2080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vanguardiasur.com.ar
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbeLLRlU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 12:41:20 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38184 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbeLLRlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 12:41:19 -0500
Received: by mail-pl1-f194.google.com with SMTP id e5so8925884plb.5
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 09:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanguardiasur-com-ar.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mAssrmJlu9H/RT/IUtyjggNaKpKcJJfSlRCSThI1Ktk=;
        b=fzOeiimQF1371cjmO961aiiHnTmNN7pqiJgAQFLMWpdtPKbZNo/NHXnJFgh9lmfQv1
         zBHEaufddQKZU8Y4f1k+6E/0upAmbUdP/OKKl81Vku/9e5yGZxVPBLh/s/11/N763V5e
         LffDcOoA0cIThN730JRIgZSSU1ZDq7TeCUpIQk6tpZw7arvVnr8VqXDI8yfZs6XZtH4B
         rYVLC4htUdLVeOb15JCVG0ca1Fe0JjQ7ITC+99AzVQ1Jm36tuKZMlgMJL2ge2G1FPDbw
         +SunAQPCOAZm9uhCbZGn2JSLuBgZdNdQQHV7zGS/R9J4jX1U00m2MhkZtj6+CzLoKc9p
         7OXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mAssrmJlu9H/RT/IUtyjggNaKpKcJJfSlRCSThI1Ktk=;
        b=Fd4uZxAyqmF7cm6XkpoFydLmC49Eqy7u2hs7kog2SSJWNmvpCl++7ZQJu0paAXtQoC
         fW5BNM+RlZkn+PZ62FR7mINm4RjZEFw6Bnq+hJXec3krcEXL1bcKl2bURb/UOQ6RMC7b
         sl50AJyvc2xyd1xe7Z7JbDFRjhJGE58FHj47LqRQFtzsVwVbrhJ2vkFpg+YXcbs0oQKh
         /Xx7DDSbwwkB2ugMVeNMUuchx/xYKSdDR05Rn5niBe7PtnqbLEhRGDYwyJraOZ3FlpVZ
         3phTgQ5P3vrgKn08NwgQyZrN532nzUzqRSY6Ly0RJLWEq/XoVzVwG8UhUPN6G6XsjL8e
         oyZw==
X-Gm-Message-State: AA+aEWZhzOzUWG03H5yp8r+fqKw9oOXeOFwbdg9VnUIoZoncXCi2xk6Q
        RXxqimP1HW5Xgq64vI5DA75uY4UF6/+N0xTdxX603w==
X-Google-Smtp-Source: AFSGD/XmGHsM9r+xZBgY4tRwegCRzPqaKSP7XvE6RSWec29QRJwogD32vSPAHNUBnUtG0m1n24zpw+su/vhIvmHKe/g=
X-Received: by 2002:a17:902:4a0c:: with SMTP id w12mr20898646pld.8.1544636479189;
 Wed, 12 Dec 2018 09:41:19 -0800 (PST)
MIME-Version: 1.0
References: <20181109190327.23606-1-matwey@sai.msu.ru> <3390244.qRE0ngbmrs@avalon>
In-Reply-To: <3390244.qRE0ngbmrs@avalon>
From:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date:   Wed, 12 Dec 2018 14:41:07 -0300
Message-ID: <CAAEAJfDaO+2gvmuXwYD_-g9Q_dtQiP1SO6HX8u7cNS8LU4b8Zw@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     matwey@sai.msu.ru, linux-media <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        matwey.kornilov@gmail.com, Tomasz Figa <tfiga@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com,
        Keiichi Watanabe <keiichiw@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 12 Dec 2018 at 14:27, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Matwey,
>
> Thank you for the patches.
>
> For the whole series,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>

Thanks Laurent.

Matwey, given your detailed analysis of this issue,
and given you have pwc hardware to test, I think
you should consider co-maintaining this driver.

Thanks,
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
