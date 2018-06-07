Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:37008 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752631AbeFGHna (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Jun 2018 03:43:30 -0400
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
        <1528275940.3438.1.camel@pengutronix.de>
        <38f24445-1dff-534e-b67a-06c069fe18c3@mentor.com>
Date: Thu, 07 Jun 2018 09:43:27 +0200
In-Reply-To: <38f24445-1dff-534e-b67a-06c069fe18c3@mentor.com> (Steve
        Longerbeam's message of "Wed, 6 Jun 2018 20:37:42 -0700")
Message-ID: <m3lgbrkpnk.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <steve_longerbeam@mentor.com> writes:

> One final note, it is incorrect to assign 'seq-tb' to a PAL signal according
> to this new understanding. Because according to various sites (for example
> [1]), both standard definition NTSC and PAL are bottom field dominant,
> so 'seq-tb' is not correct for PAL.

Actually this isn't the case:

- real PAL (= analog) is (was) interlaced, so you could choose any
  "dominant field" and it would work fine (stuff originating as film
  movies being an exception).

- the general idea at these times was that NTSC-style digital video was
  bottom-first while PAL-style was top-first.

- for example, most (practically all?) commercial TV-style interlaced
  PAL DVDs were top-first (movies were usually progressive).

- standard TV (DVB 576i) uses (used) top-first as well.

- this seems to be confirmed by e.g. ITU-R REC-BR.469-7-2002 (annex 1).
  Hovewer, this suggests that field 1 is the top one and 2 is bottom
  (and not first and second in terms of time).

- if field 1 = top and 2 = bottom indeed, then we're back at BT.656 and
  my original idea that the SAV/EAV codes show straigh the so called
  odd/even lines and not some magic, standard-dependent lines of first
  and second fields. This needs to be verified.
  I think the ADV7180 forces the SAV/EAV codes (one can't set them
  depending od PAL/NTSC etc), so we could assume it does it right.

- a notable exception to PAL = top first rule was DV and similar stuff
  (the casette camcorder things, including Digital8, miniDV, and
  probably derivatives). DV (including PAL) used bottom-first
  universally.

I think we should stick to default PAL=TB, NTSC=BT rule, though the user
should be able to override it (if working with e.g. PAL DV camcorder
connected with an analog cable - not very probable, I guess).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
