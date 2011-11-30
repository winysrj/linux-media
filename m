Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:49492 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1K3RKA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:10:00 -0500
Message-ID: <4ED65C46.20502@netup.ru>
Date: Wed, 30 Nov 2011 19:39:34 +0300
From: Abylay Ospan <aospan@netup.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: LinuxTV ported to Windows
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

We have ported linuxtv's cx23885+CAM en50221+Diseq to Windows OS (Vista, 
XP, win7 tested). Results available under GPL and can be checkout from 
git repository:
https://github.com/netup/netup-dvb-s2-ci-dual

Binary builds (ready to install) available in build directory. Currently 
NetUP Dual DVB-S2 CI card supported ( 
http://www.netup.tv/en-EN/dual_dvb-s2-ci_card.php ).

Driver based on Microsoft BDA standard, but some features (DiSEqC, CI) 
supported by custom API, for more details see netup_bda_api.h file.

Any comments, suggestions are welcome.

-- 
Abylai Ospan<aospan@netup.ru>
NetUP Inc.

