Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54292 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751276AbeEUIJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:09:29 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl>
        <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
        <m3tvresqfw.fsf@t19.piap.pl>
        <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
        <m3fu2oswjh.fsf@t19.piap.pl>
Date: Mon, 21 May 2018 10:09:27 +0200
In-Reply-To: <m3fu2oswjh.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
        "Fri, 18 May 2018 19:28:34 +0200")
Message-ID: <m3603hsa4o.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested with NTSC camera, it's the same as with PAL.
The only case when IPU2_CSI1_SENS_CONF register is set to interlaced
mode (PRCTL=3, CCIR interlaced mode (BT.656)) is when all parts of the
pipeline are set to interlaced:

"adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:interlaced]
"ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:interlaced]
"ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:interlaced]
"ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:interlaced]
"ipu2_csi1":2      [fmt:AYUV32/720x576 field:interlaced]

The image is stable and in sync, the "only" problem is that I get two
concatenated field images (in one V4L2 frame) instead of a normal
interlaced frame (all lines in order - 0, 1, 2, 3, 4 etc).
IOW I get V4L2_FIELD_ALTERNATE, V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT
(the data format, I don't mean the pixel format.field) while I need to
get V4L2_FIELD_INTERLACED, V4L2_FIELD_INTERLACED_TB or _BT.


If I set "ipu2_csi1":2 to field:none, the IPU2_CSI1_SENS_CONF is set to
progressive mode (PRCTL=2). It's the last element of the pipeline I can
configure, it's connected straight to "ipu2_csi1 capture" aka
/dev/videoX. I think CSI can't work with interlaced camera (and ADV7180)
when set to progressive, can it?


I wonder... perhaps to get an interlaced frame I need to route the data
through VDIC (ipu2_vdic, the deinterlacer)?
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
