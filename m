Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:39997 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1EEKVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 06:21:11 -0400
Received: from metzlerbros.de
	(ip-62-143-72-211.unitymediagroup.de [62.143.72.211])
	by post.strato.de (klopstock mo28) (RZmta 25.17)
	with ESMTPA id 305d97n459E3RH for <linux-media@vger.kernel.org>;
	Thu, 5 May 2011 12:21:09 +0200 (MEST)
Received: from rjkm by morden with local (Exim 4.71 #1 (Debian))
	id 1QHvgD-00009V-34
	for <linux-media@vger.kernel.org>; Thu, 05 May 2011 12:21:09 +0200
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19906.31252.838100.862025@morden.metzler>
Date: Thu, 5 May 2011 12:21:08 +0200
To: linux-media@vger.kernel.org
Subject: multiple delivery systems in one device
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

since it seems devices with several delivery systems can be queried 
with one command:

Andreas Oberritter writes:
 > > Of course it does since it is not feasible to use the same adapter
 > > number even on the same card when it provides multi-standard 
 > > frontends which share dvr and demux devices. E.g., frontend0 and
 > > frontend1 can belong to the same demod which can be DVB-C and -T 
 > > (or other combinations, some demods can even do DVB-C/T/S2). 
 > 
 > There's absolutely no need to have more than one frontend device per
 > demod. Just add two commands, one to query the possible delivery systems
 > and one to switch the system. Why would you need more than one device
 > node at all, if you can only use one delivery system at a time?

can somebody tell me how this is done and how it has to be supported
in the demod driver?

All I could find regarding this is

http://www.linuxquestions.org/questions/linux-kernel-70/dvb-adapter-driver-dvb-c-dvb-t-switching-linux-dvb-api-v5-803503/


Regards,
Ralph
