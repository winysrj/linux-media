Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:55861 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbbBPQtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 11:49:17 -0500
MIME-Version: 1.0
In-Reply-To: <1423560696-12304-4-git-send-email-josh.wu@atmel.com>
References: <1423560696-12304-1-git-send-email-josh.wu@atmel.com> <1423560696-12304-4-git-send-email-josh.wu@atmel.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 16 Feb 2015 16:48:44 +0000
Message-ID: <CA+V-a8vkd2Q714s=o9WZZvPWJQATp=6POb8VYdSgarKxxEKqyQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] media: ov2640: add primary dt support
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thanks for the patch.

On Tue, Feb 10, 2015 at 9:31 AM, Josh Wu <josh.wu@atmel.com> wrote:
[Snip]
>
> -       priv->clk = v4l2_clk_get(&client->dev, "mclk");
> +       priv->clk = v4l2_clk_get(&client->dev, "xvclk");

with this change don’t you need to update the board file using this driver/
the bridge driver ?

Regards,
--Prabhakar Lad
