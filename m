Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48021 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaEZT1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:27:41 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so8470079wgh.29
        for <linux-media@vger.kernel.org>; Mon, 26 May 2014 12:27:40 -0700 (PDT)
Message-ID: <538395A8.3040700@gmail.com>
Date: Mon, 26 May 2014 21:27:36 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: Re: [PATCH 0/6] Fix the format field order value for progressive
 subdevs
References: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 05/26/2014 09:05 PM, Laurent Pinchart wrote:
> Hello,
>
> This patch set fixes five sensor drivers and one camera interface driver to
> return a format field order value set to V4L2_FIELD_NONE instead of
> V4L2_FIELD_ANY.
>
> V4L2_FIELD_ANY is used by applications to notify the driver that they don't
> care about the interlaced video field order. The value must never be returned
> by drivers, they must instead select a default field order they support.
>
> The six drivers fixed by this patch all forgot to initialize the field order,
> resulting in V4L2_FIELD_ANY (=0) being returned. As all those drivers support
> progressive video only, make them return V4L2_FIELD_NONE instead.
>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Sangwook Lee <sangwook.lee@linaro.org>
>
> Laurent Pinchart (6):
>    v4l: noon010p30: Return V4L2_FIELD_NONE from pad-level set format
>    v4l: s5k4ecgx: Return V4L2_FIELD_NONE from pad-level set format
>    v4l: s5k5baf: Return V4L2_FIELD_NONE from pad-level set format
>    v4l: s5k6a3: Return V4L2_FIELD_NONE from pad-level set format
>    v4l: smiapp: Return V4L2_FIELD_NONE from pad-level get/set format
>    v4l: s3c-camif: Return V4L2_FIELD_NONE from pad-level set format

For patches 1...4, 6:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

>   drivers/media/i2c/noon010pc30.c                  | 1 +
>   drivers/media/i2c/s5k4ecgx.c                     | 1 +
>   drivers/media/i2c/s5k5baf.c                      | 2 ++
>   drivers/media/i2c/s5k6a3.c                       | 1 +
>   drivers/media/i2c/smiapp/smiapp-core.c           | 3 +++
>   drivers/media/platform/s3c-camif/camif-capture.c | 2 ++
>   6 files changed, 10 insertions(+)

--
Regards,
Sylwester
