Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52535 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2IITV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 15:21:58 -0400
Received: by eekc1 with SMTP id c1so666326eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 12:21:57 -0700 (PDT)
Message-ID: <1347218514.1641.4.camel@edge.config>
Subject: MFC Encode on S5PV210 hangs
From: Mike Dyer <mike.dyer@md-soft.co.uk>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Date: Sun, 09 Sep 2012 20:21:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm trying to use the MFC encoder to generate an H264 bitstream using
the V4L2 interface.  I've tried using my own application, and also the
example encode application here:
git://git.infradead.org/users/kmpark/public-apps

Both exhibit the same behavior.  Input frames are queued up until the
input queue is full, but only one frame is emitted (which I guess is the
H264 header).  The encoder then just sits there.

I'm not sure where to start looking, so any advice is appreciated.

Cheers,
Mike

