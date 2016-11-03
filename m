Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46889 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbcKCKLG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 06:11:06 -0400
Date: Thu, 03 Nov 2016 19:10:48 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] Documentation: bindings: add documentation for
 ir-spi device driver
Message-id: <20161103101048.ofyoko4mkcypf44u@gangnam.samsung>
References: <20161102104010.26959-1-andi.shyti@samsung.com>
 <CGME20161102104149epcas5p4da68197e232df7ad922f2f9cb0714a43@epcas5p4.samsung.com>
 <20161102104010.26959-6-andi.shyti@samsung.com>
 <70f4426b-e2e6-1fb7-187a-65ed4bce0668@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <70f4426b-e2e6-1fb7-187a-65ed4bce0668@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

> Only DT bindings of LED class drivers should be placed in
> Documentation/devicetree/bindings/leds. Please move it to the
> media bindings.

that's where I placed it first, but Rob asked me to put it in the
LED directory and Cc the LED mailining list.

That's the discussion of the version 2:

https://lkml.org/lkml/2016/9/12/380

Rob, Jacek, could you please agree where I can put the binding?

Thanks,
Andi
