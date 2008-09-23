Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [85.17.51.120] (helo=master.jcz.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaap@jcz.nl>) id 1Ki315-0002aC-3J
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 10:13:03 +0200
Message-ID: <48D8A4FF.9010502@jcz.nl>
Date: Tue, 23 Sep 2008 10:12:47 +0200
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TT Budget S2-3200 CI: failure with CAM module
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

Hi All,

I searched all of this maillist for hints on S2-3200 and CAM modules, but found nothing.
I hope someone can give me a starting point for debug.

When I insert my Astoncrypt CAM module into my TT Budget S2-3200 card, scanning is no longer possible. Also getting any 
data out of /dev/dvb/adapter0/dvr0 is not working. Tuning is still working (or at least, it seems...), I still can get a 
FE_LOCK. No difference when I also insert my Canaldigitaal smartcard in the CAM module; same result.

I use the current multiproto HG tree (http://jusst.de/hg/multiproto , HEAD)
I use the current dvb-apps HG tree (http://linuxtv.org/hg/dvb-apps , HEAD)

My cam device is initialised:

<snip>
DVB CAM validated successfully
dvb_ca_en50221_link_init
dvb_ca_en50221_wait_if_status
dvb_ca_en50221_wait_if_status succeeded timeout:0
dvb_ca_en50221_read_data
Received CA packet for slot 0 connection id 0x0 last_frag:1 size:0x2
Chosen link buffer size of 16
dvb_ca_en50221_wait_if_status
dvb_ca_en50221_wait_if_status succeeded timeout:0
dvb_ca_en50221_write_data
Wrote CA packet for slot 0, connection id 0x0 last_frag:1 size:0x2
dvb_ca adapter 0: DVB CAM detected and initialised successfully
</snip>

Again, when I remove the CAM module, everything works fine (as for FTA channels...). Tools like dvbdate, dvbtraffic and 
mplayer /dev/dvb/adapter0/dvr0 work fine.

Any help in where to start debugging whould be very kind!

Regards,

Jaap Crezee



--------------------



Some more info:

02:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: Technotrend Systemtechnik GmbH S2-3200

jaap@server /dev/dvb/adapter0 $ lsmod | grep -E "dvb|stb|lnb|budget"
lnbp21                  1920  1
stb6100                 6404  1
stb0899                34180  1
budget_ci              21636  3
firmware_class          7040  1 budget_ci
budget_core             9348  1 budget_ci
saa7146                15880  2 budget_ci,budget_core
ttpci_eeprom            2304  1 budget_core
ir_common              40708  1 budget_ci
dvb_core               79744  2 budget_ci,budget_core
i2c_core               21264  9 lnbp21,stb6100,stb0899,budget_ci,budget_core,ttpci_eeprom,eeprom,i2c_i801,i2c_dev
crc32                   4224  3 dvb_core,tun,skge
jaap@server /dev/dvb/adapter0 $


Kernel 2.6.26.5 , 'normal' x86 platform....

jaap@server /dev/dvb/adapter0 $ ls -al
total 0
drwxr-xr-x 2 root root     140 Sep 23 09:39 .
drwxr-xr-x 3 root root      60 Sep 23 09:39 ..
crw-rw---- 1 root video 212, 6 Sep 23 09:39 ca0
crw-rw---- 1 root video 212, 4 Sep 23 09:39 demux0
crw-rw---- 1 root video 212, 5 Sep 23 09:39 dvr0
crw-rw---- 1 root video 212, 3 Sep 23 09:39 frontend0
crw-rw---- 1 root video 212, 7 Sep 23 09:39 net0
jaap@server /dev/dvb/adapter0 $

jaap@server /dev/dvb/adapter0 $ cat /proc/interrupts | grep saa
  21:     711348   IO-APIC-fasteoi   sata_sil, saa7146 (0)
jaap@server /dev/dvb/adapter0 $

[and counting up (and not because of the sata_sil...) ...]

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
