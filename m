Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36807 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbESQnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 12:43:42 -0400
Received: by lagv1 with SMTP id v1so33743207lag.3
        for <linux-media@vger.kernel.org>; Tue, 19 May 2015 09:43:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da8b930d38345df38bac8971f570f6ffdff3b8b6.1431642235.git.mchehab@osg.samsung.com>
References: <554A00F2.5000007@bmw-carit.de> <da8b930d38345df38bac8971f570f6ffdff3b8b6.1431642235.git.mchehab@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 19 May 2015 17:43:09 +0100
Message-ID: <CA+V-a8v6j+b0XKAiB-Vy6Yy9An1Q-D-pcBh-cFhMo5hDxTm7=w@mail.gmail.com>
Subject: Re: [PATCH] ov2659: Don't depend on subdev API
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On Thu, May 14, 2015 at 11:27 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> The subdev API is optional. No driver should depend on it.
>
> Avoid compilation breakages if subdev API is not selected:
>
> drivers/media/i2c/ov2659.c: In function ‘ov2659_get_fmt’:
> drivers/media/i2c/ov2659.c:1054:3: error: implicit declaration of function ‘v4l2_subdev_get_try_format’ [-Werror=implicit-function-declaration]
>    mf = v4l2_subdev_get_try_format(sd, cfg, 0);
>    ^
> drivers/media/i2c/ov2659.c:1054:6: warning: assignment makes pointer from integer without a cast
>    mf = v4l2_subdev_get_try_format(sd, cfg, 0);
>       ^
> drivers/media/i2c/ov2659.c: In function ‘ov2659_set_fmt’:
> drivers/media/i2c/ov2659.c:1129:6: warning: assignment makes pointer from integer without a cast
>    mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
>       ^
> drivers/media/i2c/ov2659.c: In function ‘ov2659_open’:
> drivers/media/i2c/ov2659.c:1264:38: error: ‘struct v4l2_subdev_fh’ has no member named ‘pad’
>      v4l2_subdev_get_try_format(sd, fh->pad, 0);
>                                       ^
>
> Compile-tested only.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
