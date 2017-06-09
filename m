Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:36152 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdFIBBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 21:01:46 -0400
Received: by mail-ot0-f179.google.com with SMTP id i31so31903320ota.3
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 18:01:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f305d0fc-b5cd-591a-1d95-7ae66bfa72ec@xs4all.nl>
References: <20170606233741.26718-1-khilman@baylibre.com> <20170606233741.26718-3-khilman@baylibre.com>
 <f305d0fc-b5cd-591a-1d95-7ae66bfa72ec@xs4all.nl>
From: Kevin Hilman <khilman@baylibre.com>
Date: Thu, 8 Jun 2017 18:01:45 -0700
Message-ID: <CAOi56cV18wJce8hzTk0r0YKvr4vzLi8QDwu01Az1rae-9=wMRg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] [media] davinci: vpif_capture: get subdevs from DT
 when available
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 7, 2017 at 11:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 07/06/17 01:37, Kevin Hilman wrote:
>> Enable  getting of subdevs from DT ports and endpoints.
>>
>> The _get_pdata() function was larely inspired by (i.e. stolen from)
>> am437x-vpfe.c
>>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c | 126 +++++++++++++++++++++++++-
>>  drivers/media/platform/davinci/vpif_display.c |   5 +
>>  include/media/davinci/vpif_types.h            |   9 +-
>>  3 files changed, 134 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index fc5c7622660c..b9d927d1e5a8 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -22,6 +22,8 @@
>>  #include <linux/slab.h>
>>
>>  #include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-of.h>
>
> v4l2-of.h no longer exists, so this v2 is wrong. Unfortunately this patch has
> already been merged in our master. I'm not sure how this could have slipped past
> both my and Mauro's patch testing (and yours, for that matter).

I have that file in the various trees I tested agains.

> Can you fix this and post a patch on top of the media master that makes this
> compile again?

Sorry for the dumb question, but what tree are you referring to?  I
tried the master branch of both [1] and [2] and both seem to have that
include.

Kevin

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
[2] git://linuxtv.org/mchehab/media-next.git
