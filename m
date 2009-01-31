Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.ammma.de ([213.83.39.131] helo=ammma.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan@horde.org>) id 1LTEGa-00030e-0M
	for linux-dvb@linuxtv.org; Sat, 31 Jan 2009 12:44:04 +0100
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n0VBjRI25455
	for <linux-dvb@linuxtv.org>; Sat, 31 Jan 2009 12:45:27 +0100
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id
	n0VBhx86014156
	for <linux-dvb@linuxtv.org>; Sat, 31 Jan 2009 12:43:59 +0100
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id E29793E8414
	for <linux-dvb@linuxtv.org>; Sat, 31 Jan 2009 12:43:58 +0100 (CET)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rHI5-zYgirNs for <linux-dvb@linuxtv.org>;
	Sat, 31 Jan 2009 12:43:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 41437431DAC
	for <linux-dvb@linuxtv.org>; Sat, 31 Jan 2009 12:43:51 +0100 (CET)
Message-ID: <20090131124351.169513hbsz3js5fk@neo.wg.de>
Date: Sat, 31 Jan 2009 12:43:51 +0100
From: Jan Schneider <jan@horde.org>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Technotrend C-2300 and CAM
Reply-To: linux-media@vger.kernel.org
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

Hi,

for some reason, my CAM (Alphacrypt Classic) doesn't seem to be  
detected by my Technotrend C-2300/CI combination. There is nothing in  
the kernel log/syslog when inserting or removing the card. I updated  
the card to the latest firmware (3.18) to no avail.
I don't even know where to start debugging. No windows here, so I  
can't really tell whether this is a hardware problem.
Any hints on where to start looking would help. The combination seems  
to work fine for almost everybody, beside one single thread on this  
list in 2007 that didn't come to a conclusion either.

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
