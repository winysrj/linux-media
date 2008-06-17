Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1K8bln-0001qw-VC
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 16:02:50 +0200
Received: from [192.168.0.188] (89.97.249.170) by relay-pt3.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4856F0B5000074CD for linux-dvb@linuxtv.org;
	Tue, 17 Jun 2008 16:02:42 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Tue, 17 Jun 2008 16:03:27 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806171603.27766.Nicola.Sabbi@poste.it>
Subject: [linux-dvb] Lifeview Trio remote control: keys being read but even
	not notified?
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
trying the patch for the remote control of the Lifeview Trio I 
encountered a curious situation:
using printk() I can see that the function that reads the keypresses
actually reads and returns the keys, but running

$ cat /dev/input/ir 

doesn't print anything at all when I press the buttons.
Of course lirc doesn't work, either.

cat on all other eventN devices works well.

Is there some other code that needs to be added to that patch?

P.S. Lifeview seems to have closed the doors and its site.
Does anyone have a link to a recent mirror of their drivers
and application for windows, please?

Thanks,
              Nico

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
