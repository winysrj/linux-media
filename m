Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54412 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751916AbeFDHdN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 03:33:13 -0400
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
        <m336y9ouc4.fsf@t19.piap.pl>
        <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
        <m3sh66omdk.fsf@t19.piap.pl> <1527858788.5913.2.camel@pengutronix.de>
        <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com>
Date: Mon, 04 Jun 2018 09:33:12 +0200
In-Reply-To: <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com> (Steve
        Longerbeam's message of "Sat, 2 Jun 2018 10:45:37 -0700")
Message-ID: <m34lijngzr.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

> I think this must be legacy code from a Freescale BSP requirement
> that the CSI must always capture in T-B order. We should remove this
> code, so that the CSI always captures field 0 followed by field 1,
> irrespective
> of field affinity,

Well it now seems we could do just that.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
