Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:41385 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966535AbeCAIxw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 03:53:52 -0500
Received: by mail-ua0-f176.google.com with SMTP id u99so3393426uau.8
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2018 00:53:52 -0800 (PST)
Received: from mail-ua0-f178.google.com (mail-ua0-f178.google.com. [209.85.217.178])
        by smtp.gmail.com with ESMTPSA id 3sm601764uag.29.2018.03.01.00.53.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Mar 2018 00:53:50 -0800 (PST)
Received: by mail-ua0-f178.google.com with SMTP id f5so3395156uam.5
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2018 00:53:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519893856-4738-1-git-send-email-zhengsq@rock-chips.com>
References: <1519893856-4738-1-git-send-email-zhengsq@rock-chips.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 1 Mar 2018 17:53:29 +0900
Message-ID: <CAAFQd5AteVDQgHaov2Jqjbx5bAjmJJiXv-7R0HG+AcE3GH-JTw@mail.gmail.com>
Subject: Re: [PATCH] media: ov2685: Not delay latch for gain
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian,

On Thu, Mar 1, 2018 at 5:44 PM, Shunqian Zheng <zhengsq@rock-chips.com> wrote:
> Update the register 0x3503 to use 'no delay latch' for gain.
> This makes sensor to output the first frame as normal rather
> than a very dark one.

I'm not 100% sure on how this setting works, but wouldn't it mean that
setting the gain mid-frame would result in half of the frame having
old gain and another half new? Depending how this works, perhaps we
should set this during initial register settings, but reset after
streaming starts?

Best regards,
Tomasz
