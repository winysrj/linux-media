Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.tele2bedrift.no ([193.216.69.194])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hakon@alstadheim.priv.no>) id 1K14eQ-0008A9-7V
	for linux-dvb@linuxtv.org; Tue, 27 May 2008 21:16:05 +0200
Received: from [192.168.2.99] (unknown [192.168.2.99])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by alstadheim.priv.no (Postfix) with ESMTP id 56C34A2744
	for <linux-dvb@linuxtv.org>; Tue, 27 May 2008 21:15:18 +0200 (CEST)
Message-ID: <483C5DC6.8030906@alstadheim.priv.no>
Date: Tue, 27 May 2008 21:15:18 +0200
From: =?ISO-8859-1?Q?H=E5kon_Alstadheim?= <hakon@alstadheim.priv.no>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Switching mono/stereo at runtime in saa7134
	(audio_ddep) ?
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

This might be OT, since it concerns the analog bits of the saa7134 
driver. If so I'd be grateful for directions to the correct forum.

My issue:
I experience a "warble" in the audio on some (weak) NICAM stereo 
channels. The only way to make the sound bareable is to load the kernel 
module with  audio_ddep=4 (I'm in Norway).  This disables the nicam 
sound and uses the old-fashioned mono. I'm wondering if there is a way 
to turn the NICAM sound back on selectively without disturbing my 
recording ? I.e. I would like the effect of reloading the  saa7134 
module without the audio_ddep option, without actually unloading the 
module.

This would of course be unneeded if the automatic switching between mono 
and stereo on a weak signal was a tiny bit less trigger-happy, 
suggestions for how to adjust the thresholds would of course be even better.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
