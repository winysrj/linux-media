Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout03.t-online.de ([194.25.134.81]:59493 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2BFHmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 02:42:37 -0500
Message-ID: <4F2F845E.3060700@t-online.de>
Date: Mon, 06 Feb 2012 08:42:22 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [BUG 3.3-rc2] Hauppauge WinTV Nova-HD-S2 broken
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-S TV and radio reception is broken with kernel 3.3-rc2 and kaffeine 1.2.2,
it works perfectly with kernel 3.2.4.

video: distorted, only 1-2 fps
audio: distorted
system load: significantly reduced

software:
========
kernel: 3.3-rc2 (current git master)
Xorg : X.Org X Server 1.11.99.902 (1.12.0 RC 2) (current git master)
dvb-fe-cx24116.fw: version 1.26.90.0

hardware:
========
AOpen i915GMm-hfs, Pentium M Dothan, 2MHz, 2GB RAM,
Hauppauge WinTV Nova-HD-S2

cu,
  Knut
