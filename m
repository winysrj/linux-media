Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37972 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2ECJDb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 05:03:31 -0400
Received: by wgbdr13 with SMTP id dr13so1537860wgb.1
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 02:03:29 -0700 (PDT)
Message-ID: <4FA249DE.7000702@gmail.com>
Date: Thu, 03 May 2012 11:03:26 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org,
	Zdenek Styblik <stybla@turnovfree.net>, fermio.kll@hotmail.com,
	julianjm@gmail.com, thomas.mair86@googlemail.com,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
References: <4F9E5D91.30503@gmail.com> <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com> <4F9F8752.40609@gmail.com> <4FA232CE.8010404@gmail.com>
In-Reply-To: <4FA232CE.8010404@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi poma,
I have a 0BDA:2838 (Easycap EZTV646) and a 0BDA:2832 (no name 20x20mm
mini DVB-T stick) and both are based on the E4000 tuner, which is not
supported in the kernel at the moment.
I have no idea if there are sticks with the same USB PID and the fc0012
tuner.

Regards,
Gianluca

Il 03/05/2012 09:25, poma ha scritto:
> 
> [ …]
> 
> Hi there,
> 
> These two patches - 'dvb-usb-ids-v2-rtl2832-fc0012.patch' and
> 'rtl28xxu-v2-rtl2832-fc0012.patch' adds nine devices based on FC0012
> tuner, altogether eleven.
> Gianluca, please inform forum fellows to test&reply.
> Zdenek, fermio - there is a note on
> http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start at
> "Other DVB-T Sticks" regarding 'af4d:a803' device.
> Is it based on RTL2832 with FC0012 tuner?
> 
> Julian, Thomas, Antii
> cheers mates!
> ;)
> poma
> 
> ps.
> modinfo dvb_usb_rtl28xxu
> filename:
> /lib/modules/3.3.2-6.fc16.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl28xxu.ko
> license:        GPL
> author:         Thomas Mair <thomas.mair86@googlemail.com>
> author:         Antti Palosaari <crope@iki.fi>
> description:    Realtek RTL28xxU DVB USB driver
> alias:          usb:v1F4DpD803d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1F4DpC803d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1B80pD399d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1B80pD395d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1B80pD394d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1B80pD393d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1B80pD39Dd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0458p707Fd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0BDAp2838d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1F4DpB803d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0CCDp00A9d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v14AAp0161d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v14AAp0160d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0BDAp2831d*dc*dsc*dp*ic*isc*ip*
> depends:        dvb-usb,rtl2830,rc-core
> vermagic:       3.3.2-6.fc16.x86_64 SMP mod_unload
> parm:           debug:set debugging level (int)
> parm:           adapter_nr:DVB adapter numbers (array of short)
> 

