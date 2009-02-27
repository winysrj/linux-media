Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1695 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166AbZB0N1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 08:27:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Status of the go7007 driver
Date: Fri, 27 Feb 2009 14:27:24 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271427.25092.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just FYI, I also have a tree that merges the go7007 driver from the staging 
area into v4l-dvb: http://linuxtv.org/hg/~hverkuil/v4l-dvb-go7007/

This driver uses i2c modules and is not converted to v4l2_subdev. Since it 
is a staging driver I have also no plans right now to do that conversion, 
although I might revisit it in the future since I do have a go7007 device 
to test with.

If you are interested in getting it merged anyway, then I can make a pull 
request for it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
