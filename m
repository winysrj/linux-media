Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24901 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754085AbcKCKj3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 06:39:29 -0400
Subject: Re: [PATCH v3 5/6] Documentation: bindings: add documentation for
 ir-spi device driver
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <70e31ed5-e1ec-cac3-3c3d-02c75f1418bd@samsung.com>
Date: Thu, 03 Nov 2016 11:39:21 +0100
MIME-version: 1.0
In-reply-to: <20161103101048.ofyoko4mkcypf44u@gangnam.samsung>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <20161102104010.26959-1-andi.shyti@samsung.com>
 <CGME20161102104149epcas5p4da68197e232df7ad922f2f9cb0714a43@epcas5p4.samsung.com>
 <20161102104010.26959-6-andi.shyti@samsung.com>
 <70f4426b-e2e6-1fb7-187a-65ed4bce0668@samsung.com>
 <20161103101048.ofyoko4mkcypf44u@gangnam.samsung>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/2016 11:10 AM, Andi Shyti wrote:
> Hi Jacek,
>
>> Only DT bindings of LED class drivers should be placed in
>> Documentation/devicetree/bindings/leds. Please move it to the
>> media bindings.
>
> that's where I placed it first, but Rob asked me to put it in the
> LED directory and Cc the LED mailining list.
>
> That's the discussion of the version 2:
>
> https://lkml.org/lkml/2016/9/12/380
>
> Rob, Jacek, could you please agree where I can put the binding?

I'm not sure if this is a good approach. I've noticed also that
backlight bindings have been moved to leds, whereas they don't look
similarly.

We have common.txt LED bindings, that all LED class drivers' bindings
have to follow. Neither backlight bindings nor these ones do that,
which introduces some mess.

Eventually adding a sub-directory, e.g. remote_control could make it
somehow logically justified, but still - shouldn't bindings be
placed in the documentation directory related to the subsystem of the
driver they are predestined to?

-- 
Best regards,
Jacek Anaszewski
