Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2964 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZBQHzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 02:55:42 -0500
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id n1H7taIK088449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 08:55:41 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Zoran progress update
Date: Tue, 17 Feb 2009 08:55:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170855.44878.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've been working on converting the zoran driver to video_ioctl2 and v4l2 
for the communication between the driver and i2c modules. It's a 
prerequisite for converting it to the latest i2c API.

Capturing is working (both raw video and mjpeg), and it looks like mjpeg 
output is working too (have to verify it by actually looking at the 
output :-) ).

My tree is here: www.linuxtv.org/hg/~hverkuil/v4l-dvb-zoran

If anyone else has a zoran card, then I'd love to get feedback!

Whether the V4L1 API will still work through the v4l1-compat layer is 
anyone's guess. I don't think I should spend time on that.

It will be a huge relieve to have this beast converted: besides the zoran 
driver itself there are an additional 11 affected i2c drivers (saa7111 and 
saa7114 are replaced by saa7115, though).

I hope to finish this weekend, after that there are only a few drivers left 
to fix and none of them are as hard as this one.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
