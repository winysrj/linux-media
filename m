Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48480E9D.9000004@iki.fi>
Date: Thu, 05 Jun 2008 19:04:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Serge Nikitin <sergeniki@googlemail.com>,
	Michael Krufky <mkrufky@linuxtv.org>
References: <9e5406cc0806050626r5588f1d3k36896b75c05070b0@mail.gmail.com>
In-Reply-To: <9e5406cc0806050626r5588f1d3k36896b75c05070b0@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PEAK DVB-T Digital Dual Tuner PCI - anyone got this
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

Serge Nikitin wrote:
> Andrew,
> 
> PEAK DVB-T Dual tuner PCI (221544AGPK) is either renamed or rebadged 
> KWorld DVB-T PC160 card.
> 
> I'm using first tuner on this card with help of the driver from 
> following source tree (snapshot was taken around 20/05/2008):
> http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/
> and latest firmware from
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/
> 
> Small modification for sources (file af9015.c) was needed (just add one 
> more USB Device ID (1b80:c160)) and the card is "just work" as a 
> single-tuner card.

Thank you for this information, I will add this USB-ID to the driver.

> I have not test second tuner due to following issue:
>  
> Second tuner identified itself correctly only after really "cold 
> restart" (power down, wait some time, power up):
> May 20 23:39:09 dvbbird kernel: DVB: registering new adapter (KWorld  
> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
> May 20 23:39:10 dvbbird kernel: af9013: firmware version:4.95.0
> May 20 23:39:10 dvbbird kernel: tda18271 3-00c0: creating new instance
> May 20 23:39:10 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0
> May 20 23:39:10 dvbbird kernel: dvb-usb: will pass the complete MPEG2 
> transportstream to the software demuxer.
> May 20 23:39:10 dvbbird kernel: DVB: registering new adapter (KWorld  
> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
> May 20 23:39:11 dvbbird kernel: af9013: firmware version:4.95.0
> May 20 23:39:11 dvbbird kernel: tda18271 4-00c0: creating new instance
> May 20 23:39:11 dvbbird kernel: TDA18271HD/C1 detected @ 4-00c0
> 
> For any sort of "not-really-cold" restarts second tuner fails to respond 
> correctly:
> May 21 00:10:10 dvbbird kernel: DVB: registering new adapter (KWorld  
> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
> May 21 00:10:11 dvbbird kernel: af9013: firmware version:4.95.0
> May 21 00:10:11 dvbbird kernel: tda18271 3-00c0: creating new instance
> May 21 00:10:11 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0
> May 21 00:10:11 dvbbird kernel: dvb-usb: will pass the complete MPEG2 
> transportstream to the software demuxer.
> May 21 00:10:11 dvbbird kernel: DVB: registering new adapter (KWorld  
> PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)
> May 21 00:10:12 dvbbird kernel: af9013: firmware version:4.95.0
> May 21 00:10:12 dvbbird kernel: tda18271 4-00c0: creating new instance
> May 21 00:10:12 dvbbird kernel: Unknown device detected @ 4-00c0, device 
> not supported.

Hmm, Mike have you any idea why it does not detect this tuner correctly 
  when "warm  restart" done ?

> May 21 00:10:12 dvbbird kernel: tda18271 4-00c0: destroying instance
> 
> Hope this help.

Thanks.

Could you give all debug / message logs printed in startup? It should 
print eeprom content and some more information as well.

> Sergej.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
