Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:42709 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933470AbeFZUXX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 16:23:23 -0400
Received: by mail-vk0-f46.google.com with SMTP id s187-v6so10836663vke.9
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2018 13:23:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <89287fa5-a214-d86b-b991-84228b228280@nextdimension.cc>
References: <41857a8224110ed8044d5fbbdded8998129e5d7e.1520598094.git.mchehab@s-opensource.com>
 <89287fa5-a214-d86b-b991-84228b228280@nextdimension.cc>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Tue, 26 Jun 2018 16:23:21 -0400
Message-ID: <CAGoCfiwhHG+CYLp6DHZPYL2Cf+8aVK3XQrWFZ7brFB7QJvgriw@mail.gmail.com>
Subject: Re: [PATCH] media: em28xx: fix a regression with HVR-950
To: Brad Love <brad@nextdimension.cc>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2018 at 4:09 PM, Brad Love <brad@nextdimension.cc> wrote:
> Hi Mauro,
>
> It turns out this patch breaks DualHD multiple tuner capability. When
> alt mode is set in start_streaming it immediately kills the other tuners
> stream. Essentially both tuners cannot be used together when this is
> applied. I unfortunately don't have a HVR-950 to try and fix the
> original regression better. Can you please take another look at this?
> Until this is sorted, DualHD are effectively broken.

Yeah, because the Empia device uses the same USB Interface for both
endpoints, you need to have a reference count and only change the
alternate when the first endpoint is put into use and then only reset
the alternate back to zero when neither endpoint is in use.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
