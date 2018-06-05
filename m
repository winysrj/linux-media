Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:58962 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751595AbeFEEyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Jun 2018 00:54:23 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] media: imx-csi: Pass sink pad field to ipu_csi_init_interface
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
        <1527813049-3231-2-git-send-email-steve_longerbeam@mentor.com>
        <1527859350.5913.4.camel@pengutronix.de>
        <bbae0a24-7ab6-1361-f15c-068f32482f1f@gmail.com>
        <m3o9grnmwy.fsf@t19.piap.pl>
        <74a76dfd-3059-2fc1-5e8a-885ae1b0edb5@mentor.com>
Date: Tue, 05 Jun 2018 06:54:20 +0200
In-Reply-To: <74a76dfd-3059-2fc1-5e8a-885ae1b0edb5@mentor.com> (Steve
        Longerbeam's message of "Mon, 4 Jun 2018 09:47:59 -0700")
Message-ID: <m3muw9n88z.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <steve_longerbeam@mentor.com> writes:

> I think you misunderstood me. Of course there is a first and second
> field. By first I am referring to the first field transmitted, which could
> be top or bottom.

Right. I was thinking the fields are even and odd, but that's not
actually the case (I mean, the numbering uses field 1 and 2 and not
E/O).

> Progressive sensors have no fields, the entire image is captured at
> once as you said.

There are progressive cameras with analog PAL/NTSC output. The signal
is obviously interlaced and consists of fields.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
