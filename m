Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:57644 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaGZQhT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 12:37:19 -0400
Received: by mail-vc0-f171.google.com with SMTP id hq11so9060404vcb.16
        for <linux-media@vger.kernel.org>; Sat, 26 Jul 2014 09:37:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D3C578.8000802@xs4all.nl>
References: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com>
	<1406385272-425-2-git-send-email-philipp.zabel@gmail.com>
	<53D3C578.8000802@xs4all.nl>
Date: Sat, 26 Jul 2014 18:37:18 +0200
Message-ID: <CA+gwMcd2hETKbkqM5yeJiVDzadHyQX=qgPTqobFXTN4JQ-+vdA@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] coda: fix coda_g_selection
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 26, 2014 at 5:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 07/26/2014 04:34 PM, Philipp Zabel wrote:
>> Crop targets are valid on the capture side and compose targets are valid
>> on the output side, not the other way around.
>
> Are you sure about this? Usually for m2m devices the capture side supports
> compose (i.e. the result of the m2m operation can be composed into the capture
> buffer) and the output side supports crop (i.e. the m2m operates on the cropped
> part of the output buffer instead of on the full buffer), like the coda driver
> does today.

You are right, I haven't thought this through. Please ignore this patch.

> As a result of that the old G/S_CROP API cannot be used with most m2m devices
> since it does the opposite operation, which does not apply to m2m devices.

I have tried the GStreamer v4l2videodec element with the coda driver and
noticed that GStreamer calls VIDIOC_CROPCAP to obtain the pixel aspect
ratio. This always fails with -EINVAL because of this issue. Currently GStreamer
throws a warning if the return value is an error other than -ENOTTY.

regards
Philipp
