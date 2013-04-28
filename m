Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34205 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3D1NrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 09:47:21 -0400
Received: by mail-wi0-f177.google.com with SMTP id hj19so1974855wib.10
        for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 06:47:20 -0700 (PDT)
Received: from chandler.localnet (193.Red-83-61-81.dynamicIP.rima-tde.net. [83.61.81.193])
        by mx.google.com with ESMTPSA id ej8sm14344528wib.9.2013.04.28.06.47.17
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 28 Apr 2013 06:47:19 -0700 (PDT)
From: "pestrac-linux" <pestraclinux@gmail.com>
To: linux-media@vger.kernel.org
Subject: Transpor error indicator in DVB-S (Hauppauge HVR-3000)
Date: Sun, 28 Apr 2013 15:47:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304281547.25917.pestraclinux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, i have a Happauge HVR-3000 and  i have problems tunning DVB-S channels.
Channels looks good only at times.
The instalation is ok because in  Windows works fine. 
Distro: Debian testing
Kernel: 3.2.0-4-amd64

VLC Debug:
s warning: discontinuity received 0xe instead of 0xd (pid=163)
ts debug: transport_error_indicator set (pid=163)
ts debug: transport_error_indicator set (pid=163)
ts debug: transport_error_indicator set (pid=163)
ts warning: discontinuity received 0x9 instead of 0x8 (pid=163)
ts debug: transport_error_indicator set (pid=163)
ts warning: discontinuity received 0xb instead of 0xa (pid=163)
ts debug: transport_error_indicator set (pid=163)

TVHeadend Debug:
mar 27 16:51:05 subscription: "HTTP" direct subscription to adapter: "Conexant 
CX24123/CX24109", network: "ASTRA 1", mux: "ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))", provider: "PRISA TV", service: "LTC", 
quality: 100
mar 27 16:51:06 TS: Conexant CX24123/CX24109/ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))/LTC: Transport error indicator, 475 
duplicate log lines suppressed
mar 27 16:51:07 TS: Conexant CX24123/CX24109/ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))/LTC: Transport error indicator, 501 
duplicate log lines suppressed
mar 27 16:51:08 TS: Conexant CX24123/CX24109/ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))/LTC: Transport error indicator, 599 
duplicate log lines suppressed
mar 27 16:51:09 TS: Conexant CX24123/CX24109/ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))/LTC: Transport error indicator, 626 
duplicate log lines suppressed
mar 27 16:51:10 TS: Conexant CX24123/CX24109/ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))/LTC: Transport error indicator, 651 
duplicate log lines suppressed
mar 27 16:51:11 TS: Conexant CX24123/CX24109/ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))/LTC: Transport error indicator, 720 
duplicate log lines suppressed
mar 27 16:51:12 TS: Conexant CX24123/CX24109/ASTRA 1: 10,758,000 kHz Vertical 
(Default (Port 0, Universal LNB))/LTC: Transport error indicator, 737 
duplicate log lines suppressed
