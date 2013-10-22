Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57241 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab3JVIYq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Oct 2013 04:24:46 -0400
Received: from [192.168.0.22] ([79.215.129.78]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LfTC1-1W5u9k186j-00p2Lh for
 <linux-media@vger.kernel.org>; Tue, 22 Oct 2013 10:24:45 +0200
Message-ID: <52663659.3040205@gmx.net>
Date: Tue, 22 Oct 2013 10:24:57 +0200
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: NAS for recording DVB-S2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I want my NAS to record from USB DVB-S2.

It will be a Netgear ReadyNAS 102 or 104.
It has got an ARM HL cpu, so do the DVB drivers in general work on ARM
systems?

I compared prices and supported devices list.
The result is:
I should buy either a Tevii S660 or a Terratec Cynergy S2 Stick.

I don't want to have another power supply, so I am going to "steal" the
power from the nas somehow.
The Tevii uses 7,5 V which is odd...
I cannot find the voltage the Terratec requires. Does anyone own one?

Is Terratec a good choice regarding drivers?

I am going to compile the kernel myself because no builds are available
for the ReadyNAS.
There is a guy who already put the patches for the ReadyNAS DuoV2
upstream into kernel 3.10: http://natisbad.org/
Currently he is working on the 102/104...
unlike me, HE knows what he is doing ;)

thanks,

Jan
