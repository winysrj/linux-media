Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:45074 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752135AbeFFFsv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Jun 2018 01:48:51 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential input/interlaced output fields
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
        <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
        <1527860010.5913.8.camel@pengutronix.de> <m3k1rfnmfr.fsf@t19.piap.pl>
        <1528100849.5808.2.camel@pengutronix.de>
        <c9fcc11a-9f0f-0764-cb8e-66fc9c09d7f4@mentor.com>
        <1528186075.4074.1.camel@pengutronix.de>
        <98b3cd1e-32ff-e7bb-b2ba-7b622aa983b6@mentor.com>
Date: Wed, 06 Jun 2018 07:48:48 +0200
In-Reply-To: <98b3cd1e-32ff-e7bb-b2ba-7b622aa983b6@mentor.com> (Steve
        Longerbeam's message of "Tue, 5 Jun 2018 12:00:52 -0700")
Message-ID: <m3bmcompmn.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <steve_longerbeam@mentor.com> writes:

> I don't follow you, yes the interweaving step only has access to
> a single frame, but why would interweave need access to another
> frame to carry out seq-bt -> interlaced-tb ? See below...

You can't to that.
You can delay the input stream (skip one field) so the bottom-first
becomes top-first (or top-first - bottom-first), probably with some loss
of chroma quality, but you can't reorder odd and even lines.

To convert (anything)-bt -> (anything)-tb you need two consecutive
fields, the top one and then the bottom one. If the input is *-bt, this
means two "frames" (if the word "frame" is applicable at this point).

CCIR_CODE_* registers are fine, though. They don't change the geometry,
the just skip a single field (sort of, actually they sync to the
required field).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
