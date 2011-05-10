Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:56265 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab1EJXaH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 19:30:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QJwNR-0003Oc-6o
	for linux-media@vger.kernel.org; Wed, 11 May 2011 01:30:05 +0200
Received: from 213.137.58.124 ([213.137.58.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 May 2011 01:30:05 +0200
Received: from root by 213.137.58.124 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 May 2011 01:30:05 +0200
To: linux-media@vger.kernel.org
From: Doychin Dokov <root@net1.cc>
Subject: TT S2-3650CI problems with high-SR DVB-S2 transponders
Date: Wed, 11 May 2011 02:24:43 +0300
Message-ID: <iqchgm$os9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I've been trying to get TechnoTrend S2-3650CI running with DVB-S2 
transponder with SR of 30000. I'm using stock Debian 6 kernel 
2.6.32-5-amd64 and s2-liplianin tree.

Initially, the device couldn't lock the 30K transponders at all. After 
applying patch [1], it locks without any problems, and does so very fast:
sat 0, frequency 11632 MHz V, symbolrate 30000000, coderate auto, 
rolloff 0.35
vpid 0x1fff, apid 0x1fff, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 1b | signal 05aa | snr 0023 | ber 00516155 | unc fffffffe | 
FE_HAS_LOCK
This happens each and every time I try. So far, so good, but when I'm 
trying to stream a PID with dvblast, I get lots of TS discontinuities. 
It does read the NIT and PAT fine, but nothing else is nearly-usable.

I've then tried the STB6100 patch [2], but it does not seem to do any 
help in this case.

Any ideas?

