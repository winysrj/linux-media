Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.245])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greg.d.thomas@gmail.com>) id 1KFzMZ-0000EW-3A
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 00:39:16 +0200
Received: by an-out-0708.google.com with SMTP id c18so945832anc.125
	for <linux-dvb@linuxtv.org>; Mon, 07 Jul 2008 15:39:09 -0700 (PDT)
Message-ID: <e28a31000807071539r22085adwd9a820e4de25952@mail.gmail.com>
Date: Mon, 7 Jul 2008 23:39:09 +0100
From: "Greg Thomas" <Greg@TheThomasHome.co.uk>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Hauppauge WinTV-NOVA-TD-Stick;
	unable to tune after a while
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

I have a Hauppauge WinTV NOVA TD USB based DVB-T tuner
(http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-TD-Stick).

For a while, it works just fine. Eventually, though, it stops working
- and can't tune in;

greg@greg-server:~/dvb$ scan uk.sudbury
scanning uk.sudbury
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 698167000 0 3 9 1 0 0 0
initial transponder 850000000 0 2 9 3 0 0 0
initial transponder 690167000 0 2 9 3 0 0 0
initial transponder 618000000 0 3 9 1 0 0 0
initial transponder 738000000 0 3 9 1 0 0 0
initial transponder 706167000 0 3 9 1 0 0 0
initial transponder 754000000 0 2 9 3 0 0 0
>>> tune to: 698167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 698167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!

etc. etc.

As soon as I reboot, everything kicks in to life again - for a while.
So, any idea what gives? Why does the device suddenly stop working
until I reboot? Is there anyway I can avoid a reboot? Hmm, just
realised as it's a USB device, a remove/insert may help, I will try
that next time it happens.

Is there anything else I could/should be looking at to help track down
the problem?

TIA for any thoughts,

Greg
[I'm actually running on a Intel Core Du oMac Mini, so it's an Intel
chipset, FWIW]

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
