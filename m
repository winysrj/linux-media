Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f53.google.com ([209.85.160.53]:45606 "EHLO
        mail-pl0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754378AbeEUVZn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 17:25:43 -0400
Received: by mail-pl0-f53.google.com with SMTP id bi12-v6so9516275plb.12
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 14:25:43 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
References: <m37eobudmo.fsf@t19.piap.pl>
 <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com> <m3tvresqfw.fsf@t19.piap.pl>
 <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com> <m3fu2oswjh.fsf@t19.piap.pl>
 <m3603hsa4o.fsf@t19.piap.pl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
Date: Mon, 21 May 2018 14:25:40 -0700
MIME-Version: 1.0
In-Reply-To: <m3603hsa4o.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof, I've been on vacation, just returned today. I will
find the time this week to attempt to reproduce your results on
a SabreAuto quad with the adv7180.

Btw, if you just need to capture an interlaced frame (lines 0,1,2,...)
without motion compensation, there is no need to use the VDIC
path. Capturing directly from ipu2_csi1 should work, I've tested
this many times on a SabreAuto. But I will try to reproduce your
results.

Steve


On 05/21/2018 01:09 AM, Krzysztof Hałasa wrote:
> Tested with NTSC camera, it's the same as with PAL.
> The only case when IPU2_CSI1_SENS_CONF register is set to interlaced
> mode (PRCTL=3, CCIR interlaced mode (BT.656)) is when all parts of the
> pipeline are set to interlaced:
>
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":2      [fmt:AYUV32/720x576 field:interlaced]
>
> The image is stable and in sync, the "only" problem is that I get two
> concatenated field images (in one V4L2 frame) instead of a normal
> interlaced frame (all lines in order - 0, 1, 2, 3, 4 etc).
> IOW I get V4L2_FIELD_ALTERNATE, V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT
> (the data format, I don't mean the pixel format.field) while I need to
> get V4L2_FIELD_INTERLACED, V4L2_FIELD_INTERLACED_TB or _BT.
>
>
> If I set "ipu2_csi1":2 to field:none, the IPU2_CSI1_SENS_CONF is set to
> progressive mode (PRCTL=2). It's the last element of the pipeline I can
> configure, it's connected straight to "ipu2_csi1 capture" aka
> /dev/videoX. I think CSI can't work with interlaced camera (and ADV7180)
> when set to progressive, can it?
>
>
> I wonder... perhaps to get an interlaced frame I need to route the data
> through VDIC (ipu2_vdic, the deinterlacer)?
