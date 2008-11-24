Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <holger@rusch.name>) id 1L4ZFe-0004eL-Ir
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 12:05:11 +0100
Message-ID: <492A8A43.4060001@rusch.name>
Date: Mon, 24 Nov 2008 12:04:35 +0100
From: Holger Rusch <holger@rusch.name>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
In-Reply-To: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
Subject: Re: [linux-dvb] Nova/dib0700/i2C write failed
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

Hi,

jon bird schrieb:
> Just to provide a bit more info on what seems to be an ongoing issue
> with these devices, I updated my kernel (2.6.26) dvb drivers with a
> snapshot from here on 19/11/08 (v4l-dvb-5dc4a6b381f6), it has 
> marginally improved the behaviour but only slightly. Previously, 
> sporadic 'usb 1-4: USB disconnect, address 2' followed by 'mt2060 I2C
> write failed' cropping up generally put the khubd into a spin with 
> repeated messages of the form:

... are you sure that it is not a problem of the usb ports?

I got an MB with SB700 Chipset and it seems to have the same problems as
the SB600 with the USB ports (disconnects here and then).

I use a
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity
which is nearly the same as the Nova.

Now my system got a NEC-Chip USB PCIcard and everything works fine with
the Cinergy connected there.

Iam using Debian 2.6.26-1 on lenny with v4l out of the hg.

The Board is an Asrock Fulldisplayport.

It didnt work with the onboard USB last time i checked about 4 days ago.

-- 
+ Contact? => http://site.rusch.name/ +

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
