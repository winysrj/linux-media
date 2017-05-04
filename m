Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33260 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdEDP6o (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 11:58:44 -0400
Received: by mail-io0-f193.google.com with SMTP id l196so4672786ioe.0
        for <linux-media@vger.kernel.org>; Thu, 04 May 2017 08:58:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493912180.2381.35.camel@pengutronix.de>
References: <20170504152017.3696-1-p.zabel@pengutronix.de> <CAK8P3a00XGeiYXR28aM4EXcMLhSgLdnTDJwTKNk8qKO+B2TXMg@mail.gmail.com>
 <1493912180.2381.35.camel@pengutronix.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 4 May 2017 17:58:42 +0200
Message-ID: <CAK8P3a2SpN1+zZeB3UEtU2dunR5Vs2no6=LBbCv9_5c9o4-qpg@mail.gmail.com>
Subject: Re: [PATCH] [media] tc358743: fix register i2c_rd/wr function fix
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 4, 2017 at 5:36 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Arnd,
>
> On Thu, 2017-05-04 at 17:24 +0200, Arnd Bergmann wrote:
>> On Thu, May 4, 2017 at 5:20 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>> > The below mentioned fix contains a small but severe bug,
>> > fix it to make the driver work again.
>> >
>> > Fixes: 3538aa6ecfb2 ("[media] tc358743: fix register i2c_rd/wr functions")
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>> > ---
>>
>> Cc: stable@vger.kernel.org # v4.11
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Sorry about the typo
>
> Thanks, the original fix currently is only in the media-tree master
> branch. I don't see any indication that it is queued for
> stable/linux-4.11.y though. Should it be?

Sorry, my mistake (again). I looked it up wrong.

      Arnd
