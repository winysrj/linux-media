Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:40121 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbeDCKNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 06:13:33 -0400
Received: by mail-ua0-f182.google.com with SMTP id n20so10633768ual.7
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2018 03:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <20180328171243.28599-1-p.zabel@pengutronix.de>
In-Reply-To: <20180328171243.28599-1-p.zabel@pengutronix.de>
From: Tomasz Figa <tfiga@google.com>
Date: Tue, 03 Apr 2018 10:13:21 +0000
Message-ID: <CAAFQd5DAm4G23H32OsbNQxZGLKSTaEw2gt4bM6G0cmJ6NMyKkw@mail.gmail.com>
Subject: Re: [PATCH] media: coda: do not try to propagate format if capture
 queue busy
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sasha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Thu, Mar 29, 2018 at 2:12 AM Philipp Zabel <p.zabel@pengutronix.de>
wrote:

> The driver helpfully resets the capture queue format and selection
> rectangle whenever output format is changed. This only works while
> the capture queue is not busy.

Is the code in question used only for decoder case? For encoder, CAPTURE
queue determines the codec and so things should work the other way around,
i.e. setting CAPTURE format should reset OUTPUT format and it should be
allowed only if OUTPUT queue is not busy.

Best regards,
Tomasz
