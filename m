Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:50098 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbeFDFfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 01:35:37 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential input/interlaced output fields
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
        <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
        <1527860010.5913.8.camel@pengutronix.de>
Date: Mon, 04 Jun 2018 07:35:36 +0200
In-Reply-To: <1527860010.5913.8.camel@pengutronix.de> (Philipp Zabel's message
        of "Fri, 01 Jun 2018 15:33:30 +0200")
Message-ID: <m3k1rfnmfr.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Philipp Zabel <p.zabel@pengutronix.de> writes:

> This is ok in this patch, but we can't use this check in the following
> TRY_FMT patch as there is no way to interweave
> SEQ_TB -> INTERLACED_BT (because in SEQ_TB the B field is newer than T,
> but in INTERLACED_BT it has to be older) or SEQ_BT -> INTERLACED_TB (the
> other way around).

Actually we can do SEQ_TB -> INTERLACED_BT and SEQ_BT -> INTERLACED_TB
rather easily. We only need to skip a single field at start :-)
That's what CCIR_CODE_* registers do.

To be honest, SEQ_TB and SEQ_BT are precisely the same thing
(i.e., SEQUENTIAL). It's up to the user to say which field is the first.
There is the progressive sensor exception, though, and the TB/BT could
be a hint for downstream elements (i.e., setting the default field
order).

But I think we should be able to request INTERLACED_TB or INTERLACED_BT
(with any analog signal on input) and the CCIR_CODE registers should be
set accordingly. This should all magically work fine.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
