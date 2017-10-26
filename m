Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:41704 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932309AbdJZQLd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 12:11:33 -0400
From: Daniel Mack <daniel@zonque.org>
Subject: camss: camera controls missing on vfe interfaces
To: Todor Tomov <todor.tomov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>
Message-ID: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
Date: Thu, 26 Oct 2017 18:11:31 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

When using the camss driver trough one of its /dev/videoX device nodes,
applications are currently unable to see the video controls the camera
sensor exposes.

Same goes for other ioctls such as VIDIOC_ENUM_FMT, so the only valid
resolution setting for applications to use is the one that was
previously set through the media controller layer. Applications usually
query the available formats and then pick one using the standard V4L2
APIs, and many can't easily be forced to use a specific one.

If I'm getting this right, could you explain what's the rationale here?
Is that simply a missing feature or was that approach chosen on purpose?


Thanks,
Daniel
