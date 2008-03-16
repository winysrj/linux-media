Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JagdH-0003xk-Kq
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 01:21:50 +0100
Message-ID: <47DC6835.5050305@philpem.me.uk>
Date: Sun, 16 Mar 2008 00:22:13 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: sboyce@blueyonder.co.uk
References: <20080311110707.GA15085@mythbackend.home.ivor.org>	<47D701A7.40805@philpem.me.uk>	<1205273404.20608.2.camel@youkaida>	<47DC3F65.8090407@philpem.me.uk>
	<47DC5515.6030701@blueyonder.co.uk>
In-Reply-To: <47DC5515.6030701@blueyonder.co.uk>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

Sid Boyce wrote:
> Regarding the NVidia module, NVidia themselves haven't yet conjured up a 
> fix for the latest kernels.
[snip]

This was on 2.6.24 -- once I downgraded to 2.6.22, just about everything that 
could break, did. For bonus points, none of the packages would recompile 
either (but maybe I was being stupid).

Like said, it was easier to just hose it down and start over.

I've got the following kopts enabled for the DVB modules:

==============================================================

pvr@dragon:~$ cat /etc/modprobe.d/dvb-options
# enable LNA for Hauppauge Nova-T-500
options dvb-usb-dib0700 force_lna_activation=1

# disable IR remote for Nova-T-500 (and other USB-DVB IRCs)
options dvb-usb disable_rc_polling=1

# force card order -- DiB0700 (Nova-T-500) first, then CX88 (HVR-3000).
# also creates virtual i/f 10 so Myth can see the Freeview hybrid
install cx88-dvb /sbin/modprobe dvb-usb-dib0700; /sbin/modprobe 
--ignore-install cx88-dvb; mkdir -p /dev/dvb/adapter10; ln -sf 
/dev/dvb/adapter2/demux1 /dev/dvb/adapter10/demux0; ln -sf 
/dev/dvb/adapter2/dvr1 /dev/dvb/adapter10/dvr0; ln -sf 
/dev/dvb/adapter2/frontend1 /dev/dvb/adapter10/frontend0; ln -sf 
/dev/dvb/adapter2/net1 /dev/dvb/adapter10/net0

==============================================================

At the moment both of the Nova-T-500's tuners are recording live TV, and the 
HVR-3000 is in DVT-T mode and recording too. No problems yet, but uptime is 
only 75 minutes. It's got a massive list of things to record overnight (think 
"stress test"), so fingers crossed. The only USB disconnect warning in dmesg 
is from when I unplugged the USB mouse after I got the R/C working.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
