Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from protos.home-lan.co.uk ([81.23.52.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <john@ost-linux.co.uk>) id 1KVlTL-0001jz-M8
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 13:03:29 +0200
Received: from localhost.localdomain
	(92-232-227-192.cable.ubr08.shef.blueyonder.co.uk [92.232.227.192])
	by protos.home-lan.co.uk (8.13.8/8.13.8) with ESMTP id m7KB3JRb012289
	for <linux-dvb@linuxtv.org>; Wed, 20 Aug 2008 12:03:20 +0100
Message-ID: <48ABF856.504@ost-linux.co.uk>
Date: Wed, 20 Aug 2008 11:56:22 +0100
From: John Brown <john@ost-linux.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Max DVB frontends
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

Is the a maximum number of dvb frontends.  As I can't get more the 8 to 
register, all the devices work separately but after the 8th device 
registers calls to dvb_register_adapter() fail with errno -23.  If there 
is a set limit is there away to change it a run time, or is it a matter 
of altering some defines and rebuilding the kernel. If some one could 
point me in the correct direction I would appreciate it as much googling 
has turned up no useful leads.

John Brown

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
