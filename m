Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36785 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934250AbeE2OAm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 10:00:42 -0400
Received: by mail-pf0-f171.google.com with SMTP id w129-v6so7339231pfd.3
        for <linux-media@vger.kernel.org>; Tue, 29 May 2018 07:00:42 -0700 (PDT)
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
Date: Tue, 29 May 2018 07:00:36 -0700
MIME-Version: 1.0
In-Reply-To: <m3lgc2q5vl.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,


On 05/29/2018 12:26 AM, Krzysztof Hałasa wrote:
> Hi Steve,
>
> Steve Longerbeam <slongerbeam@gmail.com> writes:
>
>> Krzysztof, in the meantime the patches are available in my
>> media-tree fork, for testing on the Ventana GW5300:
>>
>> git@github.com:slongerbeam/mediatree.git, branch 'fix-csi-interlaced'
> I assume fix-csi-interlaced.2 is a newer version, isn't it?
>
> I merged it and I think I can't set the correct config:
> media-ctl -r -l '"adv7180 2-0020":0->"ipu2_csi1_mux":1[1],
>                   "ipu2_csi1_mux":2->"ipu2_csi1":0[1],
>                   "ipu2_csi1":2->"ipu2_csi1 capture":0[1]'
>
> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
> media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced]"
>
> produces:
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x480 field:interlaced]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x480 field:interlaced]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x480 field:interlaced]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x480 field:interlaced]
> "ipu2_csi1":2      [fmt:AYUV32/720x480  field:interlaced]
>
> Do I need to patch ADV7180 for field type "sequential"?

Yes, you'll need to patch adv7180.c to select either
'seq-bt/tb' or 'alternate'. The current version will override
any attempt to set field to anything other than 'interlaced'.
This is in anticipation of getting a patch merged for adv7180
that fixes this.

Steve
