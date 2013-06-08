Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:56220 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3FHNY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jun 2013 09:24:59 -0400
Received: by mail-vb0-f41.google.com with SMTP id p13so2040405vbe.14
        for <linux-media@vger.kernel.org>; Sat, 08 Jun 2013 06:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DQyeUYVdK0X0OsG51MkGjbN8d_51DW_zhVBZOHLptOQw@mail.gmail.com>
References: <1370678120-24278-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CAOMZO5DQyeUYVdK0X0OsG51MkGjbN8d_51DW_zhVBZOHLptOQw@mail.gmail.com>
Date: Sat, 8 Jun 2013 10:24:58 -0300
Message-ID: <CAOMZO5DPkcJpHfKGUBA7uq1qjqPmz-dgBJPWG9EvkBxQG9wQvQ@mail.gmail.com>
Subject: Re: [PATCH] mt9p031: Use bulk regulator API
From: Fabio Estevam <festevam@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 8, 2013 at 10:20 AM, Fabio Estevam <festevam@gmail.com> wrote:
> On Sat, Jun 8, 2013 at 4:55 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>
>> -       if (IS_ERR(mt9p031->vaa) || IS_ERR(mt9p031->vdd) ||
>> -           IS_ERR(mt9p031->vdd_io)) {
>> +       ret = devm_regulator_bulk_get(&client->dev, 3, mt9p031->regulators);

and you could use ARRAY_SIZE(mt9p031->regulators) instead of the hardcoded '3'.
