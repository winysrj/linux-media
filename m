Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64532 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab2EDBep (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 21:34:45 -0400
Received: by were53 with SMTP id e53so1468544wer.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 18:34:44 -0700 (PDT)
Message-ID: <4FA33230.6070308@gmail.com>
Date: Fri, 04 May 2012 03:34:40 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Zdenek Styblik <stybla@turnovfree.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
References: <4F9E5D91.30503@gmail.com> <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com> <4F9F8752.40609@gmail.com> <4FA232CE.8010404@gmail.com> <4FA2CBC1.5020804@turnovfree.net>
In-Reply-To: <4FA2CBC1.5020804@turnovfree.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2012 08:17 PM, Zdenek Styblik wrote:
> Hello poma,
> 
> I'm sorry, but that's all info I've been "given". :-\

It is as it is.
;)

regards,
poma

> On 05/03/12 09:25, poma wrote:
>>
>> [ …]
>>
>> Hi there,
>>
>> These two patches - 'dvb-usb-ids-v2-rtl2832-fc0012.patch' and 
>> 'rtl28xxu-v2-rtl2832-fc0012.patch' adds nine devices based on
>> FC0012 tuner, altogether eleven. Gianluca, please inform forum
>> fellows to test&reply. Zdenek, fermio - there is a note on 
>> http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start at 
>> "Other DVB-T Sticks" regarding 'af4d:a803' device. Is it based on
>> RTL2832 with FC0012 tuner?
>>
>> Julian, Thomas, Antii cheers mates! ;) poma
>>
>> ps. modinfo dvb_usb_rtl28xxu filename: 
>> /lib/modules/3.3.2-6.fc16.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl28xxu.ko
>>
>>
> license:        GPL
>> author:         Thomas Mair <thomas.mair86@googlemail.com> author:
>> Antti Palosaari <crope@iki.fi> description:    Realtek RTL28xxU DVB
>> USB driver alias:          usb:v1F4DpD803d*dc*dsc*dp*ic*isc*ip* 
>> alias:          usb:v1F4DpC803d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v1B80pD399d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v1B80pD395d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v1B80pD394d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v1B80pD393d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v1B80pD39Dd*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v0458p707Fd*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v0BDAp2838d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v1F4DpB803d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v0CCDp00A9d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v14AAp0161d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v14AAp0160d*dc*dsc*dp*ic*isc*ip* alias:
>> usb:v0BDAp2831d*dc*dsc*dp*ic*isc*ip* depends:
>> dvb-usb,rtl2830,rc-core vermagic:       3.3.2-6.fc16.x86_64 SMP
>> mod_unload parm:           debug:set debugging level (int) parm:
>> adapter_nr:DVB adapter numbers (array of short)
>>
> 
> 

