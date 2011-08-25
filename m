Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1680 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1HYMZw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 08:25:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Subject: radio-si470x-usb.c warning: can I remove 'buf'?
Date: Thu, 25 Aug 2011 14:25:37 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251425.37536.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tobias,

While going through the compile warnings generated in the daily build I came
across this one:

v4l-dvb-git/drivers/media/radio/si470x/radio-si470x-usb.c: In function 'si470x_int_in_callback':
v4l-dvb-git/drivers/media/radio/si470x/radio-si470x-usb.c:398:16: warning: variable 'buf' set but not used [-Wunused-but-set-variable]

The 'unsigned char buf[RDS_REPORT_SIZE];' is indeed unused, but can I just
remove it? There is this single assignment to buf: 'buf[0] = RDS_REPORT;'.

This makes me wonder if it is perhaps supposed to be used after all.

Please let me know if I can remove it, or if it is a bug that someone needs
to fix.

Regards,

	Hans
