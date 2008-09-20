Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Kh6BH-0007Cx-6q
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2008 19:23:40 +0200
Message-ID: <48D53190.60901@iki.fi>
Date: Sat, 20 Sep 2008 20:23:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dirk Vornheder <dirk_vornheder@yahoo.de>
References: <200809152345.37786.dirk_vornheder@yahoo.de>	<200809172115.19851.dirk_vornheder@yahoo.de>	<48D41D7B.90609@iki.fi>
	(sfid-20080920_124515_459025_6B4D8025)
	<200809201916.01736.dirk_vornheder@yahoo.de>
In-Reply-To: <200809201916.01736.dirk_vornheder@yahoo.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] UNS: Re: UNS: Re: New unspported device AVerMedia
 DVB-T
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

Dirk Vornheder wrote:
> Some messages from booting:
> 
> dvb-usb: found a 'AVerMedia DVB-T' in cold state, will try to load a firmware
> firmware: requesting dvb-usb-af9015.fw
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> usbcore: registered new interface driver dvb_usb_af9015
> 
> lsmod | grep af  shows:
> 
> af9013                 17156  0
> dvb_usb_af9015         19108  0
> dvb_usb                14860  1 dvb_usb_af9015
> usbcore               108752  10 
> iforce,usbmouse,usbhid,uvcvideo,dvb_usb_af9015,dvb_usb,btusb,ehci_hcd,uhci_hcd
> i2c_core               18324  52 
> zl10353,ves1x93,ves1820,tua6100,tda826x,tda8083,tda10086,tda1004x,tda10048,tda10023,tda10021,stv0299,stv0297,sp887x,sp8870,s5h1420,s5h1411,s5h1409,or51211,or51132,nxt6000,nxt200x,mt352,mt312,lnbp21,lgs8gl5,lgdt330x,l64781,itd1000,isl6421,isl6405,dvb_pll,drx397xD,dib7000p,dib7000m,dib3000mc,dibx000_common,dib3000mb,dib0070,cx24123,cx24110,cx22702,cx22700,bcm3510,au8522,af9013,dvb_ttpci,ttpci_eeprom,dvb_usb_af9015,dvb_usb,nvidia,i2c_i801
> 
> But i found no device entries in /dev/dvb.

Looks like tuner is not identified. Could you load af9015 with some 
debugging enabled to see more information?

1) remove all dvb-modules "make rmmod"
2) load af9015 with debug enabled "modprobe dvb-usb-af9015 debug=3"

after that there should be more information in message-log.

> 
>>>>> I buy a new notebook HP Pavilion dv7-1070eg which includes one
>> Did you mean that this AverMedia DVB-T device is integrated to the
>> motherboard of your computer?
>>
> 
> Yes.
> 
> Dirk

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
