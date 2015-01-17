Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:50990 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbbAQTym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 14:54:42 -0500
Received: by mail-la0-f48.google.com with SMTP id gf13so23560013lab.7
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2015 11:54:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1402178205-22697-43-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	<1402178205-22697-43-git-send-email-steve_longerbeam@mentor.com>
Date: Sat, 17 Jan 2015 17:54:40 -0200
Message-ID: <CAOMZO5BuNY4WE78tELVtk9iVi2fB+mNnBFC3gJ0CSsBUVT8KhQ@mail.gmail.com>
Subject: Re: [PATCH 42/43] media: imx6: Add support for ADV7180 Video Decoder
From: Fabio Estevam <festevam@gmail.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Sat, Jun 7, 2014 at 6:56 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> This driver is based on adv7180.c from Freescale imx_3.10.17_1.0.0_beta
> branch, modified heavily for code cleanup and converted from int-device
> to subdev.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx6/capture/Kconfig   |    7 +
>  drivers/staging/media/imx6/capture/Makefile  |    1 +
>  drivers/staging/media/imx6/capture/adv7180.c | 1298 ++++++++++++++++++++++++++

We should use drivers/media/i2c/adv7180.c instead, right?
