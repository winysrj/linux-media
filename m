Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36695 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdE1VmE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 17:42:04 -0400
Received: by mail-wm0-f66.google.com with SMTP id k15so13491189wmh.3
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 14:42:04 -0700 (PDT)
Date: Sun, 28 May 2017 23:42:00 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Karl Wallin <karl.wallin.86@gmail.com>,
        Thomas Kaiser <thomas@kaiser-linux.li>
Cc: linux-media@vger.kernel.org
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of
 function"
Message-ID: <20170528234200.2ffdd351@macbox>
In-Reply-To: <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
        <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li>
        <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun, 28 May 2017 21:06:33 +0200
schrieb Karl Wallin <karl.wallin.86@gmail.com>:

All,

> In "/home/ubuntu/media_build/v4l/cec-core.c" changed row 142 from:
> "ret = cdev_device_add(&devnode->cdev, &devnode->dev);" to:
> "ret = device_add(&devnode->dev);"
> and row 186 from:
> "cdev_device_del(&devnode->cdev, &devnode->dev);" to:
> "device_del(&devnode->dev);"

Until the upstream media_build repository gets the neccessary backport
patch treatment, you can apply [1] and [2] to media_build which should
fix all build issues.

Best regards,
Daniel

[1]
https://github.com/herrnst/media_build/commit/4766a716c629707d58d625c6cdfd8c395fd6ed61
[2]
https://github.com/herrnst/media_build/commit/01507a9c32a301c8fc021dcaf1b943799ff3da51
