Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:53522 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754905AbeE2H04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 03:26:56 -0400
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
Date: Tue, 29 May 2018 09:26:54 +0200
In-Reply-To: <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com> (Steve
        Longerbeam's message of "Fri, 25 May 2018 16:39:53 -0700")
Message-ID: <m3lgc2q5vl.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Steve Longerbeam <slongerbeam@gmail.com> writes:

> Krzysztof, in the meantime the patches are available in my
> media-tree fork, for testing on the Ventana GW5300:
>
> git@github.com:slongerbeam/mediatree.git, branch 'fix-csi-interlaced'

I assume fix-csi-interlaced.2 is a newer version, isn't it?

I merged it and I think I can't set the correct config:
media-ctl -r -l '"adv7180 2-0020":0->"ipu2_csi1_mux":1[1],
                 "ipu2_csi1_mux":2->"ipu2_csi1":0[1],
                 "ipu2_csi1":2->"ipu2_csi1 capture":0[1]'

media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced]"

produces:
"adv7180 2-0020":0 [fmt:UYVY2X8/720x480 field:interlaced]
"ipu2_csi1_mux":1  [fmt:UYVY2X8/720x480 field:interlaced]
"ipu2_csi1_mux":2  [fmt:UYVY2X8/720x480 field:interlaced]
"ipu2_csi1":0      [fmt:UYVY2X8/720x480 field:interlaced]
"ipu2_csi1":2      [fmt:AYUV32/720x480  field:interlaced]

Do I need to patch ADV7180 for field type "sequential"?

It seems setting seq-bt on ADV7180 sets "interlaced" on ADV -> MUX input
-> MUX output. Setting "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]" sets
interlaced on all elements of the pipeline. The effect is a pair of
fields, not an interlaced frame.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
