Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1K1XD5-0006op-1i
	for linux-dvb@linuxtv.org; Thu, 29 May 2008 03:45:46 +0200
Message-ID: <483E0AC0.2000707@linuxtv.org>
Date: Wed, 28 May 2008 21:45:36 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: dean <dean@sensoray.com>
References: <483D6BD6.1090002@sensoray.com>
In-Reply-To: <483D6BD6.1090002@sensoray.com>
Cc: Greg KH <greg@kroah.com>, Charlie Liu <charlie@sensoray.com>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] GPL Cypress FX2 firmware loader in
	dvb-usb-firmware.c
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

dean wrote:
> Hi,
> 
> How is the Cypress FX2 firmware formatted for the command 
> usb_cypress_load_firmware?  If a device previously used the fxload 
> program to load the USB chip, how would you convert that hex file 
> firmware to one acceptable by usb_cypress_load_firmware (in 
> dvb-usb-firmware.c)?

dean,

The function that you refer to expects Intel BinHex format.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
