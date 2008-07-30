Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2e.orange.fr ([80.12.242.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ktangao-neli@orange.fr>) id 1KOBp9-0003lu-K9
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 15:34:40 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2e11.orange.fr (SMTP Server) with ESMTP id 689B57000094
	for <linux-dvb@linuxtv.org>; Wed, 30 Jul 2008 15:34:06 +0200 (CEST)
Received: from [192.168.1.107] (ARennes-252-1-16-238.w83-195.abo.wanadoo.fr
	[83.195.167.238])
	by mwinf2e11.orange.fr (SMTP Server) with ESMTP id 46610700008B
	for <linux-dvb@linuxtv.org>; Wed, 30 Jul 2008 15:34:06 +0200 (CEST)
Message-ID: <48906DCF.6020300@orange.fr>
Date: Wed, 30 Jul 2008 15:34:07 +0200
From: TANGAo Khaled <ktangao-neli@orange.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] the function " int ioctl(int fd, int request =
 FE_READ_SNR, int16_t *snr); "
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

Hello.

   I am working to design a software and i am using Frontend APIs. But I 
still have a big problem witch, i do not understand. I want to know the 
unit (linear or dB) of the value returned by this function:

int ioctl(int fd, int request = FE_READ_SNR, int16_t *snr);

 I would like to display an information to the user of my program,about 
the quality of the signal his antenna picked up. To do this, i think the 
best way is to display a graphic representing a percentage. But the 
current value I read, (-258) is unusable like this. So can you please, 
give me the unit of the value or give me a link to find what i am seeking?

Thank you

-- 
Khaled TANGAO


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
