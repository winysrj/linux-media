Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:42850 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbeFAKCe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 06:02:34 -0400
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
        <m38t81plry.fsf@t19.piap.pl>
        <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
        <m336y9ouc4.fsf@t19.piap.pl>
        <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
Date: Fri, 01 Jun 2018 12:02:31 +0200
In-Reply-To: <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com> (Steve
        Longerbeam's message of "Wed, 30 May 2018 13:56:34 -0700")
Message-ID: <m3sh66omdk.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

> I tend to agree, I've found conflicting info out there regarding
> PAL vs. NTSC field order. And I've never liked having to guess
> at input analog standard based on input # lines. I will go ahead
> and remove the field order override code.

I've merged your current fix-csi-interlaced.2 branch (2018-06-01
00:06:45 UTC 22ad9f30454b6e46979edf6f8122243591910a3e) along with
"media: adv7180: fix field type" commit and NTSC camera:

media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:alternate]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced/-bt/-tb]"

correctly sets:

"adv7180 2-0020":0 [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1_mux":1  [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1_mux":2  [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1":0      [fmt:UYVY2X8/720x480 field:alternate]
"ipu2_csi1":2      [fmt:AYUV32/720x480 field:interlaced/-bt/-tb]

but all 3 cases seem to produce top-first interlaced frames.
The CCIR_CODE_* register dump shows no differences:
2a38014: 010D07DF 00040596 00FF0000

...it's because the code in drivers/gpu/ipu-v3/ipu-csi.c still sets the
registers depending on the height of the image. Hovewer, I'm using 480
lines here, so it should be B-T instead. My guess is the CSI is skipping
the first incomplete line (half-line - the first visible line has full
length) and BT becomes TB.

It seems writing to the CCIR_CODE_[12] registers does the trick, though
(the captured frames aren't correct and have the lines swapped in pairs
because t/b field pointers aren't correctly set).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
