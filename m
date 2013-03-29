Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f194.google.com ([74.125.82.194]:42855 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3C2UgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 16:36:08 -0400
Received: by mail-we0-f194.google.com with SMTP id d46so181141wer.1
        for <linux-media@vger.kernel.org>; Fri, 29 Mar 2013 13:36:07 -0700 (PDT)
From: "pestrac-linux" <pestraclinux@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Subject: Transpor error indicator in DVB-S (Hauppauge HVR-3000)
Date: Fri, 29 Mar 2013 21:36:03 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303292136.03726.pestraclinux@gmail.com>
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

 
