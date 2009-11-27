Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.176.161.3] (helo=deuromedia.de)
	by mail.linuxtv.org with smtp (Exim 4.69)
	(envelope-from <Doru.Marin@Deuromedia.ro>) id 1NE2Ee-0007iX-Ca
	for linux-dvb@linuxtv.org; Fri, 27 Nov 2009 15:55:48 +0100
Message-ID: <4B0FE7AC.3000002@Deuromedia.ro>
Date: Fri, 27 Nov 2009 16:52:28 +0200
From: Doru Marin <Doru.Marin@Deuromedia.ro>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Media-Pointer MP-S2 DVB-S2 tuning problem
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hello,

I tested the experimental driver for Media-Pointer MP-S2 PCIe card and I
got very strange timeouts for tunning.
It takes five seconds or more to tune on a channel. By comparison with
nGene driver (which tunes faster), this is terrible long time.
For demodulation, it uses the same STV0900 demodulator like NetUP Dual
Tuner cards.
I'm curious, on NetUP devices, the timeout is similar ?
Can be done anything to improve that ?

Best regards,

Doru Marin



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
