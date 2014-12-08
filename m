Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52675 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLHPKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 10:10:41 -0500
MIME-Version: 1.0
In-Reply-To: <1418038147-13221-5-git-send-email-josh.wu@atmel.com>
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
	<1418038147-13221-5-git-send-email-josh.wu@atmel.com>
Date: Mon, 8 Dec 2014 13:10:39 -0200
Message-ID: <CAOMZO5ASNUCz908esJ3iTQ6VEQGeNi-HOmqMOf12c633Q8pavw@mail.gmail.com>
Subject: Re: [PATCH 4/5] media: ov2640: add a master clock for sensor
From: Fabio Estevam <festevam@gmail.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 8, 2014 at 9:29 AM, Josh Wu <josh.wu@atmel.com> wrote:

> +       priv->master_clk = devm_clk_get(&client->dev, "xvclk");
> +       if (IS_ERR(priv->master_clk))
> +               return -EINVAL;

You should return PTR_ERR(priv->master_clk) instead.
