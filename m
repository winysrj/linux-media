Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48995 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbBYDyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 22:54:41 -0500
Message-ID: <54ED4772.902@atmel.com>
Date: Wed, 25 Feb 2015 11:54:26 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/4] media: ov2640: add primary dt support
References: <1423560696-12304-1-git-send-email-josh.wu@atmel.com> <1423560696-12304-4-git-send-email-josh.wu@atmel.com> <CA+V-a8vkd2Q714s=o9WZZvPWJQATp=6POb8VYdSgarKxxEKqyQ@mail.gmail.com>
In-Reply-To: <CA+V-a8vkd2Q714s=o9WZZvPWJQATp=6POb8VYdSgarKxxEKqyQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Prabhakar Lad

On 2/17/2015 12:48 AM, Lad, Prabhakar wrote:
> Hi Josh,
>
> Thanks for the patch.
>
> On Tue, Feb 10, 2015 at 9:31 AM, Josh Wu <josh.wu@atmel.com> wrote:
> [Snip]
>> -       priv->clk = v4l2_clk_get(&client->dev, "mclk");
>> +       priv->clk = v4l2_clk_get(&client->dev, "xvclk");
> with this change don’t you need to update the board file using this driver/
> the bridge driver ?
I think no.

First, my patch should be on top of the following two patches, which 
changed the *v4l2_clk_get()* behavior:
[v3,1/2] V4L: remove clock name from v4l2_clk API
https://patchwork.linuxtv.org/patch/28108/
[v4,2/2] V4L: add CCF support to the v4l2_clk API
https://patchwork.linuxtv.org/patch/28111/

After applied above two patches, v4l2_clk_get() function is changed. The 
name "mclk" is refer to a CCF clock of the ov2640 device.
If not found such a "mclk" CCF clock, v4l2_clk_get() will try to get the 
internal register clock in soc_camera.c.
As the CCF dt clock is not support by ov2640 until I add DT support, 
that means current ov2640 driver will always not found the "mclk" CCF 
clock, and they will use internal clock.
So after I changed the name "mclk" to "xvclk", the default behavior will 
not change (still using internal clock registered by soc-camera.c).

Best Regards,
Josh Wu

>
> Regards,
> --Prabhakar Lad

