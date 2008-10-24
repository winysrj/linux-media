Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <superjem.fr@gmail.com>) id 1KtKcy-0005Py-Vk
	for linux-dvb@linuxtv.org; Fri, 24 Oct 2008 13:14:49 +0200
Received: by nf-out-0910.google.com with SMTP id g13so355612nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 24 Oct 2008 04:14:45 -0700 (PDT)
Message-ID: <f23213140810240414k7bdd9dc2s2d9126fddbe2c3fa@mail.gmail.com>
Date: Fri, 24 Oct 2008 13:14:44 +0200
From: superjem <superjem.fr@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] dvbstream + Technotrend S-1500 + CI CAM for pay TV
	don't work.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2017396805=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2017396805==
Content-Type: multipart/alternative;
	boundary="----=_Part_6335_24737833.1224846885381"

------=_Part_6335_24737833.1224846885381
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I use a Technotrend S-1500 + CI CAM for pay TV + dvbstream to record ts
stream on an ubuntu hardy server.
I can record ts from non-scambled programs but not from scrambled programs.
descrambeling doesn't work.

Part of my dmesg :

[   28.895851] saa7146: register extension 'budget_ci dvb'.
[   28.895903] saa7146: found saa7146 @ mem ffffc200004fe400 (revision 1,
irq 20) (0x13c2,0x1017).
[   28.895907] saa7146 (0): dma buffer size 192512
[   28.895908] DVB: registering new adapter (TT-Budget/S-1500 PCI)
[   28.955156] adapter has MAC addr = 00:d0:5c:64:b6:dd
[   28.955365] input: Budget-CI dvb ir receiver saa7146 (0) as
/devices/pci0000:00/0000:00:1e.0/0000:05:05.0/input/input4
[   29.044072] budget_ci: CI interface initialised
[   29.233781] dvb_ca adapter 0: DVB CAM detected and initialised
successfully
[   29.307354] DVB: registering frontend 0 (ST STV0299 DVB-S)...

How can I record scrambled programs in command line with dvbstream (or
other) ?

Thanks !

------=_Part_6335_24737833.1224846885381
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,<br><br>I use a Technotrend S-1500 + CI CAM for pay TV + dvbstream to record ts stream on an ubuntu hardy server.<br>I can record ts from non-scambled programs but not from scrambled programs. descrambeling doesn&#39;t work.<br>
<br>Part of my dmesg :<br><br>[&nbsp;&nbsp; 28.895851] saa7146: register extension &#39;budget_ci dvb&#39;.<br>[&nbsp;&nbsp; 28.895903] saa7146: found saa7146 @ mem ffffc200004fe400 (revision 1, irq 20) (0x13c2,0x1017).<br>[&nbsp;&nbsp; 28.895907] saa7146 (0): dma buffer size 192512<br>
[&nbsp;&nbsp; 28.895908] DVB: registering new adapter (TT-Budget/S-1500 PCI)<br>[&nbsp;&nbsp; 28.955156] adapter has MAC addr = 00:d0:5c:64:b6:dd<br>[&nbsp;&nbsp; 28.955365] input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00:1e.0/0000:05:05.0/input/input4<br>
[&nbsp;&nbsp; 29.044072] budget_ci: CI interface initialised<br>[&nbsp;&nbsp; 29.233781] dvb_ca adapter 0: DVB CAM detected and initialised successfully<br>[&nbsp;&nbsp; 29.307354] DVB: registering frontend 0 (ST STV0299 DVB-S)...<br><br>How can I record scrambled programs in command line with dvbstream (or other) ?<br>
<br>Thanks !<br><br><br>

------=_Part_6335_24737833.1224846885381--


--===============2017396805==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2017396805==--
