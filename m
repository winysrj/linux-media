Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:44405 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbZETImh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 04:42:37 -0400
Date: Wed, 20 May 2009 10:42:19 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: matthieu castet <castet.matthieu@free.fr>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DIBUSB_MC : fix i2c to not corrupt eeprom in case of
 strange read pattern
In-Reply-To: <4A0EBACD.6070601@free.fr>
Message-ID: <alpine.LRH.1.10.0905201040420.6762@pub3.ifh.de>
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr> <20090129074735.76e07d47@caramujo.chehab.org> <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de> <49820C26.5090309@free.fr> <498215A8.3020203@free.fr> <4A0EBACD.6070601@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthieu,

On Sat, 16 May 2009, matthieu castet wrote:

> Hi,
>
>
> dibusb_i2c_xfer seems to do things very dangerous :
> it assumes that it get only write/read request or write request.
>
> That means that read can be understood as write. For example a program
> doing
> file = open("/dev/i2c-x", O_RDWR);
> ioctl(file, I2C_SLAVE, 0x50)
> read(file, data, 10)
> will corrupt the eeprom as it will be understood as a write.
>
> I attach a possible (untested) patch.
>
>
> Matthieu
>
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

thanks a lot for your patch. I applied it, but could not test. But even 
it is breaks things, it's better to prevent those "false-reads" than not 
having this protection. Any breakage we will fix later.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
