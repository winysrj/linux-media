Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36144 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbbCRBeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 21:34:12 -0400
MIME-Version: 1.0
In-Reply-To: <1426175114-14876-3-git-send-email-j.anaszewski@samsung.com>
References: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com> <1426175114-14876-3-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 17 Mar 2015 18:33:51 -0700
Message-ID: <CAK5ve-JrWXr08vfaERsU5jDqnW9vu-dOCmWqMfs4D_e8cyqgEQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v13 02/13] dt-binding: leds: Add common LED DT
 bindings macros
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2015 at 8:45 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> Add macros for defining boost mode and trigger type properties
> of flash LED devices.
>
Applied, thanks,
-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  include/dt-bindings/leds/common.h |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 include/dt-bindings/leds/common.h
>
> diff --git a/include/dt-bindings/leds/common.h b/include/dt-bindings/leds/common.h
> new file mode 100644
> index 0000000..79fcef7
> --- /dev/null
> +++ b/include/dt-bindings/leds/common.h
> @@ -0,0 +1,21 @@
> +/*
> + * This header provides macros for the common LEDs device tree bindings.
> + *
> + * Copyright (C) 2015, Samsung Electronics Co., Ltd.
> + *
> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + */
> +
> +#ifndef __DT_BINDINGS_LEDS_H__
> +#define __DT_BINDINGS_LEDS_H
> +
> +/* External trigger type */
> +#define LEDS_TRIG_TYPE_EDGE    0
> +#define LEDS_TRIG_TYPE_LEVEL   1
> +
> +/* Boost modes */
> +#define LEDS_BOOST_OFF         0
> +#define LEDS_BOOST_ADAPTIVE    1
> +#define LEDS_BOOST_FIXED       2
> +
> +#endif /* __DT_BINDINGS_LEDS_H */
> --
> 1.7.9.5
>
