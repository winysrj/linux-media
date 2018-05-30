Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41674 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964976AbeE3IxY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 04:53:24 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl>
        <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
        <m3tvresqfw.fsf@t19.piap.pl>
        <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
        <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
        <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
        <m3h8mxqc7t.fsf@t19.piap.pl>
        <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
        <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
        <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com>
        <m3lgc2q5vl.fsf@t19.piap.pl>
        <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
Date: Wed, 30 May 2018 10:53:21 +0200
In-Reply-To: <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com> (Steve
        Longerbeam's message of "Tue, 29 May 2018 07:00:36 -0700")
Message-ID: <m38t81plry.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

> Yes, you'll need to patch adv7180.c to select either
> 'seq-bt/tb' or 'alternate'. The current version will override
> any attempt to set field to anything other than 'interlaced'.
> This is in anticipation of getting a patch merged for adv7180
> that fixes this.

Right. I've applied the patch from your adv718x-v6 branch (just the
"media: adv7180: fix field type" patch) and now it works.

Also, I have changed "seq-bt" to "alternate" (in the examples in
Documentation/media/v4l-drivers/imx.rst) - the data stream from ADV7180
to CSI consists of separate fields which can then be merged into frames
in any order requested by the user (e.g. in accordance with "digital PAL
/ NTSC" requirements).

The following:
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:alternate]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced]"
now produces:

"adv7180 2-0020":0 [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1_mux":1  [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1_mux":2  [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1":0      [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1":2      [fmt:AYUV32/720x480 field:interlaced-bt]

and it works correctly.

The only issue is that I can't:
media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced-tb]"
(it remains fixed in -bt mode since NTSC is the default). I think we may
set TB/BT by default (depending on CSI input geometry or TV standard),
but it should be possible for the user to explicitly request the field
order on CSI output (I can make a patch I guess).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
