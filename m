Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:59878 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaANPVN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 10:21:13 -0500
Message-ID: <52D554BA.3070906@unixsol.org>
Date: Tue, 14 Jan 2014 17:16:10 +0200
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: FE_READ_SNR and FE_READ_SIGNAL_STRENGTH docs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys, I'm confused the documentation on:

http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SNR
http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SIGNAL_STRENGTH

states that these ioctls return int16_t values but frontend.h states:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/dvb/frontend.h

#define FE_READ_SIGNAL_STRENGTH  _IOR('o', 71, __u16)
#define FE_READ_SNR              _IOR('o', 72, __u16)

So which one is true?

-- 
Georgi Chorbadzhiyski | http://georgi.unixsol.org/ | http://github.com/gfto/
