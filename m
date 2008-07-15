Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out.neti.ee ([194.126.126.37])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ed.lau@mail.ee>) id 1KIpsY-0002Rk-Cm
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 21:08:03 +0200
Received: from localhost (localhost [127.0.0.1])
	by MXR-13.estpak.ee (Postfix) with ESMTP id 6045F26FA8
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 22:07:54 +0300 (EEST)
Received: from smtp-out.neti.ee ([127.0.0.1])
	by localhost (MXR-1.estpak.ee [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ph0jntXm6w-p for <linux-dvb@linuxtv.org>;
	Tue, 15 Jul 2008 22:07:51 +0300 (EEST)
Received: from Relayhost2.neti.ee (Relayhost2 [88.196.174.142])
	by MXR-13.estpak.ee (Postfix) with ESMTP id 9C6E227182
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 22:07:51 +0300 (EEST)
Message-ID: <487CF58A.1040009@mail.ee>
Date: Tue, 15 Jul 2008 22:07:54 +0300
From: Edmund Laugasson <ed.lau@mail.ee>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Gigabyte U8000-RH linux support?
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

Hi

I would like to ask, does Gigabyte U8000-RH work under Linux? If yes, which module does it use and 
which device will it use?

I looked at http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices#DiBcom_DVB-T because it seems 
like it using Dibcom chipset. But which chipset exactly - does anybody know?

Some advices, how to configure and test this device would be also appreciated.

This device is not in my PC but I got some outputs over Skype from my friend.

Some outputs:
#  lsusb
Bus 005 Device 004: ID 1044:7002 Chu Yuen Enterprise Co., Ltd

# ls /dev/usbdev*
/dev/usbdev1.1_ep00  /dev/usbdev2.1_ep81  /dev/usbdev4.1_ep00  /dev/usbdev5.1_ep81  /dev/usbdev5.8_ep81
/dev/usbdev1.1_ep81  /dev/usbdev3.1_ep00  /dev/usbdev4.1_ep81  /dev/usbdev5.8_ep00  /dev/usbdev5.8_ep82
/dev/usbdev2.1_ep00  /dev/usbdev3.1_ep81  /dev/usbdev5.1_ep00  /dev/usbdev5.8_ep01  /dev/usbdev5.8_ep83

# ls /dev/usbdev*
/dev/usbdev1.1_ep00  /dev/usbdev2.1_ep00  /dev/usbdev3.1_ep00  /dev/usbdev4.1_ep00  /dev/usbdev5.1_ep00
/dev/usbdev1.1_ep81  /dev/usbdev2.1_ep81  /dev/usbdev3.1_ep81  /dev/usbdev4.1_ep81  /dev/usbdev5.1_ep81

# lsmod | grep dvb
dvb_usb_dib0700        32648  0
dvb_usb                22924  1 dvb_usb_dib0700
dvb_core               81148  1 dvb_usb
dib7000m               16516  1 dvb_usb_dib0700
dib7000p               17672  1 dvb_usb_dib0700
dib3000mc              13960  1 dvb_usb_dib0700
dib0070                 9092  1 dvb_usb_dib0700
i2c_core               24832  75 
dvb_usb_dib0700,dvb_usb,dib7000m,dib7000p,dib3000mc,adv7175,sp887x,bt856,adv7170,s5h1409,mt2266,tea6415c,tda10023,tua6100,mt20xx,tda18271,cx22702,tda10086,tea5767,mt312,qt1010,tda1004x,tda9875,nxt200x,ves1820,bcm3510,vpx3220,saa6588,drx397xD,sp8870,tda8290,bt819,saa7110,l64781,cx24110,tda827x,tda10048,tda826x,s5h1411,ves1x93,stv0297,dib3000mb,saa7185,tda8083,lnbp21,ks0127,dibx000_common,saa7114,tda9887,isl6421,mt2060,zl10353,tda10021,cx22700,s5h1420,mt352,isl6405,xc5000,tea5761,mxl5005s,au8522,tda9840,mt2131,ovcamchip,tveeprom,saa7111,saa7191,bt866,tea6420,cx24123,dib0070,nxt6000,itd1000,i2c_algo_bit,i2c_viapro
usbcore               146028  6 dvb_usb_dib0700,dvb_usb,dabusb,ehci_hcd,uhci_hcd

If to replug device, then device number increases:
  /dev/usbdev5.11_ep82 ---> /dev/usbdev5.12_ep82

Ubuntu 8.04.1 LTS is used and all updates are made.

Thanks,
Edmund

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
