Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:60583 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3FHNUm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jun 2013 09:20:42 -0400
Received: by mail-ve0-f170.google.com with SMTP id 14so3803516vea.29
        for <linux-media@vger.kernel.org>; Sat, 08 Jun 2013 06:20:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370678120-24278-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1370678120-24278-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Sat, 8 Jun 2013 10:20:42 -0300
Message-ID: <CAOMZO5DQyeUYVdK0X0OsG51MkGjbN8d_51DW_zhVBZOHLptOQw@mail.gmail.com>
Subject: Re: [PATCH] mt9p031: Use bulk regulator API
From: Fabio Estevam <festevam@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 8, 2013 at 4:55 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> -       if (IS_ERR(mt9p031->vaa) || IS_ERR(mt9p031->vdd) ||
> -           IS_ERR(mt9p031->vdd_io)) {
> +       ret = devm_regulator_bulk_get(&client->dev, 3, mt9p031->regulators);
> +       if (ret < 0) {
>                 dev_err(&client->dev, "Unable to get regulators\n");
>                 return -ENODEV;

You should do a 'return ret' here instead.
