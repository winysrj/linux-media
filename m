Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n9.bullet.ukl.yahoo.com ([217.146.182.189])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dirk_vornheder@yahoo.de>) id 1Kh6fA-00015U-QW
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2008 19:54:35 +0200
From: Dirk Vornheder <dirk_vornheder@yahoo.de>
To: Antti Palosaari <crope@iki.fi>,
 linux-dvb@linuxtv.org
Date: Sat, 20 Sep 2008 19:53:38 +0200
References: <200809152345.37786.dirk_vornheder@yahoo.de>
	<200809201916.01736.dirk_vornheder@yahoo.de>
	<48D53190.60901@iki.fi> (sfid-20080920_192922_012008_3ACD590C)
In-Reply-To: <48D53190.60901@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809201953.39006.dirk_vornheder@yahoo.de>
Subject: Re: [linux-dvb] UNS: Re: UNS: Re: UNS: Re: New unspported device
	AVerMedia DVB-T
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


> > Some messages from booting:
> >
> > dvb-usb: found a 'AVerMedia DVB-T' in cold state, will try to load a
> > firmware firmware: requesting dvb-usb-af9015.fw
> > dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> > usbcore: registered new interface driver dvb_usb_af9015
> >
> > lsmod | grep af  shows:
> >
> > af9013                 17156  0
> > dvb_usb_af9015         19108  0
> > dvb_usb                14860  1 dvb_usb_af9015
> > usbcore               108752  10
> > iforce,usbmouse,usbhid,uvcvideo,dvb_usb_af9015,dvb_usb,btusb,ehci_hcd,u=
hc
> >i_hcd i2c_core               18324  52
> > zl10353,ves1x93,ves1820,tua6100,tda826x,tda8083,tda10086,tda1004x,tda10=
04
> >8,tda10023,tda10021,stv0299,stv0297,sp887x,sp8870,s5h1420,s5h1411,s5h140=
9,
> >or51211,or51132,nxt6000,nxt200x,mt352,mt312,lnbp21,lgs8gl5,lgdt330x,l647=
81
> >,itd1000,isl6421,isl6405,dvb_pll,drx397xD,dib7000p,dib7000m,dib3000mc,di=
bx
> >000_common,dib3000mb,dib0070,cx24123,cx24110,cx22702,cx22700,bcm3510,au8=
52
> >2,af9013,dvb_ttpci,ttpci_eeprom,dvb_usb_af9015,dvb_usb,nvidia,i2c_i801
> >
> > But i found no device entries in /dev/dvb.
>
> Looks like tuner is not identified. Could you load af9015 with some
> debugging enabled to see more information?
>
> 1) remove all dvb-modules "make rmmod"
> 2) load af9015 with debug enabled "modprobe dvb-usb-af9015 debug=3D3"
>
> after that there should be more information in message-log.
>

Sep 20 19:51:13 lappc kernel: af9015: command failed:255
Sep 20 19:51:13 lappc kernel: af9015: eeprom read failed:-1
Sep 20 19:51:13 lappc kernel: dvb_usb_af9015: probe of 3-3:1.0 failed with =

error -1
Sep 20 19:51:13 lappc kernel: usbcore: registered new interface driver =

dvb_usb_af9015


Dirk


	=

		=

___________________________________________________________ =

Der fr=FChe Vogel f=E4ngt den Wurm. Hier gelangen Sie zum neuen Yahoo! Mail=
: http://mail.yahoo.de


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
