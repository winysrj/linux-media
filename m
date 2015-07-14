Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:36642 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbGNDvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 23:51:07 -0400
Received: by ykay190 with SMTP id y190so56965042yka.3
        for <linux-media@vger.kernel.org>; Mon, 13 Jul 2015 20:51:06 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jul 2015 20:51:06 -0700
Message-ID: <CAFP0Ok97sA5bOVczsy_zmr5v+rqxKKMzRX8Ed8yK1U3MQVyRNg@mail.gmail.com>
Subject: file permissions for a video device
From: karthik poduval <karthik.poduval@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I was working with a USB camera. As soon as I plug it into the host,
it probes and video device node gets created with the following
permission.
# ll /dev/video0
crw------- root     root      81,   0 2015-07-13 20:39 video0


However it grants permissions to only a root user. I need to be able
to access this device node from a daemon (running in a non root user
account).

I can ofcourse chmod the devnode, but was wondering if there is a way
this can be done from the kernel itself ? Is there some place in the
uvc code which sets the created the devnode file permissions ?

-- 
Regards,
Karthik Poduval
