Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:39533 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbbBZAgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 19:36:37 -0500
MIME-Version: 1.0
In-Reply-To: <54ED4772.902@atmel.com>
References: <1423560696-12304-1-git-send-email-josh.wu@atmel.com>
 <1423560696-12304-4-git-send-email-josh.wu@atmel.com> <CA+V-a8vkd2Q714s=o9WZZvPWJQATp=6POb8VYdSgarKxxEKqyQ@mail.gmail.com>
 <54ED4772.902@atmel.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 26 Feb 2015 00:36:05 +0000
Message-ID: <CA+V-a8s_PosECku7Pzg4Rt4Mq7_mMtvo3ZGDxUByx__XEgUxcA@mail.gmail.com>
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

On Wed, Feb 25, 2015 at 3:54 AM, Josh Wu <josh.wu@atmel.com> wrote:
> Hi, Prabhakar Lad
>
>
> On 2/17/2015 12:48 AM, Lad, Prabhakar wrote:
>>
>> Hi Josh,
>>
>> Thanks for the patch.
>>
>> On Tue, Feb 10, 2015 at 9:31 AM, Josh Wu <josh.wu@atmel.com> wrote:
>> [Snip]
>>>
>>> -       priv->clk = v4l2_clk_get(&client->dev, "mclk");
>>> +       priv->clk = v4l2_clk_get(&client->dev, "xvclk");
>>
>> with this change don’t you need to update the board file using this
>> driver/
>> the bridge driver ?
>
> I think no.
>
> First, my patch should be on top of the following two patches, which changed
> the *v4l2_clk_get()* behavior:
> [v3,1/2] V4L: remove clock name from v4l2_clk API
> https://patchwork.linuxtv.org/patch/28108/
> [v4,2/2] V4L: add CCF support to the v4l2_clk API
> https://patchwork.linuxtv.org/patch/28111/
>
Thanks I missed the dependent patches.

Cheers,
--Prabhakar Lad
