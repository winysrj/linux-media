Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n21.bullet.mail.ukl.yahoo.com ([87.248.110.138])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dirk_vornheder@yahoo.de>) id 1Kh64W-00060D-Lh
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2008 19:16:41 +0200
From: Dirk Vornheder <dirk_vornheder@yahoo.de>
To: Antti Palosaari <crope@iki.fi>,
 linux-dvb@linuxtv.org
Date: Sat, 20 Sep 2008 19:16:01 +0200
References: <200809152345.37786.dirk_vornheder@yahoo.de>
	<200809172115.19851.dirk_vornheder@yahoo.de>
	<48D41D7B.90609@iki.fi> (sfid-20080920_124515_459025_6B4D8025)
In-Reply-To: <48D41D7B.90609@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809201916.01736.dirk_vornheder@yahoo.de>
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

Am Friday 19 September 2008 23:45:31 schrieben Sie:
> Dirk Vornheder wrote:
> > Compile produces undefined symbol:
> >
> >   Building modules, stage 2.
> >   MODPOST 166 modules
> > WARNING: "__udivdi3" [/backup/privat/kernel/af9015_test-
> > c8583d119095/v4l/af9013.ko] undefined!
> >   CC      /backup/privat/kernel/af9015_test-c8583d119095/v4l/af9013.mod.o
> >   LD [M]  /backup/privat/kernel/af9015_test-c8583d119095/v4l/af9013.ko
> >   CC      /backup/privat/kernel/af9015_test-c8583d119095/v4l/au8522.mod.o
> >   LD [M]  /backup/privat/kernel/af9015_test-c8583d119095/v4l/au8522.ko
>
> That's now fixed, please test: http://linuxtv.org/hg/~anttip/af9015_test
>

Compile now works.

Some messages from booting:

dvb-usb: found a 'AVerMedia DVB-T' in cold state, will try to load a firmware
firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
usbcore: registered new interface driver dvb_usb_af9015

lsmod | grep af  shows:

af9013                 17156  0
dvb_usb_af9015         19108  0
dvb_usb                14860  1 dvb_usb_af9015
usbcore               108752  10 
iforce,usbmouse,usbhid,uvcvideo,dvb_usb_af9015,dvb_usb,btusb,ehci_hcd,uhci_hcd
i2c_core               18324  52 
zl10353,ves1x93,ves1820,tua6100,tda826x,tda8083,tda10086,tda1004x,tda10048,tda10023,tda10021,stv0299,stv0297,sp887x,sp8870,s5h1420,s5h1411,s5h1409,or51211,or51132,nxt6000,nxt200x,mt352,mt312,lnbp21,lgs8gl5,lgdt330x,l64781,itd1000,isl6421,isl6405,dvb_pll,drx397xD,dib7000p,dib7000m,dib3000mc,dibx000_common,dib3000mb,dib0070,cx24123,cx24110,cx22702,cx22700,bcm3510,au8522,af9013,dvb_ttpci,ttpci_eeprom,dvb_usb_af9015,dvb_usb,nvidia,i2c_i801

But i found no device entries in /dev/dvb.

> >>> I buy a new notebook HP Pavilion dv7-1070eg which includes one
>
> Did you mean that this AverMedia DVB-T device is integrated to the
> motherboard of your computer?
>

Yes.

Dirk


		
___________________________________________________________ 
Telefonate ohne weitere Kosten vom PC zum PC: http://messenger.yahoo.de


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
