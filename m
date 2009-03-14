Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:54486 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZCNPud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 11:50:33 -0400
Date: Sat, 14 Mar 2009 16:49:40 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Uri Shkolnik <urishk@yahoo.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS
 based cards
In-Reply-To: <20090314082916.5f5ae403@pedra.chehab.org>
Message-ID: <alpine.LRH.1.10.0903141418110.5517@pub4.ifh.de>
References: <469952.82552.qm@web110812.mail.gq1.yahoo.com> <20090314075154.2e2af9e7@pedra.chehab.org> <alpine.LRH.1.10.0903141154310.5517@pub4.ifh.de> <20090314082916.5f5ae403@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009, Mauro Carvalho Chehab wrote:
>> The answer is relatively easy: Some hosts only have a SDIO interface, so
>> no USB, no PCI, no I2C, no MPEG2-streaming interface. So, the device has
>> to provide a SDIO interface in order to read and write register and to
>> make DMAs to get the data to the host. Think of your cell-phone, or your
>> PDA.
>
> Ok, so, if I understand well, the SDIO interface will be used just like we
> currently use the I2C or USB bus, right?
>
> So, we should create some glue between DVB and SDIO bus just like we have with
> PCI, USB, I2C, etc.
>
> Ideally something like (using the design we currently have with dvb-usb):
>
> [...]

Actually, when I created dvb-usb with the help of a lot of contributors, 
it served the purpose (and still serves) that there is a lot of different 
USB-based DVB devices which are delivering data. Bascially every 
DVB-USB-box/card-vendor is using a generic or specific 
USB-device-controller which implements some kind of high-level interface 
to do e.g. I2C and streaming. Those implementations, the USB protocol and 
its Linux-HAL requires some overhead to implement a driver. It was useful 
to create some common module and interface.

With SDIO I can't really see the same right now. First of all, SDIO should 
be much simpler as USB from the HAL point of view. Correct me if I'm 
wrong, but the SDIO-host controller should give "simple" DMA access to the 
device?.

Another thing for me is, there isn't many SDIO DVB devices out there right 
now, where Linux support is required (the latter is a pity ;) ). Also, the 
major part of supported DVB devices in Linux is PC-based and for PC (as of 
today) there is PCI(e) and USB working quite well, no one needs a SDIO 
device.

Having an SDIO device filling in to the DVB-API is rather straight 
forward, which makes me think that right now there is no need for a 
dvb-sdio.ko .

Patrick.

PS: please check the date of this email, when reading it in an archive in 
2 years ;)


