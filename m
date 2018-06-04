Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:50530 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751798AbeFDFwR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 01:52:17 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] media: imx.rst: Update doc to reflect fixes to interlaced capture
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
        <1527813049-3231-11-git-send-email-steve_longerbeam@mentor.com>
        <1527860665.5913.13.camel@pengutronix.de>
        <fc9933d7-93d0-1e0c-ca63-70a4f3faf618@mentor.com>
Date: Mon, 04 Jun 2018 07:52:16 +0200
In-Reply-To: <fc9933d7-93d0-1e0c-ca63-70a4f3faf618@mentor.com> (Steve
        Longerbeam's message of "Sat, 2 Jun 2018 11:44:24 -0700")
Message-ID: <m3fu23nlnz.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <steve_longerbeam@mentor.com> writes:

> Hmm, if the sink is 'alternate', and the requested source is
> 'interlaced*', perhaps we should allow the source to be
> 'interlaced*' and not override it. For example, if requested
> is 'interlaced-tb', let it be that. IOW assume user knows something
> we don't about the original field order, or is experimenting
> with finding the correct field order.

Yes, this is clearly possible. In fact the analog signal doesn't carry
information about the field order (if any). The video editing/encoding
software does motion estimation for this, and there is no other way
(given that the video material can change from progressive to interlaced
and vice versa, and probably can change the field order, at any time).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
