Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35389 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbDPKIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 06:08:04 -0400
Received: by obbfy7 with SMTP id fy7so37068651obb.2
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 03:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428574888-46407-2-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
	<1428574888-46407-2-git-send-email-hverkuil@xs4all.nl>
Date: Thu, 16 Apr 2015 18:08:03 +0800
Message-ID: <CAHG8p1A7yiT78t+mNWp4SjD8HAvBmAwr4G0xKV263s5NhK12Rg@mail.gmail.com>
Subject: Re: [PATCH 1/7] v4l2: replace enum_mbus_fmt by enum_mbus_code
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-04-09 18:21 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Replace all calls to the enum_mbus_fmt video op by the pad
> enum_mbus_code op and remove the duplicate video op.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---

>  drivers/media/i2c/adv7183.c                        | 15 ++++++++----
>  drivers/media/i2c/vs6624.c                         | 15 ++++++++----
>  drivers/media/platform/blackfin/bfin_capture.c     | 17 +++++++++-----

For these patches,
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
