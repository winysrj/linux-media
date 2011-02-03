Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2484 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab1BCQGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Feb 2011 11:06:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firedtv and removal of old IEEE1394 stack
Date: Thu, 3 Feb 2011 17:06:12 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102031706.12714.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stefan,

I discovered (somewhat to my surprise) that the IEEE1394 stack was removed
from the kernel in 2.6.37. Your commit 66fa12c571d35e3cd62574c65f1785a460105397
indicates that the ieee1394 firedtv code can be removed in an indepedent commit.

It seems that this was forgotten since the firedtv-1394.c source is still
present.

Is it OK if I remove it? I assume that anything that depends on DVB_FIREDTV_IEEE1394
can be deleted.

It would be nice to remove this since building the firedtv driver for older kernels
always gives problems on ubuntu due to some missing ieee1394 headers.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
