Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZIJQSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 12:18:24 -0400
Message-ID: <4AA926AC.20206@nildram.co.uk>
Date: Thu, 10 Sep 2009 17:17:48 +0100
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_Watteng=E5rd?= <cwattengard@gmail.com>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org, aospan@netup.ru
Subject: Re: [linux-dvb] NetUP Dual DVB-T/C-CI RF PCI-E x1
References: <1252507872.29643.330.camel@alkaloid.netup.ru> <42619c130909100014hdd80d02y43f8a7120548332@mail.gmail.com>
In-Reply-To: <42619c130909100014hdd80d02y43f8a7120548332@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christian Wattengård wrote:
> This sounds promising. I hope you are not going to price yourselves
> completely out as a few other DVB-C suppliers have done.
> If the price is right (around the same as a normal DVB-T tuner ~$65),
> it definitely sounds interesting.
> 
> When you say it supports two transponders, is this also true on DVB-C
> only... As in DVB-C + DVB-C channel...
> If this is the case then I only need 3 cards to cover all the
> interesting channels in my cable network ;)
> I CAN TIMESHIFT THE WORLD!!! MUHAHAHAhaha... *cough*
> 
> But seriously... This sounds very interesting.
> 
> Christian from Norway...
> 
> On Wed, Sep 9, 2009 at 4:51 PM, Abylai Ospan <aospan@netup.ru> wrote:
>> Hello,
>>
>> We have designed NetUP Dual NetUP Dual DVB-T/C-CI RF PCI-E x1 card. A short
>> description is available in wiki - http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF
>>
>> Features:
>> * PCI-e x1
>> * Supports two DVB-T/DVB-C transponders simultaneously
>> * Supports two analog audio/video channels simultaneously
>> * Independent descrambling of two transponders
>> * Hardware PID filtering
>>
>> Now we have started the work on the driver for Linux. The following  components used in this card already have their code for Linux published:
>> * Conexant CX23885, CX25840
>> * Xceive XC5000 silicon TV tuner
>>
>> We are working on the code for the following components:
>> * STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip receiver
>> * Altera FPGA for Common Interafce.
>>
>> We have developed FPGA firmware for CI (according to PCMCIA/en50221). Also we are doing "hardware" PID filtering. It's fast and very flexible. JTAG is used for firmware uploading into FPGA -
>> this part contains "JAM player" from Altera for processing JAM STAPL Byte-Code (.jbc files).
>>
>> The resulting code will be published under GPL after receiving permissions from IC vendors.
>>
>> --
>> Abylai Ospan <aospan@netup.ru>
>> NetUP Inc.
>>
>> P.S.
>> We will show this card at the upcoming IBC exhibition ( stand IP402 ).
>>

The Netup dual DVB-S2 card was around $1000, I doubt the Dual DVB-T will 
be an order of magnitude less expensive.

I'd be interested to know how many they've sold, it seems overpriced to me.

BRs,

Lou

