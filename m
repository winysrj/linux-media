Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33592 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbcCNSTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 14:19:50 -0400
Received: by mail-io0-f195.google.com with SMTP id g203so18737090iof.0
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2016 11:19:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1457969017-4088-3-git-send-email-l.stach@pengutronix.de>
References: <1457969017-4088-1-git-send-email-l.stach@pengutronix.de>
	<1457969017-4088-3-git-send-email-l.stach@pengutronix.de>
Date: Mon, 14 Mar 2016 15:19:49 -0300
Message-ID: <CABxcv==SYJGw76U7HRn_SsNrTHQa+Ewp0jio+Z94qEC5Fd2WYQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] [media] tvp5150: determine BT.656 or YUV 4:2:2
 mode from device tree
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	patchwork-lst@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Lucas,

On Mon, Mar 14, 2016 at 12:23 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
>
> By looking at the endpoint flags, it can be determined whether the link
> should be of V4L2_MBUS_PARALLEL or V4L2_MBUS_BT656 type. Disable the
> dedicated HSYNC/VSYNC outputs in BT.656 mode.
>
> For devices that are not instantiated through DT the current behavior
> is preserved.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> ---

Similar to Mauro's comment on patch 2/9, the current driver already
supports configuring the interface output format using DT.

Best regards,
Javier
