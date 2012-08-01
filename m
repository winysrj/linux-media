Return-path: <linux-media-owner@vger.kernel.org>
Received: from snt0-omc2-s19.snt0.hotmail.com ([65.55.90.94]:22565 "EHLO
	snt0-omc2-s19.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab2HAHA1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 03:00:27 -0400
Message-ID: <SNT129-W19D484C737EA5675A1D9C3E5C40@phx.gbl>
From: Peter Tilley <peter_tilley13@hotmail.com>
To: <linux-media@vger.kernel.org>
CC: <pboettcher@kernellabs.com>
Subject: RE: stk7700d problem
Date: Wed, 1 Aug 2012 07:00:25 +0000
In-Reply-To: <SNT129-W5399C49185699FB7ADC909E5C40@phx.gbl>
References: <SNT129-W5399C49185699FB7ADC909E5C40@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Apologies for resending.   Mailing list bounced the email the first time becuase it wasn't plain text format.

********************************


I have a dual USB DVB-T tuner which is sold under the brand Kaiser Baas KBA 01004 but under the hood looks pretty much the same as the Emtec s830 http://linuxtv.org/wiki/index.php/Emtec_S830
 
Whilst the device is recognised and seems to load ok, locally the only station that it seems to be able to tune is the a community TV station which transmits on QPSK. All the other TV stations are detected but the BER is too high which to me would imply that the devices LNA is proably not being turned on correctly.
 
In heading down that path I have sat and captured the USB communications both under windows and Linux with the intent to compare the two and work out which gpio is being used to turn on the LNA under windows and then duplicate that under Linux. Well that was the intent but the behaviour I am seeing under Linux is a bit strange and I think resolving that might explain why the device has not worked in the past.
 
Specifically, the device is identified as 1164:1e8c and within dib0700_devices.c proceeds to do a stk7700d_frontend_attach. This tries to set GPIOs 6,9,4 and 7 to 1, then it tries to set GPIO10 to 0 before resetting it to 1 and then finally tries to set GPIO 0 to 1. The driver reports no problem doing this but when you drill deeper you find that it does not seem to be doing what it is supposed to. That is, irrespective of which GPIO is set to 1 or 0 the same message is sent to the device over the USB interface. Specifically the USB message as seen in wireshark is 40 0C 00 00 00 00 03 00 00 00 00.
 
Drilling further still I can see that stk7700d_front_end_attach calls dib0700_set_gpio within dib0700_core.c. Within dib0700_set_gpio the main data seems to be loaded into st->buf. The contents of st->buf seem to be ok. That is, when setting any of the GPIOs st->buf[0] is always 0x0C, st->buf[1] follows the GPIOs eg GPIO6=8, GPIO9=14, GPIO4=5, GPIO7=10, GPIO10=15 and GPIO0=0 and finally st->buf[3] is 0x80 when setting GPIO10 to 0 and 0xC0 when setting any of the GPIOs to 1.
 
dib0700_set_gpio subsequently calls dib0700_ctrl_wr within dib0700_core.c but it was at this point I decided that surely this part of the code is pretty robust as it seems to be common for a number of devices and a problem would have been spotted long ago.
 
My question is whether any one has any ideas why I am seeing the same USB message irrespective of which GPIO is being set/reset?
 
Patrick, I have CC'd you specifically as your fingerprints seem to be all over the Dibcom code and presumably you are very familiar with it.
 
Happy to run additional tests and captures as required.
 
Regards
Pete 		 	   		  