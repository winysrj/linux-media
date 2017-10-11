Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55902 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753370AbdJKWhP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 18:37:15 -0400
Subject: Re: [PATCH v3 1/2] staging: Introduce NVIDIA Tegra20 video decoder
 driver
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1507752381.git.digetx@gmail.com>
 <3d432aa2617977a2b0a8621a1fc2f36f751133e1.1507752381.git.digetx@gmail.com>
 <1507754838.19342.11.camel@ndufresne.ca>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <035a188e-23e3-ad10-a4e5-1e7debfbf61a@gmail.com>
Date: Thu, 12 Oct 2017 01:37:10 +0300
MIME-Version: 1.0
In-Reply-To: <1507754838.19342.11.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.10.2017 23:47, Nicolas Dufresne wrote:
> Le mercredi 11 octobre 2017 à 23:08 +0300, Dmitry Osipenko a écrit :
>> diff --git a/drivers/staging/tegra-vde/TODO b/drivers/staging/tegra-
>> vde/TODO
>> new file mode 100644
>> index 000000000000..e98bbc7b3c19
>> --- /dev/null
>> +++ b/drivers/staging/tegra-vde/TODO
>> @@ -0,0 +1,5 @@
>> +TODO:
>> +       - Figure out how generic V4L2 API could be utilized by this
>> driver,
>> +         implement it.
>> +
> 
> That is a very interesting effort, I think it's the first time someone
> is proposing an upstream driver for a Tegra platform.

Thanks!

 When I look
> tegra_vde_h264_decoder_ctx, it looks like the only thing that the HW is
> not parsing is the media header (pps/sps). Is that correct ?
> 

That's correct. I think it's quite common among embedded (mobile) and
desktop-grade decoders to require some auxiliary info from the media headers.

> I wonder how acceptable it would be to parse this inside the driver. It
> is no more complex then parsing an EDID. If that was possible, wrapping
> this driver as a v4l2 mem2mem should be rather simple. As a side
> effect, you'll automatically get some userspace working, notably
> GStreamer and FFmpeg.
> 

Parsing bitstream in kernel feels a bit dirty, although it's up to media
maintainers to decide.

> For the case even parsing the headers is too much from a kernel point
> of view, then I think you should have a look at the following effort.
> It's a proposal base on yet to be merged Request API. Hugues is also
> propose a libv4l2 adapter that makes the driver looks like a normal
> v4l2 m2m, hiding all the userspace parsing and table filling. This
> though, is long term plan to integrate state-less or parser-less
> encoders into linux-media. It seems rather overkill for state-full
> driver that requires parsed headers like PPS/SPS.
> 
> https://lwn.net/Articles/720797/
> 

I'll take a look at the Request API / libv4l2 adapter, thank you very much for
pointing to it.
