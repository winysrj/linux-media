Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44076 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2DEUzL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Apr 2012 16:55:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SFthv-0004tN-Pi
	for linux-media@vger.kernel.org; Thu, 05 Apr 2012 22:55:03 +0200
Received: from lechon.iro.umontreal.ca ([132.204.27.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 22:55:03 +0200
Received: from monnier by lechon.iro.umontreal.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 22:55:03 +0200
To: linux-media@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Unknown eMPIA tuner
Date: Thu, 05 Apr 2012 15:30:07 -0400
Message-ID: <jwv4nsyx9pr.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just got a USB tuner ("HD TV ATSC USB stick") which lsusb describes as
"ID eb1a:1111 eMPIA Technology, Inc." and was wondering how to try to
get it working.

Would the em28xx driver be able to handle it?  If so, how should I modify
it to try it out?


        Stefan

