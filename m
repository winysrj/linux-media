Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:34272 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935747AbcKKWHH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 17:07:07 -0500
Received: by mail-vk0-f48.google.com with SMTP id x186so24006841vkd.1
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 14:07:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4483641.cSCuuSSr05@avalon>
References: <20161107201547.7537-1-philipp.zabel@gmail.com> <4483641.cSCuuSSr05@avalon>
From: Philipp Zabel <philipp.zabel@gmail.com>
Date: Fri, 11 Nov 2016 23:07:05 +0100
Message-ID: <CA+gwMcdN2OnVJ+CnC3htmbU2aU=d1Q=zH68KGvrQoM8w6fyhyg@mail.gmail.com>
Subject: Re: [PATCH] [media] uvcvideo: add support for Oculus Rift Sensor
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thibaut Girka <thib@sitedethib.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Nov 11, 2016 at 3:06 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Philipp,
>
> Thank you for the patch.
[...]
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> and applied to my tree, after fixing the conflict (see below).

Thank you, sorry for the inconvenience.
I got excited to share this patch with Thibaut and forgot to properly rebase it.

>>       /* Leap Motion Controller LM-010 */
>
> That's not in mainline, where does it come from ?

That is also from my local branch of quirky USB cameras.

regards
Philipp
