Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tommy.alander@gmail.com>) id 1JuiRT-00005j-Ud
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 08:20:27 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1114449fga.25
	for <linux-dvb@linuxtv.org>; Fri, 09 May 2008 23:20:20 -0700 (PDT)
Message-ID: <85e6aeba0805092320ja192c12hd756b5efb3725463@mail.gmail.com>
Date: Sat, 10 May 2008 08:20:18 +0200
From: "Tommy Alander" <tommy.alander@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] TerraTec Cinergy C
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

I am having some problem getting this card working. I'm using the
http://jusst.de/hg/mantis/archive/08f27ef99d74.tar.bz2 driver.
Everything seem to work ok but I'm not able to tune to any channels.

The windows drivers works and are able to find channels.

Using a channel I know works. Gives this:
# czap T2
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.czap/channels.conf'
 42 T2:394000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:410:420:28009
 42 T2: f 394000000, s 6875000, i 2, fec 0, qam 3, v 0x19a, a 0x1a4
status 00 | signal 0000 | snr 0000 | ber 000fffff | unc 00000a63 |
status 00 | signal 0000 | snr 9999 | ber 000fffff | unc 000061a7 |
status 00 | signal 0000 | snr 8e8e | ber 000006c0 | unc 000063a1 |
status 00 | signal 0000 | snr aaaa | ber 000fffff | unc 00000a4e |
status 00 | signal 0000 | snr 7474 | ber 000006c0 | unc 000063a5 |
status 00 | signal 0000 | snr 8585 | ber 000006c0 | unc 00006395 |
status 00 | signal 0000 | snr 8f8f | ber 000fffff | unc 0000215f |
status 00 | signal 0000 | snr 8f8f | ber 000006c0 | unc 000063a4 |
status 00 | signal 0000 | snr adad | ber 000006c0 | unc 0000639c |

Any pointers how to find out whats wrong?

/Tommy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
