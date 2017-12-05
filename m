Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37276 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752042AbdLENDp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 08:03:45 -0500
Subject: Re: [PATCH v4 3/5] staging: Introduce NVIDIA Tegra video decoder
 driver
To: Dmitry Osipenko <digetx@gmail.com>,
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
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Giulio Benetti <giulio.benetti@micronovasrl.com>
References: <cover.1508448293.git.digetx@gmail.com>
 <1a3798f337c0097e67d70226ae3ba665fd9156c2.1508448293.git.digetx@gmail.com>
 <ad2da9f4-8899-7db3-493f-5aa15297c33c@xs4all.nl>
 <3ac6a087-def2-014f-673d-1be9d5094635@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <93c98569-0282-80d9-78ad-c8ab8fd9db92@xs4all.nl>
Date: Tue, 5 Dec 2017 14:03:37 +0100
MIME-Version: 1.0
In-Reply-To: <3ac6a087-def2-014f-673d-1be9d5094635@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/17 13:17, Dmitry Osipenko wrote:
> Hi Hans,
> 
> On 04.12.2017 17:04, Hans Verkuil wrote:
>> Hi Dmitry,
>>
>> As you already mention in the TODO, this should become a v4l2 codec driver.
>>
>> Good existing examples are the coda, qcom/venus and mtk-vcodec drivers.
>>
>> One thing that is not clear from this code is if the tegra hardware is a
>> stateful or stateless codec, i.e. does it keep track of the decoder state
>> in the hardware, or does the application have to keep track of the state and
>> provide the state information together with the video data?
>>
>> I ask because at the moment only stateful codecs are supported. Work is ongoing
>> to support stateless codecs, but we don't support that for now.
>>
> 
> It is stateless. Is there anything ready to try out? If yes, could you please
> give a reference to that work?

I rebased my two year old 'requests2' branch to the latest mainline version and
gave it the imaginative name 'requests3':

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=requests3

(Note: only compile tested!)

This is what ChromeOS has been using (actually they use a slightly older version)
and the new version that is currently being developed will be similar, so any work
you do on top of this will carry over to the final version without too much effort.

At least, that's the intention :-)

I've CC-ed Maxime and Giulio as well: they are looking into adding support for
the stateless allwinner codec based on this code as well. There may well be
opportunities for you to work together, esp. on the userspace side. Note that
Rockchip has the same issue, they too have a stateless HW codec.

> 
>> Anyway, I'm OK with merging this in staging. Although I think it should go
>> to staging/media since we want to keep track of it.
>>
> 
> Awesome, I'll move driver to staging/media in V5. Thanks!

Nice, thanks!

	Hans
