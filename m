Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:48690 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934393AbeEYHHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 03:07:19 -0400
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
        <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
        <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
        <m3h8mxqc7t.fsf@t19.piap.pl>
        <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
Date: Fri, 25 May 2018 09:07:17 +0200
In-Reply-To: <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com> (Steve
        Longerbeam's message of "Thu, 24 May 2018 11:12:01 -0700")
Message-ID: <m336ygqkm2.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

>> The manual says: Reduce Double Read or Writes (RDRW):
>> This bit is relevant for YUV4:2:0 formats. For write channels:
>> U and V components are not written to odd rows.
>>
>> How could it be so? With YUV420, are they normally written?
>
> Well, given that this bit exists, and assuming I understand it
> correctly (1),
> I guess the U and V components for odd rows normally are placed on the
> AXI bus. Which is a total waste of bus bandwidth because in 4:2:0,
> the U and V components are the same for odd and even rows.

Right. Now, the AXI bus is just a "memory bus", it's a newer version of
the AHB. One can't simply "place data" on AXI, it must be a write to
a specific address, and the data will end up in RAM (assuming the
configuration is sane). How can we have two possible data formats (with
and without the RDRW bit) with fixed image format (420-type) is beyond
me.

> Commits
>
> 14330d7f08 ("media: imx: csi: enable double write reduction")
> b54a5c2dc8 ("media: imx: prpencvf: enable double write reduction")
>
> should be reverted for now, until the behavior of this bit is better
> understood.

I agree.

I have dumped a raw frame (720 x 480 NV12 frame size 518400 from
interlaced NTSC camera), with the RDRW bit set.

The Y plane contains, well, valid Y data (720 x 480 bytes).

The color plane (360 pixels x 240 line pairs * 2 colors) has every other
line pair zeroed. I.e., there is a 720-byte line pair filled with valid UV
data, then there are 720 zeros (360 zeroed UV pairs). Then there is valid
UV data and so on.

Not sure what could it be for. Some weird sort of YUV 4:1:0? I guess we
don't want it ATM.

WRT ADV7180 field format:

> This might be a good time to bring up the fact that the ADV7180 driver
> is wrong
> to set output to "interlaced". The ADV7180 does not transmit top lines
> interlaced
> with bottom lines. It transmits all top lines followed by all bottom
> lines (or
> vice-versa), i.e. it should be either V4L2_FIELD_SEQ_TB or
> V4L2_FIELD_SEQ_BT.
> It can also be set to V4L2_FIELD_ALTERNATE, and then it is left up to
> downstream
> elements to determine field order (TB or BT).

Right. ADV7180, AFAIK, doesn't have the hardware (frame buffer) to get
two interlaced fields and merge them to form a complete frame.
It simply transforms the incoming analog signal into binary data stream.
This issue should be fixed.

Thanks for your work,
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
