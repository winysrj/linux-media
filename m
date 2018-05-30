Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:33578 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932138AbeE3SqG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 14:46:06 -0400
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
        <m3lgc2q5vl.fsf@t19.piap.pl>
        <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
        <m38t81plry.fsf@t19.piap.pl>
        <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
Date: Wed, 30 May 2018 20:46:03 +0200
In-Reply-To: <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com> (Steve
        Longerbeam's message of "Wed, 30 May 2018 10:57:13 -0700")
Message-ID: <m336y9ouc4.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

>> but it should be possible for the user to explicitly request the field
>> order on CSI output (I can make a patch I guess).
>
> If you think that is the correct behavior, I will remove the override
> code. I suppose it makes sense to allow user to select field order even
> if that order does not make sense given the input standard. I'm fine
> either way, Philipp what is your opinion? I'll go with the popular vote :)

I think it should be up to the user.
Actually, PAL and NTSC aren't valid names in the digital world. Their
meaning ends in the ADV7180 (or equivalent). I don't know if PAL and/or
NTSC specify the field order in the analog frame (meaningful when
someone hooks a camera with progressive sensor and analog, interlaced
output), but the digital YUV422 from ADV to CSI isn't NTSC/PAL anymore.
It's just WxH @ framerate + possible interlacing, sequential fields,
top-bottom or otherwise, etc. The analog standard names could be used
here but just as defaults.

If we were strict (and we don't want to force it), then we should set
NTSC/PAL thing on ADV7180 input, 720x480@29.97i (or 720x576@50i, or
704x... etc) on the input parts of the CSI/IPU (where there are no video
frames yet), and 720x480@29.97i B-T or T-B (or default, or separate
fields - whatever suits the user) on the output from CSI.

I remember the reversed field order was sometimes needed - for example,
PAL DV (the casette camcorder thing) produced B-T frames (same as NTSC),
and to avoid (slight) additional quality loss one had to process it
(up to e.g. .MP4, DVD, and then to HDMI, SCART etc) as B-T.
It wasn't a problem in otherwise-PAL-centric environment.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
