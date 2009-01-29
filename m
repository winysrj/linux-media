Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:58251 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbZA2KTr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 05:19:47 -0500
Date: Thu, 29 Jan 2009 11:19:32 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: matthieu castet <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
In-Reply-To: <20090129074735.76e07d47@caramujo.chehab.org>
Message-ID: <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr> <20090129074735.76e07d47@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

sorry for not answering ealier, recently I became the master of 
postponing things. :(

On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:

>> +/* 14 */	{ USB_DEVICE(USB_VID_CYPRESS,		USB_PID_ULTIMA_TVBOX_USB2_FX_COLD) },
>> +#endif
>
> It doesn't sound a very good approach the need of recompiling the driver to
> allow it to work with a broken card. The better would be to have some modprobe
> option to force it to accept a certain USB ID as a valid ID for the card.

The most correct way would be to reprogram the eeprom, by simply writing 
to 0xa0 (0x50 << 1) I2C address... There was a thread on the linux-dvb some 
time ago.

> The above is really ugly. IMO, we should replace this by
> ARRAY_SIZE(dibusb_mc_properties.devices). Of course, for this to work,
> num_device_descs should be bellow devices.

We could do that, still I'm not sure if ARRAY_SIZE will work in that 
situation?! Are you 
sure, Mauro?

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
