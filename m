Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:46131 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbeJOXGg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 19:06:36 -0400
Subject: Re: [PATCH] adv7604: add CEC support for adv7611/adv7612
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <9f1afd35-b8b4-fc3c-c634-21bc6c6d9c35@xs4all.nl>
 <20181015151505.GA14189@bigcity.dyn.berto.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <16b9091a-fecc-c754-76aa-1056a1b92e75@xs4all.nl>
Date: Mon, 15 Oct 2018 17:20:49 +0200
MIME-Version: 1.0
In-Reply-To: <20181015151505.GA14189@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/15/2018 05:15 PM, Niklas Söderlund wrote:
> Hi Hans,
> 
> Thanks for your patch.
> 
> On 2018-10-12 13:30:02 +0200, Hans Verkuil wrote:
>> The CEC IP is very similar between the three HDMI receivers, but
>> not identical. Add support for all three variants.
>>
>> Tested with an adv7604 and an adv7612.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This fixes CEC on my Koelsch board using the adv7604.
> 
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Side note do you know of a way to simulate a cycling of the physical HDMI 
> cable? My current test-case for CEC is:
> 
>     v4l2-ctl -d $(grep -l "adv7612" /sys/class/video4linux/*/name | sed 's#.*video4linux\(.*\)/name#/dev\1#g') --set-edid=type=hdmi
>     cec-ctl -d 0 --playback
>     cec-ctl -d 1 --tv
>     # Here I need to attach or if it already is connected disconnect and 
>     # reconnect the HDMI cable
>     cec-ctl -d 0 -S
>     cec-ctl -d 1 -S
> 
> If that step could be done in software I can add this test to my 
> automatic test scripts which would be nice.

You can clear the EDID of the receiver: v4l2-ctl --clear-edid

This will invalidate the physical address and pull the HPD low.

Note: you'll need this recent patch: "adv7604: when the EDID is cleared, unconfigure CEC as well"

Regards,

	Hans
