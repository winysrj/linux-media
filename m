Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lon1-post-3.mail.demon.net ([195.173.77.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steve@ganymede.demon.co.uk>) id 1L9U8i-0000Pz-Me
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 01:38:23 +0100
Received: from dyn-62-56-57-223.dslaccess.co.uk ([62.56.57.223]
	helo=[192.168.0.4])
	by lon1-post-3.mail.demon.net with esmtpsa (AUTH ganymede)
	(TLSv1:AES256-SHA:256) (Exim 4.69) id 1L9U8e-0006vI-fM
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 00:38:16 +0000
Message-ID: <493C6C68.2060702@ganymede.demon.co.uk>
Date: Mon, 08 Dec 2008 00:38:00 +0000
From: Steve <steve@ganymede.demon.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TechnoTrend S2-3600
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

I note the DVB-S2 USB Devices page on the wiki 
(http://www.linuxtv.org/wiki/index.php/DVB-S2_USB_Devices) states...

"If you own one or more devices from the following list and you want to 
help with support development, please contact the linux-dvb Mailing 
list" and then goes on to list (amongst others) the TechnoTrend S2-3600.

I own a TechnoTrend S2-3600 and am prepared to help if I can, I'm 
reasonably competent with C/C++ but totally new to Linux so would 
require some assistance (all my programming to date has been on Windows).

Based on the link to 
http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029830.html I've 
downloaded the code at http://mercurial.intuxication.org/hg/s2-liplianin 
and built it which resulted in the device being recognised and the 
driver loaded.

dmesg | grep dvb then gives

dvb-usb: found a 'Technotrend TT Connect S2-3600' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
dvb-usb: MAC address: 00:d0:5c:0b:9a:3d
dvb-usb: schedule remote query interval to 500 msecs.
dvb-usb: Technotrend TT Connect S2-3600 successfully initialized and 
connected.
usbcore: registered new interface driver dvb-usb-tt-connect-s2-3600-01.fw

after this kaffeine and mythtv both recognise the device but neither 
will complete a channel scan. I've tried manually adding a channel to 
kaffeine but it doesn't seem to work.

Just about everything I try to do with the device results in messages 
like the following being logged and the computer becoming very unresponsive

dvb-usb: bulk message failed: -110 (9/0)
dvb-usb: bulk message failed: -110 (4/0)
dvb-usb: error while querying for an remote control event.

I've tried dvbscan /usr/share/dvb/dvb-s/Astra-28.2E but just get "Failed 
to set frontend".

szap -r -c ./channels-conf/dvb-s/Astra-28.2E "BBC 2 England" gives...

reading channels from file './channels-conf/dvb-s/Astra-28.2E'
zapping to 2 'BBC 2 England':
sat 0, frequency = 10773 MHz H, symbolrate 22000000, vpid = 0x0910, apid 
= 0x0912 sid = 0x189e
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |

after which I ran dvbtraffic but got no output.

referring back to the message at 
http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029830.html I 
assume I'm supposed to do something with the attachment 
my_s2api_pctv452e.patch but what?

If anyone can point out what I'm doing wrong, what I need to do, or if 
there is anything I can do to help with support for the TechnoTrend 
S2-3600 then please let me know.

Thanks

Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
