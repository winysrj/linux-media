Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41975 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751703AbdHOLfE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:35:04 -0400
Message-ID: <1502796900.2342.1.camel@pengutronix.de>
Subject: Re: [PATCH 1/3] [media] coda: constify platform_device_id
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, mchehab@kernel.org,
        prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Tue, 15 Aug 2017 13:35:00 +0200
In-Reply-To: <1502796222-9681-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502796222-9681-1-git-send-email-arvind.yadav.cs@gmail.com>
         <1502796222-9681-2-git-send-email-arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-08-15 at 16:53 +0530, Arvind Yadav wrote:
> platform_device_id are not supposed to change at runtime. All
> functions
> working with platform_device_id provided by <linux/platform_device.h>
> work with const platform_device_id. So mark the non-const structs as
> const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp
