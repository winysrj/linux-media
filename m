Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:45692 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752648AbdLEMSC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 07:18:02 -0500
Subject: Re: [PATCH v4 3/5] staging: Introduce NVIDIA Tegra video decoder
 driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1508448293.git.digetx@gmail.com>
 <1a3798f337c0097e67d70226ae3ba665fd9156c2.1508448293.git.digetx@gmail.com>
 <ad2da9f4-8899-7db3-493f-5aa15297c33c@xs4all.nl>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <3ac6a087-def2-014f-673d-1be9d5094635@gmail.com>
Date: Tue, 5 Dec 2017 15:17:58 +0300
MIME-Version: 1.0
In-Reply-To: <ad2da9f4-8899-7db3-493f-5aa15297c33c@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04.12.2017 17:04, Hans Verkuil wrote:
> Hi Dmitry,
> 
> As you already mention in the TODO, this should become a v4l2 codec driver.
> 
> Good existing examples are the coda, qcom/venus and mtk-vcodec drivers.
> 
> One thing that is not clear from this code is if the tegra hardware is a
> stateful or stateless codec, i.e. does it keep track of the decoder state
> in the hardware, or does the application have to keep track of the state and
> provide the state information together with the video data?
> 
> I ask because at the moment only stateful codecs are supported. Work is ongoing
> to support stateless codecs, but we don't support that for now.
> 

It is stateless. Is there anything ready to try out? If yes, could you please
give a reference to that work?

> Anyway, I'm OK with merging this in staging. Although I think it should go
> to staging/media since we want to keep track of it.
> 

Awesome, I'll move driver to staging/media in V5. Thanks!
