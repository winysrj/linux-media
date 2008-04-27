Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtprelay03.ispgateway.de ([80.67.18.15])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kiu@gmx.net>) id 1JqCVn-0003E6-UY
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 21:26:12 +0200
Received: from [62.216.212.3] (helo=blacksheep.qnet)
	by smtprelay03.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <kiu@gmx.net>) id 1JqCVk-00031n-JQ
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 21:26:08 +0200
Message-ID: <20080427212607.csw7xwh9wcsw04cw@blacksheep.qnet>
Date: Sun, 27 Apr 2008 21:26:07 +0200
From: kiu <kiu@gmx.net>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] TerraTec Cinergy C - tuning fails/freezes
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi List,

i have a TerraTec Cinergy C DVB-C PCI Card in my mythbuntu 8.04 pc.

After compiling the mantis driver (http://jusst.de/hg/mantis) the card
is recognized by the kernel. perfect!

If i now run

w_scan -fc -x -vvvv

it searches for QAM64 and QAM256 and finds some signals there. After  
it is finished, it tries to tune in the channels and freezes with this  
message (same happens with (dvb)scan):

tune to:
tuning status == 0x1f
add_filter:1388: add filter pid 0x0000 start_filter:1334: start filter  
pid 0x0000 table_id 0x00

Any hints for debugging/fixing it my issues ?

Btw, i also encountered a segfault once. If it happens again i will post it...

TIA!
-- 
kiu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
