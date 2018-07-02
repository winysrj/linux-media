Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:55381 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933498AbeGBISk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 04:18:40 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Make entity to interface links immutable
Message-ID: <354b01c0-6825-4302-a1f4-d120cf8c34e3@xs4all.nl>
Date: Mon, 2 Jul 2018 10:18:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While working on v4l2-compliance I noticed that entity to interface links
have just the MEDIA_LNK_FL_ENABLED flag set.

Shouldn't we also set the MEDIA_LNK_FL_IMMUTABLE? After all, you cannot change
an entity-interface link. It feels inconsistent not to have this flag.

I also propose that media_create_intf_link() drops the last flags argument:
it can set the link flags directly since they are always the same anyway.

Regards,

	Hans
