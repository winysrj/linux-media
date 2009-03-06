Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3653 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZCFOXG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 09:23:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: V4L2 spec
Date: Fri, 6 Mar 2009 15:23:15 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061523.15766.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I noticed that there is an ancient V4L2 spec in our tree in the v4l/API 
directory. Is that spec used in any way? I don't think so, so I suggest 
that it is removed.

The V4L1 spec that is there should probably be moved to the v4l2-spec 
directory as that is where people would look for it. We can just keep it 
there for reference.

The documentation on www.linuxtv.org is also out of date. How are we going 
to update that?

I think that a good schedule would be right after a kernel merge window 
closes. The spec at that moment is the spec for that new kernel and that's 
a good moment to update the website.

The current spec is really old, though, and should be updated asap.

Note that the specs from the daily build are always available from 
www.xs4all.nl/~hverkuil/spec. I've modified the build to upload the 
dvbapi.pdf as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
