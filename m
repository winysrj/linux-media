Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39782 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934057AbdLSHtq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 02:49:46 -0500
Received: by mail-wm0-f67.google.com with SMTP id i11so1774891wmf.4
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 23:49:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1513654553-27097-1-git-send-email-satendra.t@samsung.com>
References: <CGME20171219033612epcas5p41cb7d88255e0677d00c7e79572d27bc7@epcas5p4.samsung.com>
 <1513654553-27097-1-git-send-email-satendra.t@samsung.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Tue, 19 Dec 2017 08:49:05 +0100
Message-ID: <CAOFm3uHvVH4YDKkXtaBmRSotsB0SCzhjWz+8K9xA+BOa0xVRiA@mail.gmail.com>
Subject: Re: [PATCH v1] media: videobuf2: Add new uAPI for DVB streaming I/O
To: Satendra Singh Thakur <satendra.t@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, madhur.verma@samsung.com,
        hemanshu.s@samsung.com, sst2005@gmail.com,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Satendra,

On Tue, Dec 19, 2017 at 4:35 AM, Satendra Singh Thakur
<satendra.t@samsung.com> wrote:

<snip>

> --- /dev/null
> +++ b/drivers/media/dvb-core/dvb_vb2.c
> @@ -0,0 +1,422 @@
> +/*
> + * dvb-vb2.c - dvb-vb2
> + *
> + * Copyright (C) 2015 Samsung Electronics
> + *
> + * Author: jh1009.sung@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */

Would you mind using the new SPDX tags documented in Thomas patch set
[1] rather than this fine but longer legalese?

And if you could spread the word to others in your team this would be very nice.
See also this fine article posted by Mauro on the Samsung Open Source
Group Blog [2]
Thank you!

[1] https://lkml.org/lkml/2017/12/4/934
[2] https://blogs.s-osg.org/linux-kernel-license-practices-revisited-spdx/
-- 
Cordially
Philippe Ombredanne
