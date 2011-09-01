Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49520 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab1IAQOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 12:14:24 -0400
Received: by ywf7 with SMTP id 7so1505937ywf.19
        for <linux-media@vger.kernel.org>; Thu, 01 Sep 2011 09:14:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5FA1B3.9050005@mlbassoc.com>
References: <4E56734A.3080001@mlbassoc.com>
	<CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
	<4E5F7FB3.8020405@mlbassoc.com>
	<201109011526.29507.laurent.pinchart@ideasonboard.com>
	<4E5FA1B3.9050005@mlbassoc.com>
Date: Thu, 1 Sep 2011 18:14:20 +0200
Message-ID: <CA+2YH7uT0ZGV9Drc-8V1vRB0o3gyKhyX8=f+Crsn7vtDGpem=Q@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 1, 2011 at 5:16 PM, Gary Thomas <gary@mlbassoc.com> wrote:
>
> - entity 16: tvp5150m1 2-005c (1 pad, 1 link)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev8
>        pad0: Output [unknown 720x480 (1,1)/720x480]
>                -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]
>
> Ideas where to look for the 'unknown' mode?

I didn't notice that, if you are using UYVY8_2X8 the reason is in
media-ctl main.c:

{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },

You can add a line like:

{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },

recompile and it should work, i'll try it now.

Enrico
