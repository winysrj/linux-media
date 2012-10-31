Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53145 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935556Ab2JaNYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 09:24:07 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1393288oag.19
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2012 06:24:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121031131652.GM1641@pengutronix.de>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
	<20121031095632.536d9362@infradead.org>
	<20121031131652.GM1641@pengutronix.de>
Date: Wed, 31 Oct 2012 11:24:06 -0200
Message-ID: <CAOMZO5CLxM41LYoLmPbfzSTF85Zk4B5SqHeVbGU4WjEOXw0eyg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	g.liakhovetski@gmx.de, kernel@pengutronix.de, gcembed@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Wed, Oct 31, 2012 at 11:16 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Quoting yourself:
>
>> Forgot to comment: as patch 2 relies on this change, the better, IMHO, is
>> to send both via the same tree. If you decide to do so, please get arm
>> maintainer's ack, instead, and we can merge both via my tree.
>
> That's why Fabio resent these patches with my Ack. You are free to take
> these.

I have just realized that this patch (1/2) will not apply against
media tree because it does not have commit 27b76486a3 (media:
mx2_camera: remove cpu_is_xxx by using platform_device_id), which
changes from mx2_camera.0 to imx27-camera.0.

So it seems to be better to merge this via arm tree to avoid such conflict.

Regards,

Fabio Estevam
