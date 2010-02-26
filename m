Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb06fl.versatel.de ([89.246.255.250]:48365 "EHLO
	mxweblb06fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085Ab0BZQX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 11:23:56 -0500
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb06fl.versatel.de (8.13.1/8.13.1) with ESMTP id o1QGNs1o021933
	for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 17:23:54 +0100
Received: from cinnamon-sage.de (i577A4F45.versanet.de [87.122.79.69])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id o1QGNsT5023000
	for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 17:23:54 +0100
Received: from 192.168.23.2:49451 by cinnamon-sage.de for <linux-media@vger.kernel.org> ; 26.02.2010 17:23:54
Message-ID: <4B87F59A.7070006@cinnamon-sage.de>
Date: Fri, 26 Feb 2010 17:23:54 +0100
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx18: where do the transport stream PIDs come from?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

  while working on a small test app which repacks the ivtv-PS into a TS, I received a sample from a cx18-based card. The 
TS contains the video PID 301, audio PID 300 and PCR pid 101.

  Where do these PIDs come from, are they set by the driver or are they firmware given?
  Is it possible to change them?

Regards,
Lars.
