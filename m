Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:60560 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750821AbeBDNGr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 08:06:47 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: MEDIA_IOC_G_TOPOLOGY and pad indices
Message-ID: <336b3d54-6c59-d6eb-8fd8-e0a9677c7f5f@xs4all.nl>
Date: Sun, 4 Feb 2018 14:06:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I'm working on adding proper compliance tests for the MC but I think something
is missing in the G_TOPOLOGY ioctl w.r.t. pads.

In several v4l-subdev ioctls you need to pass the pad. There the pad is an index
for the corresponding entity. I.e. an entity has 3 pads, so the pad argument is
[0-2].

The G_TOPOLOGY ioctl returns a pad ID, which is > 0x01000000. I can't use that
in the v4l-subdev ioctls, so how do I translate that to a pad index in my application?

It seems to be a missing feature in the API. I assume this information is available
in the core, so then I would add a field to struct media_v2_pad with the pad index
for the entity.

Next time we add new public API features I want to see compliance tests before
accepting it. It's much too easy to overlook something, either in the design or
in a driver or in the documentation, so this is really, really needed IMHO.

Regards,

	Hans
