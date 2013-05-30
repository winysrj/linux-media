Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48153 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966927Ab3E3IHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 04:07:11 -0400
Received: by mail-wi0-f169.google.com with SMTP id hn14so5000902wib.4
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 01:07:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369825211-29770-19-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl> <1369825211-29770-19-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 30 May 2013 13:36:49 +0530
Message-ID: <CA+V-a8u7EKPhKvf54VGiLQ+GPS23H+_KcrO0FL0Wks5Db00_Zg@mail.gmail.com>
Subject: Re: [PATCHv1 18/38] media/i2c: remove g_chip_ident op.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Wed, May 29, 2013 at 4:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This is no longer needed since the core now handles this through DBG_G_CHIP_INFO.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> ---
>  drivers/media/i2c/adv7343.c              |   10 ---
>  drivers/media/i2c/ths7303.c              |   25 +------
>  drivers/media/i2c/tvp514x.c              |    1 -
>  drivers/media/i2c/tvp7002.c              |   34 ----------
For the above,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
