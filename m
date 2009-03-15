Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3870 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZCOMXr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 08:23:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: REVIEW: bttv conversion to v4l2_subdev
Date: Sun, 15 Mar 2009 13:24:00 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151324.00784.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you review my ~hverkuil/v4l-dvb-bttv2 tree?

It converts this driver to v4l2_subdev, and as far as I can see it works and 
should probe all the different audio devices in the correct and safe order.

I kept things as simple as possible in order to make a review easy.

There is only one possible i2c conflict left between tvaudio and ir-kbd-i2c, 
but I'll discuss that separately since we need input from Jean Delvare as 
well on that.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
