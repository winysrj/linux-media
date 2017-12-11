Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:38053 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdLKAM7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Dec 2017 19:12:59 -0500
Subject: Re: [PATCH v4 3/5] staging: Introduce NVIDIA Tegra video decoder
 driver
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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
 <93c98569-0282-80d9-78ad-c8ab8fd9db92@xs4all.nl>
 <f46f397d-28e1-f4e5-55d4-9863214e8f6c@gmail.com>
 <1512934179.4281.15.camel@ndufresne.ca>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <c9d8ad71-2fb3-4ce9-2672-9006511f5079@gmail.com>
Date: Mon, 11 Dec 2017 03:12:55 +0300
MIME-Version: 1.0
In-Reply-To: <1512934179.4281.15.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.12.2017 22:29, Nicolas Dufresne wrote:
> Le dimanche 10 décembre 2017 à 21:56 +0300, Dmitry Osipenko a écrit :
>>> I've CC-ed Maxime and Giulio as well: they are looking into adding support for
>>> the stateless allwinner codec based on this code as well. There may well be
>>> opportunities for you to work together, esp. on the userspace side. Note that
>>> Rockchip has the same issue, they too have a stateless HW codec.
>>
>> IIUC, we will have to define video decoder parameters in V4L API and then make a
>> V4L driver / userspace prototype (ffmpeg for example) that will use the requests
>> API for video decoding in order to upstream the requests API. Does it sound good?
> 
> Chromium/Chrome already have support for that type of decoder in their
> tree. In theory, it should just work.

Everything is possible, in theory ;)
