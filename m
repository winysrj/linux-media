Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37579 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752263AbZAJPpr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 10:45:47 -0500
From: Malte Gell <malte.gell@gmx.de>
To: linux-media@vger.kernel.org
Subject: dvb-t: searching for channels
Date: Sat, 10 Jan 2009 16:45:50 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101645.51230.malte.gell@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I just purchased a Hauppauge Nova DVB-T USB stick and the kernel module and 
firmware recognizes it well. I have first used Kaffeine to search for channels, 
but it has found none. 

To be sure I even bought a better, an active dvb-t antenna with a 20dB 
amplifier. And now I used dvbscan to scan for channels, I invoked it like this:

dvbscan -out channels /usr/share/dvb/dvb-t/de-Mannheim

Is this the better way? It takes now longer than 15 minutes, is this normal? 
Is dvbscan more reliable than kaffeine for searching for channels? If I still 
find no channels, what could be the cause? In my region dvb-t signals are said 
to be not too well.

thanx
Malte

