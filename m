Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37115 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdHQNtw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:49:52 -0400
Received: by mail-it0-f45.google.com with SMTP id 76so2279179ith.0
        for <linux-media@vger.kernel.org>; Thu, 17 Aug 2017 06:49:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1502975140.2927.1.camel@pengutronix.de>
References: <1481643559-19666-1-git-send-email-javier@osg.samsung.com> <1502975140.2927.1.camel@pengutronix.de>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Thu, 17 Aug 2017 15:49:51 +0200
Message-ID: <CABxcv=k8T29Lz6-7gX=Bi7jt__GpBmrPt4bca-MmpcYjoXqvwA@mail.gmail.com>
Subject: Re: [RFT PATCH] [media] partial revert of "[media] tvp5150: add HW
 input connectors support"
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Philipp,

On Thu, Aug 17, 2017 at 3:05 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi,
>
> On Tue, 2016-12-13 at 12:39 -0300, Javier Martinez Canillas wrote:
>> Commit f7b4b54e6364 ("[media] tvp5150: add HW input connectors support")
>> added input signals support for the tvp5150, but the approach was found
>> to be incorrect so the corresponding DT binding commit 82c2ffeb217a
>> ("[media] tvp5150: document input connectors DT bindings") was reverted.
>>
>> This left the driver with an undocumented (and wrong) DT parsing logic,
>> so lets get rid of this code as well until the input connectors support
>> is implemented properly.
>>
>> It's a partial revert due other patches added on top of mentioned commit
>> not allowing the commit to be reverted cleanly anymore. But all the code
>> related to the DT parsing logic and input entities creation are removed.
>>
>> > Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>
> what is the state of this patch? Was it forgotten or was the revert
> deemed unnecessary?
>

I think that was just forgotten. That code still needs to be reverted
since the DT patch was also reverted.

Albeit the code is harmless since should be a no-op if a connectors DT
node isn't found.

> regards
> Philipp
>

Best regards,
Javier
