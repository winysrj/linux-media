Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static.135.41.46.78.clients.your-server.de ([78.46.41.135]
	helo=hetzner.kompasmedia.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bas@kompasmedia.nl>) id 1JlVdI-0004eI-5U
	for linux-dvb@linuxtv.org; Mon, 14 Apr 2008 22:50:33 +0200
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Mon, 14 Apr 2008 22:50:28 +0200
From: Bas v.d. Wiel <bas@kompasmedia.nl>
Message-ID: <bf9a9c0dd71fe6e733de49fd916fe4eb@localhost>
Subject: [linux-dvb] Mantis 2033 change tuner
Reply-To: bas@kompasmedia.nl
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


Hello all,
As I got no response to my question about changing tuner chips on Mantis
cards (I have one with chip ID 0x7d which I read about earlier), I started
experimenting with the sources from jusst.de. I changed mantis_dvb.c in a
crude way by simply copying the contents of a case statement for a Mantis
2040 to the one for the 2033 and commenting out the original 2033 block
that loads the tda10021.

To my surprise this compiled without any trouble and everything gets loaded
and recognized without error upon next bootup, including the tda10023.
However, as I expected, something crashes in a very bad way when I actually
try to use the tuner with dvb-scan. Am I doing something wrong? Or is my
card simply not supported (yet) by the mantis driver (too new maybe)?

Thanks in advance for any help!

Bas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
