Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <rankincj@yahoo.com>) id 1KkIEp-0004rA-Hf
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 14:52:34 +0200
Date: Mon, 29 Sep 2008 05:51:56 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <667280.79255.qm@web52909.mail.re2.yahoo.com>
Subject: Re: [linux-dvb] Hauppauge DVB USB2 Nova-TD stick has a new remote
	control.
Reply-To: rankincj@yahoo.com
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

> i.e. the same as for the 0x1E and 0x1F blocks used by older
> Hauppauge-supplied remote controls.

Not quite. This new 0x1D block has only 35 buttons, whereas the 0x1E variant currently in the kernel has 45 buttons. But it doesn't matter: the new remote just won't work without the 0x1D block.

Cheers,
Chris



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
