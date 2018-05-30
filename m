Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:45711 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbeE3R5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 13:57:21 -0400
Received: by mail-pl0-f68.google.com with SMTP id c23-v6so240869plz.12
        for <linux-media@vger.kernel.org>; Wed, 30 May 2018 10:57:21 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
References: <m37eobudmo.fsf@t19.piap.pl>
 <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com> <m3tvresqfw.fsf@t19.piap.pl>
 <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com> <m3fu2oswjh.fsf@t19.piap.pl>
 <m3603hsa4o.fsf@t19.piap.pl> <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
 <m3h8mxqc7t.fsf@t19.piap.pl> <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
 <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
 <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com> <m3lgc2q5vl.fsf@t19.piap.pl>
 <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com> <m38t81plry.fsf@t19.piap.pl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
Date: Wed, 30 May 2018 10:57:13 -0700
MIME-Version: 1.0
In-Reply-To: <m38t81plry.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,


On 05/30/2018 01:53 AM, Krzysztof Hałasa wrote:
> Steve Longerbeam <slongerbeam@gmail.com> writes:
>
>> Yes, you'll need to patch adv7180.c to select either
>> 'seq-bt/tb' or 'alternate'. The current version will override
>> any attempt to set field to anything other than 'interlaced'.
>> This is in anticipation of getting a patch merged for adv7180
>> that fixes this.
> Right. I've applied the patch from your adv718x-v6 branch (just the
> "media: adv7180: fix field type" patch) and now it works.
>
> Also, I have changed "seq-bt" to "alternate" (in the examples in
> Documentation/media/v4l-drivers/imx.rst) - the data stream from ADV7180
> to CSI consists of separate fields which can then be merged into frames
> in any order requested by the user (e.g. in accordance with "digital PAL
> / NTSC" requirements).
>
> The following:
> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:alternate]"
> media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
> media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced]"
> now produces:
>
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x480 field:alternate]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x480 field:alternate]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x480 field:alternate]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x480 field:alternate]
> "ipu2_csi1":2      [fmt:AYUV32/720x480 field:interlaced-bt]
>
> and it works correctly.
>
> The only issue is that I can't:
> media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced-tb]"
> (it remains fixed in -bt mode since NTSC is the default). I think we may
> set TB/BT by default (depending on CSI input geometry or TV standard),

Yes, that's what I've implemented. If the user requests an interlaced
field type ('interlaced', 'interlaced-bt', 'interlaced-tb'), but the field
order is not correct given the input height (480=NTSC, 576=PAL),
then the request field type is overridden with the correct field order.

> but it should be possible for the user to explicitly request the field
> order on CSI output (I can make a patch I guess).

If you think that is the correct behavior, I will remove the override
code. I suppose it makes sense to allow user to select field order even
if that order does not make sense given the input standard. I'm fine
either way, Philipp what is your opinion? I'll go with the popular vote :)

Steve
