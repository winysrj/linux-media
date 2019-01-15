Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D79BC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 124C520657
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfAOOot (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:44:49 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36157 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727626AbfAOOot (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:44:49 -0500
Received: from [IPv6:2001:983:e9a7:1:415f:b492:6ed4:23a7] ([IPv6:2001:983:e9a7:1:415f:b492:6ed4:23a7])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jPxMg8NBkBDyIjPxNgxocr; Tue, 15 Jan 2019 15:44:47 +0100
Subject: Re: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc:     Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20190115093853.15495-1-andr2000@gmail.com>
 <20190115093853.15495-2-andr2000@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <393f824d-e543-476c-777f-402bcc1c0bcb@xs4all.nl>
Date:   Tue, 15 Jan 2019 15:44:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190115093853.15495-2-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNrbnBzirGivXXovkDhdzMwDc26v8/cEIAROuz2dA9lIG45vTUkilSDzuvvqTl3SknV0tEUlRG0AO0keeNgMJD/tUwDwi8tw+/WZLwrYi43D/cJYoFgZ
 +Sgn93hk/tsj+KQEwLhKOjhizFXtWO02wpF+uYqQgzr0mBpefg8umFFrFvbTp77ezsg0VlLUBmQU/vBYnJVOIfKb4Bk5RYhYq8A+SpvI9EuNUgN1vLgedwck
 sfdNxPQVVVo48isr6JSmO17JQ7xzRNTXSO3sOmBTb7E1pKI4nZCYFPnxdT6ORIlmNrIYQFDZIzhwWEpbYTtz/7VTTVL9zADfS/aLiY9pX4PHYNtlug37xeyP
 U9prHhUBiWU5z097mo7qOP+9JHC3L7bMK+X49G8Z8VoH7mwSnU38egJvNkoWajJqB7R71KPOdACl1kVqy3OxjFpewQc4Mk/K61qTEACq4i1Q06vSMxSR1jgA
 i/I+XCYdH9fBkBpVVf1TpNmNRfuAOAgzuhIUgKSMREM6h4K49iy6LhaUoRAA/t2XxnxMPaOqE1s09L8XvRtipEIBacUlvi4sAH0UxW7y7iDV6bi+/t5BpkD1
 rgVK9ICIPpB97npL1gVfXJF2
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Oleksandr,

Just two remaining comments:

On 1/15/19 10:38 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> This is the ABI for the two halves of a para-virtualized
> camera driver which extends Xen's reach multimedia capabilities even
> farther enabling it for video conferencing, In-Vehicle Infotainment,
> high definition maps etc.
> 
> The initial goal is to support most needed functionality with the
> final idea to make it possible to extend the protocol if need be:
> 
> 1. Provide means for base virtual device configuration:
>  - pixel formats
>  - resolutions
>  - frame rates
> 2. Support basic camera controls:
>  - contrast
>  - brightness
>  - hue
>  - saturation
> 3. Support streaming control
> 
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> ---
>  xen/include/public/io/cameraif.h | 1364 ++++++++++++++++++++++++++++++
>  1 file changed, 1364 insertions(+)
>  create mode 100644 xen/include/public/io/cameraif.h
> 
> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
> new file mode 100644
> index 000000000000..246eb2457f40
> --- /dev/null
> +++ b/xen/include/public/io/cameraif.h
> @@ -0,0 +1,1364 @@

<snip>

> +/*
> + ******************************************************************************
> + *                                 EVENT CODES
> + ******************************************************************************
> + */
> +#define XENCAMERA_EVT_FRAME_AVAIL      0x00
> +#define XENCAMERA_EVT_CTRL_CHANGE      0x01
> +
> +/* Resolution has changed. */
> +#define XENCAMERA_EVT_CFG_FLG_RESOL    (1 << 0)

I think this flag is a left-over from v2 and should be removed.

<snip>

> + * Request number of buffers to be used:
> + *         0                1                 2               3        octet
> + * +----------------+----------------+----------------+----------------+
> + * |               id                | _OP_BUF_REQUEST|   reserved     | 4
> + * +----------------+----------------+----------------+----------------+
> + * |                             reserved                              | 8
> + * +----------------+----------------+----------------+----------------+
> + * |    num_bufs    |                     reserved                     | 12
> + * +----------------+----------------+----------------+----------------+
> + * |                             reserved                              | 16
> + * +----------------+----------------+----------------+----------------+
> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
> + * +----------------+----------------+----------------+----------------+
> + * |                             reserved                              | 64
> + * +----------------+----------------+----------------+----------------+
> + *
> + * num_bufs - uint8_t, desired number of buffers to be used. This is
> + *   limited to the value configured in XenStore.max-buffers.
> + *   Passing zero num_bufs in this request (after streaming has stopped
> + *   and all buffers destroyed) unblocks camera configuration changes.

I think the phrase 'unblocks camera configuration changes' is confusing.

In v3 this sentence came after the third note below, and so it made sense
in that context, but now the order has been reversed and it became hard to
understand.

I'm not sure what the best approach is to fix this. One option is to remove
the third note and integrate it somehow in the sentence above. Or perhaps
do away with the 'notes' at all and just write a more extensive documentation
for this op. I leave that up to you.

> + *
> + * See response format for this request.
> + *
> + * Notes:
> + *  - frontend must check the corresponding response in order to see
> + *    if the values reported back by the backend do match the desired ones
> + *    and can be accepted.
> + *  - frontend may send multiple XENCAMERA_OP_BUF_REQUEST requests before
> + *    sending XENCAMERA_OP_STREAM_START request to update or tune the
> + *    configuration.
> + *  - after this request camera configuration cannot be changed, unless

camera configuration -> the camera configuration

> + *    streaming is stopped and buffers destroyed
> + */

Regards,

	Hans
