Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:60446 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754571AbeFNJjh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 05:39:37 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced scanning
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
        <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
        <1528708771.3818.7.camel@pengutronix.de>
        <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
        <2aff8f80-aa79-6718-6183-6e49088ae498@redhat.com>
        <f6e7eaa3-355e-a5d9-1be5-e5db08a99897@gmail.com>
Date: Thu, 14 Jun 2018 11:39:34 +0200
In-Reply-To: <f6e7eaa3-355e-a5d9-1be5-e5db08a99897@gmail.com> (Steve
        Longerbeam's message of "Tue, 12 Jun 2018 10:31:32 -0700")
Message-ID: <m3h8m5yaeh.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reporting from the field :-)

The fix-csi-interlaced.3 branch is still a bit off the track I guess:

   media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/576 field:seq-tb]"
   media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x576]"
   media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x576 field:interlaced-tb]"

does:
"adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:alternate
                 crop.bounds:(0,0)/720x1152
                 crop:(0,0)/720x1152
                 compose.bounds:(0,0)/720x1152
                 compose:(0,0)/720x1152]
"ipu2_csi1":2      [fmt:AYUV32/720x1152 field:seq-tb]

... and not interlaced[-*], as with fix-csi-interlaced.2.

The double heights are funny, too - probably an ADV7180 issue.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
