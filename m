Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55150 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2HCSLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 14:11:35 -0400
Received: by yenl2 with SMTP id l2so1164689yen.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 11:11:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
References: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
Date: Fri, 3 Aug 2012 15:11:34 -0300
Message-ID: <CALF0-+UdxdawZMeniA-tia3qKARbX_+u2k8PnbhA_FhDKUMv3Q@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Fix height setting on non-progressive captures
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 3, 2012 at 2:52 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> This was introduced on commit c2a6b54a9:
> "em28xx: fix: don't do image interlacing on webcams"
> It is a known bug that has already been reported several times
> and confirmed by Mauro.
> Tested by compilation only.
>

I wonder if it's possible to get an Ack or a Tested-By from any of the
em28xx owners?

Also, Devin: you mentioned in an old mail [1] you had some patches for em28xx,
but you had no time to put them into shape for submission.

If you want to, send then to me (or the full em28xx tree) and I can
try to submit
the patches.

Thanks,
Ezequiel.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48232.html
