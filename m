Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:46248 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751973AbdJZCt7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 22:49:59 -0400
Received: by mail-yw0-f196.google.com with SMTP id t71so1763984ywc.3
        for <linux-media@vger.kernel.org>; Wed, 25 Oct 2017 19:49:59 -0700 (PDT)
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com. [209.85.161.171])
        by smtp.gmail.com with ESMTPSA id i6sm2080737ywa.62.2017.10.25.19.49.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Oct 2017 19:49:58 -0700 (PDT)
Received: by mail-yw0-f171.google.com with SMTP id k11so1774471ywh.1
        for <linux-media@vger.kernel.org>; Wed, 25 Oct 2017 19:49:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171019144343.2j34twk6dvodan2o@valkosipuli.retiisi.org.uk>
References: <20170928095027.127173-1-acourbot@chromium.org> <20171019144343.2j34twk6dvodan2o@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 26 Oct 2017 11:49:36 +0900
Message-ID: <CAAFQd5BmeWzwcDcRwP6r7eTvK=JjdZC8X96WqwfUN0KqQeOOTw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] V4L2 Jobs API WIP
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, Oct 19, 2017 at 11:43 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Alexandre,
>
> On Thu, Sep 28, 2017 at 06:50:18PM +0900, Alexandre Courbot wrote:
>> Hi everyone,
>>
[snip]
>
> Still it shouldn't be forgotten that if the framework is geared towards
> helping drivers "running one job at a time" the scope will be limited to
> memory-to-memory devices; streaming devices, e.g. all kinds of cameras have
> multiple requests being processed simultaneously (or frames are bound to be
> lost, something we can't allow to happen due to framework design).

I'd be interested in some further explanation of these multiple
requests being processed simultaneously and why they couldn't be
included in a single job.

Best regards,
Tomasz
