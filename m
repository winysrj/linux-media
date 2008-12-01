Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1L772F-0003aB-SX
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 12:33:53 +0100
Date: Mon, 1 Dec 2008 12:33:12 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Benjamin Morgan <bemorgan@gmail.com>
In-Reply-To: <3d623cf80811292004u282db50crcb17ea9f376578dd@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0812011230220.19122@pub1.ifh.de>
References: <3d623cf80811292004u282db50crcb17ea9f376578dd@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge Nova-T 500 problem, probably erased eeprom
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

Hi Benjamin,

On Sun, 30 Nov 2008, Benjamin Morgan wrote:
> I've tried doing what was suggested in the thread to force the driver
> to recognise the device as a Nova T 500 however this hasn't worked.
> For reference I edited the following:
>
> linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h - added the following lines:
> #define USB_PID_HAUPPAUGE_NOVA_T_500_4                  0x10b8
> #define USB_PID_HAUPPAUGE_NOVA_T_500_5                  0x0066
>
> /linux/drivers/media/dvb/dvb-usb/dib0700_devices.c - added the following lines:
>       { USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_4) },
>        { USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_5) },
>
> and then ran a make, make install and shutdown the computer and
> restarted it however it is still not being recognised.

If you want to do that change USB_VID_HAUPPAUGE to 0x10b8, then it will 
work.

But as your eeprom is erased you should better exchange your card at your 
dealer: there is another information in the eeprom which is used for the 
tuner on that board to achieve a better sensitivity - this is now gone as 
well.

regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
