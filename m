Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from asmtp1.iomartmail.com ([62.128.201.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lawrence@softsystem.co.uk>) id 1LDMJM-0007B2-ET
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 18:05:21 +0100
Received: from asmtp1.iomartmail.com (localhost.localdomain [127.0.0.1])
	by asmtp1.iomartmail.com (8.12.11.20060308/8.12.8) with ESMTP id
	mBIH4kYd007807
	for <linux-dvb@linuxtv.org>; Thu, 18 Dec 2008 17:04:46 GMT
Received: from collins.softsystem.co.uk (230.229.98-84.rev.gaoland.net
	[84.98.229.230]) (authenticated bits=0)
	by asmtp1.iomartmail.com (8.12.11.20060308/8.12.11) with ESMTP id
	mBIH4jF4007789
	for <linux-dvb@linuxtv.org>; Thu, 18 Dec 2008 17:04:46 GMT
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: "Linux-dvb list" <linux-dvb@linuxtv.org>
Date: Thu, 18 Dec 2008 18:04:34 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812181804.34557.lawrence@softsystem.co.uk>
Subject: [linux-dvb] Nova-S-Plus audio line input
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

I have a Hauppauge Nova-S-plus PCI card and it works great with satellite 
reception.  However, I would also like to use it with an external DVB-T box  
that outputs composite video and line audio but when I select the composite 
video input I can see a picture but get no sound.

I'm using kernel version 2.6.24 so I dug around those sources and I see in 
cx88-cards.c that there's no provision for line audio in.  However, the 
latest v4l top of tree sources have added support for I2S audio input 
and 'audioroute's.

So I modded my 2.6.24 sources to support the external ADC and enable I2S audio 
input using the struct cx88_board cx88_boards.extadc flag, similar to the 
changes made in the current top of tree.  This now means that I can watch 
DVB-T :-)  I don't believe the changes affect any other cards.

I would like to see support added for the Nova-S-Plus audio line input in the 
kernel tree asap.  What's the best way of achieving this?  I can supply a 
diff for 2.6.24 or the current top of tree.

-- Lawrence Rust


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
