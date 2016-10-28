Return-path: <linux-media-owner@vger.kernel.org>
Received: from in.ti-gw.moria.de ([217.197.85.202]:44618 "EHLO mail.moria.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760627AbcJ1MUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 08:20:24 -0400
Received: from fangorn.moria.de ([2001:67c:1407:e1::2]:37622)
        by mail.moria.de with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.87 #2)
        id 1c063l-0007go-HD
        for linux-media@vger.kernel.org; Fri, 28 Oct 2016 14:14:57 +0200
Received: from michael by fangorn.moria.de with local (ID michael) (Exim 4.87 #2)
        id 1c063j-00071G-Hv
        for linux-media@vger.kernel.org; Fri, 28 Oct 2016 14:14:55 +0200
Date: Fri, 28 Oct 2016 14:14:55 +0200
To: linux-media@vger.kernel.org
Subject: Still images and v4l2?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1c063j-00071G-Hv@fangorn.moria.de>
From: Michael Haardt <michael@moria.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am currently developing a new image v4l2 sensor driver to acquire
sequences of still images and wonder how to interface that to the
v4l2 API.

Currently, cameras are assumed to deliver an endless stream of images
after being triggered internally with VIDIOC_STREAMON.  If supported by
the driver, a certain frame rate is used.

For precise image capturing, I need two additional features:

Limiting the number of captured images: It is desirable not having to stop
streaming from user space for camera latency.  A typical application
are single shots at random times, and possibly with little time in
between the end of one image and start of a new one, so an image that
could not be stopped in time would be a problem.  A video camera would
only support the limit value "unlimited" as possible capturing limit.
Scientific cameras may offer more, or possibly only limited capturing.

Configuring the capture trigger: Right now sensors are implicitly
triggered internally from the driver.  Being able to configure external
triggers, which many sensors support, is needed to start capturing at
exactly the right time.  Again, video cameras may only offer "internal"
as trigger type.

Perhaps v4l2 already offers something that I overlooked.  If not, what
would be good ways to extend it?

Regards,

Michael
