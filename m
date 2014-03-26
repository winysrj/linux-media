Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39623 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaCZEmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 00:42:25 -0400
Received: by mail-ob0-f174.google.com with SMTP id wo20so1808536obc.19
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 21:42:24 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Mar 2014 21:42:24 -0700
Message-ID: <CABMudhRSRQk2+HZNXo+Af=3Ob9h-n-CCA4y=7fXF2gKKAhr0HA@mail.gmail.com>
Subject: Question about 'flush' operation in v4l2 m2m driver framework
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I read this email thread regarding 'flush operation'in v4l2 m2m driver
framework:

http://www.spinics.net/lists/linux-media/msg42944.html

To implement a 'flush' operation, I should implement support for
'V4L2_DEC_CMD_STOP' command. Is my understanding correct?/

But my currently just implement 'stream_on/stream_off' function
callback, do I need to switch that to   V4L2_DEC_CMD_START' command?

If not, I find it weird that my driver implemention has support for
V4L2_DEC_CMD_STOP not V4L2_DEC_CMD_START (and user need to call
stream_on to start, stream_off to stop and V4L2_DEC_CMD_STOP for
'flush'

Thank you.
