Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:36642 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbeFAFX1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 01:23:27 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Philipp Zabel <pza@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
        <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
        <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com>
        <m3lgc2q5vl.fsf@t19.piap.pl>
        <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
        <m38t81plry.fsf@t19.piap.pl>
        <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
        <m336y9ouc4.fsf@t19.piap.pl>
        <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
        <20180531062911.pkl2pracmyvhsldz@pengutronix.de>
Date: Fri, 01 Jun 2018 07:23:24 +0200
In-Reply-To: <20180531062911.pkl2pracmyvhsldz@pengutronix.de> (Philipp Zabel's
        message of "Thu, 31 May 2018 08:29:11 +0200")
Message-ID: <m3wovjnkqb.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Philipp Zabel <pza@pengutronix.de> writes:

> Note that the code in ipu_csi_init_interface currently hard-codes field
> order depending on frame size. It could be that selecting opposite field
> order is as easy as switching the relevant parts of writes to registers
> CCIR_CODE_2 and _3, but we'd have to pass the desired output field order
> to this function. I'd welcome if somebody would verify that this works.

I can test anything I guess.
Though, in this case, I would be surprised if there is something else
needed. We already do the opposite field order by switching the
CCIR_CODE_[23] values :-)
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
