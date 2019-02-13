Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC85C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 05:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5163F222BE
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 05:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QvE29idY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbfBMF6q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 00:58:46 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40315 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730072AbfBMF6q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 00:58:46 -0500
Received: by mail-ot1-f68.google.com with SMTP id s5so2045454oth.7
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2019 21:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gkpMzz5e85M/mpA6nnQiGM6P6+2dTHeMydu1MAi3sms=;
        b=QvE29idYaPgjZL7I691YgVnZF4qiT2cPUII43nFemIPPMGTNQZdfItaADNVIH3WY2G
         UoPkXK5eaZiTGXLXXhIJiV6VmGBjK+nzTFNmPOMQycsaV+MbGQgOHC5WyoWr8Hkq/PJw
         1QlcYV4z0VfGBz/vdejBZRoHtdP+FN6kS3YDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gkpMzz5e85M/mpA6nnQiGM6P6+2dTHeMydu1MAi3sms=;
        b=b9SE2VOykTitVuFtpuwkKYx1A1DiwaIXZmXde/S84muFd8mFjf3t2ce6f8P2ty7xhc
         3CpFn29QaTiXsURQ6pNW7MOBohUriiBytaK18n1C2MVDTk6ruIJ+Rhgn0Ft5oRjpznVg
         ag1X58MEnpmp/0neZEf25IuUwy/WdTaHBi+0ykYliDS+hei++X2R0Xatt6a7buI1QbGk
         rSwTczkJnPdJmzF5zsd3hfmchkvQTI9roobk5MwpckWvWcu6+SuYMS0flwVPwnrTibXt
         viTCzZ//ca948v7c8jiHaZwGOhJ0C/gYTGc8kg9SKeTG1qAZfIyt7MkOLMz6KG+Iywqw
         NpKQ==
X-Gm-Message-State: AHQUAubDZ30SVmpVxqtFMmQHfZ328j27nkpkABFMCDYbKaCtj0FTNYx/
        xXxKRHs4jdAW5RL7U9WoGXlR52qWW5Q=
X-Google-Smtp-Source: AHgI3Ia9xODvh0H68SCrNZD/QioP0lBGoxj+tTNSgvcIPeRhPiX8PvfE91geb+UFO33tQ08dmZq+FQ==
X-Received: by 2002:aca:300c:: with SMTP id w12mr216268oiw.123.1550037525638;
        Tue, 12 Feb 2019 21:58:45 -0800 (PST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id i22sm6239058otp.7.2019.02.12.21.58.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 21:58:45 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id b3so2075504otp.4
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2019 21:58:44 -0800 (PST)
X-Received: by 2002:a9d:6f97:: with SMTP id h23mr7665834otq.26.1550037524549;
 Tue, 12 Feb 2019 21:58:44 -0800 (PST)
MIME-Version: 1.0
References: <20190213055317.192029-1-acourbot@chromium.org>
In-Reply-To: <20190213055317.192029-1-acourbot@chromium.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 13 Feb 2019 14:58:32 +0900
X-Gmail-Original-Message-ID: <CAPBb6MUDK0s665wjSjvo3ZePtmFXFrs2WqpaywOSjnRxp08Ong@mail.gmail.com>
Message-ID: <CAPBb6MUDK0s665wjSjvo3ZePtmFXFrs2WqpaywOSjnRxp08Ong@mail.gmail.com>
Subject: Re: [PATCH v3] media: docs-rst: Document m2m stateless video decoder interface
To:     Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Feb 13, 2019 at 2:53 PM Alexandre Courbot <acourbot@chromium.org> wrote:
> [snip]
> +Buffers used as reference frames can be queued back to the ``CAPTURE`` queue as
> +soon as all the frames they are affecting have been queued to the ``OUTPUT``
> +queue. The driver will refrain from using the reference buffer as a decoding
> +target until all the frames depending on it are decoded.

Just want to highlight this part in order to make sure that this is
indeed what we agreed on. The recent changes to vb2_find_timestamp()
suggest this, but maybe I misunderstood the intent. It makes the
kernel responsible for tracking referenced buffers and not using them
until all the dependent frames are decoded, something the client could
also do.

Thanks!
Alex.
