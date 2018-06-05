Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:44362 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbeFEKnG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Jun 2018 06:43:06 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential input/interlaced output fields
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
        <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
        <1527860010.5913.8.camel@pengutronix.de> <m3k1rfnmfr.fsf@t19.piap.pl>
        <1528100849.5808.2.camel@pengutronix.de>
        <c9fcc11a-9f0f-0764-cb8e-66fc9c09d7f4@mentor.com>
        <1528186075.4074.1.camel@pengutronix.de>
Date: Tue, 05 Jun 2018 12:43:03 +0200
In-Reply-To: <1528186075.4074.1.camel@pengutronix.de> (Philipp Zabel's message
        of "Tue, 05 Jun 2018 10:07:55 +0200")
Message-ID: <m3in6xms3s.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Philipp Zabel <p.zabel@pengutronix.de> writes:

> I'm probably misunderstanding you, so at the risk of overexplaining:
> There is no way we can ever produce a correct interlaced-tb frame in
> memory from a seq-bt frame output by the CSI, as the interweaving step
> only has access to a single frame.

Anyway we can use CCIR_CODE registers to get the fields in required
order. Actually I think it's the preferred way, even if there are
others.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
