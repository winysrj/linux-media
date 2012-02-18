Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60288 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2BRP36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 10:29:58 -0500
Received: by eaah12 with SMTP id h12so1665248eaa.19
        for <linux-media@vger.kernel.org>; Sat, 18 Feb 2012 07:29:57 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 18 Feb 2012 20:59:57 +0530
Message-ID: <CANMsd02vLtdmrV-eHuBJ4SAc6PiYG8tw1+OvSXYAJ83zcoe7Hw@mail.gmail.com>
Subject: omap4 v4l media-ctl usage
From: Ryan <ryanphilips19@googlemail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello,
I am using media-ctl on the panda board. The sensor gets detected. But
media-ctl doesnt print anything.
The kernel is cloned from omap4 v4l git tree: commit id:
3bc023462a68f78bb0273848f5ab08a01b434ffa

what could be wrong in here?

~ # ./media-ctl -p
Opening media device /dev/media0
Enumerating entities
Found 0 entities
Enumerating pads and links
Device topology

What steps i need to follow get output from sensor in terms of
arguments to media-ctl and yavta.

Regards,
ryan
