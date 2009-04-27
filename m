Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xsmtp12.mail2web.com ([168.144.250.177])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mikeparkins@pop.ntlworld.com>) id 1LyR4D-0004iL-Ny
	for linux-dvb@linuxtv.org; Mon, 27 Apr 2009 15:40:18 +0200
Received: from [168.144.108.42] (helo=M2W042.mail2web.com)
	by xsmtp12.mail2web.com with smtp (Exim 4.63)
	(envelope-from <mikeparkins@pop.ntlworld.com>) id 1LyR2S-00023W-95
	for linux-dvb@linuxtv.org; Mon, 27 Apr 2009 09:38:43 -0400
Message-ID: <380-220094127133828254@M2W042.mail2web.com>
From: "mikeparkins@pop.ntlworld.com" <mikeparkins@pop.ntlworld.com>
To: linux-dvb@linuxtv.org
Date: Mon, 27 Apr 2009 09:38:28 -0400
MIME-Version: 1.0
Subject: [linux-dvb] Nova HD S2 problem
Reply-To: linux-media@vger.kernel.org, mikeparkins@ntlworld.com
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

Hi, I hope someone can help me get this card working.

I am using Mandriva Linux 2009.1 with 2.6.29.1 kernel. My Hauppauge Nova HD
S2 (which I understand is known as an HVR4000lite in the DVB API) is not
recognised on boot. Using lspci I see the vendor/device code is 0070:4096,
whereas the API code (in cx88-cards.c) appears to expect 0070:6096 for this
card.

Can anyone clue me in?
Mike.

--------------------------------------------------------------------
mail2web - Check your email from the web at
http://link.mail2web.com/mail2web



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
