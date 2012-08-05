Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64644 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2HEEEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2012 00:04:45 -0400
Received: by vcbfk26 with SMTP id fk26so1823665vcb.19
        for <linux-media@vger.kernel.org>; Sat, 04 Aug 2012 21:04:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+VHfxhjzc-yBQYrXL7-gscfqt2tZmxx+Tpe8qE+cPXzWA@mail.gmail.com>
References: <1344103941-23047-1-git-send-email-develkernel412222@gmail.com>
	<CALF0-+VHfxhjzc-yBQYrXL7-gscfqt2tZmxx+Tpe8qE+cPXzWA@mail.gmail.com>
Date: Sun, 5 Aug 2012 09:49:44 +0545
Message-ID: <CA+C2MxQn1OR_2ONEKuGc7HfX+aZos0RUGdr9e-7vP5iNduMn6Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: media: cxd2099: use kzalloc to allocate ci
 pointer of type struct cxd in cxd2099_attach
From: Devendra Naga <develkernel412222@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ezequiel,

On Sun, Aug 5, 2012 at 12:24 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hi Devendra,
>
> On Sat, Aug 4, 2012 at 3:12 PM, Devendra Naga
> <develkernel412222@gmail.com> wrote:
>>
>>         mutex_init(&ci->lock);
>>         memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
>
> While you're still looking at this driver, perhaps you can change the memcpy
> with a plain struct assignment (if you feel like).
> It's really pointless to use a memcpy here.
>
> Something like this:
>
> -       memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
> +       ci->cfg = *cfg;
>
Correct, and also one more thing like this is

-           memcpy(&ci->en, &en_templ, sizeof(en_templ));
+          ci->en = en_templ;

Is it ok if i change ci->cfg and ci->en?
> Regards,
> Ezequiel.

Thanks,
