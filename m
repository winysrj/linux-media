Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:43527 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754764Ab1B1Ptl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 10:49:41 -0500
From: Malte Gell <malte.gell@gmx.de>
To: linux-media@vger.kernel.org
Subject: Bulding az6007 module fails
Date: Mon, 28 Feb 2011 16:49:37 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102281649.37619.malte.gell@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

Terratec has released sources for the AzureWave 6007 chipset at
http://linux.terratec.de/files/TERRATEC_H7_Linux.tar.gz

I have merged these sources into a 2.6.38-rc tree and tried to compile these 
modules, but I get an error. Can someone tell me how to fix this in order to 
build the modules? Maybe these sources could even become part of the official 
Linux kernel? Below is the output when I try to buld the modules.

Thanx in advance
Malte

CALL    scripts/checksyscalls.sh
  CC [M]  drivers/media/dvb/dvb-usb/az6007.o
In file included from drivers/media/dvb/dvb-usb/az6007.c:11:
drivers/media/dvb/frontends/mt2063_cfg.h: In function ‘tuner_MT2063_Open’:
drivers/media/dvb/frontends/mt2063_cfg.h:62: error: ‘DVBFE_TUNER_OPEN’ 
undeclared (first use in this function)
drivers/media/dvb/frontends/mt2063_cfg.h:62: error: (Each undeclared 
identifier is reported only once
drivers/media/dvb/frontends/mt2063_cfg.h:62: error: for each function it 
appears in.)
drivers/media/dvb/frontends/mt2063_cfg.h: In function 
‘tuner_MT2063_SoftwareShutdown’:
drivers/media/dvb/frontends/mt2063_cfg.h:83: error: 
‘DVBFE_TUNER_SOFTWARE_SHUTDOWN’ undeclared (first use in this function)
drivers/media/dvb/frontends/mt2063_cfg.h: In function 
‘tuner_MT2063_ClearPowerMaskBits’:
drivers/media/dvb/frontends/mt2063_cfg.h:104: error: 
‘DVBFE_TUNER_CLEAR_POWER_MASKBITS’ undeclared (first use in this function)
drivers/media/dvb/dvb-usb/az6007.c: At top level:
drivers/media/dvb/dvb-usb/az6007.c:156: error: array type has incomplete 
element type
drivers/media/dvb/dvb-usb/az6007.c:535: error: ‘USB_PID_AZUREWAVE_6007’ 
undeclared here (not in a function)
drivers/media/dvb/dvb-usb/az6007.c:536: error: ‘USB_PID_TERRATEC_H7’ 
undeclared here (not in a function)
drivers/media/dvb/dvb-usb/az6007.c:576: error: unknown field ‘rc_key_map’ 
specified in initializer
drivers/media/dvb/dvb-usb/az6007.c:576: error: initializer element is not 
constant
drivers/media/dvb/dvb-usb/az6007.c:576: error: (near initialization for 
‘az6007_properties.identify_state’)
drivers/media/dvb/dvb-usb/az6007.c:577: error: unknown field ‘rc_key_map_size’ 
specified in initializer
drivers/media/dvb/dvb-usb/az6007.c:577: error: invalid operands to binary / 
(have ‘struct usb_device_id *’ and ‘long unsigned int’)
drivers/media/dvb/dvb-usb/az6007.c:577: warning: missing braces around 
initializer
drivers/media/dvb/dvb-usb/az6007.c:577: warning: (near initialization for 
‘az6007_properties.rc’)
drivers/media/dvb/dvb-usb/az6007.c:577: error: initializer element is not 
constant
drivers/media/dvb/dvb-usb/az6007.c:577: error: (near initialization for 
‘az6007_properties.rc.mode’)
drivers/media/dvb/dvb-usb/az6007.c:578: error: unknown field ‘rc_interval’ 
specified in initializer
drivers/media/dvb/dvb-usb/az6007.c:578: warning: initialization makes pointer 
from integer without a cast
drivers/media/dvb/dvb-usb/az6007.c:579: error: unknown field ‘rc_query’ 
specified in initializer
drivers/media/dvb/dvb-usb/az6007.c:579: warning: initialization makes integer 
from pointer without a cast
drivers/media/dvb/dvb-usb/az6007.c:579: error: initializer element is not 
computable at load time
drivers/media/dvb/dvb-usb/az6007.c:579: error: (near initialization for 
‘az6007_properties.generic_bulk_ctrl_endpoint’)
make[4]: *** [drivers/media/dvb/dvb-usb/az6007.o] Fehler 1
make[3]: *** [drivers/media/dvb/dvb-usb] Fehler 2
make[2]: *** [drivers/media/dvb] Fehler 2
make[1]: *** [drivers/media] Fehler 2
make: *** [drivers] Fehler 2
("Fehler"=error)
