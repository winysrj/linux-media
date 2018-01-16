Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:43954 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbeAPQtP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 11:49:15 -0500
MIME-Version: 1.0
In-Reply-To: <20180116154403.muqorw74ggyhz7ze@paasikivi.fi.intel.com>
References: <20180116153105.3523235-1-arnd@arndb.de> <20180116154403.muqorw74ggyhz7ze@paasikivi.fi.intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 16 Jan 2018 17:49:13 +0100
Message-ID: <CAK8P3a2vhH+ApKi+S+cN20+N_umY5aJysbxzWpvF=Tvao33CSw@mail.gmail.com>
Subject: Re: [PATCH] [v2] media: s3c-camif: fix out-of-bounds array access
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES"
        <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 16, 2018 at 4:44 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:

>>               if (camif_mbus_formats[i] == mf->code)
>>                       break;
>>
>> +     if (i == ARRAY_SIZE(camif_mbus_formats))
>> +             mf->code = camif_mbus_formats[0];
>> +
>
> Either else here so that the line below is executed only if the condition
> is false, or assign i = 0 above. Otherwise you'll end up with a different
> off-by-one bug. :-)

Oops. Sent v3 now, thanks for the review.

      Arnd
