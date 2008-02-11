Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from web33115.mail.mud.yahoo.com ([209.191.69.145])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JOfaa-0002Wi-VZ
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 21:49:21 +0100
Date: Mon, 11 Feb 2008 12:47:40 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <197907.77856.qm@web33115.mail.mud.yahoo.com>
Subject: [linux-dvb] mantis vp1041 with strange diseqc rotor commands
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I am using the latest mantis drivers from Manu's repository:
http://jusst.de/hg/mantis/
with my Azureware twinhan vp1041 based card.
Locking to DVB-S channels works fine almost all the time with the patched szap or patched mythtv.
Did not try DVB-S2 yet. But what I am having troubles now is the diseqc. I have a switch behind a diseqc 1.2 rotor (goto stored positions).
The switching works fine under Windoz. I have no problems also using it with my other card in the same box - Twinhan 102g.
Initially with the vp1041 card after a couple of diseqc commands I would get stb0899_diseqc_fifo_empy timeout. It turned out that I had to use some very long pauses before sending a repeat command. If 
for the 102g standart 15ms worked fine, for the vp1041 I had to use 1s! pause. Then the rotor will start
 moving very slowly with small steps  - as if it is does one step , stops and then continues to the desired position.If one is patient enough the rotor gets to the desired position. I checked using voltmeter the voltages that come out of the card and they seem to be good. For sending the commands I used both mythtv and hacked version of Michel Verbraak's gotox program.
Has anyone experienced something similar with stb0899 frontend? Perhaps you can give me an idea what might be going wrong?

Thanks,
Simeon





      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
