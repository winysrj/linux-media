Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B63C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4233E20892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4233E20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbeLGMLt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:11:49 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51534 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbeLGMLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 07:11:49 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VEyjg6LbQgJOKVEymgYj6U; Fri, 07 Dec 2018 13:11:47 +0100
Subject: Re: Configure video PAL decoder into media pipeline
To:     Jagan Teki <jagan@amarulasolutions.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Michael Trimarchi <michael@amarulasolutions.com>
References: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl>
Date:   Fri, 7 Dec 2018 13:11:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfA2bJyv5rEdDc8irmuQ2ddDc/ibVOStJHLxHFIEfP/heacszTD6o/6anUZeXw64EUQ/Wy/qnkS5jFPjyUFoJgk0QhmqrbJcfdF4cZqXHq+QMllBWbFe1
 gLr1VtV56YaqBYNlLfkAPcFbo2blnA1Iv/hEzIFk/JWPiuHq5D+bl+M4D2MY3rOwHAv9yXsbx3/ysmXq6peE+0DuXMTA0TSGMLb0rkCJ59TCukHHRxYoFfdG
 PEs1DongWUwaU0zzwDo8fTimeodg/+HNJx0MFr73oFod/WF4n9NnWs6VnQ9groeMgGX6NbmeAyXgk9aYuT6aWu8hpzTk3sbSUPJgwIpSHswIT5VjEZ3L+/w6
 FqHc2l+66NfLRXxhOaOr7AvoWnfEGQcKMRfQkFf/eZj5ePr5FHk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/07/2018 12:51 PM, Jagan Teki wrote:
> Hi,
> 
> We have some unconventional setup for parallel CSI design where analog
> input data is converted into to digital composite using PAL decoder
> and it feed to adv7180, camera sensor.
> 
> Analog input =>  Video PAL Decoder => ADV7180 => IPU-CSI0

Just PAL? No NTSC support?

> 
> The PAL decoder is I2C based, tda9885 chip. We setup it up via dt
> bindings and the chip is
> detected fine.
> 
> But we need to know, is this to be part of media control subdev
> pipeline? so-that we can configure pads, links like what we do on
> conventional pipeline  or it should not to be part of media pipeline?

Yes, I would say it should be part of the pipeline.

> 
> Please advise for best possible way to fit this into the design.
> 
> Another observation is since the IPU has more than one sink, source
> pads, we source or sink the other components on the pipeline but look
> like the same thing seems not possible with adv7180 since if has only
> one pad. If it has only one pad sourcing to adv7180 from tda9885 seems
> not possible, If I'm not mistaken.

Correct, in all cases where the adv7180 is used it is directly connected
to the video input connector on a board.

So to support this the adv7180 driver should be modified to add an input pad
so you can connect the decoder. It will be needed at some point anyway once
we add support for connector entities.

Regards,

	Hans

> 
> I tried to look for similar design in mainline, but I couldn't find
> it. is there any design similar to this in mainline?
> 
> Please let us know if anyone has any suggestions on this.
> 
> Jagan.
> 

