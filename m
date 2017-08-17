Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33542 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdHQNSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <1502796222-9681-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502796222-9681-1-git-send-email-arvind.yadav.cs@gmail.com> <1502796222-9681-3-git-send-email-arvind.yadav.cs@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 17 Aug 2017 14:17:41 +0100
Message-ID: <CA+V-a8vQ9XqVoUNx+Wc0UcJ+RthNk3JGDrCCY8xtJCG08f1v3Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] davinci: constify platform_device_id
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 15, 2017 at 12:23 PM, Arvind Yadav
<arvind.yadav.cs@gmail.com> wrote:
>
> platform_device_id are not supposed to change at runtime. All functions
> working with platform_device_id provided by <linux/platform_device.h>
> work with const platform_device_id. So mark the non-const structs as
> const.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
