Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38893 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727659AbeIGTQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 15:16:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFP] Stateless Codec Userspace Support
Message-ID: <ae73ad59-af82-040c-ec89-b8defd8e312c@xs4all.nl>
Date: Fri, 7 Sep 2018 16:34:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for stateless codecs and Request API will hopefully be merged for
4.20, and the next step is to discuss how to organize the userspace support.

Hopefully by the time the media summit starts we'll have some better ideas
of what we want in this area.

Some userspace support is available from bootlin for the cedrus driver:

  - v4l2-request-test, that has a bunch of sample frames for various
    codecs and will rely solely on the kernel request api (and DRM for
    the display part) to test and bringup a particular driver
    https://github.com/bootlin/v4l2-request-test

  - libva-v4l2-request, that is a libva implementation using the
    request API
    https://github.com/bootlin/libva-v4l2-request

But this is more geared towards testing and less a 'proper' implementation.

I don't know yet how much time to reserve for this discussion. It's a
bit too early for that. I would expect an hour minimum, likely more.

Regards,

	Hans
