Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60865 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2HDSjC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2012 14:39:02 -0400
Received: by yhmm54 with SMTP id m54so1706058yhm.19
        for <linux-media@vger.kernel.org>; Sat, 04 Aug 2012 11:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344103941-23047-1-git-send-email-develkernel412222@gmail.com>
References: <1344103941-23047-1-git-send-email-develkernel412222@gmail.com>
Date: Sat, 4 Aug 2012 15:39:01 -0300
Message-ID: <CALF0-+VHfxhjzc-yBQYrXL7-gscfqt2tZmxx+Tpe8qE+cPXzWA@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: media: cxd2099: use kzalloc to allocate ci
 pointer of type struct cxd in cxd2099_attach
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devendra,

On Sat, Aug 4, 2012 at 3:12 PM, Devendra Naga
<develkernel412222@gmail.com> wrote:
>
>         mutex_init(&ci->lock);
>         memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));

While you're still looking at this driver, perhaps you can change the memcpy
with a plain struct assignment (if you feel like).
It's really pointless to use a memcpy here.

Something like this:

-       memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
+       ci->cfg = *cfg;

Regards,
Ezequiel.
