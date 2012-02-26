Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37098 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2BZOQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 09:16:21 -0500
Received: by eaah12 with SMTP id h12so1821354eaa.19
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2012 06:16:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330226857-8651-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1330226857-8651-2-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Sun, 26 Feb 2012 11:16:19 -0300
Message-ID: <CAOMZO5B9=fGGWMxKfr+DfRmSHj4CExS5d5WTzXT_EoH2L=LG2A@mail.gmail.com>
Subject: Re: [PATCH 01/11] v4l: Add driver for Micron MT9M032 camera sensor
From: Fabio Estevam <festevam@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 26, 2012 at 12:27 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> +static int __init mt9m032_init(void)
> +{
> +       int rval;
> +
> +       rval = i2c_add_driver(&mt9m032_i2c_driver);
> +       if (rval)
> +               pr_err("%s: failed registering " MT9M032_NAME "\n", __func__);
> +
> +       return rval;
> +}
> +
> +static void mt9m032_exit(void)
> +{
> +       i2c_del_driver(&mt9m032_i2c_driver);
> +}
> +
> +module_init(mt9m032_init);
> +module_exit(mt9m032_exit);

module_i2c_driver could be used here instead.

> +
> +MODULE_AUTHOR("Martin Hostettler");

E-mail address missing.

Regards,

Fabio Estevam
