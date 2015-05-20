Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34466 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbbETNVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 09:21:46 -0400
MIME-Version: 1.0
In-Reply-To: <555C86A5.2030007@melag.de>
References: <555C86A5.2030007@melag.de>
Date: Wed, 20 May 2015 10:21:44 -0300
Message-ID: <CAOMZO5CTz4DOdB6xvrw1=i4DRsukQjtzyDMJn50znXd6uXMBUA@mail.gmail.com>
Subject: Re: imx53 IPU support on 4.0.4
From: Fabio Estevam <festevam@gmail.com>
To: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Wed, May 20, 2015 at 10:05 AM, Enrico Weigelt, metux IT consult
<weigelt@melag.de> wrote:
>
> Hi folks,
>
>
> I've rebased the IPUv3 patches from ptx folks onto 4.0.4,
> working good for me. (now gst plays h264 @25fps on imx53)
>
> https://github.com/metux/linux/commits/submit-4.0-imx53-ipuv3

That's great.

Kamil mentioned that the scaler patches should be merged via the the
gpu subsystem:
http://www.spinics.net/lists/linux-media/msg88582.html

,so I guess Phillip will handle it.

>
> (Haven't 4.1rc* yet, as it broke some other things for me.)

What are the regressions you see?

Regards,

Fabio Estevam
