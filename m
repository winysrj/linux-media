Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39785 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZIJHOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 03:14:34 -0400
Received: by ewy2 with SMTP id 2so99383ewy.17
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 00:14:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252507872.29643.330.camel@alkaloid.netup.ru>
References: <1252507872.29643.330.camel@alkaloid.netup.ru>
Date: Thu, 10 Sep 2009 09:14:36 +0200
Message-ID: <42619c130909100014hdd80d02y43f8a7120548332@mail.gmail.com>
Subject: Re: [linux-dvb] NetUP Dual DVB-T/C-CI RF PCI-E x1
From: =?ISO-8859-1?Q?Christian_Watteng=E5rd?= <cwattengard@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org, aospan@netup.ru
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sounds promising. I hope you are not going to price yourselves
completely out as a few other DVB-C suppliers have done.
If the price is right (around the same as a normal DVB-T tuner ~$65),
it definitely sounds interesting.

When you say it supports two transponders, is this also true on DVB-C
only... As in DVB-C + DVB-C channel...
If this is the case then I only need 3 cards to cover all the
interesting channels in my cable network ;)
I CAN TIMESHIFT THE WORLD!!! MUHAHAHAhaha... *cough*

But seriously... This sounds very interesting.

Christian from Norway...

On Wed, Sep 9, 2009 at 4:51 PM, Abylai Ospan <aospan@netup.ru> wrote:
> Hello,
>
> We have designed NetUP Dual NetUP Dual DVB-T/C-CI RF PCI-E x1 card. A short
> description is available in wiki - http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF
>
> Features:
> * PCI-e x1
> * Supports two DVB-T/DVB-C transponders simultaneously
> * Supports two analog audio/video channels simultaneously
> * Independent descrambling of two transponders
> * Hardware PID filtering
>
> Now we have started the work on the driver for Linux. The following  components used in this card already have their code for Linux published:
> * Conexant CX23885, CX25840
> * Xceive XC5000 silicon TV tuner
>
> We are working on the code for the following components:
> * STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip receiver
> * Altera FPGA for Common Interafce.
>
> We have developed FPGA firmware for CI (according to PCMCIA/en50221). Also we are doing "hardware" PID filtering. It's fast and very flexible. JTAG is used for firmware uploading into FPGA -
> this part contains "JAM player" from Altera for processing JAM STAPL Byte-Code (.jbc files).
>
> The resulting code will be published under GPL after receiving permissions from IC vendors.
>
> --
> Abylai Ospan <aospan@netup.ru>
> NetUP Inc.
>
> P.S.
> We will show this card at the upcoming IBC exhibition ( stand IP402 ).
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
