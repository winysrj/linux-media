Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF749C43387
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 08:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC2E22171F
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 08:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DC+R6XBy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbeLXIYG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 03:24:06 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43017 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbeLXIYG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 03:24:06 -0500
Received: by mail-ot1-f65.google.com with SMTP id a11so10328057otr.10;
        Mon, 24 Dec 2018 00:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+K3W/ijGEq9bltzERQhPrtELn2ss525q7HQ7lHMjnm4=;
        b=DC+R6XByEMbTNeCjfzgOxCTJgE4fk6UJS2GUg3NybOe4/d9yQ6dRWZZzmu1tMKMxpS
         jG4eJPsGX4k4owPlhxMJYfmwIgusTFRc7cVBrA9z7kaWxjGxFArjgb7cJvhMsChElvRf
         QIDIBYCdMGf2Pzk7JW7/1Ck//MdGm+lPYOeTNNfwGFxPQlZX0XaGYcAqR7liCFqcSQQP
         V5fKvN+CZ5Tz/82PxCq3rA7e/tEI5MS33GhUussGxQfbKFoRIqmE3HEVMNMwaT7xKKFk
         YZi5vG8BpL+vPGQdglRJ0zuU4gHUobFj7NCjrCvsn/uRRsvIugET4bxFg5H9i2sF8apZ
         XffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+K3W/ijGEq9bltzERQhPrtELn2ss525q7HQ7lHMjnm4=;
        b=f3GTbLw1hRBytW8biich5vMMl+ZiojpfTPpDAY7169DtKuJe1o1sn+xjnaIygzPnmi
         tRHRM3aIte4S2liWI0hqpWByUEXLMrtuPfJf3rBnoLPrvXjShhc9dZqvGtAbWvAvfKHH
         xbPrRn/+eIv6pV2/uz9A7Hi3Ikj8H0Sap9T6W6zANf2SFsgK/Dj+mRtiuuYs7Nr1HL1e
         H94qTjQadlYr1g6Qs4TKGNjzxDyhAyzCxPS4Uk+TA0Qa8M45r19ccGlCRu7PwiOfzh8J
         xaS/ZLma74/sNpzPk/hRILyDULUKBZkzS31Rl/018oTrAdNaO//uG7xs0LM6iYsRqwsK
         Rn3w==
X-Gm-Message-State: AJcUukd0bTrVvZL5b++w3fj70VAVq88qDRltrpdWzDuO7hMQ9By0LnM/
        IJiMeMEIMOkDduYTsPeYx+GU+qDw6FrdE4aqJZs=
X-Google-Smtp-Source: ALg8bN5x42fZzG+h+c4AFgJfbZmvHy/XFdqhWd2Fzq5hyLSClDxIxQZ1wE+9SJRINWqFvLYhyFfMuXPIgZktUxsAAWU=
X-Received: by 2002:a05:6830:2115:: with SMTP id i21mr6667969otc.237.1545639844495;
 Mon, 24 Dec 2018 00:24:04 -0800 (PST)
MIME-Version: 1.0
References: <20181109190327.23606-1-matwey@sai.msu.ru> <3390244.qRE0ngbmrs@avalon>
 <CAAEAJfDaO+2gvmuXwYD_-g9Q_dtQiP1SO6HX8u7cNS8LU4b8Zw@mail.gmail.com>
In-Reply-To: <CAAEAJfDaO+2gvmuXwYD_-g9Q_dtQiP1SO6HX8u7cNS8LU4b8Zw@mail.gmail.com>
From:   "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date:   Mon, 24 Dec 2018 11:23:53 +0300
Message-ID: <CAJs94EZt7mfz7uTrcTeQ29=9G7Ksoun_TQa1iyT+RE0=umobkA@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To:     Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

=D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3. =D0=B2 20:41, Ezequiel Ga=
rcia <ezequiel@vanguardiasur.com.ar>:
>
> On Wed, 12 Dec 2018 at 14:27, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >
> > Hi Matwey,
> >
> > Thank you for the patches.
> >
> > For the whole series,
> >
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >
>
> Thanks Laurent.
>
> Matwey, given your detailed analysis of this issue,
> and given you have pwc hardware to test, I think
> you should consider co-maintaining this driver.
>

Well, It would be great if I could help. Is there some guide how to apply?

> Thanks,
> --
> Ezequiel Garc=C3=ADa, VanguardiaSur
> www.vanguardiasur.com.ar



--=20
With best regards,
Matwey V. Kornilov
