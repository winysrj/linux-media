Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1285 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZA2IvS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 03:51:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Merging the v4l2 spec?
Date: Thu, 29 Jan 2009 09:51:04 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290951.04874.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Is it possible to merge the v4l2 spec from my tree soon? With all the 
various new API additions that are being discussed it would help a lot if 
they can also make patches against the documentation at the same time.

BTW, I'm working on improving the qv4l2 tool to make it much more useful for 
testing. I'm integrating it with the v4lconvert lib and added capture 
support as well. It should become a proper testbench for drivers. All the 
other tools around are really crappy, so I decided to extend qv4l2 instead.

I've also bought a bunch of old hardware from ebay. I should be able to test 
various old v4l1 drivers and convert them to v4l2. I basically want to be 
able to test pretty much the whole v4l2 API, preferably with qv4l2. 
Yesterday two webcams came in, so I can now test w9968cf and se401.

Check out my qv4l2 tree for progress on this tool!

Now all I need is lots more time :-(

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
