Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45614 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751727AbeFBSod (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 14:44:33 -0400
Subject: Re: [PATCH v2 10/10] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
 <1527813049-3231-11-git-send-email-steve_longerbeam@mentor.com>
 <1527860665.5913.13.camel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <fc9933d7-93d0-1e0c-ca63-70a4f3faf618@mentor.com>
Date: Sat, 2 Jun 2018 11:44:24 -0700
MIME-Version: 1.0
In-Reply-To: <1527860665.5913.13.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/01/2018 06:44 AM, Philipp Zabel wrote:
> On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
> <snip>
>> +
>> +.. code-block:: none
>> +
>> +   # Setup links
>> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
>> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>> +   # Configure pads
>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480 field:interlaced]"
> Could the example suggest using interlaced-bt to be explicit here?
> Actually, I don't think we should allow interlaced on the CSI src pads
> at all in this case. Technically it always writes either seq-tb or seq-
> bt into the smfc, never interlaced (unless the input is already
> interlaced).
>

Hmm, if the sink is 'alternate', and the requested source is
'interlaced*', perhaps we should allow the source to be
'interlaced*' and not override it. For example, if requested
is 'interlaced-tb', let it be that. IOW assume user knows something
we don't about the original field order, or is experimenting
with finding the correct field order.

Steve
