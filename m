Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:46850 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932097AbeFFG0K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Jun 2018 02:26:10 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential input/interlaced output fields
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
        <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
        <1527860010.5913.8.camel@pengutronix.de> <m3k1rfnmfr.fsf@t19.piap.pl>
        <1528100849.5808.2.camel@pengutronix.de>
        <c9fcc11a-9f0f-0764-cb8e-66fc9c09d7f4@mentor.com>
Date: Wed, 06 Jun 2018 08:26:08 +0200
In-Reply-To: <c9fcc11a-9f0f-0764-cb8e-66fc9c09d7f4@mentor.com> (Steve
        Longerbeam's message of "Mon, 4 Jun 2018 17:56:44 -0700")
Message-ID: <m37encmnwf.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <steve_longerbeam@mentor.com> writes:

> Yes, I had already implemented this idea yesterday, I've added it
> to branch fix-csi-interlaced.3. The CSI will swap field capture
> (field 1 first, then field 2, by inverting F bit in CCIR registers) if
> the field order input to the CSI is different from the requested
> output field order.

It seems the fix-csi-interlaced.2 was a bit better.

Now I do:
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x576 field:alternate]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x576]"
media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x576 field:interlaced]"

and get:
"adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:alternate]
"ipu2_csi1":2      [fmt:AYUV32/720x576 field:seq-tb]

Needless to say, the output isn't an interlaced frame.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
