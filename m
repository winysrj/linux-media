Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38716 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1AIBO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 20:14:27 -0500
Received: by vws16 with SMTP id 16so7673677vws.19
        for <linux-media@vger.kernel.org>; Sat, 08 Jan 2011 17:14:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294407540-23477-1-git-send-email-manjunath.hadli@ti.com>
References: <1294407540-23477-1-git-send-email-manjunath.hadli@ti.com>
Date: Sun, 9 Jan 2011 02:14:26 +0100
Message-ID: <AANLkTikopOfTeVvAHWvMu8Mv16YgrwQnP_9zx1+gzS=N@mail.gmail.com>
Subject: Re: [PATCH v12 2/8] davinci vpbe: VPBE display driver
From: =?UTF-8?Q?Bj=C3=B8rn_Forsman?= <bjorn.forsman@gmail.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-arm-kernel@listinfradead.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 7 January 2011 14:39, Manjunath Hadli <manjunath.hadli@ti.com> wrote:
> This patch implements the core functionality of the dislay driver,
> mainly controlling the VENC and other encoders, and acting as
> the one point interface for the main V4L2 driver. This implements
> the core of each of the V4L2 IOCTLs.
>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/davinci/vpbe.c |  826 ++++++++++++++++++++++++++++++++++++
>  include/media/davinci/vpbe.h       |  185 ++++++++
>  2 files changed, 1011 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpbe.c
>  create mode 100644 include/media/davinci/vpbe.h
>
> diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/video/davinci/vpbe.c

[snip]

> +module_param(def_output, charp, S_IRUGO);
> +module_param(def_mode, charp, S_IRUGO);
> +module_param(debug, int, 0644);
> +
> +MODULE_PARM_DESC(def_output, "vpbe output name (default:Composite)");
> +MODULE_PARM_DESC(ef_mode, "vpbe output mode name (default:ntsc");

Typo: "ef_mode" should be "def_mode". Right?

Best regards,
Bjørn Forsman
