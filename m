Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:45837 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727499AbeJEC5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 22:57:21 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: s5p_mfc and H.264 frame cropping question
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <5eebb2ed-8f58-84c3-6589-a2579c0004dd@xs4all.nl>
Date: Thu, 4 Oct 2018 22:02:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm looking at removing the last users of vidioc_g/s_crop from the driver and
I came across vidioc_g_crop in drivers/media/platform/s5p-mfc/s5p_mfc_dec.c.

What this really does AFAICS is return the H.264 frame crop as read from the
bitstream. This has nothing to do with regular cropping/composing but it might be
something that could be implemented as a new selection target.

I'm not really sure what to do with the existing code since it is an abuse of
the crop API, but I guess the first step is to decide how this should be handled
properly.

Are there other decoders that can retrieve this information? Should this be
mentioned in the stateful codec API?

Regards,

	Hans
