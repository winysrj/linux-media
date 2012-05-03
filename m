Return-path: <linux-media-owner@vger.kernel.org>
Received: from pylon.zeratul.org ([195.5.121.140]:37546 "EHLO
	pylon.zeratul.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab2ECS1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 14:27:39 -0400
Message-ID: <4FA2CBC1.5020804@turnovfree.net>
Date: Thu, 03 May 2012 20:17:37 +0200
From: Zdenek Styblik <stybla@turnovfree.net>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org, gennarone@gmail.com,
	fermio.kll@hotmail.com, julianjm@gmail.com,
	thomas.mair86@googlemail.com, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
References: <4F9E5D91.30503@gmail.com> <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com> <4F9F8752.40609@gmail.com> <4FA232CE.8010404@gmail.com>
In-Reply-To: <4FA232CE.8010404@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello poma,

I'm sorry, but that's all info I've been "given". :-\

Best regards,
Z.

On 05/03/12 09:25, poma wrote:
> 
> [ …]
> 
> Hi there,
> 
> These two patches - 'dvb-usb-ids-v2-rtl2832-fc0012.patch' and 
> 'rtl28xxu-v2-rtl2832-fc0012.patch' adds nine devices based on
> FC0012 tuner, altogether eleven. Gianluca, please inform forum
> fellows to test&reply. Zdenek, fermio - there is a note on 
> http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start at 
> "Other DVB-T Sticks" regarding 'af4d:a803' device. Is it based on
> RTL2832 with FC0012 tuner?
> 
> Julian, Thomas, Antii cheers mates! ;) poma
> 
> ps. modinfo dvb_usb_rtl28xxu filename: 
> /lib/modules/3.3.2-6.fc16.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl28xxu.ko
>
> 
license:        GPL
> author:         Thomas Mair <thomas.mair86@googlemail.com> author:
> Antti Palosaari <crope@iki.fi> description:    Realtek RTL28xxU DVB
> USB driver alias:          usb:v1F4DpD803d*dc*dsc*dp*ic*isc*ip* 
> alias:          usb:v1F4DpC803d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v1B80pD399d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v1B80pD395d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v1B80pD394d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v1B80pD393d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v1B80pD39Dd*dc*dsc*dp*ic*isc*ip* alias:
> usb:v0458p707Fd*dc*dsc*dp*ic*isc*ip* alias:
> usb:v0BDAp2838d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v1F4DpB803d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v0CCDp00A9d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v14AAp0161d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v14AAp0160d*dc*dsc*dp*ic*isc*ip* alias:
> usb:v0BDAp2831d*dc*dsc*dp*ic*isc*ip* depends:
> dvb-usb,rtl2830,rc-core vermagic:       3.3.2-6.fc16.x86_64 SMP
> mod_unload parm:           debug:set debugging level (int) parm:
> adapter_nr:DVB adapter numbers (array of short)
> 


-- 
Zdenek Styblik
email: stybla@turnovfree.net
jabber: stybla@jabber.turnovfree.net
