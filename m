Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:48185 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3A1Hqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 02:46:31 -0500
Received: by mail-ob0-f178.google.com with SMTP id wd20so1890278obb.37
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2013 23:46:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359351936-20618-1-git-send-email-vikas.sajjan@linaro.org>
References: <1359351936-20618-1-git-send-email-vikas.sajjan@linaro.org>
Date: Mon, 28 Jan 2013 13:16:31 +0530
Message-ID: <CAK9yfHzu505bJoF+3ef-t0-99T_DQPbdEWLs2xSL9APDWq9irQ@mail.gmail.com>
Subject: Re: [PATCH] Adds display-timing node parsing to exynos drm fimd as per
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, s.trumtrar@pengutronix.de,
	inki.dae@samsung.com, l.krishna@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikas,

This patch should be numbered 0/1 as it is not a patch in itself and
the subsequent patch should be 1/1 so as to show that these 2 together
form a series.

Also, your subject line seems to have been truncated.

On 28 January 2013 11:15, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> This patch adds display-timing node parsing to drm fimd, this depends on
> the display helper patchset at
> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33354.html
>
> It also adds pinctrl support for drm fimd.
>
> patch is based on branch "exynos-drm-next" at
> http://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
>
> It is tested on Exynos4412 board by applying dependent patches available at
> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33354.html
>
> Vikas Sajjan (1):
>   video: drm: exynos: Adds display-timing node parsing using video
>     helper function
>
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   35 ++++++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With warm regards,
Sachin
