Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35759 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbbDPUuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 16:50:50 -0400
Received: by lbbuc2 with SMTP id uc2so68135767lbb.2
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 13:50:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428574888-46407-3-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl> <1428574888-46407-3-git-send-email-hverkuil@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 16 Apr 2015 21:50:18 +0100
Message-ID: <CA+V-a8uR3J=O7vKqYLV5PhwLX_z2D0NC+bWiUXHfxmDMD+AEWQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] v4l2: replace video op g_mbus_fmt by pad op get_fmt
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Thu, Apr 9, 2015 at 11:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The g_mbus_fmt video op is a duplicate of the pad op. Replace all uses
> by the get_fmt pad op and remove the video op.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---
[Snip]
>  drivers/media/i2c/tvp514x.c                        | 35 ++------------
>  drivers/media/i2c/tvp7002.c                        | 28 -----------
>  drivers/media/platform/am437x/am437x-vpfe.c        |  6 +--
>  drivers/media/platform/davinci/vpfe_capture.c      | 19 ++++----

For the above,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
