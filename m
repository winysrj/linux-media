Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:52403 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCLJYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:24:14 -0400
Received: by bwz26 with SMTP id 26so96301bwz.37
        for <linux-media@vger.kernel.org>; Thu, 12 Mar 2009 02:24:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Mar 2009 10:24:11 +0100
Message-ID: <23be820f0903120224k332742a0ue0178a7468df6850@mail.gmail.com>
Subject: disable v4l2-ctl logging --log-status in /var/log/messages
From: Gregor Fuis <gujs.lists@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Is it possible to disable v4l2-ctl aplication logging into /var/log/messages.
I am using it to control and monitor my PVR 150 cards and every time I
run v4l2-ctl -d /dev/video0 --log-status all output is logged into
/var/log/messages and some other linux log files.

Best Regards,
Gregor
