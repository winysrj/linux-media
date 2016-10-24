Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:36222 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933644AbcJXRMd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 13:12:33 -0400
Received: by mail-yb0-f170.google.com with SMTP id f133so15893123ybc.3
        for <linux-media@vger.kernel.org>; Mon, 24 Oct 2016 10:12:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160928212220.27220-1-bparrot@ti.com>
References: <20160928212220.27220-1-bparrot@ti.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Mon, 24 Oct 2016 14:12:32 -0300
Message-ID: <CABxcv=kEWpw7q6a57JAiiR8U0itvfMQaUKddVNdDN2WyfVpPmQ@mail.gmail.com>
Subject: Re: [Patch 20/35] media: ti-vpe: vpe: Added MODULE_DEVICE_TABLE hint
To: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Benoit,

On Wed, Sep 28, 2016 at 5:22 PM, Benoit Parrot <bparrot@ti.com> wrote:
> ti_vpe module currently does not get loaded automatically.
> Added MODULE_DEVICE_TABLE hint to the driver to assist.
>
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
