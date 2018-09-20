Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41800 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730984AbeITU0J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 16:26:09 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFP] Which V4L2 ioctls could be replaced by better versions?
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
Date: Thu, 20 Sep 2018 16:42:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some parts of the V4L2 API are awkward to use and I think it would be
a good idea to look at possible candidates for that.

Examples are the ioctls that use struct v4l2_buffer: the multiplanar support is
really horrible, and writing code to support both single and multiplanar is hard.
We are also running out of fields and the timeval isn't y2038 compliant.

A proof-of-concept is here:

https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95549df06d9900f3559afdbb9da06bd4b22d1f3

It's a bit old, but it gives a good impression of what I have in mind.

Another candidate is VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAMEINTERVALS:
expressing frame intervals as a fraction is really awkward and so is the fact
that the subdev and 'normal' ioctls are not the same.

Would using nanoseconds or something along those lines for intervals be better?

I have similar concerns with VIDIOC_SUBDEV_ENUM_FRAME_SIZE where there is no
stepwise option, making it different from VIDIOC_ENUM_FRAMESIZES. But it should
be possible to extend VIDIOC_SUBDEV_ENUM_FRAME_SIZE with stepwise support, I
think.

Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps, again in
order to improve single vs multiplanar handling.

It is not the intention to come to a full design, it's more to test the waters
so to speak.

Regards,

	Hans
