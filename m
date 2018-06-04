Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:49864 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750723AbeFDFZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 01:25:20 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 01/10] media: imx-csi: Pass sink pad field to ipu_csi_init_interface
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
        <1527813049-3231-2-git-send-email-steve_longerbeam@mentor.com>
        <1527859350.5913.4.camel@pengutronix.de>
        <bbae0a24-7ab6-1361-f15c-068f32482f1f@gmail.com>
Date: Mon, 04 Jun 2018 07:25:17 +0200
In-Reply-To: <bbae0a24-7ab6-1361-f15c-068f32482f1f@gmail.com> (Steve
        Longerbeam's message of "Sat, 2 Jun 2018 09:30:57 -0700")
Message-ID: <m3o9grnmwy.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

> I think we should return to enforcing field order to userspace that
> matches field order from the source, which is what I had implemented
> previously. I agree with you that we should put off allowing inverting
> field order.

There is no any particular field order at the source, most of the time.
The odd field is followed by the even field, and so on, sure. But there
is no "first" and "second" field, any field can be the "first".

The exception to this is a camera with a progressive sensor - both
"fields" are taken at the same time and transmitted one after the other,
so in this case the order is defined (by the camera, e.g. B-T on DV even
with PAL version). But this isn't exactly PAL/NTSC.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
