Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:37277 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbeIIOEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 10:04:16 -0400
Subject: Fwd: Re: [PATCH] vicodec: change codec license to LGPL
References: <CAPDgk_Jc91zZKZ4tHZJE-R7BUrbeNtfDhbd23muhSrYr7ko=1w@mail.gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c28000c3-5260-814d-f293-dd536777c7ab@xs4all.nl>
Date: Sun, 9 Sep 2018 11:15:10 +0200
MIME-Version: 1.0
In-Reply-To: <CAPDgk_Jc91zZKZ4tHZJE-R7BUrbeNtfDhbd23muhSrYr7ko=1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forwarding this to the linux-media mailinglist so Tom's Signed-off-by is archived.

His original email was blocked by the mailinglist since it contained HTML markup.

Regards,

	Hans


-------- Forwarded Message --------
Subject: 	Re: [PATCH] vicodec: change codec license to LGPL
Date: 	Mon, 3 Sep 2018 09:52:37 +0200
From: 	Tom aan de Wiel <tom.aandewiel@gmail.com>
To: 	Hans Verkuil <hverkuil@xs4all.nl>
CC: 	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Linux Media Mailing List <linux-media@vger.kernel.org>, Nicolas Dufresne
<nicolas.dufresne@collabora.com>



Hi!

For me both GPL and LGPL are ok, I'm not sure as to what is the best way to make the change, but I'll be fine with either way:

Signed-off-by: Tom aan de Wiel <tom.aandewiel@gmail.com>

Kind regards,

Tom

man. 3. sep. 2018 kl. 09:32 skrev Hans Verkuil <hverkuil@xs4all.nl <mailto:hverkuil@xs4all.nl>>:

    On 09/03/2018 03:17 AM, Mauro Carvalho Chehab wrote:
    > Em Sun, 2 Sep 2018 12:37:04 +0200
    > Hans Verkuil <hverkuil@xs4all.nl <mailto:hverkuil@xs4all.nl>> escreveu:
    >
    >> The FWHT codec can also be used by userspace utilities and libraries, but
    >> since the current license is GPL and not LGPL it is not possible to include
    >> it in e.g. gstreamer, since LGPL is required for that.
    >>
    >> Change the license of these four files to LGPL.
    >>
    >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com <mailto:hans.verkuil@cisco.com>>
    >> ---
    >> Tom, if you agree to this, can you give your 'Signed-off-by' line? I cannot
    >> make this change for the codec-fwht.c/h files without it. I think this change
    >> makes sense.
    >>
    >> Regards,
    >>
    >>      Hans
    >> ---
    >> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
    >> index 47939160560e..36656031b295 100644
    >> --- a/drivers/media/platform/vicodec/codec-fwht.c
    >> +++ b/drivers/media/platform/vicodec/codec-fwht.c
    >> @@ -1,4 +1,4 @@
    >> -// SPDX-License-Identifier: GPL-2.0+
    >> +// SPDX-License-Identifier: LGPL-2.1+
    >
    > There aren't much C files under LGPL at the Kernel. Yeah, I know it
    > is compatible with GPL-2.0+, but I would prefer it the tag would
    > be, instead:
    >
    > // SPDX-License-Identifier: GPL-2.0+ OR LGPL-2.1+
    >
    > as this makes easier if one uses some software to parse the Kernel
    > tree.
    >
    > (same applies to the other files).

    I don't see the point. Grepping for this shows nobody else doing that.
    LGPL is one of the preferred licenses (LICENSES/preferred/), so I don't
    see what you gain by supporting both.

    I don't see why this would make it easier parsing the kernel, since
    that's what the SPDX tag is for.

    Regards,

            Hans

    >
    > Regards,
    > Mauro
    >
    >>  /*
    >>   * Copyright 2016 Tom aan de Wiel
    >>   * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
    >> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
    >> index 1f9e47331197..3e9391fec5fe 100644
    >> --- a/drivers/media/platform/vicodec/codec-fwht.h
    >> +++ b/drivers/media/platform/vicodec/codec-fwht.h
    >> @@ -1,4 +1,4 @@
    >> -/* SPDX-License-Identifier: GPL-2.0+ */
    >> +/* SPDX-License-Identifier: LGPL-2.1+ */
    >>  /*
    >>   * Copyright 2016 Tom aan de Wiel
    >>   * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
    >> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
    >> index cfcf84b8574d..6b06aa382cbb 100644
    >> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
    >> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
    >> @@ -1,4 +1,4 @@
    >> -// SPDX-License-Identifier: GPL-2.0
    >> +// SPDX-License-Identifier: LGPL-2.1
    >>  /*
    >>   * A V4L2 frontend for the FWHT codec
    >>   *
    >> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
    >> index 7794c186d905..95d1756556db 100644
    >> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
    >> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
    >> @@ -1,4 +1,4 @@
    >> -/* SPDX-License-Identifier: GPL-2.0 */
    >> +/* SPDX-License-Identifier: LGPL-2.1 */
    >>  /*
    >>   * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
    >>   */
    >
    >
    >
    > Thanks,
    > Mauro
    >
