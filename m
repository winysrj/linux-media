Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36574 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbcB0BG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 20:06:58 -0500
Received: by mail-ig0-f179.google.com with SMTP id xg9so45348707igb.1
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2016 17:06:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456485695-15412-1-git-send-email-p.zabel@pengutronix.de>
References: <1456485695-15412-1-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 26 Feb 2016 22:06:57 -0300
Message-ID: <CAOMZO5BSiO3NXKig-hAPLSXyPLNav+r7y0otr5EmNupO3ykR6A@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: fix error path in case of missing pdata on
 non-DT platform
From: Fabio Estevam <festevam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	linux-media <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 26, 2016 at 8:21 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> If we bail out this early, v4l2_device_register() has not been called
> yet, so no need to call v4l2_device_unregister().
>
> Fixes: b7bd660a51f0 ("[media] coda: Call v4l2_device_unregister() from a single location")
> Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
