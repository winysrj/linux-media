Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58024 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaLIDDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 22:03:51 -0500
Message-ID: <5486668C.3000808@atmel.com>
Date: Tue, 9 Dec 2014 11:03:40 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/5] media: ov2640: add a master clock for sensor
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>	<1418038147-13221-5-git-send-email-josh.wu@atmel.com> <CAOMZO5ASNUCz908esJ3iTQ6VEQGeNi-HOmqMOf12c633Q8pavw@mail.gmail.com>
In-Reply-To: <CAOMZO5ASNUCz908esJ3iTQ6VEQGeNi-HOmqMOf12c633Q8pavw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Fabio

On 12/8/2014 11:10 PM, Fabio Estevam wrote:
> On Mon, Dec 8, 2014 at 9:29 AM, Josh Wu <josh.wu@atmel.com> wrote:
>
>> +       priv->master_clk = devm_clk_get(&client->dev, "xvclk");
>> +       if (IS_ERR(priv->master_clk))
>> +               return -EINVAL;
> You should return PTR_ERR(priv->master_clk) instead.
sure. I'll fix it in next version. Thanks.

Best Regards,
Josh Wu
