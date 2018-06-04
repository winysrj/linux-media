Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:57516 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbeFDI6V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 04:58:21 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl> <m3tvresqfw.fsf@t19.piap.pl>
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
        <m3sh66omdk.fsf@t19.piap.pl> <1527858788.5913.2.camel@pengutronix.de>
        <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com>
        <1528102047.5808.11.camel@pengutronix.de>
Date: Mon, 04 Jun 2018 10:58:18 +0200
In-Reply-To: <1528102047.5808.11.camel@pengutronix.de> (Philipp Zabel's
        message of "Mon, 04 Jun 2018 10:47:27 +0200")
Message-ID: <m3zi0blyhh.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've just tested the PAL setup: in currect situation (v4.17 + Steve's
fix-csi-interlaced.2 + "media: adv7180: fix field type" + a small cheap
PAL camera) the following produces bottom-first interlaced frames:

media-ctl -r -l '"adv7180 2-0020":0->"ipu2_csi1_mux":1[1],
                 "ipu2_csi1_mux":2->"ipu2_csi1":0[1],
                 "ipu2_csi1":2->"ipu2_csi1 capture":0[1]'

media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x576 field:alternate]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x576]"
media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x576 field:interlaced]"

"adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1":2      [fmt:AYUV32/720x576 field:interlaced]

I think it would be great if these changes make their way upstream.
The details could be refined then.
-- 
Krzysztof Halasa
Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
